classdef Beta < CameraModel
   
    properties
        param = 0.8 % dorf: 0.4800 
    end
    
    methods (Access = public)
        function this = Beta(varargin)
             this = this@CameraModel(varargin{:});
        end
        
        function B = crf(this, E)
            B = (E .^ this.param);
        end
        
        function B1 = btf(this, B0, k)
            B1 = B0 .* (k .^ this.param);
        end
        
        function E = crf_inv(this, B)
            E = B .^ (1./this.param);
        end
    end
end

