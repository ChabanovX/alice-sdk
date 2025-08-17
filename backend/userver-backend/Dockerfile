FROM ghcr.io/userver-framework/ubuntu-24.04-userver:latest

WORKDIR /app

# Копируем нужные папки
COPY cmake cmake
COPY configs configs
COPY src src
COPY unittests unittests
COPY tests tests

# Копируем нужные файлы
COPY CMakeLists.txt .
COPY CMakePresets.json .
COPY Makefile .

RUN make build-release

EXPOSE 8080

CMD ["./build-release/classifier_service", "-c", "configs/static_config.yaml"]
# CMD ["make", "start-release"]
