# OTM-AAL

## Summary
This is the MATLAB source code of a haze removal algorithm, which was published in Remote Sensing (MDPI). In this paper, the transmission map was estimated by maximizing an objective function quantifying image contrast and shaprness. Additionally, an adaptive atmospheric light was devised to prevent the loss of dark details after removing haze. The pros and cons of this algorithm is summarized as follows:
Pros | Cons
-----|-----
Quality of dehazed images are quite good. | Optimal estimate of transmission map is not always guaranteed.
Dark details are well preserved. | Extremely time-consuming is a main problem.

Some qualitative results are as follows:

![First](/results/more_results_1.jpg)

## Run the code
Executing the file *OTM_demo.m* in **MATLAB R2019a** to view the demonstration results on different types of input images, namely:
* Synthetic road scene.
* Real hazy scene.
* Real yellow dust scene.

The souce code of this algorithm was placed in the *souce-code* folder and the full datasets are available at: [Dropbox link](https://www.dropbox.com/s/yxsny8ooxjhg68i/Dataset.rar?dl=0)

## Future development
Solving the optimization problem analytically to derive a direct solution of transmission map. This will significantly accelerate the processing rate and favor the hardware implementation for real-time processing.

## Reference
In any publication related to the use of source code or datasets, you are kindly requested to cite the following reference:

1. [Ngo, D.; Lee, S.; Kang, B. Robust Single-Image Haze Removal Using Optimal Transmission Map and Adaptive Atmospheric Light. *Remote Sens.* **2020**, 12, 2233.](https://www.mdpi.com/2072-4292/12/14/2233)
1. [Tarel, J.P.; Hautiere, N.; Caraffa, L.; Cord, A.; Halmaoui, H.; Gruyer, D. Vision Enhancement in Homogeneous and Heterogeneous Fog. *IEEE Intell. Transp. Syst. Mag.* **2012**, 4, 6–20.](https://ieeexplore.ieee.org/document/6190796)
1. [Ancuti, C.O.; Ancuti, C.; Timofte, R.; De Vleeschouwer, C. O-HAZE: A Dehazing Benchmark with Real Hazy and Haze-Free Outdoor Images. In Proceedings of *the 2018 IEEE/CVF Conference on Computer Vision and Pattern Recognition Workshops (CVPRW)*, Salt Lake City, UT, USA, 18–22 June **2018**; pp. 867–8678.](https://ieeexplore.ieee.org/document/8575270)
1. [Ancuti, C.O.; Ancuti, C.; Timofte, R.; De Vleeschouwer, C. I-HAZE: A dehazing benchmark with real hazy and haze-free indoor images. *arXiv* **2018**, arXiv:1804.05091.](https://arxiv.org/abs/1804.05091)
