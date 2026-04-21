# Copyright (c) <2014-2017> <Newton Game Dynamics>
# 
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
# 
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely.

cmake_minimum_required(VERSION 2.8)

# low level core
set(dgCore_srcs
    core/dg.cpp
    core/dgRef.cpp
    core/dgCRC.cpp
    core/dgTree.cpp
    core/dgNode.cpp
    core/dgTypes.cpp
    core/dgDebug.cpp
    core/dgMatrix.cpp
    core/dgGoogol.cpp
    core/dgMemory.cpp
    core/dgSphere.cpp
    core/dgRandom.cpp
    core/dgThreads.cpp
    core/dgPolyhedra.cpp
    core/dgQuaternion.cpp
    core/dgConvexHull3d.cpp
    core/dgConvexHull4d.cpp
    core/dgIntersections.cpp
    core/dgAABBPolygonSoup.cpp
    core/dgSmallDeterminant.cpp
    core/dgPolygonSoupBuilder.cpp
    core/dgPolyhedraMassProperties.cpp
    core/dgDelaunayTetrahedralization.cpp)

# Newton engine
set(dgNewton_srcs
    newton/Newton.cpp
    newton/NewtonClass.cpp)
# physics
set(dgPhysics_srcs
    physics/dgWorld.cpp
    physics/dgBody.cpp
    physics/dgMeshEffect.cpp
    physics/dgMeshEffect2.cpp
    physics/dgMeshEffect3.cpp
    physics/dgMeshEffectSolidTree.cpp
    physics/dgCollisionConvex.cpp
    physics/dgBallConstraint.cpp
    physics/dgBilateralConstraint.cpp
    physics/dgCorkscrewConstraint.cpp
    physics/dgHingeConstraint.cpp
    physics/dgNarrowPhaseCollision.cpp
    physics/dgBroadPhaseCollision.cpp
    physics/dgMinkowskiConv.cpp
    physics/dgCollisionBox.cpp
    physics/dgCollisionCapsule.cpp
    physics/dgCollisionBVH.cpp
    physics/dgCollisionMesh.cpp
    physics/dgCollisionUserMesh.cpp
    physics/dgCollisionChamferCylinder.cpp
    physics/dgPointToCurveConstraint.cpp
    physics/dgCollisionCone.cpp
    physics/dgCollisionConvexHull.cpp
    physics/dgSlidingConstraint.cpp
    physics/dgCollisionConvexModifier.cpp
    physics/dgUniversalConstraint.cpp
    physics/dgCollision.cpp
    physics/dgUpVectorConstraint.cpp
    physics/dgCollisionCylinder.cpp
    physics/dgUserConstraint.cpp
    physics/dgCollisionEllipse.cpp
    physics/dgCollisionNull.cpp
    physics/dgCollisionScene.cpp
    physics/dgCollisionCompoundBreakable.cpp
    physics/dgCollisionHeightField.cpp
    physics/dgWorldDynamicUpdate.cpp
    physics/dgCollisionSphere.cpp
    physics/dgCollisionCompound.cpp
    physics/dgConnectorConstraint.cpp
    physics/dgConstraint.cpp
    physics/dgBodyMasterList.cpp
    physics/dgContact.cpp)
#file(GLOB dgTimeTracker_srcs dgTimeTracker/*.cpp) # time tracker

add_library(NewtonObj OBJECT ${dgCore_srcs} ${dgNewton_srcs} ${dgPhysics_srcs}) #${dgTimeTracker_srcs}

target_include_directories(NewtonObj PRIVATE core newton physics)

# create static library
add_library(NewtonStatic STATIC $<TARGET_OBJECTS:NewtonObj>)
target_include_directories(NewtonStatic INTERFACE newton)

# create shared library
add_library(Newton SHARED $<TARGET_OBJECTS:NewtonObj>)
target_include_directories(Newton INTERFACE newton)

if (UNIX)
  set_target_properties(NewtonStatic PROPERTIES OUTPUT_NAME Newton)
endif(UNIX)

# choose right place on UNIX
if (UNIX)
  include("GNUInstallDirs")
else (UNIX)
  set(CMAKE_INSTALL_LIBDIR "lib")
  set(CMAKE_INSTALL_INCLUDEDIR "include")
endif (UNIX)

install(TARGETS Newton DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES newton/Newton.h DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

if (MSVC)
  set_source_files_properties(core/dgTypes.cpp PROPERTIES COMPILE_FLAGS "/YcdgStdafx.h")
  set_source_files_properties(newton/NewtonClass.cpp PROPERTIES COMPILE_FLAGS "/YcNewtonStdAfx.h")
  set_source_files_properties(physics/dgWorld.cpp PROPERTIES COMPILE_FLAGS "/YcdgPhysicsStdafx.h")

  set_target_properties(NewtonStatic PROPERTIES COMPILE_FLAGS "/YudgStdafx.h /YuNewtonStdAfx.h /YudgPhysicsStdafx.h")
  set_target_properties (NewtonStatic PROPERTIES COMPILE_DEFINITIONS "_NEWTON_STATIC_LIB;_WIN_32_VER;PTW32_BUILD;PTW32_STATIC_LIB;_CRT_SECURE_NO_WARNINGS")

  set_target_properties(Newton PROPERTIES COMPILE_FLAGS "/YudgStdafx.h /YuNewtonStdAfx.h /YudgPhysicsStdafx.h")
  set_target_properties (Newton PROPERTIES COMPILE_DEFINITIONS "_NEWTON_BUILD_DLL;_WIN_32_VER;PTW32_BUILD;PTW32_STATIC_LIB;_CRT_SECURE_NO_WARNINGS")
endif(MSVC)

if (CMAKE_COMPILER_IS_GNUCC)
  add_definitions(-fpic -ffast-math -funsafe-math-optimizations -Wall -Wno-strict-aliasing -D_SCALAR_ARITHMETIC_ONLY)
endif(CMAKE_COMPILER_IS_GNUCC)

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  add_definitions(-D_MACOSX_VER)
else(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  if (${UNIX})
    if (BUILD_64)
      add_definitions(-D_POSIX_VER_64)
    else (BUILD_64)
      add_definitions(-D_POSIX_VER)
    endif (BUILD_64)
  endif(${UNIX})
endif(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
