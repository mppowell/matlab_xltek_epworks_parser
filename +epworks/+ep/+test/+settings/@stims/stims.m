classdef stims < epworks.id_object
    %
    %   Class:
    %   epworks.ep.test.settings.stims
    
    properties (Hidden)
       Delay 
    end
    
    properties
        d5 = '-----  Properties for all stim types  -----'
        stim_delay %Delay from main sync pulse
        ID
        PhysName
        PhysNum
        Rate %
        %for electrical: (Units: Hz)
        %
        SwStimId
        TriggerToStimLat
        Type
    end
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {}
    end
    
    methods (Static)
        function objs = initializeStimObjects(roa,array_indices)
            %
            %
            %   objs = epworks.ep.test.settings.stims.initializeStimObjects(all_objects,children_indices)
            
            %At this point our children indices point to array elements
            %For each of these, we need to get the children, find the type
            %element, and then assign based on that element
            
            n_array = length(array_indices);
            objs = cell(1,n_array);
            
            for iArray = 1:n_array
               cur_array_index  = array_indices(iArray); 
               children_indices = roa.children_indices{cur_array_index};
               child_names = roa.name(children_indices);
              
               %Hack, look away :/
               %This should really be specified in the csv file
               child_names(strcmp(child_names,'2ndPulseIntensity')) = {'second_pulse_intensity'};
               
               
               child_data  = roa.data_value(children_indices);
               I = find(strcmp(child_names,'Type'),1);
               type_value = child_data{I};
               switch type_value
                   case 'Auditory'
                       temp_obj = epworks.ep.test.settings.stims.auditory;
                   case 'Visual'
                       temp_obj = epworks.ep.test.settings.stims.visual;
                   case 'External'
                       temp_obj = epworks.ep.test.settings.stims.external;
                   case 'TceMEP'
                       temp_obj = epworks.ep.test.settings.stims.tcemep;
                   case 'Electrical'
                       temp_obj = epworks.ep.test.settings.stims.electrical;
                   otherwise
                       error('Unrecognized stimulus type')
               end
               
               for iChild = 1:length(children_indices)
                  cur_child_prop = child_names{iChild};
                  data_value = child_data{iChild};
                  if ~isempty(data_value)
                    temp_obj.(cur_child_prop) = data_value;
                  end
               end
               
               objs{iArray} = temp_obj;
            end
            
            
            %NOTE: We'll pass out a cell array, later we'll
            %need to go in and fix this ...
            
            
%             
%             
%             
%             
%             
            
        end
    end
    
end

%{
'EPTest.Data.Settings.Stims'
'EPTest.Data.Settings.Stims.000'
'EPTest.Data.Settings.Stims.000.2ndPulseIntensity'
'EPTest.Data.Settings.Stims.000.AudStimOutput'
'EPTest.Data.Settings.Stims.000.AudioOnset'
'EPTest.Data.Settings.Stims.000.AudioRamp'
'EPTest.Data.Settings.Stims.000.Colour'
'EPTest.Data.Settings.Stims.000.ConstVoltage'
'EPTest.Data.Settings.Stims.000.ContraMode'
'EPTest.Data.Settings.Stims.000.Delay'
'EPTest.Data.Settings.Stims.000.DeviceType'
'EPTest.Data.Settings.Stims.000.Divisions'
'EPTest.Data.Settings.Stims.000.ID'
'EPTest.Data.Settings.Stims.000.InitIntensity'
'EPTest.Data.Settings.Stims.000.Intensity'
'EPTest.Data.Settings.Stims.000.InterPulseDuration'
'EPTest.Data.Settings.Stims.000.IpsiMode'
'EPTest.Data.Settings.Stims.000.IsActiveHigh'
'EPTest.Data.Settings.Stims.000.IsOutput'
'EPTest.Data.Settings.Stims.000.Location'
'EPTest.Data.Settings.Stims.000.MaskIntensity'
'EPTest.Data.Settings.Stims.000.Mode'
'EPTest.Data.Settings.Stims.000.Nerve'
'EPTest.Data.Settings.Stims.000.NumberOfPhases'
'EPTest.Data.Settings.Stims.000.OnTimeline'
'EPTest.Data.Settings.Stims.000.PhysName'
'EPTest.Data.Settings.Stims.000.PhysNum'
'EPTest.Data.Settings.Stims.000.Polarity'
'EPTest.Data.Settings.Stims.000.PrimingGap'
'EPTest.Data.Settings.Stims.000.PrimingPulses'
'EPTest.Data.Settings.Stims.000.PulseDuration'
'EPTest.Data.Settings.Stims.000.PulseIntensity'
'EPTest.Data.Settings.Stims.000.PulsesPerTrain'
'EPTest.Data.Settings.Stims.000.Range'
'EPTest.Data.Settings.Stims.000.Rate'
'EPTest.Data.Settings.Stims.000.RelayPort'
'EPTest.Data.Settings.Stims.000.RelaySwitchDelay'
'EPTest.Data.Settings.Stims.000.SwStimId'
'EPTest.Data.Settings.Stims.000.TrainRate'
'EPTest.Data.Settings.Stims.000.TriggerToStimLat'
'EPTest.Data.Settings.Stims.000.Type'
'EPTest.Data.Settings.Stims.000.VisualField'
'EPTest.Data.Settings.Stims.000.VisualFlash'
'EPTest.Data.Settings.Stims.000.VisualStimOutput'
'EPTest.Data.Settings.Stims.000.VisualTrigger'
%}