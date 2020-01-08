# Direct Monocular Odometry Using Points and Lines

## Introduce

edge detect is less sensitive  to light change

+ maintain a semi-dense map for key-frame high gradient pixel.
+ detect and match edge every frame
+ joint optimize both photometric and geometric error
+ speed up stereo search and improve depth quality by edge regularizing

## Proposed Framework

detect line segments and match them with the key-frame edges

camera pose tracking

update the depth map through variable baseline stereo

#### Tracking

the depth map of the reference frame is assumed to be fixed

use LBD descriptor to match line

to minimize photometric residual and line re-projection geometric error(if pixel belong to edge) use Gauss-Newton

![Screenshot from 2020-01-08 14-30-39](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-08%2014-30-39-1578466578997.png)

![Screenshot from 2020-01-06 10-48-37](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-06%2010-48-37-1578466618237.png)

![Screenshot from 2020-01-06 10-48-42](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-06%2010-48-42-1578466627756.png)

information matrix 

![Screenshot from 2020-01-06 11-03-29](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-06%2011-03-29-1578466645148.png)

#### Mapping

camera pose is assumed to be fixed

depth map updated through stereo triangulation followed by line regularization

Regularization to improve the depth estimation accuracy

+ stereo triangulation

![Screenshot from 2020-01-08 13-56-30](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-08%2013-56-30-1578466658976.png)

+ uncertain analysis

![Screenshot from 2020-01-08 14-20-16](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-08%2014-20-16-1578466666049.png)

![Screenshot from 2020-01-08 14-20-22](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot from 2020-01-08 14-20-22.png)

​	Then do EKF update pixel depth

+ line regularization

  ![Screenshot from 2020-01-08 14-26-52](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-08%2014-26-52-1578466674859.png)

  use RANSAC to select a set of inlier 2D points

## Result

![Screenshot from 2020-01-08 14-46-33](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-08%2014-46-33-1578466691883.png)

![Screenshot from 2020-01-08 14-46-38](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-08%2014-46-38-1578466697151.png)

![Screenshot from 2020-01-08 14-47-24](asset/Direct_Monocular_Odometry_Using_Points_and_Lines/Screenshot%20from%202020-01-08%2014-47-24-1578466701571.png)

