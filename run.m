%% input
p = mfilename('fullpath');
p = strsplit(p,'\');
imgFile=fullfile(p{1:end-1},'image\1.JPG');
in = im2double(imread(imgFile));

%% select a camera response model
model = CameraModels.Sigmoid();
% model = CameraModels.Beta();
% model = CameraModels.BetaGamma();

%% enhance
out = LECARM(in,model);

%% plot
figure
subplot(1,2,1)
imshow(in);
title('the input low-light image');

subplot(1,2,2)
imshow(out);
title('the enhanced output image');