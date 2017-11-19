classdef Sigmoid < CameraModel
    properties
        param = [0.90,0.60] % n sigma
    end
    
    methods (Access = public)
        function this = Sigmoid(varargin)
             this = this@CameraModel(varargin{:});
        end
        
        function B = crf(this, E)
            n = this.param(1);
            sigma = this.param(2);
            B = (1+sigma) .* (E.^n) ./ (E.^n + sigma);
        end
        
        function B1 = btf(this,B0,k)
            n = this.param(1);
            sigma = this.param(2);
            B1 = ( (sigma+sigma^2)*k.^n.*B0 )./(k.^n*sigma.*B0+(1+sigma-B0).* sigma);
        end
        
        function E = crf_inv(this, B)
            n = this.param(1);
            sigma = this.param(2);
            E = sigma * B ./ (1 + sigma - B);
            E = E.^(1./n);
        end
    end
end

