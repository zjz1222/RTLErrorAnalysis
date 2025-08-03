from code_rag.search import hybrid_search
from utils import extract_module_header, parse_code_block, run_design
from model import ChatModel

system_prompt = """
You are an excellent Verilog programming expert.  
you will be given programming design example and user's design description,

You should refer to the example exactly line by line to complete the Verilog code implementation.
Specifically, you need to learn the implementation details of example from start to finish.
At the same time, your design needs to meet user requirements.

Remember the module name, the port name, etc. must meet the user's description requirements. 
"""

def rag_based_knowledge_error_mitigation(llm: ChatModel, description: str):
    examples = hybrid_search(description)
    example_prompt = ""
    example_prompt = "### Example Begin ###"
    for example in examples:
        example_prompt = example_prompt + f"{example}\n"
    example_prompt += "### Example End ###"

    user_prompt = f"{example_prompt}\n[Design Description]:\n{description}\n[Design Detail]:\n"
    messages = [
        {"role": "system", "content": system_prompt},
        {"role": "user", "content": user_prompt}
    ]
    response = llm.generate(messages)
    design = parse_code_block(response, "verilog")
    # print(example_prompt)
    # print(design)

    return design, example_prompt

    
if __name__ == "__main__":
    input_path = "./input"
    llm = ChatModel(model_name = "/public/Qwen2.5-Coder-32B-Instruct", temperature = 0.1, local = True)
    
    with open(f"{input_path}/description.txt", "r", encoding = 'utf-8', errors = 'ignore') as file: description = file.read()
    with open(f"{input_path}/ref.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: ref = file.read()
    with open(f"{input_path}/testbench.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: testbench = file.read()
    corrected_design, example_prompt = rag_based_knowledge_error_mitigation(llm, description)
    
    with open(f"{input_path}/design.sv", "w", encoding = 'utf-8', errors = 'ignore') as file: file.write(corrected_design)
    print(corrected_design)
    print(example_prompt)
