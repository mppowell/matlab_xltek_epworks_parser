classdef electrical < epworks.ep.test.settings.stims
    %
    %   Class:
    %   epworks.ep.test.settings.stims.electrical
    
    properties (Hidden)
       Mode
       Nerve
       Polarity
       Range %Maximum stimulus ampl
    end
    
    properties (Dependent)
       Label %Renaming Nerve as Label
    end
    
    methods
        function value = get.Label(obj)
           value = obj.Nerve; 
        end
    end
    
    properties
        dS = '--  Stimulus Waveform Parameters --'
        InterPulseDuration %only seen 2, I think this is only for repetitive pulses
        NumberOfPhases  %1, monophasic
        PulseDuration   %(Units: ms)
        max_stim_intensity
        dT = '--  Train Parameters --'
        PulsesPerTrain
        
        TrainRate
        d2 = '----  Convenience Settings  ----'
        InitIntensity
        d3 = '-- Unknown Props --'
        second_pulse_intensity
        ConstVoltage    %Logical?, is this  a switch on voltage vs current?
        %Doesn't seem to be. I think you need to look at the electrode for
        %this.
        DeviceType       %-1, only value observed
        Intensity        %0, only value ever observed
        PulseIntensity   %(Units: mA)
        RelaySwitchDelay %0, only value observed
        d4 = '---- Enumerated Props ----'
    end
    
    properties (Dependent)
       mode
       polarity
    end
    
    methods
        function value = get.max_stim_intensity(obj)
           value = obj.Range;
        end
        function value = get.mode(obj)
           value = epworks.enumerations.getStimMode(obj.Mode); 
        end
        function value = get.polarity(obj)
           value = epworks.enumerations.getStimPolarity(obj.Polarity);  
        end
    end
    
end

%{

    '2ndPulseIntensity'
    'ConstVoltage'
    'Delay'
    'DeviceType'
    'ID'
    'InitIntensity'
    'Intensity'
    'InterPulseDuration'
    'Mode'
    'Nerve'
    'NumberOfPhases'
    'PhysName'
    'PhysNum'
    'Polarity'
    'PulseDuration'
    'PulseIntensity'
    'PulsesPerTrain'
    'Range'
    'Rate'
    'RelaySwitchDelay'
    'SwStimId'
    'TrainRate'
    'TriggerToStimLat'
    'Type'

%}