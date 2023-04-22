classdef Generator < handle
    
    properties
        output
    end
    
    properties (Hidden)
        defaults
    end
    
    methods
        function obj = Generator(varargin)
            obj.store_defaults();
            if isempty(varargin)
                obj.report();
            else
                obj.parse_inputs(varargin{:});
            end
        end
        
        function out = get.output(obj)
            for n = obj.get_parameters()
                out.(n{:}) = obj.(n{:});
            end
        end
        
        function report(obj)
            fprintf('Available parameters: \n')
            for n = obj.get_parameters()
                fprintf('\t%s: %s (default: %s)\n', n{:}, num2str(obj.(n{:})), num2str(obj.defaults.(n{:})));
            end
        end
        
        function store_defaults(obj)
            for n = obj.get_parameters()
                obj.defaults.(n{:}) = obj.(n{:});
            end
        end
        
        function out = get_parameters(obj)
            % must be a better way...
            all_properties = properties(obj);
            mc = metaclass(obj);
            ii = 1;
            is_bad = false(1, length(all_properties));
            for p = mc.PropertyList'
                if strcmp(p.DefiningClass.Name, 'Generator')
                    is_bad(ii) = true;
                end
                ii = ii + 1;
            end
            out = all_properties(~is_bad)';
        end
        
        function parse_inputs(obj, varargin)
            p = inputParser;
            
            for n = properties(obj)'
                p.addParameter(n{:}, obj.(n{:})); % validation?
            end
            p.parse(varargin{:});
            
            % update properties
            for f = fieldnames(p.Results)'
                obj.(f{:}) = p.Results.(f{:});
            end
        end
    end
end