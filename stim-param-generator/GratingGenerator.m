classdef GratingGenerator < Generator
    
    properties
        ori (1, 1) double {mustBeGreaterThanOrEqual(ori, 0), mustBeLessThanOrEqual(ori, 360)} = 0;
        sf (1, 1) double {mustBeGreaterThanOrEqual(sf, 0)} = 0.01;
        tf (1, 1) double {mustBeGreaterThanOrEqual(tf, 0)} = 1;
        contrast (1, 1) double {mustBeGreaterThanOrEqual(contrast, 0), mustBeLessThanOrEqual(contrast, 1)} = 1;
        phase (1, 1) double {mustBeGreaterThanOrEqual(phase, 0), mustBeLessThanOrEqual(phase, 360)}= 0;
        size (1, 1) double {mustBeGreaterThanOrEqual(size, 0)}= 20;
        name = 'GratingGenerator';
    end
    
    methods
        function obj = GratingGenerator(varargin)
            obj@Generator(varargin{:});
        end
    end
end