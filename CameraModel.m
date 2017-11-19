classdef CameraModel < matlab.mixin.Heterogeneous % & handle
    properties (Abstract)
        param
    end
    
    properties
        name
    end
    
    methods (Abstract)
        B = crf(this, E)
    end
    
    methods (Access = public)
        function this = CameraModel(param)
            if exist('param', 'var')
                this.param = param;
            end
            s = strsplit(class(this), '.');
            this.name = s{end};
        end
        
        function this = setParam(this, param)
            this.param = param;
        end
        
        function B1 = btf(this, B0, k)
            B1 = this.crf(k .* this.crf_inv(B0));
        end
        
        function E = crf_inv(this, B)
            idx = linspace(0,1,1024);
            e = idx;
            b = this.crf(e);
            
            E = interpn(b, e, B(:), 'spline');
            E = reshape(E, size(B));

        end
    end
    

end