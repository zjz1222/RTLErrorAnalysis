from rule_based_description_refinement import rule_based_description_refinement
from multimodal_data_conversion import multimodal_data_conversion
from rag_based_knowledge_error_mitigation import rag_based_knowledge_error_mitigation
from two_stage_localization_and_correction import two_stage_localization_and_correction
from utils import run_design
import os
from model import ChatModel
from config import *

#VerilogEval_Human
task_prompt = """
You only complete chats with syntax correct Verilog code. 
End the Verilog module code completion with 'endmodule'.
Do not include module, input and output definitions.
"""

def main():
    
    llm = ChatModel(model_name = model_name, temperature = temperature, local = local)

    with open("./input/description", "r", encoding = 'utf-8', errors = 'ignore') as file: description = file.read()
    with open("./input/ref.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: ref = file.read()
    with open("./input/testbench.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: testbench = file.read()
    
    design, refined_description =  rule_based_description_refinement(llm, description, task_prompt)
    succeed, status, fail_messages = run_design(design, ref, testbench)
    corrected_design = design
    if not succeed:
        design, meta_format = multimodal_data_conversion(description, design)
        refine_description = refine_description + f"[Multimodal Data Meta Format]:{refine_description}\n"
        succeed, status, fail_messages = run_design(design, ref, testbench)

        if not succeed:
            design, example_prompt = rag_based_knowledge_error_mitigation(llm, description)
            succeed, status, fail_message = run_design(design, ref, testbench)

            if not succeed:
                if iter_with_example == False:
                    example_prompt = ""
                
                design =  two_stage_localization_and_correction(llm, description, design, ref, testbench, example_prompt, max_iter)
                succeed, status, fail_message = run_design(design, ref, testbench)
                
                if not succeed:
                    print("Generate Wrong...")
                else:
                    print("Generate Correct (Two Stage Localization and Correction)...")    
            
            else:
                print("Generate Correct (RAG based Knowledge Error Mitigation)...") 
            
        else:
            print("Generate Correct (Multimodal Data Conversion)...") 
    
    else:
        print("Generate Correct (Rule based Description Refinement)...")

                        
    with open("./input/design.sv", "w") as file: file.write(design)



if __name__ == "__main__":
    main()