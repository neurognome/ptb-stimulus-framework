classdef BlankScreen < Renderable
    methods
        function initialize(obj)
            obj.description = sprintf('Blank screen.');
        end

        function draw(obj, t_close)
            %% From MG function "DrawDriftingGrating.m"
            while obj.renderer.getTime() < t_close
                % dont do anything
            end
            return;
        end
    end   
end
