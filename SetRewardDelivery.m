function [ vr ] = SetRewardDelivery( vr )
% Useful after daqreset...
if isfield(vr,'RewardDelivery')
    delete(vr.RewardDelivery.daqSessRewardDelivery);
end

if strcmpi(vr.ComputerName, 'WINDOWS-9AEMBGN')  % the rig pc
    vr.RewardDelivery.daqSessRewardDelivery = 0; 
    vr.RewardDelivery.rewardCh              = 0;
    vr.RewardDelivery.TTLPeak               = 0; %peak voltage;
    vr.RewardDelivery.TTLDuration           = 0;  % in 1 ms unit, if 50 means 50 ms...
    vr.RewardDelivery.TTLSignal             = 0; % creates the TTL
    vr.RewardDelivery.TTLSignal(end+1)      = 0; % adds one more data point and sets it to 0...

else
    vr.RewardDelivery.daqSessRewardDelivery = daq.createSession('ni'); 
    % vr.RewardDelivery.Channel = 0 ;
    vr.RewardDelivery.rewardCh = addAnalogOutputChannel(vr.RewardDelivery.daqSessRewardDelivery, vr.devNames{3}, 0, 'Voltage');
    % vr.RewardDelivery.daqSessRewardDelivery.IsContinuous = true;

    % vr.RewardDelivery.daqSess.Rate = 1000;
    % vr.RewardDelivery.daqSessRewardDelivery = analogoutput('nidaq', 'Dev1'); % the AO number
    % addchannel(vr.RewardDelivery.daqSessRewardDelivery, [vr.RewardDelivery.Channel] , {'RewardChannel1'});%,'voltage'); % added channel1
    % set(vr.RewardDelivery.daqSessRewardDelivery,'samplerate',1000);
    vr.RewardDelivery.TTLPeak     = 5; %peak voltage;
    vr.RewardDelivery.TTLDuration = [str2double(vr.BehaviourInfo.Answers{find(strcmp(vr.BehaviourInfo.Prompt, 'Valve Open for (ms):'))}) ];  % in 1 ms unit, if 50 means 50 ms...
    vr.RewardDelivery.TTLSignal   = [repmat(vr.RewardDelivery.TTLPeak,1,vr.RewardDelivery.TTLDuration)]; % creates the TTL
    vr.RewardDelivery.TTLSignal(end+1) = [0]; % adds one more data point and sets it to 0...
end
