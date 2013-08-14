classdef rec_waveform < epworks.id_object
    %
    %   Class:
    %   epworks.history.rec_waveform
    %
    
    properties
       m_parent %Points to: epworks.rec_file
       
       ID
       %    Some of these have identical IDs with triggered_waveform objects.
       %    Not all of them do however.
       
       timestamp
       timestamp_string
       
       d1 = '---- Not sure what these are ... ----'
       stim_amp %Is this correct? Not yet verified ...
       
       %I don't really know what these mean yet. As they change their name
       %will likely change as well ...
       %NOTE: Some of these might not really be u32s, but rather 2 u16s
       word_0
       word_1
       %Observed values:
       %    
       %    0 - most common
       %    1 - occasionally
       %
       word_2 %Always 1?
       bytes   
       word_3 %Appears to be some sort of counter, this may be a reference
       %to the set number
       %Start locations
       word_4
       %Observed values:
       %    0
       word_5
       %Observed values:
       %    0
       %    1
       %    2
       %
       more_words %[1 x 8] 
       %
       %    2) Occasionally a 1 is seen
       %    3) seems to always be intmax('uint32')
       
       data
       d2 = '----  Links  -----'
       triggered_waveform %Might not always be valid ...
    end
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {}
    end
    methods
    end
    
end

