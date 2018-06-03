function out = LECARM(in, cameraModel)
if ~exist('cameraModel', 'var')
    cameraModel = CameraModels.Sigmoid();
end
if ~isfloat(in), in = im2double(in); end
ratioMax = 7;
estimater = @(t)limeEstimate(t, 0.15, 2);

%%
T = max(in, [], 3);
T = imresize( estimater( imresize( T, 0.5 ) ), size(T) );
K = repmat(min(1./T,ratioMax),[1,1,size(in,3)]);
out = cameraModel.btf(in, K);
end