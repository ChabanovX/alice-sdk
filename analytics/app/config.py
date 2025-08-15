from pathlib import Path

MODEL_DIR: Path = Path("app/trained_models")
DATA_DIR: Path = Path("app/datasets")

BI_CLASSIFIER_PATH: Path = MODEL_DIR / "bi_classifier.joblib"
MULTICLASS_PATH: Path = MODEL_DIR / "multi_classifier.joblib"
TARIFF_CLASSIFIER_PATH: Path = MODEL_DIR / "tariff_classifier.joblib"

MAIN_DATA_PATH: Path = DATA_DIR / "main_data.csv"
CLASSES_DATA_PATH: Path = DATA_DIR / "dataset_6k_10_classes.csv"
OTHER_DATA_PATH: Path = DATA_DIR / "dataset_other_12k.csv.csv"
TARIFF_DATA_PATH: Path = DATA_DIR / "tariff_change.csv"
