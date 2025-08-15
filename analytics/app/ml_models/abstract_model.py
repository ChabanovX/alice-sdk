import pandas as pd
import numpy as np
from pathlib import Path
from typing import Any, Union
from abc import ABC, abstractmethod

ArrayLike = Union[pd.DataFrame, np.ndarray]


class BaseClassifier(ABC):
    @abstractmethod
    def is_fitted(self) -> bool:
        raise NotImplementedError

    @abstractmethod
    def predict(self, X: ArrayLike) -> Any:
        raise NotImplementedError

    @abstractmethod
    def fit(self, X: ArrayLike, y: pd.Series):
        raise NotImplementedError

    @abstractmethod
    def save(self, path: Union[str, Path]):
        raise NotImplementedError

    @classmethod
    @abstractmethod
    def load(cls, path: Union[str, Path]):
        raise NotImplementedError

    def _to_dataframe(self, X: ArrayLike, *, fit_phase: bool) -> pd.DataFrame:
        if isinstance(X, pd.DataFrame):
            if fit_phase:
                self.feature_names_in_ = list(X.columns)
                self._expects_df = True
            else:
                X = X[self.feature_names_in_]
            return X.reset_index(drop=True)

        if isinstance(X, pd.Series):
            X = X.to_frame().T
            return self._to_dataframe(X, fit_phase=fit_phase)

        if isinstance(X, np.ndarray):
            if X.ndim == 1:
                X = X.reshape(1, -1)
            if fit_phase:
                self.feature_names_in_ = [f"f{i}" for i in range(X.shape[1])]
                self._expects_df = False
            elif X.shape[1] != len(self.feature_names_in_):
                raise ValueError(
                    f"Wrong number of features: expected {len(self.feature_names_in_)}, got {X.shape[1]}"
                )
            return pd.DataFrame(X, columns=self.feature_names_in_)

        raise TypeError("X must be pandas DataFrame / Series or numpy ndarray")
