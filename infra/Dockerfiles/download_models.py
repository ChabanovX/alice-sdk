"""
Скрипт для предзагрузки всех моделей машинного обучения
"""
import os
from transformers import AutoTokenizer, AutoModel, pipeline
import torch
import pymorphy3

def download_models():
    """Загружает все необходимые модели"""
    
    print("Загружаем модели transformers...")
    
    # 1. BERT модель для эмбеддингов (используется в embedder.py)
    try:
        print("Загружаем cointegrated/rubert-tiny2...")
        tokenizer = AutoTokenizer.from_pretrained("cointegrated/rubert-tiny2")
        model = AutoModel.from_pretrained("cointegrated/rubert-tiny2")
        print("✓ cointegrated/rubert-tiny2 загружена")
    except Exception as e:
        print(f"✗ Ошибка загрузки cointegrated/rubert-tiny2: {e}")
        exit(1)
    
    # 2. NER модель для извлечения адресов (используется в location_extractor.py)
    try:
        print("Загружаем aidarmusin/address-ner-ru...")
        ner_pipe = pipeline("ner", model="aidarmusin/address-ner-ru", device=-1)
        print("✓ aidarmusin/address-ner-ru загружена")
    except Exception as e:
        print(f"✗ Ошибка загрузки aidarmusin/address-ner-ru: {e}")
        exit(1)
    
    # 3. Инициализация pymorphy3 (скачает словари)
    print("Инициализируем pymorphy3...")
    try:
        morph = pymorphy3.MorphAnalyzer()
        # Тестируем работу
        test_word = morph.parse('тестирование')[0]
        print("✓ pymorphy3 словари загружены")
    except Exception as e:
        print(f"✗ Ошибка загрузки pymorphy3: {e}")
        exit(1)
    
    # 4. Создаем директории для сохранения обученных моделей
    print("Создаем директории для обученных моделей...")
    os.makedirs("app/trained_models", exist_ok=True)
    print("✓ Директории созданы")
    
    print("Все модели успешно загружены!")
    
    # Показываем размер кэша
    import subprocess
    try:
        result = subprocess.run(['du', '-sh', '/root/.cache'], 
                              capture_output=True, text=True)
        print(f"Размер кэша: {result.stdout.strip()}")
    except:
        pass

if __name__ == "__main__":
    download_models()