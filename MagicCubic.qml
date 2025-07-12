import QtQuick
import QtQuick3D

Node {
    id: id_root

    function m_getCubicIndex(model){
        return {
            x: Math.round(model.position.x),
            y: Math.round(model.position.y),
            z: Math.round(model.position.z)
        }
    }

    function m_rotCubes(pickedIndex, axis, direction) {
        let dir = (direction === "clockwise") ? -90 : 90;
        let axisVec = axis === "X" ? Qt.vector3d(1, 0, 0) :
                                     axis === "Y" ? Qt.vector3d(0, 1, 0) : Qt.vector3d(0, 0, 1);

        let rotCubes = []
        let animSet = []

        // 1. Collect cubes to rotate
        for (let i = 0; i < id_node.children.length; i++) {
            let cube = id_node.children[i];
            if (!cube || !cube.position) continue;

            let pos = m_getCubicIndex(cube);
            if ((axis === "X" && pos.x === pickedIndex.x) ||
                    (axis === "Y" && pos.y === pickedIndex.y) ||
                    (axis === "Z" && pos.z === pickedIndex.z)) {

                rotCubes.push(cube);
                let anim = Qt.createQmlObject(`
                                              import QtQuick
                                              import QtQuick3D
                                              ParallelAnimation {
                                              RotationAnimation { duration: 300; direction:RotationAnimation.Shortest}
                                              RotationAnimation { duration: 300; direction:RotationAnimation.Shortest}
                                              RotationAnimation { duration: 300; direction:RotationAnimation.Shortest}
                                              Vector3dAnimation { duration: 300 }
                                              alwaysRunToEnd: true
                                              }`, id_root);
                animSet.push(anim);
            }
        }

        // 2. Create temporary parent for rotation
        let container = Qt.createQmlObject(`
                                           import QtQuick3D
                                           Node { position: Qt.vector3d(0,0,0) }
                                           `, id_root);

        for (let i = 0; i < rotCubes.length; i++) {
            let cube = rotCubes[i];
            let anim = animSet[i];

            anim.animations[0].target = cube;
            anim.animations[1].target = cube;
            anim.animations[2].target = cube;

            anim.animations[3].target = cube;

            anim.animations[0].property = "eulerRotation.x"
            anim.animations[0].from= cube.eulerRotation.x;
            anim.animations[1].property = "eulerRotation.y"
            anim.animations[1].from= cube.eulerRotation.y;
            anim.animations[2].property = "eulerRotation.z"
            anim.animations[2].from= cube.eulerRotation.z;

            cube.rotate(dir,axisVec,Node.ParentSpace)

            const roundRot=Qt.vector3d(Math.round(cube.eulerRotation.x),Math.round(cube.eulerRotation.y),Math.round(cube.eulerRotation.z))
            anim.animations[0].to = roundRot.x;
            anim.animations[1].to = roundRot.y;
            anim.animations[2].to = roundRot.z;

            // console.log('from:',anim.animations[0].from,anim.animations[1].from,anim.animations[2].from,'->',
            //             anim.animations[0].to,anim.animations[1].to,anim.animations[2].to)

            cube.parent = container;
        }

        container.rotate(dir, axisVec, Node.LocalSpace);

        for (let i = 0; i < rotCubes.length; i++) {
            let cube = rotCubes[i];
            let anim = animSet[i];

            let mapped = container.mapPositionToNode(id_node, cube.position);
            let roundPos = Qt.vector3d(Math.round(mapped.x), Math.round(mapped.y), Math.round(mapped.z));

            cube.parent = id_node;
            anim.animations[3].property = "position";
            anim.animations[3].to = roundPos;
        }

        for (let i = 0; i < animSet.length; i++) {
            animSet[i].start();
        }

        container.destroy();
    }


    // Resources
    PrincipledMaterial {
        id: white_material
        objectName: "white"
        baseColor: "#ffffffff"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: blue_material
        objectName: "blue"
        baseColor: "#ff0100cc"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: orange_material
        objectName: "orange"
        baseColor: "#ffccb800"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: black_material
        objectName: "black"
        baseColor: "#ff000000"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: red_material
        objectName: "red"
        baseColor:"#ffff0000"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: yellow_material
        objectName: "yellow"
        baseColor: "#fff3f30f"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }
    PrincipledMaterial {
        id: green_material
        objectName: "green"
        baseColor: "#ff00cc22"
        roughness: 0.5
        cullMode: PrincipledMaterial.NoCulling
        alphaMode: PrincipledMaterial.Opaque
    }

    // Nodes:
    Node {
        id: id_node
        objectName: "NODE"

        BaseCube {
            id: cube
            objectName: "Cube"
            position: Qt.vector3d(-1, -1, 1)
            source: "meshes/cube_mesh.mesh"
            materials: [
                white_material,
                blue_material,
                orange_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_001
            objectName: "Cube.001"
            position: Qt.vector3d(0, -1, 1)
            source: "meshes/cube_001_mesh.mesh"
            materials: [
                white_material,
                orange_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_002
            objectName: "Cube.002"
            position: Qt.vector3d(1, -1, 1)
            source: "meshes/cube_002_mesh.mesh"
            materials: [
                white_material,
                red_material,
                orange_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_003
            objectName: "Cube.003"
            position: Qt.vector3d(-1, -1, 0)
            source: "meshes/cube_003_mesh.mesh"
            materials: [
                white_material,
                blue_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_004
            objectName: "Cube.004"
            position: Qt.vector3d(0, -1, 0)
            source: "meshes/cube_004_mesh.mesh"
            materials: [
                white_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_005
            objectName: "Cube.005"
            position: Qt.vector3d(1, -1, 0)
            source: "meshes/cube_005_mesh.mesh"
            materials: [
                white_material,
                red_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_006
            objectName: "Cube.006"
            position: Qt.vector3d(-1, -1, -1)
            source: "meshes/cube_006_mesh.mesh"
            materials: [
                white_material,
                yellow_material,
                blue_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_007
            objectName: "Cube.007"
            position: Qt.vector3d(0, -1, -1)
            source: "meshes/cube_007_mesh.mesh"
            materials: [
                white_material,
                yellow_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_008
            objectName: "Cube.008"
            position: Qt.vector3d(1, -1, -1)
            source: "meshes/cube_008_mesh.mesh"
            materials: [
                white_material,
                red_material,
                yellow_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_009
            objectName: "Cube.009"
            position: Qt.vector3d(-1, 0, 1)
            source: "meshes/cube_009_mesh.mesh"
            materials: [
                blue_material,
                orange_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_010
            objectName: "Cube.010"
            position: Qt.vector3d(0, 0, 1)
            source: "meshes/cube_010_mesh.mesh"
            materials: [
                orange_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_011
            objectName: "Cube.011"
            position: Qt.vector3d(1, 0, 1)
            source: "meshes/cube_011_mesh.mesh"
            materials: [
                red_material,
                orange_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_012
            objectName: "Cube.012"
            position: Qt.vector3d(-1, 0, 0)
            source: "meshes/cube_012_mesh.mesh"
            materials: [
                blue_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_013
            objectName: "Cube.013"
            source: "meshes/cube_043_mesh.mesh"
            materials: [
                black_material
            ]
        }
        BaseCube {
            id: cube_014
            objectName: "Cube.014"
            position: Qt.vector3d(1, 0, 0)
            source: "meshes/cube_014_mesh.mesh"
            materials: [
                red_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_015
            objectName: "Cube.015"
            position: Qt.vector3d(-1, 0, -1)
            source: "meshes/cube_015_mesh.mesh"
            materials: [
                yellow_material,
                blue_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_016
            objectName: "Cube.016"
            position: Qt.vector3d(0, 0, -1)
            source: "meshes/cube_016_mesh.mesh"
            materials: [
                yellow_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_017
            objectName: "Cube.017"
            position: Qt.vector3d(1, 0, -1)
            source: "meshes/cube_017_mesh.mesh"
            materials: [
                red_material,
                yellow_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_018
            objectName: "Cube.018"
            position: Qt.vector3d(-1, 1, 1)
            source: "meshes/cube_018_mesh.mesh"
            materials: [
                blue_material,
                orange_material,
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_019
            objectName: "Cube.019"
            position: Qt.vector3d(0, 1, 1)
            source: "meshes/cube_019_mesh.mesh"
            materials: [
                orange_material,
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_020
            objectName: "Cube.020"
            position: Qt.vector3d(1, 1, 1)
            source: "meshes/cube_020_mesh.mesh"
            materials: [
                red_material,
                orange_material,
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_021
            objectName: "Cube.021"
            position: Qt.vector3d(-1, 1, 0)
            source: "meshes/cube_021_mesh.mesh"
            materials: [
                blue_material,
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_022
            objectName: "Cube.022"
            position: Qt.vector3d(0, 1, 0)
            source: "meshes/cube_022_mesh.mesh"
            materials: [
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_023
            objectName: "Cube.023"
            position: Qt.vector3d(1, 1, 0)
            source: "meshes/cube_023_mesh.mesh"
            materials: [
                red_material,
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_024
            objectName: "Cube.024"
            position: Qt.vector3d(-1, 1, -1)
            source: "meshes/cube_024_mesh.mesh"
            materials: [
                yellow_material,
                blue_material,
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_025
            objectName: "Cube.025"
            position: Qt.vector3d(0, 1, -1)
            source: "meshes/cube_025_mesh.mesh"
            materials: [
                yellow_material,
                green_material,
                black_material
            ]
        }
        BaseCube {
            id: cube_026
            objectName: "Cube.026"
            position: Qt.vector3d(1, 1, -1)
            source: "meshes/cube_026_mesh.mesh"
            materials: [
                red_material,
                yellow_material,
                green_material,
                black_material
            ]
        }
    }

    // Animations:
}
