import os
import openai
import numpy as np
import faiss
import csv
from sentence_transformers import SentenceTransformer
import torch
import logging

model = SentenceTransformer("Qwen/Qwen3-Embedding-0.6B")
EMBEDDING_DIM = 1024

index = faiss.IndexFlatL2(EMBEDDING_DIM)
metadata = []
WATCHED_DIR = "./code_rag/knowledge_base"
FAISS_INDEX_FILE = os.path.join(WATCHED_DIR, 'coderag_index.faiss')

def generate_embeddings(content: str, local = True):
    if local == False:
        try:
            response = openai.Embedding.create(
                input = content,
                model = model
            )
            embeddings = response['data'][0]['embedding']
            return np.array(embeddings).astype('float32').reshape(1, -1)
        except Exception as e:
            print(f"Error generating embeddings with OpenAI: {e}")
            return None
    else: 
        with torch.no_grad():
            embeddings = model.encode(content)
        return np.array(embeddings).astype('float32').reshape(1, -1)

def clear_index():
    """Delete the FAISS index and metadata files if they exist, and reinitialize the index."""
    global index, metadata
    
    # Delete the FAISS index file
    if os.path.exists(FAISS_INDEX_FILE):
        os.remove(FAISS_INDEX_FILE)
        print(f"Deleted FAISS index file: {FAISS_INDEX_FILE}")

    # Delete the metadata file
    metadata_file = f"{WATCHED_DIR}/metadata.csv"
    if os.path.exists(metadata_file):
        os.remove(metadata_file)
        print(f"Deleted metadata file: {metadata_file}")

    # Reinitialize the FAISS index and metadata
    index = faiss.IndexFlatL2(EMBEDDING_DIM)
    metadata = []

def add_to_index(embeddings, full_content, file_name, file_path):
    global index, metadata

    if embeddings.shape[1] != index.d:
        raise ValueError(f"Embedding dimension {embeddings.shape[1]} does not match FAISS index dimension {index.d}")
    
    keyword = full_content.split('\n')[0].split('[Keyword]: ')[1]
    relative_file_path = os.path.relpath(file_path, WATCHED_DIR)
    
    index.add(embeddings)
    metadata.append({
        "keyword": keyword,
        "content": full_content,
        "filename":file_name,
        "filepath": relative_file_path
    })

def save_index():
    faiss.write_index(index, FAISS_INDEX_FILE)
    with open(f"{WATCHED_DIR}/metadata.csv", "w", newline="", encoding = 'utf-8') as f:
        fieldnames = ['keyword', 'content', 'filename', 'filepath']
        writer = csv.DictWriter(f, fieldnames = fieldnames, quoting=csv.QUOTE_MINIMAL)
        writer.writeheader()
        writer.writerows(metadata)

def load_index():
    global index, metadata
    index = faiss.read_index(FAISS_INDEX_FILE)
    
    loaded_metadata = []
    csv.field_size_limit(10 * 1024 * 1024) 
    with open(f"{WATCHED_DIR}/metadata.csv", "r", encoding = 'utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            loaded_metadata.append(row)
    metadata = loaded_metadata
    
    #print(metadata)

    return index, metadata

def retrieve_vectors(n=5):
    n = min(n, index.ntotal)
    vectors = np.zeros((n, EMBEDDING_DIM), dtype=np.float32)
    for i in range(n):
        vectors[i] = index.reconstruct(i)
    return vectors

def inspect_metadata(n=5):
    print(f"Inspecting the first {n} metadata entries:")
    for i, data in enumerate(metadata[:n]):
        print(f"Entry {i}:")
        print(f"Filename: {data['filename']}")
        print(f"Filepath: {data['filepath']}")
        print(f"Content: {data['content'][:100]}...")  # Show the first 100 characters
        print()

def full_reindex():
    logging.info("Starting full reindexing of the codebase...")
    files_processed = 0
        
    for root, _, files in os.walk(WATCHED_DIR):
        for file in files:
            filepath = os.path.join(root, file)
            print(filepath)
            try:
                with open(filepath, "r", encoding = 'utf-8') as file: full_content = file.read()
                
                # only embedding text
                if "[Design Detail]:" in full_content:
                    embed_content = full_content.split("[Design Detail]:")[0]
                else:
                    embed_content = full_content

                embeddings = generate_embeddings(embed_content)
                if embeddings is not None:
                    add_to_index(embeddings, full_content, file, filepath)
                else:
                    logging.warning(f"Failed to generate embeddings for {filepath}")
                files_processed += 1
            except Exception as e:
                logging.error(f"Error processing file {filepath}: {e}")

    save_index()
    logging.info(f"Full reindexing completed. {files_processed} files processed.")
    
if __name__ == "__main__":
    
    clear_index()
    full_reindex()