function [vr] =  RewardDeliverySettings(vr)

vr = SetRewardDelivery(vr);
vr.RewardDelivery.fidLicking = fopen(['Reward_' vr.SessionTimeStamp '.data'],'w');%creates the file where the behavioural data is stored (better than updating this into the vr structure)...
vr.RewardDelivery.RewardLog  = zeros(vr.TrialSettings.MaxNumerTrials,numel(vr.EnvironmentSettings.LabelEnvironment));  % that will increase during recordings for each world that a reward was given....

if isfield(vr.worlds{1,1}.objects.indices,'GoalCue');
    vr.NumberOfCues = numel(vr.exper.worlds{vr.WorldIndexWithReward}.objects{vr.worlds{vr.WorldIndexWithReward}.objects.indices.GoalCue}.x);
else
    vr.NumberOfCues =  1;
end

vr.RewardDelivery.GoalCueLog = zeros(vr.TrialSettings.MaxNumerTrials,vr.NumberOfCues,vr.NumberOfTimesRewardEnvironmentPresented) ;  % that will increase during recordings, only for the cue areas...
vr.RewardDelivery.Positions  = [];
vr.RewardDelivery.TimeStamps = [] ;
vr.RewardDelivery.ManualReward = [] ;
vr.RewardDelivery.NumRewards = 0; % that will increase during recordings this is oing to inc manual...
vr.RewardDelivery.MinimumTimeDistance = [1];% seconds...

