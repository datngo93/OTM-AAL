# OTM-AAL

## Summary
This is the MATLAB source code of a haze removal algorithm, which was published in Remote Sensing (MDPI). In this paper, the transmission map was estimated by maximizing an objective function quantifying image contrast and shaprness. Additionally, an adaptive atmospheric light was devised to prevent the loss of dark details after removing haze. The pros and cons of this algorithm is summarized as follows:
Pros | Cons
-----|-----
Quality of dehazed images are quite good. | Optimal estimate of transmission map is not always guaranteed.
Dark details are well preserved. | Extremely time-consuming is a main problem.

## Run the code
Executing the file *OTM_demo.m* in **MATLAB R2019a** to view the demonstration results on different types of input images, namely:
* Synthetic road scene.
* Real hazy scene.
* Real yellow dust scene.

The souce code of this algorithm was placed in the *souce-code* folder.

## Future development
Solving the optimization problem analytically to derive a direct solution of transmission map. This will significantly accelerate the processing rate and favor the hardware implementation for real-time processing.

## Reference
In any publication related to the use of source code, you are kindly requested to cite the following reference:

[Ngo, D.; Lee, S.; Kang, B. Robust Single-Image Haze Removal Using Optimal Transmission Map and Adaptive Atmospheric Light. *Remote Sens.* **2020**, 12, 2233.](https://www.mdpi.com/2072-4292/12/14/2233)
