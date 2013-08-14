classdef ochans < epworks.type
    %
    %   Class:
    %       epworks.type.ochans

    %What is an ochan? output channel?
    %These point to 
    
    properties
        name

        lff_cutoff
        hff_cutoff
        notch_cutoff
        
        is_channel_enabled
        is_channel_trigger
        is_rejection_on_stim_saturation

        group        %Class: epworks.type.groupdef
        to_id
    end
    
    properties (Hidden)
       self_id
    end
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'GroupDef'                       'group'
            'HffCutoff'                      'hff_cutoff'
            'ID'                             'self_id'
            'IsChannelEnabled'               'is_channel_enabled'
            'IsChannelTrigger'               'is_channel_trigger'
            'IsRejectionOnStimSaturation'    'is_rejection_on_stim_saturation'
            'LffCutoff'                      'lff_cutoff'
            'Name'                           'name'
            'NotchCutoff'                    'notch_cutoff'
            'To'                             'to_id'
            }
       SELF_ID   = 'self_id'
       OTHER_IDS = {'group' 'to_id'} %NONE 
    end
    
%     properties (Constant,Hidden)
%         TAGS_TO_GET = epworks.type.ochans.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.ochans.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    methods
        function obj = ochans(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
    end
    
end

