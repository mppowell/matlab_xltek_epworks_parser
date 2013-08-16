classdef enumerations
    %
    %   Class:
    %   epworks.enumerations
    
    properties
    end
    
    methods (Static)
        
        function value = getStimgetStimPolarity(value_in)
            %
            %   value = epworks.enumerations.getStimMode(value_in)
           VALUES = [1 -1];
           value  = VALUES(value_in+1);
        end
        function value = getStimMode(value_in)
            %
            %   value = epworks.enumerations.getStimMode(value_in)
           VALUES = {'Repetitive Pulses' 'Single Pulse' 'Repetitive Trains' 'Single Train'};
           value  = VALUES{value_in+1};
        end
        function value = getGroupSignalType(value_in)
           %
           %    value = epworks.enumerations.getGroupSignalType(value_in)
           
           VALUES = {'Free Run' 'Triggered' '??? Unknown Type' 'Averaged'};
           value  = VALUES{value_in+1};
        end
        function value = getGroupDisplayMode(value_in)
           %I'm not sure about these yet
           %    value = epworks.enumerations.getGroupDisplayMode(value_in)
           
           if value_in(2) ~= 1
               fprintf(2,'WARNING: unexepected value for 2nd value of display mode, see epworks.enumerations\n');
           end
           
           try
              VALUES   = {'Vertical Curve Stack' '??? Unknown Type' 'Overlay' 'Replace'};
              bits     = bitget(value_in(1),1:8);
              value    = VALUES{find(bits,1)};
           catch ME
              value = 'ERROR: Unknown display mode value'; 
           end
           
        end
    end
    
end

