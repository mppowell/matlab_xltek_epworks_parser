classdef dat_entries < epworks.id_object
    %
    %   Class:
    %   epworks.history.dat_entries
    
    
%     sdata   %[1 x n_segs], structure array
%             mainID: [5372221655656442148 10840506685521778867] ??? What
%                     are these? They might be useful in linking the .REC
%                     ids to something else. These are trace IDs
%                  n: 100
%                IDs: [100x4 uint32]
%                u32: [100x1 uint32] <- I'm not sure what this represents yet
%         timestamps: [100x1 double]
    
    properties (Hidden)
       %This is currently needed to make epworks.id_object work
       ID = uint64([0 0]) 
    end

    properties
       TraceID    %
       n          
       
       %NOTE: Apparently these are not always populated, 'n' can be 0
       IDs        %[n x 2], uint64
       u32        %[n x 1] I'm not sure what these represent yet
       timestamps %[n x 1] Values are in Matlab time format.
       d1 = '----  Pointers to Other Objects  ----'
       trace
    end
    
    %NOTE: I don't have suppport yet for resolving an array of values
    %so IDs is not resolved to objects
    
    properties (Constant,Hidden)
        ID_PROP_INFO_1 = {
            'TraceID' 'trace'}
    end
    
    methods
    end
    
end

