%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/04
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : Quadtree-subdivision algorithm for finding region
%                containing atmospheric light candidate
%==========================================================================

function [maskr,xr,yr,regsize,A] = qtSubAl(inImg,stopBZ,slidingOp,sv)
%QTDIV Quadtree-subdivision on the input image.
%   inImg: input RGB image or grayscale image.
%   stopBZ ([0,1]): when image's size reduce below stopBZ, subdivision will stop.
%   slidingOp: min filter's sliding option. 'sliding' or 'distinct'.
%   sv: min filter's window size.
%   maskr: output mask
%   xr,yr: location of selected region for calculating atmospheric light.
%   regsize: size of selected region.
%   A: estimated atmospheric light.

% Default parameters
switch nargin
    case 1
        stopBZ = 0.2;
        slidingOp = 'sliding';
        sv = 5;
    case 2
        slidingOp = 'sliding';
        sv = 5;
    case 3
        sv = 5;
    case 4
        % all arguments are provided
    otherwise
        warning('Invalid input arguments!');
        return;
end

[h,w,c] = size(inImg);
if (c ~= 3)
    if (isinteger(inImg))
        inImg = double(inImg)/255;
    else
        % assume that inImg is in the range [0,1]
    end
    
    inImgGray = inImg;
    inImgGray = minFilt2(inImgGray,sv,slidingOp);
    
    hsub = h;
    wsub = w;
    tempImg = inImgGray;
    mask = ones(size(inImgGray));
    xo = 1;
    yo = 1;
    while (((hsub/h)>=stopBZ)&&((wsub/w)>=stopBZ))
        [tempImg,mask,xo,yo] = qtdiv_v2(tempImg,mask,xo,yo);
        [hsub,wsub] = size(tempImg);
    end
    
    maskr = mask;
    xr = xo;
    yr = yo;
    
    chosenReg = inImg(yr:yr+hsub-1,xr:xr+wsub-1);
    d = sqrt((chosenReg-1).^2);
    [y,x] = find(d==min(d(:)));
    A = chosenReg(y(1),x(1));
    
    regsize = [hsub,wsub];
else
    if (isinteger(inImg))
        inImg = double(inImg)/255;
    else
        % assume that inImg is in the range [0,1]
    end
    
    inImgGray = rgb2gray(inImg);
    inImgGray = minFilt2(inImgGray,sv,slidingOp);
    
    hsub = h;
    wsub = w;
    tempImg = inImgGray;
    mask = ones(size(inImgGray));
    xo = 1;
    yo = 1;
    while (((hsub/h)>=stopBZ)&&((wsub/w)>=stopBZ))
        [tempImg,mask,xo,yo] = qtdiv_v2(tempImg,mask,xo,yo);
        [hsub,wsub] = size(tempImg);
    end
    
    maskr = mask;
    xr = xo;
    yr = yo;
    
    chosenReg = inImg(yr:yr+hsub-1,xr:xr+wsub-1,:);
    d = sqrt((chosenReg(:,:,1)-1).^2 + (chosenReg(:,:,2)-1).^2 + (chosenReg(:,:,3)-1).^2);
    [y,x] = find(d==min(d(:)));
    A = chosenReg(y(1),x(1),:);
    
    regsize = [hsub,wsub];
end

end
