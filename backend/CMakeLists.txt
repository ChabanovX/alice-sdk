cmake_minimum_required(VERSION 3.12...3.31)
project(classifier_service CXX)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(DownloadUserver)

find_package(
    userver
    COMPONENTS core postgresql
    QUIET
)
if(NOT userver_FOUND)
    # Tries TRY_DIR first, falls back to downloading userver from GitHub using CPM.
    download_userver(TRY_DIR third_party/userver)
endif()

userver_setup_environment()

# Common sources
include_directories(src)

add_library(
    ${PROJECT_NAME}_objs OBJECT

    src/handlers/v1/classify-message/view.cpp
    src/handlers/v1/classify-message/view.hpp

    src/integrations/analytics-service/analytics-client.hpp
    src/integrations/analytics-service/analytics-client.cpp

    src/db/voice_statistics/models.hpp
    src/db/voice_statistics/repository.hpp
    src/db/voice_statistics/repository.cpp
)
target_link_libraries(
    ${PROJECT_NAME}_objs PUBLIC 
    userver::core userver::postgresql
)


# The Service
add_executable(${PROJECT_NAME} src/main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE ${PROJECT_NAME}_objs)

# Unit Tests
add_executable(${PROJECT_NAME}_unittest unittests/basic.cpp)
target_link_libraries(${PROJECT_NAME}_unittest PRIVATE ${PROJECT_NAME}_objs userver::utest)
add_google_tests(${PROJECT_NAME}_unittest)

# Functional testing
userver_testsuite_add(
    SERVICE_TARGET
    ${PROJECT_NAME}
    WORKING_DIRECTORY
    ${CMAKE_CURRENT_SOURCE_DIR}/tests
    PYTHON_BINARY
    ${TESTSUITE_PYTHON_BINARY}
    PYTEST_ARGS
    --service-config=${CMAKE_CURRENT_SOURCE_DIR}/configs/static_config.yaml
    --service-binary=${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}
    --service-config-vars=${CMAKE_CURRENT_SOURCE_DIR}/configs/config_vars.testing.yaml
)

# Install
include(GNUInstallDirs)

if(DEFINED ENV{PREFIX})
    message(STATUS "Set install prefix: $ENV{PREFIX}")
    file(TO_CMAKE_PATH "$ENV{PREFIX}" PREFIX_PATH)
    set(CMAKE_INSTALL_PREFIX "${PREFIX_PATH}")
endif()

file(GLOB CONFIGS_FILES ${CMAKE_CURRENT_SOURCE_DIR}/configs/*.yaml ${CMAKE_CURRENT_SOURCE_DIR}/configs/*.json)

install(
    TARGETS ${PROJECT_NAME}
    DESTINATION ${CMAKE_INSTALL_BINDIR}
    COMPONENT ${PROJECT_NAME}
)
install(
    FILES ${CONFIGS_FILES}
    DESTINATION ${CMAKE_INSTALL_SYSCONFDIR}/${PROJECT_NAME}
    COMPONENT ${PROJECT_NAME}
)
