function H = tamura(I)
%IColor = imread('34.jpg');
IColor = rgb2gray(I);%Converts RGB image to grayscale
[r,c] = size(IColor);%size of array
G=double(IColor);

%% -------------------Coarseness-------------------

%initialization
%Average of neighbouring pixels
A1=zeros(r,c);A2=zeros(r,c);
A3=zeros(r,c);A4=zeros(r,c);
A5=zeros(r,c);A6=zeros(r,c);
%Sbest for coarseness
Sbest=zeros(r,c);
%Subtracting for Horizontal and Vertical case
E1h=zeros(r,c);E1v=zeros(r,c);
E2h=zeros(r,c);E2v=zeros(r,c);
E3h=zeros(r,c);E3v=zeros(r,c);
E4h=zeros(r,c);E4v=zeros(r,c);
E5h=zeros(r,c);E5v=zeros(r,c);
E6h=zeros(r,c); E6v=zeros(r,c);
flag=0;%To avoid errors

%2x2  E1h and E1v
%subtracting average of neighbouring 2x2 pixels 
for x=2:r
    for y=2:c
        A1(x,y)=(sum(sum(G(x-1:x,y-1:y))));
    end
end
for x=2:r-1
    for y=2:c-1
        E1h(x,y) = A1(x+1,y)-A1(x-1,y);
        E1v(x,y) = A1(x,y+1)-A1(x,y-1);
    end
end
E1h=E1h/2^(2*1);
E1v=E1v/2^(2*1);

%4x4  E2h and E2v
if (r<4||c<4)
    flag=1;
end
%subtracting average of neighbouring 4x4 pixels
if(flag==0)
    for x=3:r-1
        for y=3:c-1
            A2(x,y)=(sum(sum(G(x-2:x+1,y-2:y+1))));
        end
    end
    for x=3:r-2
        for y=3:c-2
            E2h(x,y) = A2(x+2,y)-A2(x-2,y);
            E2v(x,y) = A2(x,y+2)-A2(x,y-2);
        end
    end
end
E2h=E2h/2^(2*2);
E2v=E2v/2^(2*2);

%8x8 E3h and E3v
if (r<8||c<8)
    flag=1;
end
%subtracting average of neighbouring 8x8 pixels
if(flag==0)
    for x=5:r-3
        for y=5:c-3
            A3(x,y)=(sum(sum(G(x-4:x+3,y-4:y+3))));
        end
    end
    for x=5:r-4
        for y=5:c-4
            E3h(x,y) = A3(x+4,y)-A3(x-4,y);
            E3v(x,y) = A3(x,y+4)-A3(x,y-4);
        end
    end
end
E3h=E3h/2^(2*3);
E3v=E3v/2^(2*3);
 
%16x16 E4h and E4v
if (r<16||c<16)
    flag=1;
end
%subtracting average of neighbouring 16x16 pixels
if(flag==0)
    for x=9:r-7
        for y=9:c-7
            A4(x,y)=(sum(sum(G(x-8:x+7,y-8:y+7))));
        end
    end
    for x=9:r-8
        for y=9:c-8
            E4h(x,y) = A4(x+8,y)-A4(x-8,y);
            E4v(x,y) = A4(x,y+8)-A4(x,y-8);
        end
    end
end
E4h=E4h/2^(2*4);
E4v=E4v/2^(2*4);
 
%32x32 E5h and E5v
if (r<32||c<32)
    flag=1;
end
%subtracting average of neighbouring 32x32 pixels
if(flag==0)
    for x=17:r-15
        for y=17:c-15
            A5(x,y)=(sum(sum(G(x-16:x+15,y-16:y+15))));
        end
    end
    for x=17:r-16
        for y=17:c-16
            E5h(x,y) = A5(x+16,y)-A5(x-16,y);
            E5v(x,y) = A5(x,y+16)-A5(x,y-16);
        end
    end
end
E5h=E5h/2^(2*5);
E5v=E5v/2^(2*5);
 
%64x64 E6h and E6v
if (r<64||c<64)
    flag=1;
end
%subtracting average of neighbouring 64x64 pixels
if(flag==0)
    for x=33:r-31
        for y=33:c-31
            A6(x,y)=(sum(sum(G(x-32:x+31,y-32:y+31))));
        end
    end
    for x=33:r-32
        for y=33:c-32
            E6h(x,y) = A6(x+32,y)-A6(x-32,y);
            E6v(x,y) = A6(x,y+32)-A6(x,y-32);
        end
    end
end
E6h=E6h/2^(2*6);
E6v=E6v/2^(2*6);

%plots
%{
figure
subplot(131);
imshow(IColor);
title('Original image')
subplot(132);
imshow(E1h);
title('Horizontal case')
subplot(133)
imshow(E1v);
title('Vertical case')
%}
%at each point pick best size "Sbest", which gives highest output value
for i=1:r
    for j=1:c
        [maxv,index]=max([abs(E1h(i,j)),abs(E1v(i,j)),abs(E2h(i,j)),abs(E2v(i,j)),...
            abs(E3h(i,j)),abs(E3v(i,j)),abs(E4h(i,j)),abs(E4v(i,j)),abs(E5h(i,j)),...
            abs(E5v(i,j)),abs(E6h(i,j)),abs(E6v(i,j))]);
        k=floor((index+1)/2);%'k'corresponding to highest E in either direction
        Sbest(i,j)=2.^k;
    end
end 
%figure;
%plot(Sbest)
%title('Output of best size detector')
%Coarseness Value
Fcoarseness=sum(sum(Sbest))/(r*c);
%% Contrast
    [counts,graylevels] = imhist(IColor);
    PI = counts/(r*c);
    averagevalue = sum(graylevels.*PI);
    u4 = sum((graylevels-repmat(averagevalue,[256,1])).^4.*PI);
    standarddeviation = sum((graylevels-repmat(averagevalue,[256,1])).^2.*PI);
    alpha4 = u4/standarddeviation^2;
    Fcontrast = sqrt(standarddeviation)/alpha4.^(1/4);
     %% Direction degree
    [deltaH,deltaV,theta] = deal(zeros(r,c));
    PrewittH = [-1 0 1;-1 0 1;-1 0 1];
    PrewittV = [1 1 1;0 0 0;-1 -1 -1];
    % Horizontal gradient
    for i=2:r-1
        for j=2:c-1
            deltaH(i,j)=sum(sum(G(i-1:i+1,j-1:j+1).*PrewittH));
        end
    end
    deltaH(1,2:c-1) = bsxfun(@minus, G(1,3:c), G(1,2:c-1));
    deltaH(r,2:c-1) = bsxfun(@minus, G(r,3:c), G(r,2:c-1));
    deltaH(1:r,1) = bsxfun(@minus, G(1:r,2), G(1:r,1));
    deltaH(1:r,c) = bsxfun(@minus, G(1:r,c), G(1:r,c-1));

    % Vertical gradient
    for i=2:r-1
        for j=2:c-1
            deltaV(i,j)=sum(sum(G(i-1:i+1,j-1:j+1).*PrewittV));
        end
    end
    deltaV(1,1:c) = bsxfun(@minus, G(2,1:c), G(1,1:c));
    deltaV(r,1:c) = bsxfun(@minus, G(r,1:c), G(r-1,1:c));
    deltaV(2:r-1,1) = bsxfun(@minus, G(3:r,1), G(2:r-1,1));
    deltaV(2:r-1,c) = bsxfun(@minus, G(3:r,c), G(2:r-1,c));

    % Gradient vector direction
    theta(cell2mat(arrayfun(@(x) find(deltaH==x & deltaV~=x),0, 'UniformOutput', false)))=pi;
    tempInd = cell2mat(arrayfun(@(x) find(deltaH~=x),0, 'UniformOutput', false));
    theta(tempInd)=atan(deltaV(tempInd')./deltaH(tempInd'))+pi/2;

    theta1 = reshape(theta,1,[]);
    phai = 0:0.0001:pi;
    HD1 = hist(theta1,phai);
    HD1 = HD1/(r*c);
    HD2 = zeros(size(HD1));
THRESHOLD = 0.01;
    thrInd = find(HD1>=THRESHOLD);
    HD2(thrInd) = HD1(thrInd);

    [~,index] = max(HD2);
    phaiP = index*0.0001;
    ind = find(HD2~=0);
    Fdirection = sum(((phai(ind)-phaiP).^2).*HD2(ind));
%fprintf('[Fcoarseness,Fcontrast,Fdirection]')
display([Fcoarseness,Fcontrast,Fdirection])
    H=[Fcoarseness Fcontrast Fdirection];
    clear('r','c','alpha4','u4','A1','A2','A3','A4','A5','A6',...
        'averagevalue','counts','deltaH','deltaV','E1h','E1v','E2h','E2v','E3h','E3v','x','y','X','i','I','Icolor',...
        'G','ind','index','graylevels','j','k','maxv','E4h','E4v','E5h','E5v','E6h','E6v',...
        'HD1','HD2','Sbest','tempInd','theta1','thrInd');
end 