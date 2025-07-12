import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Item{
        id:id_root
        anchors.fill:parent
        property bool     m_isRotating     : false
        property var      m_pkResult       : null
        property vector2d m_startMousePos

        View3D{
            id:id_view3d
            anchors.fill:parent
            environment: SceneEnvironment {
                backgroundMode: SceneEnvironment.SkyBox
                lightProbe: Texture{
                    textureData: ProceduralSkyTextureData{
                        groundBottomColor: "white"
                        skyTopColor: "white"
                        groundHorizonColor:"white"

                    }
                }

            }


            MagicCubic{
                id:id_magicCube
                scale: Qt.vector3d(100,100,100)

            }

            Node{
                id:id_Origin
                OrthographicCamera {
                    id: id_camera
                    position:Qt.vector3d(300,300,300)

                    // 朝向立方体中心 (0,0,0)
                    eulerRotation.x: -35.26  // arctan(1/√2) ≈ -35.26°
                    eulerRotation.y: 45      // 45° 朝向对角线
                    eulerRotation.z: 0

                }
            }

            OrbitCameraController{
                id:id_cameraController
                origin: id_Origin
                camera: id_camera
                //enabled: !id_root.m_isRotating
                //enabled:false

            }

            // AxisHelper{

            // }

            MouseArea{
                id:id_mouseArea
                anchors.fill:parent
                acceptedButtons:  Qt.RightButton

                onPressed:(mouse)=>{
                              if(mouse.button == Qt.RightButton){
                                  var pkResult = id_view3d.pick(mouse.x,mouse.y)
                                  if(pkResult.objectHit){
                                      id_root.m_pkResult = pkResult
                                      id_root.m_isRotating = true
                                      id_root.m_startMousePos = Qt.vector2d(mouse.x,mouse.y)
                                      //console.log(pkResult.normal)
                                  }
                              }


                          }


                onReleased:(mouse)=>{
                    if (id_root.m_isRotating) {
                        let currentMousePos = Qt.vector2d(mouse.x,mouse.y)
                        const delta = currentMousePos.minus(id_root.m_startMousePos)

                        let rotAxisAndRotDirection = m_calRotAxisAndLayer(id_root.m_pkResult.normal,delta)

                        let pkIndex = id_magicCube.m_getCubicIndex(id_root.m_pkResult.objectHit)
                        id_magicCube.m_rotCubes(pkIndex,rotAxisAndRotDirection.axis,rotAxisAndRotDirection.clockwise)

                        // 重置状态
                        id_root.m_isRotating = false

                    }
                }

                ///
                function m_calRotAxisAndLayer(faceNormalLocal,delta){
                    let axis = null
                    let clockwise = null

                    //transform pkResult.normal to id_magicCube's faceNormal
                    let faceNormalMapped=id_magicCube.mapDirectionFromNode(id_root.m_pkResult.objectHit,faceNormalLocal)


                    let faceNormal=Qt.vector3d(Math.round(faceNormalMapped.x),Math.round(faceNormalMapped.y),Math.round(faceNormalMapped.z))
                    //console.log(faceNormalLocal,'->',faceNormal)

                    let absDelta = Qt.vector2d(Math.abs(delta.x), Math.abs(delta.y));

                    if (faceNormal.x!=0) {//+- x face
                        if(absDelta.x>absDelta.y){
                            axis='Y'
                            clockwise=delta.x>0?false:true
                        }else{
                            axis='Z'
                            clockwise=delta.y<0?false:true //since Y axis upside down
                        }

                    } else if (faceNormal.y!=0) {
                        if(absDelta.x>absDelta.y){
                            axis='X'
                            clockwise=delta.x>0?true:false
                        }else{
                            axis='Z'
                            clockwise=delta.y<0?false:true
                        }
                    } else {
                        if(absDelta.x>absDelta.y){
                            axis='Y'
                            clockwise=delta.x>0?false:true
                        }else{
                            axis='X'
                            clockwise=delta.y<0?true:false
                        }
                    }
                    return {
                        axis: axis,
                        clockwise: clockwise?'clockwise':'anticlockwise'
                    }
                }
            }
        }
    }

}
