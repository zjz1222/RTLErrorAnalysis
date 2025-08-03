import re
import subprocess
from model import ChatModel
import json
import os
from typing import Optional

execute_dir = "./input"

def timeout_process_function():
    succeed = False
    status = "Error compiling testbench"
    fail_message = "Simulation time is too long. Please regenerate the design with a shorter simulation time"
    return succeed, status, fail_message

def parse_code_block(string: str, lang: str) -> Optional[str]:
    if lang not in string:
        return string

    code_pattern = fr"```{lang}\n(.*?)\n```"
    match = re.search(code_pattern, string, re.DOTALL)

    if match:
        return match.group(1)

    generic_code_pattern = r"```\n(.*?)\n```"
    match = re.search(generic_code_pattern, string, re.DOTALL)

    if match:
        return match[-1]

    return ""

def add_code_block(string: str, lang: str) -> str:
    return f"```{lang}\n{string}\n```"

def run_design_without_ref(design, testbench):
    design_dir = execute_dir + "/design.sv"
    testbench_dir = execute_dir + "/testbench.sv"
    design_vvp_dir = execute_dir + "/design.vvp"

    with open(design_dir, "w") as file: file.write(design)
    with open(testbench_dir, "w") as file: file.write(testbench)

    try:
        proc = subprocess.run(["iverilog", "-g2005-sv","-o", design_vvp_dir, design_dir, testbench_dir],capture_output=True,text=True, timeout = 30)    
    except subprocess.TimeoutExpired:
        can_compile, status, fail_message, score = timeout_process_function()
        return can_compile, fail_message 

    if proc.returncode != 0:
        fail_message = "The testbench failed to compile. Please fix the module. The output of iverilog is as follows:\n"+proc.stderr
    else:
        try:
            proc = subprocess.run(["vvp", design_vvp_dir],capture_output=True,text=True, timeout = 30)
        except subprocess.TimeoutExpired:
            can_compile, status, fail_message, score = timeout_process_function()
            return can_compile, fail_message
        
        can_compile = True
        message = proc.stdout.strip()
     
    return can_compile, message
        
def run_design(design: str = "", ref: str = "", testbench: str = ""):

    design_dir = execute_dir + "/design.sv"
    ref_dir = execute_dir + "/ref.sv"
    testbench_dir = execute_dir + "/testbench.sv"
    design_vvp_dir = execute_dir + "/design.vvp"
 
    with open(design_dir, "w", encoding = 'utf-8', errors = 'ignore') as file: file.write(design)
    with open(ref_dir, "w", encoding = 'utf-8', errors = 'ignore') as file: file.write(ref)
    with open(testbench_dir, "w", encoding = 'utf-8', errors = 'ignore') as file: file.write(testbench)
    
    succeed = False
    fail_message = ""
    
    try:
        if ref != "": 
            proc = subprocess.run(["iverilog", "-g2005-sv","-o", design_vvp_dir, design_dir, ref_dir, testbench_dir],capture_output=True,text=True, timeout = 30)
        else:
            proc = subprocess.run(["iverilog", "-g2005-sv","-o", design_vvp_dir, design_dir, testbench_dir],capture_output=True,text=True, timeout = 30)    
    except subprocess.TimeoutExpired:
        succeed, status, fail_message = timeout_process_function()
        return succeed, status, fail_message 
    
    if proc.returncode != 0:
        status = "Error compiling testbench"
        fail_message = proc.stderr
    else:
        try:
            proc = subprocess.run(["vvp", design_vvp_dir],capture_output=True,text=True, timeout = 30)
        except subprocess.TimeoutExpired:
            succeed, status, fail_message = timeout_process_function()
            return succeed, status, fail_message 
        
        result = proc.stdout.strip()
        if "no mismatches" not in result:
            status = "Error running testbench"
            fail_message = proc.stdout
        else:
            count_testbench = str(testbench).count("no mismatches")
            count_result = str(result).count("no mismatches")
            if count_testbench == count_result:
                status = "Testbench ran successfully"
                succeed = True
            else:
                status = "Error running testbench"
                succeed = False
                fail_message = "The testbench simulated, but had errors. Please fix the module. The output of iverilog is as follows:\n"+proc.stdout
    
    return succeed, status, fail_message 


def extract_module_output_signal(verilog_code):
    pattern = r'\boutput\s+(?:reg|logic)?\s*(?:\[\d+:\d+\])?\s*([a-zA-Z_]\w*)\b'
    matches = re.findall(pattern, verilog_code)
    print(matches)
    return matches

def extract_module_header(design: str):
    module_header_pattern = r'module\s+.*?\);'
    module_header = re.search(module_header_pattern, design, re.DOTALL)
    
    if module_header == None:
        return ""
    return module_header.group().strip()


