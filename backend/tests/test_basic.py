# Start via `make test-debug` or `make test-release`


async def test_basic(service_client, mockserver):
    calls = []

    @mockserver.json_handler('/cluster')
    def _mock_cluster(request):
        calls.append(request)
        assert request.json.get('text') == 'Принять заказ'
        return {
            "scenario": "ACCEPT_ORDER",
            "address": "",
            "address_number": None,
            "fare": ""
        }

    response = await service_client.post('/classify-message', json={'text': 'Принять заказ'})
    assert response.status == 200

    got = response.json()
    expected = {"scenario": "ACCEPT_ORDER", "address": "", "address_number": None, "fare": ""}
    assert got == expected

    # опциональная проверка, что внешний сервис был вызван ровно 1 раз
    assert len(calls) == 1

async def test_error_empty_request(service_client):
    response = await service_client.post('/classify-message')
    assert response.status == 400

async def test_error_request_without_text(service_client):
    response = await service_client.post('/classify-message',json={'name': 'Sus'})
    assert response.status == 400