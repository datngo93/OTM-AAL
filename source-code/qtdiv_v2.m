%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/04
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Quadtree-subdivision on the input image
%==========================================================================

function [chosenReg,maskr,xr,yr] = qtdiv_v2(inImgGray,mask,xo,yo)
%QTDIV Quadtree-subdivision on the input image.

[h,w,c] = size(inImgGray);
if (c ~= 1)
    warning('Input image must be grayscale image!');
    return;
else
    % do nothing
end

% Notation of image's sub-regions
% -------------------------------------------
% |                    |                    |
% |                    |                    |
% |                    |                    |
% |         1          |         2          |
% |                    |                    |
% |                    |                    |
% |                    |                    |
% -------------------------------------------
% |                    |                    |
% |                    |                    |
% |                    |                    |
% |         3          |         4          |
% |                    |                    |
% |                    |                    |
% |                    |                    |
% -------------------------------------------

firstReg = inImgGray(1:floor(h/2),1:floor(w/2));
secondReg = inImgGray(1:floor(h/2),floor(w/2)+1:w);
thirdReg = inImgGray(floor(h/2)+1:h,1:floor(w/2));
fourthReg = inImgGray(floor(h/2)+1:h,floor(w/2)+1:w);
regArr = {firstReg;secondReg;thirdReg;fourthReg};

firstRegInten = mean(firstReg(:));
secondRegInten = mean(secondReg(:));
thirdRegInten = mean(thirdReg(:));
fourthRegInten = mean(fourthReg(:));

[~,ind] = sort([firstRegInten,secondRegInten,thirdRegInten,fourthRegInten],'descend');
chosenReg = regArr{ind(1)};

switch ind(1)
    case 1
        kx = 0;
        ky = 0;
    case 2
        kx = 1;
        ky = 0;
    case 3
        kx = 0;
        ky = 1;
    otherwise % 4
        kx = 1;
        ky = 1;
end

xr = xo+kx*floor(w/2);
yr = yo+ky*floor(h/2);

maskr = mask;
maskr(yo+floor(h/2),xo:xo+(w-1)) = 0;
maskr(yo:yo+(h-1),xo+floor(w/2)) = 0;

end
