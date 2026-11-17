# Team Alpha - Computer Vision Dataset

This directory contains reference dataset assets for Computer Vision model training.

- **Dataset Type**: Synthetic RGB Images (3 channels, 32x32 resolution, 10 image classes)
- **Generation**: Integrated in `train.py` via `generate_synthetic_data()`, avoiding large binary downloads during initial POC training runs.
- **Production Integration**: For production workloads, images are mounted directly from the Central Shared Storage Account (`stmlopsshared0vx1e/golden-datasets`) via Azure ML Datastore (`azureml:golden_cv_dataset`).
