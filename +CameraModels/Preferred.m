classdef Preferred < CameraModel
   
    properties
        param =[4.35,1.29,0.14];
    end
    
    methods (Access = public)
        function this = Preferred(varargin)
             this = this@CameraModel(varargin{:});
        end
        
        function B = crf(this, E)
            B = exp(this.param(2)) .* power(E, this.param(1));
            B = B ./ (B+1);
            B = B .^ this.param(3);
        end
        
        function B1 = btf(this, B0, k)
            cf = B0.^(1./this.param(3));
            ka = k .^ this.param(1);
            B1 = ((cf .* ka) ./ (cf .* (ka-1) + 1)) .^ this.param(3);
        end
        
        function E = crf_inv(this, B)
            cf = B .^(1./this.param(3));
            E = (cf ./(1-cf))./ exp(this.param(2));
            E = E .^(1./this.param(1));
        end
    end
end

