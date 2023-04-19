classdef StaticGrating < Renderable
    properties
        ori
        spat_freq
        temp_freq
        contrast
        phase
        size
    end

    properties (Access = protected)
        amplitude
        phase_increment
        rotate_mode
        gratingtex
        patch_size
    end

    methods
        function obj = StaticGrating(ori, spat_freq, temp_freq, contrast, phase, sz)
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
            
            if nargin < 6 || isempty(sz)
                sz = nan;
            end
            
            obj.ori = ori;
            obj.spat_freq = spat_freq;
            obj.temp_freq = temp_freq;
            obj.contrast = contrast;
            obj.phase = phase;
            obj.patch_size = 2000; % big
            obj.size = sz;
        end

        function initialize(obj)
            obj.amplitude = obj.contrast / 2;
            obj.rotate_mode = kPsychUseTextureMatrixForRotation;
            obj.phase_increment = (obj.temp_freq * 360) * obj.getIFI();
            obj.gratingtex = CreateProceduralSquareWaveGrating(obj.getWindow(), obj.patch_size, obj.patch_size, [0.5 0.5 0.5 0.0]);
%             obj.description = sprintf('Drifting grating: %d deg', obj.ori);
        end

        function draw(obj, t_close)
            %% From MG function "DrawDriftingGrating.m"
            vbl = Screen('Flip', obj.getWindow());
            while obj.renderer.getTime() < t_close
                % Increment phase by 1 degree:
                
                % Draw the grating:
                Screen('DrawTexture',obj.getWindow(), obj.gratingtex, obj.getRect(obj.size), obj.getRect(obj.size), obj.ori, [], [], [], [], obj.rotate_mode, [obj.phase, obj.spat_freq, obj.amplitude, 0]); % subsample
                Screen('DrawingFinished', obj.getWindow());
                % Show it at next retrace:
                vbl = Screen('Flip', obj.getWindow(), vbl + 0.5 * obj.getIFI());
            end
            return;
        end
    end   
end
