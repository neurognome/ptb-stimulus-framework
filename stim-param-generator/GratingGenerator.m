classdef GratingGenerator < Generator
    
    properties
        ori (1, 1) double {mustBeGreaterThanOrEqual(ori, 0), mustBeLessThanOrEqual(ori, 360)} = 0;
        sf = 0.01;
        tf = 1;
        contrast = 1;
        phase = 0;
        size = 20;
        name = 'GratingGenerator';
    end
    
    methods
        function obj = GratingGenerator(varargin)
            obj@Generator(varargin{:});
        end
    end
end