import os
import re
from model import ChatModel
from utils import parse_code_block, extract_module_header, run_design

description_refinement_rules = """
As a natural language understanding expert, you will be given a Verilog Module Description. 
Your task is to clarify ambiguities or contradictions in the user-provided description, specifically addressing the following aspects:

1. Check for unclear or contradictory functionality in the overall module description.
   If issues exist, clarify the module's overall function. Remind the user to provide additional information when necessary.
2. Examine whether input/output signals are clearly described. 
   If unclear, infer and supplement their basic functionality along with relevant input/output examples.
3. Verify if initialization information is missing. 
   If missing, you should add information about all reg-type output variables (output reg) must be explicitly initialized to 0 in the module declaration.

Note present the final optimized module description enclosed within [refined descritption begin]: [end].
Note the final output must be a natural language design description (not code).
"""

programming_rules_suffix = """
Here are some additional rules and coding conventions.
 - For reg-type output variables, ensure they are initialized to 0.

 - Do not assign values to wire-type variables within always blocks.

 - Do not redefine variables that have already been declared in the module's header.
  
 - When indexing a vector, ensure the index values are correctly set and do not exceed the bounds.

 - When slicing a vector, make sure the slice order strictly matches the defined order of the vector.
 
 - All sized numeric constants must have a size greater than zero (e.g, 0'b0 is not a valid expression).

 - An always block must read at least one signal otherwise it will never be executed; 
   use an assign statement instead of an always block in situations where there is no need to read any signals.
  
 - In Verilog programming, avoid confusing the use of generate-for and for loops. Use generate-for exclusively for instantiating submodules.

 - If the module uses a synchronous reset signal, this means the reset signal is sampled with respect to the clock. 
   When implementing a synchronous reset signal, do not include posedge reset in the sensitivity list of any sequential always block.

 - Do not mix blocking (=) and non-blocking (<=) assignments within the same always block.
"""

def rule_based_description_refinement(llm: ChatModel, description: str, task_prompt: str):
    messages = [
        {"role": "system", "content": description_refinement_rules},
        {"role": "user", "content": description}
    ]
    
    response = llm.generate(messages)
    pattern = r'\[refined description begin\]:(.*?)\[end\]'
    match = re.search(pattern, response, re.DOTALL)
    refined_description = ""
    
    if match:
        refined_description = match.group(1).strip()
    else:
        refined_description = description
    
    module_header = extract_module_header(description)

    system_prompt = f"""
    As a Verilog programming expert, you need to complete Verilog code based on user's prompt.
    {task_prompt}
    
    When writing Verilog designs, you need to adhere to the following rules:
    {programming_rules_suffix}
    """

    user_prompt = f"""
    {refined_description}
    {module_header}
    """
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt}
    ]
    
    response = llm.generate(messages)
    module_block = parse_code_block(response, "verilog")

    design = module_header + module_block

    return design, refined_description

if __name__ == "__main__":
    llm = ChatModel(model_name = "/public/Qwen2.5-Coder-32B-Instruct", temperature = 0.1, local = True)
    
    task_prompt = """
    You only complete chats with syntax correct Verilog code. 
    End the Verilog module code completion with 'endmodule'.
    Do not include module, input and output definitions.
    """
    input_path = "./input"
    llm = ChatModel(model_name = "/public/Qwen2.5-Coder-32B-Instruct", temperature = 0.1, local = True)
    
    with open(f"{input_path}/description.txt", "r", encoding = 'utf-8', errors = 'ignore') as file: description = file.read()
    with open(f"{input_path}/ref.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: ref = file.read()
    with open(f"{input_path}/testbench.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: testbench = file.read()
    corrected_design, example_prompt = rag_based_knowledge_error_mitigation(llm, description)
    
    with open(f"{input_path}/design.sv", "w", encoding = 'utf-8', errors = 'ignore') as file: file.write(design)
    print(corrected_design)
    print(meta_format)
