function S = limeEstimate( I, lambda, sigma, sharpness)
% estimate illumination T using method proposed by lime
% X. Guo,Y. Li, and H. Ling. 
% Lime: Low-light image enhance- ment via illumination map estimation. 
% IEEE Transactions on Image Processing, 26(2):982¨C993, 2017. 1,

if ( ~exist( 'lambda', 'var' ) )
    lambda = 0.15;
end
if ( ~exist( 'sigma', 'var' ) )
    sigma = 2;
end
if ( ~exist( 'sharpness', 'var' ) )
    sharpness = 0.001;
end
I = im2double( I );
x = I;
[ wx, wy ] = computeTextureWeights( x, sigma, sharpness);
S = solveLinearEquation( I, wx, wy, lambda );
end

function [ W_h, W_v ] = computeTextureWeights( fin, sigma, sharpness)

range = 5;
dt0_v = [diff(fin,1,1);fin(1,:)-fin(end,:)];
dt0_h = [diff(fin,1,2)';fin(:,1)'-fin(:,end)']';


mid = ceil(range/2);
temp = ones(1,range);
temp = (find(temp==1)-mid).^2;
fil = gaussmf(temp,[sigma,0]);

gauker_h = filter2(fil,dt0_h);
gauker_v = filter2(fil,dt0_v);
W_h = sum(fil)./(abs(gauker_h).*abs(dt0_h)+sharpness);
W_v = sum(fil)./(abs(gauker_v).*abs(dt0_v)+sharpness);



end

function OUT = solveLinearEquation( IN, wx, wy, lambda )
[ r, c, ch ] = size( IN );
k = r * c;
dx =  -lambda * wx( : );
dy =  -lambda * wy( : );
tempx = [wx(:,end),wx(:,1:end-1)];
tempy = [wy(end,:);wy(1:end-1,:)];
dxa = -lambda *tempx(:);
dya = -lambda *tempy(:);
tempx = [wx(:,end),zeros(r,c-1)];
tempy = [wy(end,:);zeros(r-1,c)];
dxd1 = -lambda * tempx(:);
dyd1 = -lambda * tempy(:);
wx(:,end) = 0;
wy(end,:) = 0;
dxd2 = -lambda * wx(:);
dyd2 = -lambda * wy(:);

Ax = spdiags( [dxd1,dxd2], [-k+r,-r], k, k );
Ay = spdiags( [dyd1,dyd2], [-r+1,-1], k, k );

D = 1 - ( dx + dy + dxa + dya);
A = (Ax+Ay) + (Ax+Ay)' + spdiags( D, 0, k, k );

if exist( 'ichol', 'builtin' )
    L = ichol( A, struct( 'michol', 'on' ) );
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        [ tout, ~ ] = pcg( A, tin( : ), 0.1, 50, L, L' );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
else
    OUT = IN;
    for ii = 1:ch
        tin = IN( :, :, ii );
        tout = A\tin( : );
        OUT( :, :, ii ) = reshape( tout, r, c );
    end
end
end