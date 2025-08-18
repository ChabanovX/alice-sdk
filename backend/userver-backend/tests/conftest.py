import pytest
import pathlib

from testsuite.databases.pgsql import discover

pytest_plugins = [
    'pytest_userver.plugins.core',
    'pytest_userver.plugins.postgresql',
]

USERVER_CONFIG_HOOKS = ['patch_external_service']

@pytest.fixture(scope='session')
def service_source_dir():
    """Path to root directory service."""
    return pathlib.Path(__file__).parent.parent

@pytest.fixture(scope='session')
def initial_data_path(service_source_dir):
    """Path for find files with data"""
    return [
        service_source_dir / 'postgresql/data',
    ]

@pytest.fixture(scope='session')
def pgsql_local(service_source_dir, pgsql_local_create):
    """Create schemas databases for tests"""
    databases = discover.find_schemas(
        'pg_service_template',
        [service_source_dir.joinpath('postgresql')],
    )
    return pgsql_local_create(list(databases.values()))


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
