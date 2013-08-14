classdef ep_study < epworks.type
    %
    %   Class:
    %   epworks.type.ep_study
    %
    %   NOTE: I am not sure what the difference is between
    %   this class and the epworks.study class. I am not sure if I am
    %   evening using this class ...
    
    properties
        acquisition_instrument
        acquisition_timezone
        comm_channel_handle
        creation_time
        creator
        duration
        eeg_no_label
        end_time
        iom_ui_version_high
        iom_ui_version_low
        product_version_high
        product_version_low
        is_root
    end
    
    properties
        self_id
        parent_id
    end
    
    properties (Constant,Hidden)
        %Please keep sorted ...
        %sortrows(REQUESTED_VALUES_AND_FUNCTIONS)
        
        REQUESTED_VALUES_AND_FUNCTIONS = {
            'AcquisitionInstrument'    'acquisition_instrument'
            'AcquisitionTimeZone'      'acquisition_timezone'
            'CommChannelHandle'        'comm_channel_handle'
            'CreationTime'             'creation_time'
            'Creator'                  'creator'
            'Duration'                 'duration'
            'EegNoLabel'               'eeg_no_label'
            'EndTime'                  'end_time'
            'IOMUIVersionHigh'         'iom_ui_version_high'
            'IOMUIVersionLow'          'iom_ui_version_low'
            'Id'                       'self_id'
            'IsRoot'                   'is_root'
            'Parent'                   'parent_id'
            'ProductVersionHigh'       'product_version_high'
            'ProductVersionLow'        'product_version_low'
            }
    end
    
%     properties (Constant,Hidden)
%         %***Make sure to update the class name if copying from another class
%         TAGS_TO_GET = epworks.type.ep_study.REQUESTED_VALUES_AND_FUNCTIONS(:,1)';
%         NEW_NAMES   = epworks.type.ep_study.REQUESTED_VALUES_AND_FUNCTIONS(:,2)';
%     end
    
    methods
        function obj = ep_study(parent_obj,prop_names,values)
            obj@epworks.type(parent_obj,prop_names,values);
%             for iProp = 1:length(prop_names)
%                 obj.(prop_names{iProp}) = values{iProp};
%             end
        end
    end
    
end

