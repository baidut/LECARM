classdef Gamma < CameraModel
   properties
        param = 0.8
    end
    
    methods (Access = public)
        function this = Gamma(varargin)
             this = this@CameraModel(varargin{:});
        end
        
        function B = crf(this, E)
            B = exp(E .^ this.param);
        end
        
        function B1 = btf(this, B0, k)
            B1 = B0 .* (k .^ this.param);
        end
        
        function E = crf_inv(this, B)
            E = log(B) .^ (1./this.param);
        end
    end
end

