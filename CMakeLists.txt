cmake_minimum_required(VERSION 3.16)

project(DeviceStorage VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Android setting app icon
if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android" CACHE INTERNAL "")
endif()

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Core Gui Widgets QuickControls2 Network)

# on windows set app icon
set(app_icon_resource_windows "${CMAKE_CURRENT_SOURCE_DIR}/appicon.rc")

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appDeviceStorage
    main.cpp
    fdevice.h fdevice.cpp
    fdeviceloader.h fdeviceloader.cpp
    fdevicenetwork.h fdevicenetwork.cpp
    images.qrc
    ${app_icon_resource_windows}
)

qt_add_qml_module(appDeviceStorage
    URI DeviceStorage
    VERSION 1.0
    QML_FILES Main.qml
)

set_target_properties(appDeviceStorage PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER my.example.com
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

target_link_libraries(appDeviceStorage
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::Gui
    PRIVATE Qt6::Widgets
    PRIVATE Qt6::QuickControls2
    PRIVATE Qt6::Network

)

install(TARGETS appDeviceStorage
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
