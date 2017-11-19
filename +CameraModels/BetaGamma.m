classdef BetaGamma < CameraModel
    
    properties
        param = [-0.3293 1.1258]; % dorf
    end
    
    methods (Access = public)
        function this = BetaGamma(varargin)
             this = this@CameraModel(varargin{:});
        end
        
        function B = crf(this, E)
            B = exp((1-E.^this.param(1))*this.param(2));
        end
        
        function B1 = btf(this, B0, k)
            beta = this.crf(k);
            gamma = k.^this.param(1);
            B1 = B0.^gamma.*beta;
        end
        
        function E = crf_inv(this, B)
            E = (1 - log(B)./this.param(2)) .^(1./this.param(1));
        end
    end
end