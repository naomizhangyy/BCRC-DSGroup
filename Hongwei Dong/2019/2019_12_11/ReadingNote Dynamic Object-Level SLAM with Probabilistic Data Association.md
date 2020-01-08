# Dynamic Object-Level SLAM with Probabilistic Data Association

## Introduce

The environment is dynamic，the author  propose a approach for dynamic dense SLAM use RGBD images.

Determine the unknown association of pixels to objects through EM, which provides **additional geometric cues** and **implicitly handles occlusions**, tracking and mapping.

Represent object maps by volumetric **signed distance functions (SDFs)**.

The probabilistic data association facilitates the **direct alignment of the depth maps with the SDF object maps**, avoid use ICP.

**contributions**

+ probabilistic EM formulation for dynamic object SLAM
+ direct alignment of depth with SDF map



## Proposed Framework

propose a **probabilistic formulation** for tracking and mapping of multiple objects and **for data association and occlusion handling**. Represent the 3D objects and background in **volumetric SDF estimated from depth images**. New object **initial by Mask R-CNN**.

#### OLS Optimize

 $argmax_{x,\xi_t}p(m,\xi|z_{1:t})$  given all images so far to optimize $\xi_t$(frame t pose) first, and then for m(background or foreground object).

Then find the association of each pixel u to one of the objects $m_i$ and define as $c_{t,u}$ in EM.

#### EM  Framework

use to find association

E-step : $q(c_t)=argmax\sum_{c_t}q(c_t)lnp(z_t,c_t|m,\xi) $ recovery approximation of the association likelihood.

> association likelihood can be determined for each pixel individually.

M-step : max the expect $\theta(m,\xi)$

> M-step solved individually per object from the association likelihood $q(c_t)$

#### Map Represent as SDF

from world coordinates($\mathbb R^3$) to SDF($\mathbb R$)

The object surface defined as the zero level-set

maintain background volume (resolution $512^3$) object (initialized as $64^3$)

#### Instance Detection from Mask RCNN

Mask R-CNN is run sequentially every 30 frames.

If detection result available, match with the exist objects and create new objects.

> match if IOU(detected and re-projected)>0.2
>
> else create (calculate 10%-90% depth pcl to determine volume center and size)
>
> Initialized if center within 5m from the camera and the volumetric IoU with any volume is lower than 0:5.

update the foreground probability $p_{fg}(p|i)$

$Fg_i(v)=Fg_i(v)+p_{fg}^{MRCNN}(v)\quad Bg_i(v)=Bg_i(v)+(1-p_{fg}^{MRCNN}(v))$

During raycasting​ only rendered if $p_{fg}>0.5$ and no other model along the ray with a shorter ray distance

#### Data Association

Model the data associate likelihood with mixture distribution

If the pixel not in the map volume of object $c_t$, set data likelihood to zero

Then association likelihood  $p(c_t|u,\theta)=\frac{p(u|c_t,\theta)}{\sum_{c_t'}p(u|c_t',\theta)}$

**Occlusions are implicitly handled by our data association approach**

> the association likelihood will be higher than the occluding object

#### Pose Estimate

instead use ICP, use iteratively reweighted nonlinear least squares (IRLS) algorithm.

E(\delta\xi)=\sum_{u\in\Omega}qw_u(\psi(T(\xi)T(\delta\xi)p))^2​

additionally weight are confidence about a surface estimate in the model.

#### Mapping

after camera poses $\xi_t$ have been estimated, implement M-step.

maximum likelihood surface fit to the depth using recursive integration scheme.

$\psi(v)=\frac{W(v)\psi(v)+q(c_u)d(v)}{W(v)+q(c_u)}$

> $W(v)=min(W_{max},W(v)+q(c_u))$



## Result

![image-20191209220334240](asset/ReadingNote Dynamic Object-Level SLAM with Probabilistic Data Association/image-20191209220334240.png)

can handle fast movement

