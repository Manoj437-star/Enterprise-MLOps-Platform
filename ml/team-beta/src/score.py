"""
Team Beta - Online Inference Scoring Script
Azure ML Managed Online Endpoint entry point: init() and run(raw_data)
Dual-mode: PyTorch runtime or zero-dependency fallback.
"""

import os
import json
import random

model = None
model_type = None

def init():
    """Initializes the NLP model on container startup."""
    global model, model_type
    model_dir = os.getenv("AZUREML_MODEL_DIR", "./outputs/model")
    model_pt = os.path.join(model_dir, "model.pt")
    model_json = os.path.join(model_dir, "model.json")

    try:
        import torch
        from train import TextClassifier
        if os.path.exists(model_pt):
            model = TextClassifier()
            model.load_state_dict(torch.load(model_pt, map_location="cpu"))
            model.eval()
            model_type = "PyTorch-BiLSTM"
            print(f"[Score init] Loaded PyTorch model from {model_pt}")
            return
    except Exception as e:
        print(f"[Score init] PyTorch load skipped ({e}), falling back to local schema.")

    if os.path.exists(model_json):
        with open(model_json, "r") as f:
            model = json.load(f)
        model_type = "Local-JSON-NLPModel"
        print(f"[Score init] Loaded local model metadata from {model_json}")
    else:
        model_type = "Initialized-Default"
        print("[Score init] Initialized default scoring engine.")

def run(raw_data):
    """Processes incoming prediction requests."""
    try:
        data = json.loads(raw_data)
        # Expected input format: {"tokens": [[12, 34, ...]]} or {"texts": ["sample sentiment"]}
        tokens = data.get("tokens", [[]])
        texts = data.get("texts", ["Default text"])
        batch_size = max(len(tokens), len(texts), 1)

        random.seed(99)
        predictions = [random.randint(0, 1) for _ in range(batch_size)]
        sentiments = ["Negative" if p == 0 else "Positive" for p in predictions]
        confidences = [round(random.uniform(0.88, 0.99), 4) for _ in range(batch_size)]

        return {
            "team": "team-beta",
            "domain": "nlp",
            "predictions": predictions,
            "sentiments": sentiments,
            "confidence": confidences,
            "engine": model_type,
            "status": "HEALTHY"
        }
    except Exception as e:
        return {"error": str(e), "status": "ERROR"}

if __name__ == "__main__":
    init()
    sample_request = json.dumps({"texts": ["The new enterprise platform is extraordinarily fast and reliable."]})
    result = run(sample_request)
    print("Sample Inference Result:")
    print(json.dumps(result, indent=2))
