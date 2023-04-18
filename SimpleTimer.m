classdef SimpleTimer < FrameworkObject
%{
    Super basic timer just for tracking and passing time across different things
%}

properties
    t_start
end

methods
    function obj = SimpleTimer()
    end

    function start(obj)
        obj.t_start = GetSecs;
    end

    function finish(obj)
        obj.msgPrinter(sprintf('Total stimulus duration: %s seconds', obj.get()));
    end

    function out = get(obj)
        out = GetSecs - obj.t_start;
    end
end
end