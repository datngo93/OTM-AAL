%%=========================================================================
% Copyright © 2020, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% - Date       : 17-Jan-2020
% - Author     : Dat Ngo
% - Affiliation: SoC Design Lab. - Dong-A University
% - Design     : Optimal Transmission Map & Adaptive Atmospheric Light
%==========================================================================

function [j,t_opt,t_opt_en] = OTM(img,ps,dp,tmin,lambda,aalEn)

% Input checking
[h,w,c] = size(img);
if (~isinteger(img))&&(c~=3)
    warning('Input image must be an RGB unsigned integer matrix!');
    return;
end

% Default parameters
switch nargin
    case 1
        ps = 16; % patch size
        dp = 0.7; % dehazing power
        tmin = 0.2; % lower limit of transmission map
        lambda = 4; % smoothing coefficient
        aalEn = true; % enable/disable adaptive atmospheric light
    case 2
        dp = 0.7;
        tmin = 0.2;
        lambda = 4;
        aalEn = true;
    case 3
        tmin = 0.2;
        lambda = 4;
        aalEn = true;
    case 4
        lambda = 4;
        aalEn = true;
    case 5
        aalEn = true;
    otherwise
        % all parameters are provided
end

[H,W,~] = size(img);
imggray = rgb2gray(img);
[~,~,~,~,a] = qtSubAl(img); % atmospheric light

patches_r = im2col(img(:,:,1),[ps,ps],'distinct');
patches_g = im2col(img(:,:,2),[ps,ps],'distinct');
patches_b = im2col(img(:,:,3),[ps,ps],'distinct');
patches = cat(3,patches_r,patches_g,patches_b);

t_opt = zeros(1,size(patches,2));
options = optimset('MaxFunEvals',1e5,'MaxIter',1e5,'TolFun',1e-7,'TolX',1e-7);
mscnwin = fspecial('gaussian',ps,ps/4);
for pi = 1:size(patches,2)
    t_init = 1-min(min(double(patches(:,pi,:))./(a*255),[],3));
    objFunc = @(x)anonymousFunc(x,double(patches(:,pi,:))/255,a,ps,mscnwin(:));
    t_opt(pi) = fminsearch(objFunc,t_init,options);
end
t_opt = repmat(t_opt,[ps^2,1]);
t_opt = col2im(t_opt,[ps,ps],[ceil(h/ps)*ps,ceil(w/ps)*ps],'distinct');
t_opt = t_opt(1:H,1:W);
t_opt_en = guidedfilter(double(imggray)/255,t_opt,30,1e-4);

if aalEn
    beta = 1./t_opt_en-1;
    a_adapt = zeros(size(img));
    a_adapt(:,:,1) = guidedfilter(double(imggray)/255,(beta.^2.*double(imggray)/255+lambda*a(1))./(beta.^2+lambda),30,1e-4);
    a_adapt(:,:,2) = guidedfilter(double(imggray)/255,(beta.^2.*double(imggray)/255+lambda*a(2))./(beta.^2+lambda),30,1e-4);
    a_adapt(:,:,3) = guidedfilter(double(imggray)/255,(beta.^2.*double(imggray)/255+lambda*a(3))./(beta.^2+lambda),30,1e-4);
    a_adapt(a_adapt>1) = 1;
    a_adapt(a_adapt<0) = 0;
else
    a_adapt = a;
end

j = (double(img)/255-a_adapt)./(max(t_opt_en,tmin).^dp)+a_adapt;
j(j<0) = 0;
j(j>1) = 1;

end

% Objective function
function f = anonymousFunc(t,i,a,ps,mscnwin)
j = (i-a)./t+a;
jgray = rgb2gray(j);
entropy = nansum(-(imhist(uint8(jgray*255))/ps^2).*log2(imhist(uint8(jgray*255))/ps^2));
[CEgray,CEby,CErg] = CE(uint8(reshape(j,[ps,ps,3])*255));
muj = sum(jgray.*mscnwin);
stdj = sum(sqrt((jgray-muj).^2.*mscnwin));
ft = [entropy;nanmean(CEgray,'all');nanmean(CEby,'all');nanmean(CErg,'all');stdj;stdj/muj];
f = -prod(log(1+abs(ft)));
end
