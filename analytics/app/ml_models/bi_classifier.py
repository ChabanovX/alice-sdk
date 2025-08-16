import joblib
import numpy as np
import pandas as pd
from pathlib import Path
from catboost import CatBoostClassifier
from typing import Any, Union, List, Dict

from .abstract_model import BaseClassifier, ArrayLike


class BiClassifier(BaseClassifier):
    def __init__(self, bin_thresh: float = 0.80, **cb_params: Any):
        super().__init__()
        self.bin_thresh = bin_thresh
        self.feature_names_in_: List[str] | None = None
        self.model_: CatBoostClassifier | None = None
        self._expects_df: bool | None = None
        defaults: Dict[str, Any] = {
            "iterations": 500,
            "learning_rate": 0.05,
            "loss_function": "Logloss",
            "random_seed": 42,
            "verbose": False,
        }
        self._cb_params: Dict[str, Any] = {**defaults, **cb_params}

    def fit(self, X: ArrayLike, y: pd.Series) -> "BiClassifier":
        print("It's fucking new BI-classifier")
        X_df = self._to_dataframe(X, fit_phase=True)
        y_int = y.astype(int).to_numpy()
        pos, neg = (y_int == 1).sum(), (y_int == 0).sum()
        self._cb_params["scale_pos_weight"] = neg / pos if pos > 0 else 1.0
        self.model_ = CatBoostClassifier(**self._cb_params)
        self.model_.fit(X_df, y_int)
        return self

    def predict_proba(self, X: ArrayLike) -> np.ndarray:
        if not self.is_fitted():
            raise ValueError("Model is not fitted yet.")
        X_df = self._to_dataframe(X, fit_phase=False)
        return self.model_.predict_proba(X_df)

    def predict(self, X: ArrayLike) -> np.ndarray:
        prob = self.predict_proba(X)[:, 1]
        return (prob >= self.bin_thresh).astype(int)

    def is_fitted(self) -> bool:
        return (
                self.model_ is not None
                and self.model_.is_fitted()
                and self.feature_names_in_ is not None
        )

    def save(self, path: Union[str, Path]):
        if not self.is_fitted():
            raise ValueError("Model is not fitted yet. Call 'fit' before saving.")

        path = Path(path)
        path.parent.mkdir(parents=True, exist_ok=True)

        payload = {
            "model": self.model_,
            "features": self.feature_names_in_,
            "bin_thresh": self.bin_thresh,
            "_cb_params": self._cb_params,
            "expects_df": self._expects_df,
        }
        joblib.dump(payload, path)

    @classmethod
    def load(cls, path: Union[str, Path]) -> "BiClassifier":
        payload = joblib.load(path)
        inst = cls(
            bin_thresh=payload["bin_thresh"],
            **{k: v for k, v in payload["_cb_params"].items() if k not in {"loss_function"}}
        )
        inst.model_ = payload["model"]
        inst.feature_names_in_ = payload["features"]
        inst._expects_df = payload["expects_df"]
        if not inst.is_fitted():
            raise ValueError("Loaded model is not fitted.")
        return inst
