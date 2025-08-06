# Start via `make test-debug` or `make test-release`


async def test_basic(service_client):
    response = await service_client.post('/classify-message', json={'text': 'Привет от бека!'})
    assert response.status == 200
    assert response.text == 'Привет от бека!'

async def test_error_empty_request(service_client):
    response = await service_client.post('/classify-message')
    assert response.status == 400

async def test_error_request_without_text(service_client):
    response = await service_client.post('/classify-message',json={'name': 'Sus'})
    assert response.status == 400