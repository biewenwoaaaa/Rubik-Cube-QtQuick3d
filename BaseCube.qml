import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

Model {
    id: id_cubeBlock
    position: Qt.vector3d(0, 0, 0)
    pickable: true
    eulerRotation: Qt.vector3d(0,0,0)

    // // 动画过渡
    // Behavior on position {
    //     NumberAnimation {
    //         duration: 300
    //         easing.type: Easing.OutCubic
    //     }
    // }

    // Behavior on eulerRotation {
    //     RotationAnimation {
    //         duration: 300
    //         direction: RotationAnimation.Shortest
    //         easing.type: Easing.OutCubic
    //     }
    // }
}
