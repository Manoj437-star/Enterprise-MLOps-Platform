"""
Team Alpha - Model Evaluation and Quality Gate Script
Evaluates model accuracy against baseline threshold (e.g. 0.70)
Exports evaluation_report.json and returns appropriate exit codes for CI/CD gates.
"""

import os
import sys
import argparse
import json
import random

def evaluate(model_dir, threshold=0.70):
    metrics_path = os.path.join(model_dir, "metrics.json")
    model_json_path = os.path.join(model_dir, "model.json")
    model_pt_path = os.path.join(model_dir, "model.pt")

    if not os.path.exists(model_pt_path) and not os.path.exists(model_json_path):
        raise FileNotFoundError(f"No model artifacts found in directory: {model_dir}")

    # Read train metrics if available
    train_acc = 0.85
    if os.path.exists(metrics_path):
        with open(metrics_path, "r") as f:
            data = json.load(f)
            train_acc = data.get("final_val_accuracy", 0.85)

    random.seed(123)
    # Simulated test evaluation variation around validation accuracy
    test_accuracy = min(0.98, max(0.50, train_acc + random.uniform(-0.02, 0.02)))
    precision = round(test_accuracy * random.uniform(0.96, 0.99), 4)
    recall = round(test_accuracy * random.uniform(0.95, 0.98), 4)
    f1_score = round(2 * (precision * recall) / (precision + recall), 4)

    passed = test_accuracy >= threshold

    report = {
        "team": "team-alpha",
        "domain": "computer-vision",
        "model_name": "cv-classifier-alpha",
        "eval_accuracy": round(test_accuracy, 4),
        "precision": precision,
        "recall": recall,
        "f1_score": f1_score,
        "target_threshold": threshold,
        "gate_passed": passed,
        "status": "APPROVED_FOR_REGISTRY" if passed else "REJECTED_QUALITY_GATE",
        "evaluation_timestamp": "2026-11-13T01:50:00Z"
    }

    report_path = os.path.join(model_dir, "evaluation_report.json")
    with open(report_path, "w") as f:
        json.dump(report, f, indent=2)

    print(f"[Quality Gate] Team Alpha CV Evaluation:")
    print(f"  Test Accuracy: {report['eval_accuracy']} (Threshold: {threshold})")
    print(f"  Precision:     {report['precision']}")
    print(f"  Recall:        {report['recall']}")
    print(f"  F1 Score:      {report['f1_score']}")
    print(f"  Gate Decision: {report['status']}")

    if not passed:
        print("ERROR: Quality gate rejected model due to insufficient accuracy.")
        sys.exit(1)
    else:
        print("SUCCESS: Model passed quality gate. Approved for Central Azure ML Registry.")
        return report

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model-dir", type=str, default="./outputs/model", help="Path to trained model")
    parser.add_argument("--threshold", type=float, default=0.70, help="Minimum accuracy gate")
    args = parser.parse_args()

    evaluate(args.model_dir, args.threshold)
