cmake_minimum_required(VERSION 3.16)

project(MagicCubic VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick Quick3D Quick3DHelpers)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appMagicCubic
    main.cpp
)

qt_add_qml_module(appMagicCubic
    URI MagicCubic
    VERSION 1.0
    QML_FILES
        Main.qml
        MagicCubic.qml
        BaseCube.qml
    RESOURCES
        meshes/cube_001_mesh.mesh
        meshes/cube_002_mesh.mesh
        meshes/cube_003_mesh.mesh
        meshes/cube_004_mesh.mesh
        meshes/cube_005_mesh.mesh
        meshes/cube_006_mesh.mesh
        meshes/cube_007_mesh.mesh
        meshes/cube_008_mesh.mesh
        meshes/cube_009_mesh.mesh
        meshes/cube_010_mesh.mesh
        meshes/cube_011_mesh.mesh
        meshes/cube_012_mesh.mesh
        meshes/cube_014_mesh.mesh
        meshes/cube_015_mesh.mesh
        meshes/cube_016_mesh.mesh
        meshes/cube_017_mesh.mesh
        meshes/cube_018_mesh.mesh
        meshes/cube_019_mesh.mesh
        meshes/cube_020_mesh.mesh
        meshes/cube_021_mesh.mesh
        meshes/cube_022_mesh.mesh
        meshes/cube_023_mesh.mesh
        meshes/cube_024_mesh.mesh
        meshes/cube_025_mesh.mesh
        meshes/cube_026_mesh.mesh
        meshes/cube_043_mesh.mesh
        meshes/cube_mesh.mesh

)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMagicCubic PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMagicCubic
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMagicCubic
    PRIVATE Qt6::Quick Qt6::Quick3D
)

include(GNUInstallDirs)
install(TARGETS appMagicCubic
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
