classdef PTscreen < handle
    
    properties
        vertScreenCM = 14;
        dScreenCM = 10;
    end
    
    properties
        white = BlackIndex(screen);
        black = WhiteIndex(screen);
        gray = round((white+black)/2);
        inc = white-gray;
        yRes = RectHeight(Screen('Rect', screen));
        xRes = RectWidth(Screen('Rect', screen));
        fr = Screen('FrameRate',screen);
    end
    
    methods
        function x = getPxPerDeg(obj)
            vScreenDeg = atand(obj.vertScreenCM, obj.dScreenCM);
            x = obj.yRes/vScreenDeg;
        end
        
        function loadGamma(obj)%, path)
            gammaFile = 'C:/Users/miscFrankenRig/Documents/HBIO/gamma_correction_210330.mat';
            load(gammaFile,'gamma_table')
            %Screen('LoadNormalizedGammaTable',w,gamma_table);
        end    

    end
end