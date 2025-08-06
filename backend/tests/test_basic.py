# Start via `make test-debug` or `make test-release`


async def test_basic(service_client):
    response = await service_client.post('/classify-message', json={'text': 'Привет от бека!'})
    assert response.status == 200
    assert response.text == 'Привет от бека!'