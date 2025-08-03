from utils import parse_code_block, add_code_block, run_design
from model import ChatModel

localization_system_prompt = """
You are an excellent code debugger.
You will be given the execution results of a golden testbench and erroneous RTL code.

Based on the on the input signal values and the error signal,
analyze potential errors in the RTL code and mark suspicious statements with "//Error!".

Here is an example:

[Testbench Output]:
Input: y = 3'b100, w = 0.
Errorneous Output: Y2 = 1; Expected Output: Y2 = 0.

[Erroneous RTL Code]:
```verilog
module TopModule (input [3:1] y, input w,
                  output reg Y2);
    always @(*) begin
        case (y)
            3'b000: Y2 = w ? 0 : 1; 
            3'b001: Y2 = w ? 1 : 0; 
            3'b010: Y2 = w ? 1 : 0; 
            3'b011: Y2 = 0; 
            3'b100: Y2 = 1; 
            3'b101: Y2 = w ? 1 : 0; 
            default: Y2 = 0; 
        endcase
    end
endmodule
```

[Analysis Result]:
```verilog
module TopModule (input [3:1] y, input w,
                  output reg Y2); //Mismatch Signal
    always @(*) begin
        case (y)
            3'b000: Y2 = w ? 0 : 1; 
            3'b001: Y2 = w ? 1 : 0; 
            3'b010: Y2 = w ? 1 : 0; 
            3'b011: Y2 = 0; 
            3'b100: Y2 = 1;      //Error!   Because when y = 3'b100, this branch will be covered, while other branches will not be covered.
            3'b101: Y2 = w ? 1 : 0; 
            default: Y2 = 0; 
        endcase
    end
endmodule
```
"""

correction_system_prompt = """
You are an excellent Verilog Programming expert.
Based on the given Correct Design Description, Error Design, Fail Test Case.
Think Step by Step to fix the Possible error statements based on the error reason.
The modified code is required to fully comply with the requirements of the Fail Test Case and the Design Description.
Remember do not modify statements without "Error!" comments.

Note that your output should wrapping the corrected code with ```verilog and ```.
"""


def two_stage_localization_and_correction(
    llm: ChatModel, 
    description: str, 
    design: str,
    ref: str,
    testbench: str,
    example_prompt: str,
    max_iter: int = 1):
    
    now_iter = 0
    iter_design = design

    while True:
        if now_iter >= max_iter: break
        succeed, status, testbench_output = run_design(iter_design, ref, testbench)
        if succeed:
            return iter_design
        
        now_iter += 1     
        

        user_prompt = f"[Testbench Output]:\n{testbench_output}\n[Erroneous RTL Code]:\n{iter_design}\n[Analysis Result]:\n" 
        messages = [
            {"role": "system", "content": localization_system_prompt},
            {"role": "user", "content": user_prompt}
        ]
        response = llm.generate(messages)
        localization_design = parse_code_block(response, 'verilog')
        # print(testbench_output)
        # print(localization_design)

        user_prompt = example_prompt
        user_prompt += f"[Design Description]:\n{description}\n[Fail Message]:\n{testbench_output}\n[Erroneous RTL Code]:\n{localization_design}\n[Analysis Result]:\n"
        messages = [
            {"role": "system", "content": correction_system_prompt},
            {"role": "user", "content": user_prompt}
        ]
        response = llm.generate(messages)
        iter_design = parse_code_block(response,'verilog')
        # print(iter_design)
    
    return iter_design

if __name__ == "__main__":
    input_path = "./input"
    llm = ChatModel(model_name = "qwen2.5-coder-32b-instruct", temperature = 0.1, local = False)
    
    with open(f"{input_path}/description.txt", "r", encoding = 'utf-8', errors = 'ignore') as file: description = file.read()
    with open(f"{input_path}/design.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: design = file.read()
    with open(f"{input_path}/ref.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: ref = file.read()
    with open(f"{input_path}/testbench.sv", "r", encoding = 'utf-8', errors = 'ignore') as file: testbench = file.read()
    design = two_stage_localization_and_correction(llm, description, design, ref, testbench, "", max_iter = 1)

    with open(f"{input_path}/design.sv", "w", encoding = 'utf-8', errors = 'ignore') as file: file.write(design)

    print(corrected_design)
    print(meta_format)
