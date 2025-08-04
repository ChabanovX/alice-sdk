# Start via `make test-debug` or `make test-release`


async def test_basic(service_client):
    response = await service_client.post('/classify-message', json={'name': 'Tester', 'text': 'Hello, Tester!'})
    assert response.status == 200
    assert response.text == 'Hello, Tester!\n'