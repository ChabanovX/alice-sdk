import numpy as np

import torch
from transformers import AutoTokenizer, AutoModel

class BertEmbedder:
    def __init__(self):
        self.tokenizer = AutoTokenizer.from_pretrained("cointegrated/rubert-tiny2")
        self.model = AutoModel.from_pretrained("cointegrated/rubert-tiny2")

    def embed(self, text) -> np.ndarray:
        t = self.tokenizer(text, padding=True, truncation=True, return_tensors="pt")
        with torch.no_grad():
            model_output = self.model(
                **{k: v.to(self.model.device) for k, v in t.items()}
            )
        embeddings = model_output.last_hidden_state[:, 0, :]
        embeddings = torch.nn.functional.normalize(embeddings)
        return embeddings[0].cpu().numpy()
