import pytest


pytest_plugins = [
    'pytest_userver.plugins.core',
]

USERVER_CONFIG_HOOKS = ['patch_external_service']


@pytest.fixture(scope='session')
def patch_external_service(mockserver_info):
    def _patch(config_yaml, _config_vars):
        comps = config_yaml['components_manager']['components']
        # Подменяем analytics-url на адрес mockserver (у static_config.yaml путь /cluster уже задан)
        comps['analytics-client']['analytics-url'] = mockserver_info.url(
            '/cluster')
        # Отладка
        # print("Patched analytics-url ->", mockserver_info.url('/cluster'))
    return _patch
