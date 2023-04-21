classdef DriftingTex < GratingFactory & Renderable
    properties
        drifting = 1;
    end
    
    methods
        function draw(obj, t_close)
            phase = obj.phase;
            vbl = Screen('Flip', obj.getWindow());
            while obj.renderer.getTime() < t_close
                % Increment phase by 1 degree:
                phase = phase + obj.phase_increment;
                
                % Draw the grating:
                Screen('DrawTexture',obj.getWindow(), obj.gratingtex, obj.getRect(obj.ground_sz), obj.getRect(obj.ground_sz), obj.ori+90, [], [], [], [], obj.rotate_mode, [phase, obj.spat_freq, obj.amplitude, 0]); % subsample
                Screen('DrawTexture',obj.getWindow(), obj.gratingtex, obj.getRect(obj.figure_sz), obj.getRect(obj.figure_sz), obj.ori, [], [], [], [], obj.rotate_mode, [phase, obj.spat_freq, obj.amplitude, 0]); % subsample
                Screen('DrawingFinished', obj.getWindow());
                % Show it at next retrace:
                vbl = Screen('Flip', obj.getWindow(), vbl + 0.5 * obj.getIFI());
            end
        end
    end
    
            
end