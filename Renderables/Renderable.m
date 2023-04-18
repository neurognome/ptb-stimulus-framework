classdef Renderable < FrameworkObject
    properties
        renderer
        description
    end

    methods
        function obj = Renderable()
        end

        function setWindow(obj, window)
            obj.window = window;
        end

        function setRenderer(obj, renderer)
            obj.renderer = renderer;
            obj.initialize();
        end

        function initialize(obj)
            % Initialization happens post renderer injection because we might need parameters from the Renderer
        end

        function out = getIFI(obj)
            out = obj.renderer.getIFI();
        end

        function out = getWindow(obj)
            out = obj.renderer.getWindow();
        end

        function out = getRect(obj, varargin)
            % I don't really like this.. need to think of better ways to pass the IFI/win etc between renderable and renderer       
            out = obj.renderer.getRect(varargin{:});
        end

        function out = getTime(obj)
            out = obj.renderer.getTime();
        end

        function draw(obj, tclose)
        end
    end
end
