import time
import os
from watchdog.observers import Observer
from watchdog.events import FileSystemEvent, FileSystemEventHandler
from CodeRAG.index import add_to_index, save_index
from CodeRAG.embeddings import generate_embeddings
from config import *

class CodeChangeHander(FileSystemEventHandler):
    def on_modified(self, event: FileSystemEvent):
        if event.is_directory:
            return
        
        if event.src_path.endswith(".txt"):
            print(f"Detected change in file: {event.src_path}")
            with open(event.src_path, "r", encoding = 'utf-8') as file:
                full_content = file.read()
            embeddings = generate_embeddings(full_content)
            
            if embeddings is not None and len(embeddings) > 0:
                filename = os.path.basename(event.src_path)
                add_to_index(embeddings, full_content, filename, event.src_path)
                save_index()
                print(f"Update FAISS index for file: {event.src_path}")

def start_monitoring(WATCHED_DIR: str):
    event_handler = CodeChangeHander()
    observer = Observer()
    observer.schedule(event_handler, path = WATCHED_DIR, recursive = True)
    observer.start()

    print(f"Started monitoring {WATCHED_DIR} ...")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()