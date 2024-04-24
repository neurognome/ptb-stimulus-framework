classdef ProceduralNoise < Renderable
    properties
        contrast
        
        size                    % image size (pixels)
        sigma                     % sigma for smaller gaussian (difference of gaussians filter)
        tf                  % maximum temporal frequency (default = 2 Hz)
        motion_shift                    % frequency with which to random shift apparent motion (default = 2 Hz)
        binarize                        % grayscale (0) or black/white(1)
    end
    
    properties (Access = protected)
        textures
        n_frames
    end
    
    methods
        function obj = ProceduralNoise(contrast, motion_shift, size, binarize, sigma, tf)
            % Setting default parameters
            if nargin < 1 || isempty(contrast)
                contrast = 1;
            end
            
            if nargin < 2 || isempty(motion_shift)
                motion_shift = 2;
            end
            
            if nargin < 3 || isempty(size)
                size = 500;
            end
            
            if nargin < 4 || isempty(binarize)
                binarize = 0;
            end
            
            if nargin < 5 || isempty(sigma)
                sigma = [0.5, 1];
            end
            
            if nargin < 6 || isempty(tf)
                tf = 2;
            end
            
            obj.contrast = contrast;
            obj.motion_shift = motion_shift;
            obj.size = size;
            obj.binarize = binarize;
            obj.sigma = sigma;
            obj.tf = tf;
        end
        
        function initialize(obj)
            phase_inc = obj.tf*pi * obj.getIFI();
            motion_shift_frames = round(obj.motion_shift/obj.getIFI());
            % Make difference-of-gaussians filter and reshape
            filter_centered = fspecial('gaussian',obj.size,obj.sigma(2))-fspecial('gaussian',obj.size,obj.sigma(1));
            filter_centered(filter_centered<0) = 0;
            
            center = round(obj.size/2);
            spatial_filter(1:center,1:center) = filter_centered(center+1:obj.size,center+1:obj.size);
            spatial_filter(1:center,center+1:obj.size) = filter_centered(center+1:obj.size,1:center);
            spatial_filter(center+1:obj.size,1:center) = filter_centered(1:center,center+1:obj.size);
            spatial_filter(center+1:obj.size,center+1:obj.size) = filter_centered(1:center,1:center);
            
            % take FFT of seed white noise matrix
            white_noise = rand(obj.size);
            Z_pre = fft2(white_noise);
            
            % Calculate magnitude and phase in frequency domain
            mag = abs(Z_pre);
            phi = angle(Z_pre);
            
            % Filter magnitude
            mag = mag.*spatial_filter;
            
            % initalize
            obj.n_frames = ceil(2 * (1/obj.getIFI()));
            % calculate noise frames
            for i = 1:obj.n_frames
                
                % periodically randomize polarity of phase increment (random apparent motion)
                if rem(i,motion_shift_frames)==1
                    polarity_mat = round(rand(obj.size)*2-1).*rand(obj.size)*pi;
                end
                
                % Progress phase shifts
                delta_phi = phase_inc*polarity_mat;
                phi = mod(phi+delta_phi+pi,2*pi)-pi;
                
                Z_post = mag.*exp(1i*phi);
                ifft_image = ifft2(Z_post);
                
                % Pick just the real component
                real_comp = real(ifft_image);
                
                % Normalize
                norm_image = real_comp-mean(mean(real_comp));
                norm_image = norm_image/max(max(abs(norm_image)));
                
                % Binarize
                if obj.binarize==1
                    norm_image = double(norm_image>0)*2-1;
                else
                    
                end
                % Scale image for Psychtoolbox
                 obj.textures(i) = Screen('MakeTexture', obj.getWindow(), norm_image * obj.contrast * 127.5 + 127.5);
            end
        end
        
        function draw(obj, t_close)
            %% From MG function "DrawDriftingGrating.m"
            vbl = Screen('Flip', obj.getWindow());
            frame_idx = 1;
            while obj.renderer.getTime() < t_close
                % Increment phase by 1 degree:
                Screen('DrawTexture',obj.getWindow(), obj.textures(frame_idx),[], []);
                Screen('DrawingFinished', obj.getWindow());
                % Show it at next retrace:
                vbl = Screen('Flip', obj.getWindow(), vbl + 0.5 * obj.getIFI());
                frame_idx = mod(frame_idx, obj.n_frames) + 1;
            end
            return;
        end
    end
end
