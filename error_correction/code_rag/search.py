import numpy as np
import os
from .index import load_index, generate_embeddings

def vector_search(query: str, k = 1):
    index, metadata = load_index()
    query_embedding = generate_embeddings(query)

    if query_embedding is None:
        print(f"Failed to generate query embedding.")
        return []
    
    distances, indices = index.search(query_embedding, k)

    results = []
    for i, idx in enumerate(indices[0]):
        if idx < len(metadata):
            file_data = metadata[idx]
            results.append(file_data['content'])
        else:
            print(f"Warning: Index {idx} is out of bounds for metadata with length {len(get_metadata())}")
    return results

def keyword_search(query: str, k = 1):
    index, metadata = load_index()
    tuple_results = []
    for file_data in metadata:
        keyword = file_data['keyword']
        content = file_data['content']
        
        str1 = keyword.lower().strip()
        str2 = query.lower().strip()
        if str1 in str2:
           tuple_results.append((content, len(keyword)))

    sorted_results = sorted(tuple_results, key = lambda x: x[1], reverse = True)
    results = []
    for index, tuple_result in enumerate(tuple_results):
        if index >= k:
            break
        results.append(tuple_result[0])
    
    return results

def hybrid_search(query: str, k1 = 1, k2 = 0):
    vector_results = vector_search(query, k = k1)
    keyword_results = keyword_search(query, k = k2)
    results = list(set(vector_results + keyword_results))
    return results


if __name__ == "__main__":
    #print(vector_search("Please implement a dual-edge D flip-flop", k = 1))
    print(hybrid_search("Please implement a dual-edge D flip-flop", k1 = 1, k2 = 1))