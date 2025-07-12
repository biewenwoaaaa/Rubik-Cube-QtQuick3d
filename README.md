# Rubik-Cube-QtQuick3D
Rubic Cube written with Qt Quick3d, including mesh import and rotate/transform calculation.

## tips
* mouse left click shift camera, mouse right click rotate cubes;

 
1.   .mesh files included in this project was generated with Blender and export with .gltf format, you can convert .gltf format to .mesh with Qt tools;
.mesh文件由blender导出的gltf文件借助Qt官方的工具生成；

2. This project was published with Qt6.8.3.  no *.cpp file used but with pure .qml;
纯使用qml文件，没有cpp文件配合；
3. The cubes' rotation are achieved with *rotate* method one by one; and cubes' position are updated with one container first, which temporarily wrapped these cubes and rotate then, after that, we can map the cube's position from the container to the world coordinate with method *mapPositionToNode*; (since there is no method like *mapRotationToNode* in qtquick3d);
魔方的扭动动作，实际上由子方块的移动+旋转两个动作构成。由于没有*mapRotationToNode*这样的函数提供，所以扭动层所在的子方块旋转操作单独实现；移动操作通过构建临时的层容器，旋转层容器后，通过*mapPositionToNode*这样的函数映射子方块的位置回世界坐标系实现；
4. you can find cubic object picking in 3D, interacting with Mouse click, 3d animation in this project.
该项目涉及技术包括3d目标拾取，鼠标交互，3d动画；


