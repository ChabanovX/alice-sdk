from __future__ import annotations

from pathlib import Path
from typing import Any, List, Tuple

import numpy as np
import pandas as pd

from app.config import BI_CLASSIFIER_PATH, MAIN_DATA_PATH, MULTICLASS_PATH
from app.ml_models import BertEmbedder, BiClassifier, MultiClassifier


class IntentClassifier:
    def __init__(
            self,
            embd: BertEmbedder | None = None,
            X_data: pd.DataFrame | None = None,
            y_data: pd.Series | None = None,
    ) -> None:
        self.embedder_: BertEmbedder = embd or BertEmbedder()
        self.X_: pd.DataFrame | None = X_data
        self.y_: pd.Series | None = y_data
        self.detector_: BiClassifier = BiClassifier()
        self.multi_classifier_: MultiClassifier = MultiClassifier()
        self.MODELS_CFG: List[dict[str, Any]] = [
            {"attr": "detector_", "path": Path(BI_CLASSIFIER_PATH), "cls": BiClassifier},
            {"attr": "multi_classifier_", "path": Path(MULTICLASS_PATH), "cls": MultiClassifier},
        ]

    def _prepare_for_bi(self) -> Tuple[pd.DataFrame, pd.Series]:
        if self.X_ is None or self.y_ is None:
            raise ValueError("Не заданы X_ и/или y_")
        label_map = {"other": 0, "inlier": 1}
        y_bin = self.y_.map(lambda v: label_map["other"] if v == "other" else label_map["inlier"])
        return self.X_, y_bin

    def _prepare_for_multi(self) -> Tuple[pd.DataFrame, pd.Series]:
        if self.X_ is None or self.y_ is None:
            raise ValueError("Не заданы X_ и/или y_")
        mask = self.y_.ne("other")
        return self.X_.loc[mask].reset_index(drop=True), self.y_.loc[mask].reset_index(drop=True)

    def _get_data_for(self, cls_) -> Tuple[pd.DataFrame, Any]:
        return self._prepare_for_bi() if cls_ is BiClassifier else self._prepare_for_multi()

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
                X_train, y_train = self._get_data_for(cls_)
                model = cls_() if model is None else model
                model.fit(X_train, y_train)
                path.parent.mkdir(parents=True, exist_ok=True)
                model.save(path)
            setattr(self, attr, model)

    def _vectorize(self, text: str) -> np.ndarray:
        vec = self.embedder_.embed(text)
        return vec.reshape(1, -1) if vec.ndim == 1 else vec

    def predict_intention(self, text: str) -> str:
        self.dump_models()
        vec = self._vectorize(text.lower())
        if self.detector_.predict(vec)[0] == 0:
            return "other"
        return str(self.multi_classifier_.predict(vec)[0])


if __name__ == "__main__":
    import time
    df = pd.read_csv(MAIN_DATA_PATH, sep=";")
    y = df["label"]
    embedder = BertEmbedder()
    X = pd.DataFrame(np.vstack([embedder.embed(t) for t in df["text"]]))
    clf = IntentClassifier(embedder, X, y)
    clf.dump_models(force_retrain=True)
    phrase = 'Прими заказ'
    t0 = time.perf_counter()
    print(clf.predict_intention(phrase))
    t1 = time.perf_counter()
    print(f'Performance: {t1 - t0}')
