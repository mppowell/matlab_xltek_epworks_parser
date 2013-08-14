classdef ep < epworks.id_object
    %
    %   Class:
    %   epworks.ep
    %
    %   This is inherited by the top level IOM objects which all have
    %   these properties.
    
    %NOTE: This can be hidden or unhidden as necessary.
    properties (Hidden)
        %d5 = '----  Top Level Properties ----'
        Children = uint64([0 0])
        ID
        IsRoot
        Parent   = uint64([0 0])
        Schema
        Type
    end
    

    
end

