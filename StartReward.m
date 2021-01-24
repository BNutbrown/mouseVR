function vr = StartReward(vr)

% Play sound through speaker
PlaySound(500, 0.2);
% sound(vr.sound_reward, vr.sound_reward_fs)


% deliver the reward, either via TCP or directly
if strcmpi(vr.ComputerName, 'WINDOWS-9AEMBGN')
    fwrite(vr.tcp.t, vr.tcp.REWARD)
else
    if ~vr.RewardDelivery.daqSessRewardDelivery.IsRunning
        queueOutputData( vr.RewardDelivery.daqSessRewardDelivery, vr.RewardDelivery.TTLSignal' );
        vr.RewardDelivery.daqSessRewardDelivery.startBackground();
    else
        disp('--- still doing the last one mate')
    end
end
disp('--- REWARD')


% Log reward data...
fwrite(vr.RewardDelivery.fidLicking, [vr.timeElapsed vr.pos], 'double');
vr.RewardDelivery.NumRewards    = vr.RewardDelivery.NumRewards + 1;
vr.RewardDelivery.TimeStamps    = [vr.RewardDelivery.TimeStamps; vr.timeElapsed];
vr.RewardDelivery.Positions     = [vr.RewardDelivery.Positions; vr.pos];
vr.RewardDelivery.ManualReward  = [vr.RewardDelivery.ManualReward; vr.ManualReward];

