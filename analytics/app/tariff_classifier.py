from __future__ import annotations

from pathlib import Path
from typing import Any, List

import numpy as np
import pandas as pd

from app.config import TARIFF_DATA_PATH, TARIFF_CLASSIFIER_PATH
from app.ml_models import BertEmbedder, MultiClassifier


class TariffClassifier:
    def __init__(
            self,
            embd: BertEmbedder | None = None,
            X_data: pd.DataFrame | None = None,
            y_data: pd.Series | None = None,
    ) -> None:
        self.embedder_: BertEmbedder = embd or BertEmbedder()
        self.X_: pd.DataFrame | None = X_data
        self.y_: pd.Series | None = y_data
        self.multi_classifier_: MultiClassifier = MultiClassifier()
        self.MODELS_CFG: List[dict[str, Any]] = [
            {"attr": "multi_classifier_", "path": Path(TARIFF_CLASSIFIER_PATH), "cls": MultiClassifier},
        ]

    @staticmethod
    def _is_fitted(model) -> bool:
        if hasattr(model, "is_fitted") and callable(model.is_fitted):
            return model.is_fitted()
        return hasattr(model, "classes_")

    def dump_models(self, *, force_retrain: bool = False) -> None:
        for cfg in self.MODELS_CFG:
            attr, path, cls_ = cfg["attr"], cfg["path"], cfg["cls"]
            model = getattr(self, attr)
            if self._is_fitted(model) and not force_retrain:
                continue
            if path.exists() and not force_retrain:
                model = cls_.load(path)
            if not self._is_fitted(model) or force_retrain:
                model = cls_() if model is None else model
                model.fit(self.X_, self.y_)
                path.parent.mkdir(parents=True, exist_ok=True)
                model.save(path)
            setattr(self, attr, model)

    def _vectorize(self, text: str) -> np.ndarray:
        vec = self.embedder_.embed(text)
        return vec.reshape(1, -1) if vec.ndim == 1 else vec

    def predict_tariff(self, text: str) -> str:
        self.dump_models()
        vec = self._vectorize(text)
        return str(self.multi_classifier_.predict(vec)[0])


if __name__ == "__main__":
    df = pd.read_csv(TARIFF_DATA_PATH, sep=";")
    y = df["label"]
    embedder = BertEmbedder()
    X = pd.DataFrame(np.vstack([embedder.embed(t) for t in df["text"]]))
    clf = TariffClassifier(embedder, X, y)
    clf.dump_models(force_retrain=True)
    import time
    while True:
        phrase=input()

        start_time = time.perf_counter()
        print(clf.predict_tariff(phrase))
        end_time = time.perf_counter()

        elapsed_time = end_time - start_time
        print(f"Время выполнения: {elapsed_time:.4f} секунд")
