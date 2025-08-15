import joblib
import numpy as np
import pandas as pd
from pathlib import Path
from catboost import CatBoostClassifier
from typing import Any, Dict, List, Union

from .abstract_model import BaseClassifier, ArrayLike


class MultiClassifier(BaseClassifier):
    def __init__(
            self,
            n_bags: int = 4,
            depths: List[int] | None = None,
            lrs: List[float] | None = None,
            regs: List[int] | None = None,
            iterations: int = 500,
            random_state: int = 42,
            **cb_params: Any,
    ) -> None:
        super().__init__()

        self.n_bags = n_bags
        self.depths = depths or [6, 8]
        self.lrs = lrs or [0.03, 0.05]
        self.regs = regs or [3, 5]

        self._cb_params: Dict[str, Any] = {
            "iterations": iterations,
            "random_state": random_state,
            "loss_function": "MultiClass",
            "verbose": False,
            **cb_params,
        }

        self.models_: List[CatBoostClassifier] = []
        self.lbl2id_: Dict[str, int] = {}
        self.id2lbl_: Dict[int, str] = {}
        self.feature_names_in_: List[str] | None = None
        self._expects_df: bool | None = None

    def fit(self, X: ArrayLike, y: pd.Series) -> "MultiClassifier":
        print("It's fucking new MULTI-classifier")
        X_df = self._to_dataframe(X, fit_phase=True)
        classes = sorted(y.unique())
        self.lbl2id_ = {c: i for i, c in enumerate(classes)}
        self.id2lbl_ = {i: c for c, i in self.lbl2id_.items()}
        y_int = y.map(self.lbl2id_).to_numpy(dtype=int)

        self.models_.clear()
        n_samples = len(X_df)

        for bag_idx in range(self.n_bags):
            rng = np.random.RandomState(self._cb_params["random_state"] + bag_idx)
            idx = rng.choice(n_samples, int(0.8 * n_samples), replace=True)

            params = {
                "depth": self.depths[bag_idx % len(self.depths)],
                "learning_rate": self.lrs[bag_idx % len(self.lrs)],
                "l2_leaf_reg": self.regs[bag_idx % len(self.regs)],
                **self._cb_params,
                "random_state": self._cb_params["random_state"] + bag_idx,
            }

            clf = CatBoostClassifier(**params)
            clf.fit(X_df.iloc[idx], y_int[idx])
            self.models_.append(clf)

        return self

    def predict_proba(self, X: ArrayLike) -> np.ndarray:
        if not self.is_fitted():
            raise ValueError("Model is not fitted yet.")

        X_df = self._to_dataframe(X, fit_phase=False)

        n_classes = len(self.lbl2id_)
        agg = np.zeros((len(X_df), n_classes), dtype=float)
        for m in self.models_:
            agg += m.predict_proba(X_df)
        return agg / self.n_bags

    def predict(self, X: ArrayLike) -> np.ndarray:
        proba = self.predict_proba(X)
        class_ids = proba.argmax(axis=1)
        return np.vectorize(self.id2lbl_.get)(class_ids)

    def predict_many(self, X: np.ndarray) -> np.ndarray:
        return self.predict(X)

    def is_fitted(self) -> bool:
        return (
                bool(self.models_)
                and self.feature_names_in_ is not None
                and all(m.is_fitted() for m in self.models_)
        )

    def save(self, path: Union[str, Path]) -> None:
        if not self.is_fitted():
            raise ValueError("Model is not fitted yet. Call 'fit' before saving.")

        path = Path(path)
        path.parent.mkdir(parents=True, exist_ok=True)

        payload = {
            "models": self.models_,
            "lbl2id": self.lbl2id_,
            "id2lbl": self.id2lbl_,
            "features": self.feature_names_in_,
            "expects_df": self._expects_df,
            "init_params": {
                "n_bags": self.n_bags,
                "depths": self.depths,
                "lrs": self.lrs,
                "regs": self.regs,
                "_cb_params": self._cb_params,
            },
        }
        joblib.dump(payload, path)

    @classmethod
    def load(cls, path: Union[str, Path]) -> "MultiClassifier":
        payload = joblib.load(path)
        init = payload["init_params"]

        inst = cls(
            n_bags=init["n_bags"],
            depths=init["depths"],
            lrs=init["lrs"],
            regs=init["regs"],
            **{k: v for k, v in init["_cb_params"].items() if k not in {"loss_function"}}
        )

        inst.models_ = payload["models"]
        inst.lbl2id_ = payload["lbl2id"]
        inst.id2lbl_ = payload["id2lbl"]
        inst.feature_names_in_ = payload["features"]
        inst._expects_df = payload["expects_df"]

        if not inst.is_fitted():
            raise ValueError("Loaded model is not fitted.")
        return inst
