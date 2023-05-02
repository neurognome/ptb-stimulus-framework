classdef GratingFactory < handle
    
    properties
        ori = 0;
        sf = 0.01;
        tf = 1;
        contrast = 1;
        phase = 0;
        sz = 20;
    end
    
    properties
        white = BlackIndex(1);
        black = WhiteIndex(1);
        yRes = RectHeight(Screen('Rect', 1));
        xRes = RectWidth(Screen('Rect', 1));
        fr = Screen('FrameRate',1);
    end
    
    properties
        heightCM
        distanceCM
        gray
        inc
        pxPerDeg
        fq
        p
    end
    
    methods
        function obj = GratingFactory()
            obj.gray = round((obj.white+obj.black)/2);
            obj.inc = obj.white-obj.gray;
        end
        
        function setScreenSize(obj, h, d)
            obj.heightCM = h;
            obj.distanceCM = d;
            obj.pxPerDeg = obj.calcPxPerDeg(h,d);
            obj.p = ceil(1/obj.sf*obj.pxPerDeg);
            obj.fq = 1/obj.p*2*pi;
        end
        
        function  x = calcPxPerDeg(obj, h, d)
            x = obj.yRes/atand(h/d);
        end
        
        function tx = make(obj)
            r = ceil(obj.sz*obj.pxPerDeg/2);
%             visiblesize = 2*r+1;
            [x,~] = meshgrid(-r:r+obj.p, -r:r);
            sinusoid = obj.gray + obj.inc*cos(obj.p*x);
            grating_mask = sinusoid > obj.gray;
            contrast_diff = 1;
            sinusoid(grating_mask) = obj.gray-(255*contrast_diff/2); %makes actual squarewave
            sinusoid(~grating_mask) = obj.gray+(255*contrast_diff/2);
%             tx = Screen('MakeTexture',w,sinusoid);
            tx = sinusoid;
        end
            
                    
    end
end