cmake_minimum_required(VERSION 3.5)
project(webcface-windows
    HOMEPAGE_URL "https://github.com/na-trium-144/webcface"
    DESCRIPTION "Web-based RPC & UI Library"
)
set(WEBCFACE_TAG 1.6.1)
set(WEBCFACE_WEBUI_TAG 1.4.0)
set(WEBCFACE_TOOLS_TAG 1.3.1)
set(WEBCFACE_PKG_REVISION "")

set(CMAKE_CXX_STANDARD 20)
add_compile_options(/utf-8)

set(WEBCFACE_INSTALL on CACHE INTERNAL "" FORCE)
set(WEBCFACE_EXAMPLE on CACHE INTERNAL "" FORCE)
set(WEBCFACE_VERSION_SUFFIX ${ARCH} CACHE INTERNAL "" FORCE)
set(WEBCFACE_TOOLS_VERSION_SUFFIX ${ARCH} CACHE INTERNAL "" FORCE)
set(WEBCFACE_DOWNLOAD_WEBUI off CACHE INTERNAL "" FORCE)

include(FetchContent)

FetchContent_Declare(webcface
    GIT_REPOSITORY https://github.com/na-trium-144/webcface.git
    GIT_TAG v${WEBCFACE_TAG}
)
FetchContent_MakeAvailable(webcface)

if(CMAKE_BUILD_TYPE STREQUAL Release)

FetchContent_Declare(webcface-tools
    GIT_REPOSITORY https://github.com/na-trium-144/webcface-tools.git
    GIT_TAG v${WEBCFACE_TOOLS_TAG}
)
FetchContent_MakeAvailable(webcface-tools)

set(WEBUI_VERSION ${WEBCFACE_WEBUI_TAG})

get_directory_property(WEBCFACE_VERSION_ORG
    DIRECTORY ${webcface_SOURCE_DIR}
    DEFINITION PROJECT_VERSION
)
get_directory_property(WEBCFACE_VERSION_MAJOR
    DIRECTORY ${webcface_SOURCE_DIR}
    DEFINITION PROJECT_VERSION_MAJOR
)
get_directory_property(WEBCFACE_VERSION_MINOR
    DIRECTORY ${webcface_SOURCE_DIR}
    DEFINITION PROJECT_VERSION_MINOR
)
get_directory_property(WEBCFACE_VERSION_REVISION
    DIRECTORY ${webcface_SOURCE_DIR}
    DEFINITION PROJECT_VERSION_PATCH
)
get_directory_property(WEBCFACE_EXAMPLE_TARGETS_CPACK
    DIRECTORY ${webcface_SOURCE_DIR}
    DEFINITION WEBCFACE_EXAMPLE_TARGETS_CPACK
)
get_directory_property(WEBCFACE_SOVERSION
    DIRECTORY ${webcface_SOURCE_DIR}
    DEFINITION WEBCFACE_SOVERSION
)
# Debugを ./install_debug にインストールした後に Releaseのcmake, build, installをする
set(WEBCFACE_INSTALL_DEBUG ${CMAKE_CURRENT_LIST_DIR}/install_debug)
install(FILES
    ${WEBCFACE_INSTALL_DEBUG}/bin/webcface${WEBCFACE_SOVERSION}d.dll
    ${WEBCFACE_INSTALL_DEBUG}/bin/spdlogd.dll
    DESTINATION bin
)
install(DIRECTORY ${WEBCFACE_INSTALL_DEBUG}/lib/
    DESTINATION lib
)

install(DIRECTORY ${OpenCV_DIR}/../bin/
    DESTINATION bin
)
install(DIRECTORY ${OpenCV_DIR}/../../../
    DESTINATION opencv
)

# 同じバージョンで再ビルドするとき -1 など
if(WEBCFACE_PKG_REVISION STREQUAL "")
    set(WIN_PACKAGE_VERSION "${WEBCFACE_VERSION_ORG}")
else()
    set(WIN_PACKAGE_VERSION "${WEBCFACE_VERSION_ORG}-${WEBCFACE_PKG_REVISION}")
endif()

FetchContent_Declare(webui
    URL https://github.com/na-trium-144/webcface-webui/releases/download/v${WEBUI_VERSION}/webcface-webui_${WEBUI_VERSION}.tar.gz
    SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/dist
)
FetchContent_Populate(webui)
FetchContent_Declare(webui-s
    URL https://github.com/na-trium-144/webcface-webui/releases/download/v${WEBUI_VERSION}/webcface-webui-server_${WEBUI_VERSION}_x64.zip
    SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/webui-server
)
FetchContent_Populate(webui-s)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/dist
    DESTINATION share/webcface
)
install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/webui-server/
    DESTINATION webui-server
)

set(CPACK_VERBATIM_VARIABLES yes)
set(CPACK_PACKAGE_NAME WebCFace)
set(CPACK_PACKAGE_VERSION_MAJOR ${WEBCFACE_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${WEBCFACE_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${WEBCFACE_VERSION_REVISION})
set(CPACK_PACKAGE_FILE_NAME "WebCFace-${WIN_PACKAGE_VERSION}-${ARCH}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY WebCFace)
set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY WebCFace)

set(CPACK_PACKAGE_CONTACT "na-trium-144@users.noreply.github.com")
set(CPACK_PACKAGE_VENDOR "na-trium-144@users.noreply.github.com")
set(CPACK_PACKAGE_EXECUTABLES
    webcface-server "WebCFace Server"
    ${WEBCFACE_EXAMPLE_TARGETS_CPACK}
    webcface-launcher "WebCFace-Tools Launcher"
    webcface-send "WebCFace-Tools Send"
)
set(CPACK_STRIP_FILES yes)
set(CPACK_INSTALL_DEFAULT_DIRECTORY_PERMISSIONS
    OWNER_READ OWNER_WRITE OWNER_EXECUTE
    GROUP_READ GROUP_EXECUTE
    WORLD_READ WORLD_EXECUTE
)
set(CPACK_RESOURCE_FILE_LICENSE ${webcface_SOURCE_DIR}/LICENSE)

set(CPACK_NSIS_DISPLAY_NAME "WebCFace ${WIN_PACKAGE_VERSION}")
set(CPACK_NSIS_PACKAGE_NAME "WebCFace")
set(CPACK_NSIS_MODIFY_PATH on)
set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL on)

set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS
    "CreateShortCut \"$SMPROGRAMS\\$STARTMENU_FOLDER\\WebCFace WebUI (Server).lnk\" \"$INSTDIR\\webui-server\\webcface-webui-server.exe\""
)
# nsisの複数の文を書くときは\nを使う?

include(CPack)

endif()
