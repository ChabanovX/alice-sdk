# async def test_trivial_request(service_client):
#     test_cases = [
#         'принять заказ',
#     ]
#     for text in test_cases:
#         response = await service_client.post('/classify-message', json={'text': text})
#         assert response.status == 200
#         assert response.text == 'ACCEPT_ORDER'

# async def test_noise_request(service_client):
#     test_cases = [
#         'принять заказ вмымсм цоурмси цума лл млц',
#         'лао ивалоук лепл ол принять заказ',
#         'иа оруоки укиук к принять заказ улокадоир уоркиа',
#         'улоукт кумм укмпринять заказуокаулпм ппмла',
#         'ысдутамсицуамкипринятьзаказукаиуамшг',
#     ]
#     for text in test_cases:
#         response = await service_client.post('/classify-message', json={'text': text})
#         assert response.status == 200
#         assert response.text == 'ACCEPT_ORDER'

# async def test_another_words_request(service_client):
#     test_cases = [
#         'принять заказ в этот раз',
#         'доброго дня алиса принять заказ',
#         'сейчас я хочу принять заказ но это будет последний на сегодня',
#         'сейчас я хочупринять заказно это будет последний на сегодня',
#         'сейчасяхочупринятьзаказноэтобудетпоследнийнасегодня',
#     ]
#     for text in test_cases:
#         response = await service_client.post('/classify-message', json={'text': text})
#         assert response.status == 200
#         assert response.text == 'ACCEPT_ORDER'

# async def test_errors_word_request(service_client):
#     test_cases = [
#         'пренять заказ',
#         'приянять заказ',
#         'принять закас',
#         'принять закао',
#         'принять закоз',
#         'приать заказ',
#         'прнить заказ',
#         'принять закаж',
#         'приять закоз',
#         'приинять заказ',
#         'приянять закас',
#         'пренать заказ',
#         'прин зак',
#         'принят закас',
#     ]
#     for text in test_cases:
#         response = await service_client.post('/classify-message', json={'text': text})
#         assert response.status == 200
#         assert response.text == 'ACCEPT_ORDER'

# async def test_errors_and_noise_request(service_client):
#     test_cases = [
#         'хывпиевол пренять заказ уукпвга',
#         'приянять заказ уа уп уукпкйцвршг',
#         'пксцкпаукац принять закас уцкаэш',
#         'принять закао упкеипмля',
#         'принять закоз укпмтв',
#         'екприать заказбщз',
#         'прникть заказкапмтикайфы',
#         'принять закажпткуаерпа',
#         'приятъ закозлум',
#         'приинять заказычю',
#         'приянять закаспещ',
#         'пренать заказкою',
#         'принят закассмл',
#     ]
#     for text in test_cases:
#         response = await service_client.post('/classify-message', json={'text': text})
#         assert response.status == 200
#         assert response.text == 'ACCEPT_ORDER'

# async def test_errors_and_another_words_request(service_client):
#     test_cases = [
#         'принят закас в этот раз',
#         'доброго дня алиса плинять саказ',
#         'сейчас я хочу приять заказ но это будет последний на сегодня',
#         'сейчас я хочупренять зоказно это будет последний на сегодня',
#         'сейчасяхочупринятзаказноэтобудетпоследнийнасегодня',
#     ]
#     for text in test_cases:
#         response = await service_client.post('/classify-message', json={'text': text})
#         assert response.status == 200
#         assert response.text == 'ACCEPT_ORDER'

# async def test_synonyms_request(service_client):
#     test_cases = [
#         'да',
#         'оформи заказ',
#         'беру',
#         'едем',
#         'прими заказ',
#         'принять заявку',
#         'взять заказ',
#         'еду',
#         'выезжаю',
#         'поехали',
#     ]
#     for text in test_cases:
#         response = await service_client.post('/classify-message', json={'text': text})
#         assert response.status == 200
#         assert response.text == 'ACCEPT_ORDER'