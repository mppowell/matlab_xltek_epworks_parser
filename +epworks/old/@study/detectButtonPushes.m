function detectButtonPushes(obj)

%Goal is to be able to get timestamps that indicate button press
%onsets


%1) unique timestamps
%2) For each unique, get instances
%3) Get delay for instance

%This might not work so well for single pulse tests ...
%Should add on check that makes button pushes occur for each single pulse
%even if the times happen to align with the inter_train_interval, unless
%that value is null already given the single_pulse option

unique_start_times        = obj.unique_trigger_timestamps;
u_indices                 = obj.unique_trigger_timestamp_indices;
representative_trig_index = cellfun(@(x) x(1),u_indices);
tw = obj.triggered_waveforms;

set_numbers = [tw.set_number];

d = diff(unique_start_times);

keyboard


%ts = [
%Trigger Source Mode:
%epworks.type.electrical_stim
%mode: Repetitive Trains
%mode: Repetitive Pulses

%time_until_next

expected_next_times = [tw(representative_trig_index).trigger_delay] + unique_start_times;
expected_next_times(end) = [];
observed_next_times = unique_start_times(2:end);

time_difference = expected_next_times - observed_next_times;

plot(observed_next_times - expected_next_times,'o')