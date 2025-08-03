import re
from utils import extract_module_output_signal, extract_module_header

def extract_kmap_var_name_in_line(var_name_line: str, index):
    var_name = var_name_line[index]
    while True:
        index = index + 1
        if index >= len(var_name_line):
            break
        if var_name_line[index] != '[' and \
           var_name_line[index] != ']' and \
           (not (var_name_line[index] >= '0' and var_name_line[index] <= '9')):
            break
        var_name += var_name_line[index]
    
    return var_name

def extract_kmap_var(design_description: str):
    design_description_lines, start_line_index = design_description.split("\n"), -1
    for index, design_description_line in enumerate(design_description_lines):
        if ("| 0 |" in design_description_line) or ("| 1 |" in design_description_line):
            start_line_index = index - 2
            break 
    
    var_name_list, row_value_list, column_value_list, value_list = [], [], [], []
    var_name_line_1 = design_description_lines[start_line_index]
    var_name_line_2 = design_description_lines[start_line_index + 1]
    var_name_line_len = max(len(var_name_line_1), len(var_name_line_2))
    for index in range(var_name_line_len):
        if index < len(var_name_line_1):
            if var_name_line_1[index] >= 'a' and var_name_line_1[index] <= 'z':
               var_name = extract_kmap_var_name_in_line(var_name_line_1, index)
               var_name_list.append(var_name)
        if index < len(var_name_line_2):
            if var_name_line_2[index] >= 'a' and var_name_line_2[index] <= 'z':
               var_name = extract_kmap_var_name_in_line(var_name_line_2, index)
               var_name_list.append(var_name)
    
    elements = var_name_line_2.split(" ")
    for element in elements:
        if element.isdigit():
            row_value_list.append(element)
    
    for design_description_line in design_description_lines:
        if "|" in design_description_line:
            column_line_list = design_description_line.replace(" ","").split("|")
            column_value_list.append(column_line_list[0])
            for value in column_line_list:
                if value == '0' or value == '1' or value == 'd':
                    value_list.append(value)

    return var_name_list, row_value_list, column_value_list, value_list


def kmap_conversion(design_description: str,
               design: str,
               dataset: str = "VerilogEval"):
    
    corrected_design = design
        
    var_name_list, row_value_list, column_value_list, value_list = extract_kmap_var(design_description)
    
    module_header = extract_module_header(design)

    output_signal = extract_module_output_signal(module_header)[0]

    output_logic = ""
    output_start_flag = True
    value_list_index = 0
    
    meta_format = ""
    case_id = 0
    
    for column_value in column_value_list:
        for row_value in row_value_list:
            input_value = column_value + row_value
            output_value = value_list[value_list_index]
            value_list_index += 1

            if output_value != '1': continue

            
            term_start_flag = True
            term = ""
            
            case_id = case_id + 1
            meta_format = meta_format + f"Case: {case_id}\nInput:  "

            for index, var_name in enumerate(var_name_list):
                var_value = input_value[index]
                if var_value == '0':
                    term += f"~{var_name}" if term_start_flag else f"&~{var_name}"
                else:
                    term += f"{var_name}" if term_start_flag else f"&{var_name}"
                
                if term_start_flag: 
                    term_start_flag = False
                meta_format = meta_format + f"{var_name} = {var_value}; "

            meta_format = meta_format + f"\nOutput: {output_signal} = {output_value};\n"

            
            output_logic += f"({term})" if output_start_flag else f"|({term})"
            if output_start_flag:
                output_start_flag = False

    
    corrected_design = module_header + "\n"
    corrected_design += "   assign " + output_signal + "=" + output_logic + ";\nendmodule" 
    
    return corrected_design, meta_format
    

def truthtable_conversion(design_description: str,
                     design: str):
    corrected_design = design
    
    output_logic = ""
    var_name_list = []
    design_description_lines = design_description.split("\n")
    start_line_flag, start_output_logic = True, True
    
    meta_format = ""
    case_id = 0

    for design_description_line in design_description_lines:
        if "|" not in design_description_line:
            continue
        if start_line_flag:
            var_name_list = design_description_line.replace(" ","").split("|")
            start_line_flag = False
        else:
            var_value_list = design_description_line.replace(" ","").split("|")
            if var_value_list[-1] == '1':
                term = ""
                start_term_flag = True
                
                case_id = case_id + 1
                meta_format = meta_format + f"Case: {case_id}\nInput:  "

                for index, var_name in enumerate(var_name_list):
                    if var_name_list[index] == var_name_list[-1]:
                        continue
                    var_value = var_value_list[index]
                    term += "" if start_term_flag else "&"
                    term += f"{var_name}" if var_value == '1' else f"~{var_name}"
                    start_term_flag = False
                    
                    meta_format = meta_format + f"{var_name} = {var_value}; "
                
                meta_format = meta_format + f"\nOutput: {var_name_list[-1]} = {var_value_list[-1]}; "

                output_logic += f"({term})" if start_output_logic else f"|({term})"
                start_output_logic = False
    
    module_header = extract_module_header(design)
    corrected_design = module_header + f"\n     assign {var_name_list[-1]}={output_logic};\nendmodule"
    return corrected_design, meta_format

def has_upper_or_lower(s):
    for char in s:
        if char.isupper() or char.islower():
            return True
    return False

def process_input_value(var_name_list: list, value: str):
    if has_upper_or_lower(value):
        return f"{4*len(value)}'h{value}" 
    return value

def process_output_value(var_name_list: list, value: str):
    if value in var_name_list:
        return value
    elif has_upper_or_lower(value):
        return f"{4*len(value)}'h{value}" 
    return value

def combinational_waveform_conversion(design_description: str,
                                 design: str):
    
    meta_format = ""
    case_id = 0

    output_signal = extract_module_output_signal(design)
    module_header = extract_module_header(design)
    wire_output_signal = []
    corrected_design = f"{module_header}\n"

    module_tail = ""

    design_description_lines = design_description.split("\n")
    module_header_lines = module_header.split("\n")

    var_name_list, value_list = [], []
    
    output_signal_index = 0
    for module_header_line in module_header_lines:
        if "output" in module_header_line:
            output_signal_index += 1;

        if "output" in module_header_line and ("reg" not in module_header_line):
            output_signal_name = output_signal[output_signal_index - 1]
            corrected_design += module_header_line.replace("output","reg").replace(output_signal_name, f"{output_signal_name}_reg")
            module_tail += f"    assign {output_signal_name} = {output_signal_name}_reg;\n"
            wire_output_signal.append(output_signal_name)
            if ";" not in module_header_line:
                corrected_design += ";\n"
            else:
                corrected_design += "\n" 
    
    corrected_design += "   always@(*)  begin\n"
    
    conditional_var = []
    for index, design_description_line in enumerate(design_description_lines):
        if " 0ns " in design_description_line:
            var_name_list = design_description_lines[index - 1].split(" ")
            var_name_list = [x for x in var_name_list if x != '']
        if "5ns" in design_description_line or "0ns" in design_description_line:
            value_list = design_description_line.split(" ")
            value_list = [x for x in value_list if x != '']        
        
        for var_index, var_name in enumerate(var_name_list):
            if (not var_name in conditional_var) and var_name != value_list[var_index] and value_list[var_index] != 'x':
                conditional_var.append(var_name)


    for index, design_description_line in enumerate(design_description_lines):

        if " 0ns " in design_description_line:
            var_name_list = design_description_lines[index - 1].split(" ")
            var_name_list = [x for x in var_name_list if x != '']

        if "5ns" in design_description_line or "0ns" in design_description_line:
            value_list = design_description_line.split(" ")
            value_list = [x for x in value_list if x != '']

            if value_list[-1] == 'x':
                continue

            corrected_design += "       if("
            
            case_id = case_id + 1
            meta_format = meta_format + f"Case: {case_id}\nInput:  "

            start_var_flag = True
            for var_index, var_name in enumerate(var_name_list):
                if var_name == "time" or 'ns' in var_name:
                    continue
                elif var_name != var_name_list[-1]:
                    if var_name not in conditional_var:
                        continue
                    value = process_input_value(var_name_list, value_list[var_index])
                    corrected_design += f"({var_name} == {value})" if start_var_flag else f"&&({var_name} == {value})"
                    start_var_flag = False
                    
                    meta_format = meta_format + f"{var_name} = {value}; "


                elif var_name == var_name_list[-1]:
                    corrected_design += ")"
                    value = process_output_value(var_name_list, value_list[var_index])
                    meta_format = meta_format + f"\nOutput: {var_name} = {value};\n"


                    if var_name in wire_output_signal:
                        corrected_design += f"   {var_name}_reg = {value};\n"
                    else:
                        corrected_design += f"   {var_name} = {value};\n"
    
    corrected_design += f"   end\n{module_tail}\nendmodule"


    return corrected_design, meta_format

def check_posedge(clk_value_list, output_value_list):
    for index, clk_value in enumerate(clk_value_list):
        if (index == 0 and clk_value == '1') or \
            (index > 0 and clk_value_list[index - 1] == '0' and clk_value_list[index] == '1'): #posedge
            current_index = index
            while current_index < len(clk_value_list) and clk_value_list[current_index] == '1':
                if current_index != index    \
                   and output_value_list[current_index - 1] != output_value_list[current_index]:
                    return False
                current_index += 1
            while current_index < len(clk_value_list) and clk_value_list[current_index] == '0':
                if current_index != index  \
                   and output_value_list[current_index - 1] != output_value_list[current_index]:
                    return False
                current_index += 1

    return True

def check_negedge(clk_value_list, output_value_list):
    for index, clk_value in enumerate(clk_value_list):
        if (index == 0 and clk_value == '0') or \
            (index > 0 and clk_value_list[index - 1] == '1' and clk_value_list[index] == '0'): #negedge
            current_index = index
            while current_index < len(clk_value_list) and clk_value_list[current_index] == '0':
                if current_index != index    \
                   and clk_value_list[current_index - 1] == clk_value_list[current_index]   \
                   and output_value_list[current_index - 1] != output_value_list[current_index]:
                    return False
                current_index += 1
            while current_index < len(clk_value_list) and clk_value_list[current_index] == '1':
                if current_index != index  \
                   and output_value_list[current_index - 1] != output_value_list[current_index]:
                    return False
                current_index += 1
    
    return True

def get_clk_edge_type(design_description: str, 
                      clk_index: int,
                      output_signal_index: int):
    clk_edge_type = "*"
    clk_value_list, output_value_list = [], []
    
    design_description_lines = design_description.split("\n")
    for design_description_line in design_description_lines:
        if "5ns " in design_description_line or "0ns " in design_description_line:
            var_value_list = design_description_line.split(" ")
            var_value_list = [x for x in var_value_list if x != '']

            clk_value_list.append(var_value_list[clk_index])
            output_value_list.append(var_value_list[output_signal_index])         
    
    if check_posedge(clk_value_list, output_value_list):
        clk_edge_type = "posedge"
    if check_negedge(clk_value_list, output_value_list):
        clk_edge_type = "negedge"
    return clk_edge_type
#Posedge , Negedge, *
def extract_sequential_waveform_logic(design_description: str, 
                                      design: str,
                                      output_signal: str):

    module_header = extract_module_header(design)
    output_signal_list = extract_module_output_signal(module_header)
    module_header_lines = module_header.split("\n")
    
    meta_format = ""
    case_id = 0

    clk_name = "clk" if "clk" in module_header else "clock"

    output_signal_type = "reg"
    for module_header_line in module_header_lines:
        if output_signal in module_header_line and "reg" not in module_header_line:
            output_signal_type = "wire"
 
    var_name_list = []
    design_description_lines = design_description.split("\n")
    for design_description_line in design_description_lines:
        if " clk " in design_description_line:
            var_name_list = design_description_line.split(" ")
            var_name_list = [x for x in var_name_list if x != ""]
            break

    clk_index, output_signal_index = -1, -1
    for index, var_name in enumerate(var_name_list):
        if var_name == "clk":
            clk_index = index
        if var_name == output_signal:
            output_signal_index = index
    clk_edge_type = get_clk_edge_type(design_description, clk_index, output_signal_index)
    
    always_block = "" if output_signal_type == "reg" else f"reg {output_signal}_reg;\n"
    output_signal_name = f"{output_signal}_reg" if  output_signal_type != "reg" else output_signal

    if clk_edge_type == "posedge" or clk_edge_type == "negedge":
        always_block += f"always @({clk_edge_type} {clk_name}) begin\n"
        for index, design_description_line in enumerate(design_description_lines): #posedge
            if index > 0 \
               and ("5ns " in design_description_line or "0ns " in design_description_line) \
               and ("5ns " in design_description_lines[index - 1] or "0ns " in design_description_lines[index - 1]):
               
               previous_design_description_line = design_description_lines[index - 1]
               input_var_value_list = previous_design_description_line.split(" ") 
               input_var_value_list = [x for x in input_var_value_list if x != '']

               now_var_value_list = design_description_line.split(" ") 
               now_var_value_list = [x for x in now_var_value_list if x != '']
               
               if (not (input_var_value_list[clk_index] == '0' and now_var_value_list[clk_index] == '1' and clk_edge_type == 'posedge')) and \
                  (not (input_var_value_list[clk_index] == '1' and now_var_value_list[clk_index] == '0' and clk_edge_type == 'negedge')):
                  continue

               output_value = now_var_value_list[output_signal_index]
               if 'x' in output_value: 
                   continue

               start_condition_flag = True
               condition = ""
               
               case_id = case_id + 1
               meta_format_im = ""
               
               for index, var_name in enumerate(var_name_list):
                   var_value = input_var_value_list[index]
                   if var_name == 'clk' or var_name == "clock" or var_name == 'time':
                       continue
                   if var_value == 'x' or output_value == 'x':
                       continue 
                   if var_name in output_signal_list and var_name != output_signal:
                       continue

                   condition += f"({var_name} == {process_input_value(var_name_list ,var_value)})" if start_condition_flag\
                                else f"&&({var_name} == {process_input_value(var_name_list, var_value)})"    
                   meta_format_im = meta_format_im + f"{var_name} = {process_input_value(var_name_list ,var_value)}; "
                   
                   start_condition_flag = False        
               if condition != "" and (not condition in always_block):
                   always_block += f"   if({condition})\n"
                   always_block += f"       {output_signal_name} <= {process_output_value(var_name_list, output_value)};\n"
                   meta_format = meta_format + f"Case: {case_id}\nInput:  {meta_format_im}"
                   meta_format = meta_format + f"\nOutput: {output_signal_name} = {process_output_value(var_name_list, output_value)};\n"

    else:
        previous_output_value, output_value = "x", "x"
        always_block += f"always @(*) begin\n"
        for design_description_line in design_description_lines:
            if not ('5ns ' in design_description_line or '0ns ' in design_description_line):
                continue
            var_value_list = design_description_line.split(" ") 
            var_value_list = [x for x in var_value_list if x != '']
            previous_output_value = output_value
            output_value = var_value_list[output_signal_index]
            if 'x' in output_value: 
                continue
            if previous_output_value == output_value:
                continue
            condition = ""
            start_condition_flag = True

            case_id = case_id + 1
            meta_format = meta_format + f"Case: {case_id}\nInput:  "


            for index, var_name in enumerate(var_name_list):
                   var_value = var_value_list[index]
                   if var_name == 'time':
                       continue
                   if var_value == 'x':
                       continue 
                   if var_name in output_signal_list:
                       continue
                   
                   if var_name == 'clk' and clk_name != 'clk':
                       var_name = clk_name
                   condition += f"({var_name} == {process_input_value(var_name_list ,var_value)})" if start_condition_flag\
                                else f"&&({var_name} == {process_input_value(var_name_list, var_value)})"
                   meta_format = meta_format + f"{var_name} = {process_input_value(var_name_list ,var_value)}; "

                   start_condition_flag = False
            if condition != "" and (not condition in always_block):
                always_block += f"   if({condition})\n"
                always_block += f"       {output_signal_name} = {process_output_value(var_name_list, output_value)};\n"
                meta_format = meta_format + f"\nOutput: {output_signal_name} = {process_output_value(var_name_list, output_value)};\n"

    
    
    always_block += f"\n    end\n"
    if output_signal_type != "reg":
        always_block += f"    assign {output_signal} = {output_signal_name};"
    return always_block, meta_format               


def sequential_waveform_conversion(design_description: str,
                              design: str):
    meta_format = ""
    
    module_header = extract_module_header(design)
    output_signal_list = extract_module_output_signal(module_header)

    corrected_design = module_header
    for output_signal in output_signal_list:
        meta_format = meta_format + f"\n{output_signal}'s logic\n"
        output_signal_always_block, output_signal_meta_format = extract_sequential_waveform_logic(design_description, design, output_signal)
        meta_format = meta_format + output_signal_meta_format
        corrected_design += f"\n{output_signal_always_block}"
    
    corrected_design += "\nendmodule"
    return corrected_design, meta_format

def multimodal_data_conversion(design_description: str, design: str = ""):
    
    corrected_design = design
    meta_format = ""
    if "karnaugh" in design_description.lower() or "kmap" in design_description.lower():
        corrected_design, meta_format = kmap_conversion(design_description, design)

    if "table" in design_description.lower():
        corrected_design, meta_format = truthtable_conversion(design_description, design)
    
    if ("clk" not in design_description.lower()) and "waveform" in design_description.lower():
        corrected_design, meta_format = combinational_waveform_conversion(design_description, design)
    
    if ("clk" in design_description.lower()) and "waveform" in design_description.lower():
        corrected_design, meta_format = sequential_waveform_conversion(design_description, design)
    return corrected_design, meta_format

if __name__ == "__main__":
    input_path = "./input"
    with open(f"{input_path}/description.txt", "r", encoding = 'utf-8', errors = 'ignore') as file:
        description = file.read()
    with open(f"{input_path}/design.sv", "r", encoding = 'utf-8', errors = 'ignore') as file:
        design = file.read() 
    corrected_design, meta_format = multimodal_data_conversion(description, design)
    with open(f"{input_path}/design.sv", "w", encoding = 'utf-8', errors = 'ignore') as file: file.write(design)
    print(corrected_design)
    print(meta_format)
