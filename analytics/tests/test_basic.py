from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_cluster_endpoint():
    raw = {"text": "привет мир"}
    resp = client.post("/cluster", json=raw)
    assert resp.status_code == 200
    data = resp.json()
    assert "text" in data