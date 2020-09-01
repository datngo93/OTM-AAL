# OTM-AAL
This is the MATLAB source code of a haze removal algorithm, which was published in Remote Sensing (MDPI). In this paper, the transmission map was estimated by maximizing an objective function quantifying image contrast and shaprness. Additionally, an adaptive atmospheric light was devised to prevent the loss of dark details after removing haze. The pros and cons of this algorithm is summarized as follows:
1. Pros: the quality of dehazed images are quite good, dark details are well preserved, and the visibility is restored considerably.
2. Cons: the algorithm does not always guarantee to dehaze the input images correctly, owing to the employed Nelder-Mead optimization algorithm (which is a heuristic method), and it is extremely time-consuming.
