## Context-aware chunking

- Run `python pipeline/context_chunk.py` to convert every PDF in `pipeline/data` into JSONL chunks under `pipeline/chunks`.
- Chunking respects paragraph boundaries (using PyMuPDF blocks) and only splits long blocks on sentence boundaries.
- Tweak `MAX_CHARS_PER_CHUNK` / `MIN_CHARS_PER_CHUNK` in `pipeline/context_chunk.py` to suit your model limits.

## Semantic chunking (Azure + AutoGen)

- Ensure Azure OpenAI env vars are set (`OPENAI_KEY`, `OPENAI_ENDPOINT`, `OPENAI_MODEL`, optional `OPENAI_API_VERSION`).
- Run `python pipeline/semantic_chunk.py` to produce JSONL chunks in `pipeline/chunks_semantic`.
- This script sends paragraph windows to Azure via AutoGen, asking the model to group adjacent paragraphs into semantic chunks (~1200 chars).
- Each JSONL line includes `chunk_id`, `text`, `pages`, `paragraph_ids`, `label`, `char_len`, `total_chunks`, and `source`.
