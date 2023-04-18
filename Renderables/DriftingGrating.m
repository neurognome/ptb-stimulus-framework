classdef DriftingGrating < Renderable
    properties
        ori
        spat_freq
        temp_freq
        contrast
        phase 
    end

    properties (Access = protected)
        amplitude
        phase_increment
        rotate_mode
        gratingtex
        patch_size
    end

    methods
        function obj = DriftingGrating(ori, spat_freq, temp_freq, contrast, phase, patch_size)
            % Setting default parameters
            if nargin < 1 || isempty(ori)
                ori = 0;
            end
            
            if nargin < 2 || isempty(spat_freq)
                spat_freq = 0.004;
            end
            
            if nargin < 3 || isempty(temp_freq)
                temp_freq = 2;
            end
            
            if nargin < 4 || isempty(contrast)
                contrast = 1;
            end
            
            if nargin < 5 || isempty(phase)
                phase = 0;
            end
            
            if nargin < 6 || isempty(patch_size)
                patch_size = 1000; %pixels
            end

            obj.ori = ori;
            obj.spat_freq = spat_freq;
            obj.temp_freq = temp_freq;
            obj.contrast = contrast;
            obj.phase = phase;
            obj.patch_size = patch_size;
        end

        function initialize(obj)
            obj.amplitude = obj.contrast / 2;
            obj.rotate_mode = kPsychUseTextureMatrixForRotation;
            obj.phase_increment = (obj.temp_freq * 360) * obj.getIFI();
            obj.gratingtex = CreateProceduralSineGrating(obj.getWindow(), obj.patch_size, obj.patch_size, [0.5 0.5 0.5 0.0]);
            obj.description = sprintf('Drifting grating: %d deg', obj.ori);
        end

        function draw(obj, t_close)
            %% From MG function "DrawDriftingGrating.m"
            phase = obj.phase;
            vbl = Screen('Flip', obj.getWindow());
            while obj.renderer.getTime() < t_close
                % Increment phase by 1 degree:
                phase = phase + obj.phase_increment;
                
                % Draw the grating:
                Screen('DrawTexture',obj.getWindow(), obj.gratingtex, obj.getRect(), obj.getRect(), obj.ori, [], [], [], [], obj.rotate_mode, [phase, obj.spat_freq, obj.amplitude, 0]);
                Screen('DrawingFinished', obj.getWindow());
                % Show it at next retrace:
                vbl = Screen('Flip', obj.getWindow(), vbl + 0.5 * obj.getIFI());
            end
            return;
        end
    end   
end
