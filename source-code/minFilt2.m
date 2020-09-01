%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/06
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : 2-D Minimum Filter
%                sv2: filtering window size.
%                slidingOp: sliding option, "sliding" or "distinct". 
%                "sliding" option uses symmetric boundary padding. 
%                "distinct" option pads image with Inf.
%==========================================================================

function [minImg] = minFilt2(inImg,sv2,slidingOp)

% Default parameters
switch nargin
    case 3
        % All arguments were provided, do nothing
    case 2
        slidingOp = 'sliding';
    case 1
        sv2 = 5;
        slidingOp = 'sliding';
    otherwise
        warning('Please check input arguments!');
        return;
end

[~,~,c] = size(inImg);
padsize = floor((sv2-1)/2);

% Resolve border effect in 'distinct' mode
switch slidingOp
    case 'sliding'
        paddedImg = sympad(inImg,sv2);
    case 'distinct'
        paddedImg = padarray(inImg,[padsize,padsize],Inf);
        [ph,pw,pc] = size(paddedImg);
        deltaH = ceil(ph/sv2)*sv2-ph;
        deltaW = ceil(pw/sv2)*sv2-pw;
        for index = 1:pc
            paddedImg = [[paddedImg,Inf(ph,deltaW)];Inf(deltaH,pw+deltaW)];
        end
    otherwise
        warning('Wrong input value!');
        return;
end

switch c
    case 1 % grayscale image
        temp = colfilt(paddedImg,[sv2,sv2],slidingOp,@customMin);
        switch slidingOp
            case 'sliding'
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
            case 'distinct'
                temp = temp(1:ph,1:pw);
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
            otherwise
                warning('Wrong input value!');
                return;
        end
    case 3 % RGB image
        temp = zeros(size(paddedImg));
        temp(:,:,1) = colfilt(paddedImg(:,:,1),[sv2,sv2],slidingOp,@customMin);
        temp(:,:,2) = colfilt(paddedImg(:,:,2),[sv2,sv2],slidingOp,@customMin);
        temp(:,:,3) = colfilt(paddedImg(:,:,3),[sv2,sv2],slidingOp,@customMin);
        switch slidingOp
            case 'sliding'
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
            case 'distinct'
                temp = temp(1:ph,1:pw,:);
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
            otherwise
                warning('Wrong input value!');
                return;
        end
    otherwise
        warning('Invalid input image!');
        return;
end

    % Customized min function
    function [out] = customMin(in)
        switch slidingOp
            case 'sliding'
                out = min(in);
            case 'distinct'
                out = repmat(min(in),[size(in,1),1]);
            otherwise
                warning('Invalid input value!');
                return;
        end
    end

end

% Symmetric padding (local function)
function inpad = sympad(in,sv)

[~,~,c] = size(in);
switch c
    case 1 % grayscale image
        inpad = sympad2(in,sv);
    case 3 % rgb image
        inpad(:,:,1) = sympad2(in(:,:,1),sv);
        inpad(:,:,2) = sympad2(in(:,:,2),sv);
        inpad(:,:,3) = sympad2(in(:,:,3),sv);
    otherwise
end

end

function inpad = sympad2(in,sv)

[y,x] = size(in);
ypad = y+(sv-1);
xpad = x+(sv-1);
inpad = zeros(ypad,xpad);
inpad((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2) = in;

upmask = false(ypad,xpad);
upmask((sv+1)/2+1:sv,:) = true;
uppad = reshape(inpad(upmask),[(sv-1)/2,xpad]);
uppad = uppad(end:-1:1,:);

lowmask = false(ypad,xpad);
lowmask(end-(sv-1):end-(sv-1)/2-1,:) = true;
lowpad = reshape(inpad(lowmask),[(sv-1)/2,xpad]);
lowpad = lowpad(end:-1:1,:);

inpad(1:(sv+1)/2-1,:) = uppad;
inpad(end-(sv-1)/2+1:end,:) = lowpad;

leftmask = false(ypad,xpad);
leftmask(:,(sv+1)/2+1:sv) = true;
leftpad = reshape(inpad(leftmask),[ypad,(sv-1)/2]);
leftpad = leftpad(:,end:-1:1);

rightmask = false(ypad,xpad);
rightmask(:,end-(sv-1):end-(sv-1)/2-1) = true;
rightpad = reshape(inpad(rightmask),[ypad,(sv-1)/2]);
rightpad = rightpad(:,end:-1:1);

inpad(:,1:(sv+1)/2-1) = leftpad;
inpad(:,end-(sv-1)/2+1:end) = rightpad;

end
