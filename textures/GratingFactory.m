classdef GratingFactory < handle
    
    properties
        ori = 0;
        sf = 0.01;
        tf = 1;
        contrast = 1;
        phase = 0;
        size = 20;
    end
    
    properties(Access = protected)
        patch_size = 1000;
    end
    
end