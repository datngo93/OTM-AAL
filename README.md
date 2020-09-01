# OTM-AAL
This is the MATLAB source code of a haze removal algorithm, which was published in Remote Sensing (MDPI). In this paper, the transmission map was estimated by maximizing an objective function quantifying image contrast and shaprness. Additionally, an adaptive atmospheric light was devised to prevent the loss of dark details after removing haze. The pros and cons of this algorithm is summarized as follows:

Pros | Cons
-----|-----
Quality of dehazed images are quite good. | Optimal estimate of transmission map is not always guaranteed.
Dark details are well preserved. | Extremely time-consuming is a main problem.

## Future development
* Solving the optimization problem analytically to derive a direct solution of transmission map. This will significantly accelerate the processing rate and favor the hardware implementation for real-time processing.
