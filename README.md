# RTLErrorAnalysis
In this work, we systematically categorize the causes of LLM-generated RTL errors and corresponding correction methods based on VerilogEval-Human benchmark.

## SetUp
1. Create a Virtual Environment
```
# For Windows
python -m venv venv
venv\Scripts\activate  # Activate

# For macOS/Linux
python3 -m venv venv
source venv/bin/activate  # Activate
```
2. Install Dependencies
```
pip install -r requirements.txt
```
You can call the model via a remote API, or deploy your own model on your server/host for local use. (config.py: local = True means use local model)

## How to Use

### 1. Error Analysis

gpt-3.5-turbo: 89 faulty designs (including manually annotated labels)

gpt-4-turbo: 65 faulty designs (including manually annotated labels)

qwen-coder-32B-instruction: 83 faulty designs (including manually annotated labels)

Error_Analysis_zh.pdf: This report systematically analyzes and categorizes the root causes of errors in each identified case. (Chinese version)

It should be noted that all error categories were manually annotated and may contain inaccuracies or incompleteness.

### 2. Error Correction
config.py: You can configure various settings in this file including api_base, api_key, model_name and other related information.

code_rag:

1. knowledge_base: including over 400 annotated RTL design samples
2. index.py: Implement indexing construction for the knowledge_base. (base on Qwen-Embedding-0.6B)
3. search.py: Implement hybrid retrieval on the database using FAISS.

input: 
1. description.txt: The relevant description of the design to be generated.
2. design.sv: The generated design will be written to this file.
3. ref.sv (optional): golden design
4. testbench.sv (optional)

**rag_based_knowledge_error_mitigation.py:** Reducing RTL generation errors through Hybrid Retrieval-Augmented Generation (RAG) Methods (Knowledge Base is in code_rag)

**multimodal_data_conversion.py:** Generating Verilog code with automated conversion tools for KMAP, Waveform, and Truth Table Inputs

**rule_based_description_refinement.py:** Enhanced Verilog code generation with description refinement and RTL design rule compliance

**two_stage_localization_and_correction.py:** Iterative RTL error localization and repair methodology leveraging testbench verification

**main.py:** Integrate all correction methods into a unified pipeline.

You can leverage the aforementioned methods to assist in generating higher-quality RTL code based on specific requirements.
 

**Looking forward to your further suggestions!**





