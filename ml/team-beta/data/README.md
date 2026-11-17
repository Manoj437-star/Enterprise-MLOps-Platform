# Team Beta - NLP Dataset

This directory contains reference dataset assets for NLP sentiment and text classification model training.

- **Dataset Type**: Synthetic / Tokenized Text Sequences (Sequence length: 32 tokens, Binary Sentiment: Positive / Negative).
- **Generation**: Integrated in `train.py` via `generate_synthetic_nlp_data()`, enabling fast offline validation without requiring large external Hugging Face downloads during POC runs.
- **Production Integration**: For production workloads, curated text corpuses are mounted directly from the Central Shared Storage Account (`stmlopsshared0vx1e/golden-datasets`) via Azure ML Datastore (`azureml:golden_nlp_dataset`).
- **Benchmark Source**: Modeled after standard SST-2 / IMDb movie reviews sentiment benchmarks.
