TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
CONFIG -= qt
CONFIG += c++11

SOURCES += main.cpp \
    ray.cpp \
    vector.cpp \
    sphere.cpp \
    scene.cpp \
    material.cpp \
    object.cpp \
    intersectionpointcsg.cpp \
    box.cpp \
    intersection.cpp \
    union.cpp \
    cylinder.cpp \
    torus.cpp \
    quartisolver.cpp \
    boundingbox.cpp \
    geometry.cpp \
    plan.cpp \
    squarestexture.cpp \
    texture.cpp \
    perlin.cpp \
    marbletexture.cpp \
    woodtexture.cpp \
    perlintexture.cpp \
    substraction.cpp

HEADERS += \
    ray.h \
    vector.h \
    sphere.h \
    scene.h \
    helpers.h \
    material.h \
    object.h \
    intersectionpointcsg.h \
    box.h \
    intersection.h \
    union.h \
    cylinder.h \
    torus.h \
    quarticsolver.h \
    boundingbox.h \
    geometry.h \
    plan.h \
    squarestexture.h \
    texture.h \
    perlin.h \
    marbletexture.h \
    woodtexture.h \
    perlintexture.h \
    substraction.h

QMAKE_CFLAGS_RELEASE += -fopenmp
QMAKE_CFLAGS_DEBUG += -fopenmp
QMAKE_CXXFLAGS += -fopenmp
QMAKE_LFLAGS +=  -fopenmp \
                 -O3
QMAKE_CXXFLAGS_RELEASE += -O3
QMAKE_CXXFLAGS_RELEASE -= -O2
QMAKE_LFLAGS_RELEASE +=  -O3
QMAKE_LFLAGS_RELEASE -=  -O1

OTHER_FILES += \
    girl.obj
