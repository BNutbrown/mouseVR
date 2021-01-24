% %% VR behaviour analysis
%  % clean & organise behaviour data
%  
%  
%  %% TODO
% %mouse by mouse and pool mice 
% 
% %% define paths
% % select the master folder
% % vrFolder = uigetdir('', 'Select the main experiment folder');
% % if vrFolder == 0
% %     disp('Cancelled')
% %     return
% % end
% % 
% % disp(vrFolder)
% % 
% % %% make output folder
% % make a results folder
% % saveDir = [vrFolder filesep 'VR_analysis'];
% % if ~exist(saveDir, 'dir')
% %     mkdir(saveDir)
% % end
% % 
% % disp(saveDir)
% 
% 
% %% for now 
% % load('M:\bnutbrown\behaviour_backup\LinearTrack\RN179\20191007\Mouse_RN179_20191007_Session_1.mat')
% 
% %% preallocate 
% 
% timestamps     = Data.pos.ts;
% % break into trials
% numTrials      = (Data.vr.TrialSettings.iTrial)-1; % -1 because last trial is always partial ie when stop the VR
% position       = cell(numTrials,1);
% licks          = cell(numTrials,1);
% velocity       = cell(numTrials,1);
% acceleration   = cell(numTrials,1);
% stops          = cell(numTrials,1);
% correct        = false(numTrials,1); % ie blackout
% incorrect      = false(numTrials,1); % ie whiteout 
% licked         = zeros(numTrials,1);
% % lickTimes_trials = 
% speed = Data.pos.speed;
% rewards = (Data.vr.RewardDelivery.TimeStamps);
% lickTimes      = Data.vr.LickDetection.LickTimeStamps;
% lickPositions  = Data.vr.LickDetection.LickPositions;
% rewardTimes    = Data.vr.RewardDelivery.TimeStamps;
% blackoutTimes  = Data.vr.BlackoutTimeOnset;
% whiteoutTimes  = Data.vr.WhiteoutTimeOnset;
% trials         = Data.pos.Trial;
% %% split by trial
% temp_length = size(speed);
% 
% [C,trialStart_idx] = unique(Data.pos.Trial); %frame when trial X started
% [C,trialStop_idx]  = unique(Data.pos.Trial, 'last');%frame when trial X stopped
% 
% for i = 1:numTrials
%     position {i}     = Data.pos.pos(trialStart_idx(i):trialStop_idx(i)); %position for each trial as a new row
%     speed_trials{i}  = Data.pos.speed(trialStart_idx(i):trialStop_idx(i));
%      velocity{i}     = gradient(position{i});
%      stops{i}        = find(acceleration{i} < -0.3);
%      acceleration{i} = gradient(speed_trials{i});
% end
% 
% %% licks & lick positions per trial
% round(lickTimes);
% trialtimes_secs            = cell(numTrials,1);
% 
% for i = 1:numTrials
%     trialtimes_secs{i}     = Data.pos.ts(trialStart_idx(i):trialStop_idx(i));
%     
%     %take the first and last nums within each cell and find lick time stamps within those values
%     thisTrialStart_sec (i) = trialtimes_secs{i}(1);
%     thisTrialEnd_sec (i)   =  trialtimes_secs{i}(end);
%     theseTrialLicks    = lickTimes(lickTimes >= thisTrialStart_sec(i)  & lickTimes <= thisTrialEnd_sec(i));
%     trialLicks_time{i} = theseTrialLicks;
%     trialLicks_pos{i}  = lickPositions(lickTimes >= thisTrialStart_sec(i)  & lickTimes <= thisTrialEnd_sec(i));
% end 
% 
%   %% find correct & incorrect trials
%    blackoutTimes =   blackoutTimes'; % do i need this 
%    trial_outcome = zeros(numTrials,1);
%    
%    for i = 1:numTrials
%        if any( (blackoutTimes <= thisTrialEnd_sec(i)) & (blackoutTimes > thisTrialStart_sec(i)))
%            trial_outcome(i) = 1; %correct is 0?
%        end
%    end 
%     
%    correctTrial_count  = sum(trial_outcome);
%    incorrectTrial_count = numTrials-correctTrial_count;
%    %use to index into other trial strcutures 
% 
% 
%          
% %% trial wise matrix (ie not cell array)
% 
% longestTrial = max(cellfun(@numel, position));
% 
% position_AllTrials     = nan(numTrials, longestTrial);
% velocity_AllTrials     = nan(numTrials, longestTrial);
% acceleration_AllTrials = nan(numTrials, longestTrial);
% licksPos_AllTrials     = nan(numTrials, longestTrial);
% 
% for i = 1:numTrials
%     position_AllTrials(i,1:numel(position{i})) = position{i};
%     velocity_AllTrials(i,1:numel(velocity{i})) = velocity{i};
%     acceleration_AllTrials(i,1:numel(acceleration{i})) = acceleration{i};
%     licksPos_AllTrials(i,1:numel(trialLicks_pos{i})) = trialLicks_pos{i};
% %     
% %     position_AllTrials_EndAligned(i,end-numel(position{i})+1:end) = position{i};
% %     velocity_AllTrials_EndAligned(i,end-numel(velocity{i})+1:end) = velocity{i};
% %     acceleration_AllTrials_EndAligned(i,end-numel(acceleration{i})+1:end) = acceleration{i};
% end
% 
% %% binning behaviour data
% 
% trackBinFactor = 5;
% minPos  = round(min(Data.pos.pos));  % -2?
% maxPos  = 530;  % 177.9160
% nBins   = ceil((maxPos-minPos)/trackBinFactor);
% binSize = (maxPos-minPos) / nBins;
% edges   = minPos:binSize:maxPos;
% edges   = edges(1:end-1);
% 
% % occupancy in bins 
% binnedPosition_AllTrials = discretize(position_AllTrials, edges);
% occupancy_AllTrials      = hist(position_AllTrials', edges)';  % in number of samples?
% 
% BinnedPosIdx = {};
% for i = 1:numTrials
%     for j = 1:nBins
%         indices = find(binnedPosition_AllTrials(i,:)==j);
%         BinnedPosIdx{i,j} = indices;
%     end
% end
% 
% 
% % count licks in bins 
% [N, edges ]= histcounts(licksPos_AllTrials, nBins);
% lickCount = sum(N);
% 
%  
% %% occupancy normalised licks 
% 
% % occupancy_noralised_licks_position = licks_position ./ occupancy_AllTrials;
% 
% 
% %% <plotting behaviour>
% rewardzone = Data.vr.Rzone(1);
% total_numrewards = size(Data.vr.RewardDelivery.TimeStamps,1);
% 
% % plot lick histogram
% figure; %('position',[100 100 1000 1000]) 
% 
% subplot(4,3,1:3) %'DisplayStyle','stairs',
% hist(licksPos_AllTrials, nBins ) %'EdgeColor','color', [0.960000 0.760000 0.760000]);
% box off
% txt = ['Total lick count: ', num2str(lickCount) ' Licks'];
% text(4,400,txt) % x y coords for the text in axis
% txt2 = ['reward zone'];
% text(Data.vr.Rzone(10),400,txt2) % x y coords for the text in axis
% rec= rectangle('position',[rewardzone 0 30 max(N)+4], 'linestyle','none', 'facecolor',[.9 .9 .9]); % position = x y height width
% uistack (rec, 'bottom');
% xlabel(['Binned position', ' Bin size =', num2str(binSize)])
% ylabel('Lick count')
% title(['Behavioural data: ' num2str(Data.vr.RatName) ' Total trials = ' num2str(numTrials), ' Correct trials = '  num2str(correctTrial_count) ' Total rewards = ' num2str(total_numrewards)])
% 
% %% position example with licking and rewards overlayed
% 
% pos_trial = Data.pos.pos;
% subplot(4,3,7:9)
% 
% plot(timestamps,pos_trial./max(pos_trial), 'color',[0.6 0.6 0.6], 'linewidth',2)
% ylim([0 1.3])
% txt = ['Correct trials'];
% text(4,400,txt) % HERE change the x y coords for the text in axis
% txt = ['Incorrect trials'];
% text(2,400,txt) % 
% box off
% xlabel('time (seconds)')
% ylabel('Virtual track position (cm)')
% hold on
% idx = find (trial_outcome ==1);
% ylim([0 1])
% % incorrect trials
% for i = 1:numel(idx)
%  plot([thisTrialEnd_sec(idx(i)) thisTrialEnd_sec(idx(i))], [0 1], 'color',[0.470000 0.870000 0.470000])
% end 
% % correct trials
% idx = find (trial_outcome == 0);
% for i = 1:numel(idx)
%  plot([thisTrialEnd_sec(idx(i)) thisTrialEnd_sec(idx(i))], [0 1], 'color',[1 0 0.5])
% end 
% 
% ylim([0 1.2])
% plot (rewards,ones(size(rewards))*1.1, 'o', 'color',[0.630000 0.790000 0.950000], 'LineWidth', 2)
% hold on 
% plot(lickTimes, ones(size(lickTimes))*1.1, 'k.')
% 
%     
% %% speed plot
% minSpeedThresh = 5;
% 
% subplot(4,3,4:6)
% %plot(timestamps, movmean(speed,20)', 'color',[0.6 0.6 0.6])
% hold on
% plot([1 max(timestamps)], [minSpeedThresh minSpeedThresh], 'color' , colors('violet'), 'linewidth',1)
% ylabel('averaged speed')
% xlabel ('time (s)')
% txt = ['Min speed threshold: ', num2str(minSpeedThresh) ' cm/s'];
% text(2450,5,txt) % x y coords for the text in axis
% box off
% ylim([0 40])
% 
% 
% % trials and filter
% subplot(4,3,10)
% meanTrajectory = nanmean(position_AllTrials);
% axis square
% hold on
% set(gca,'TickLength',[0.1, 0.01])
% plot(position_AllTrials', '-', 'color',[.8 .8 .8])
% hold on
% idx = find (trial_outcome == 0);
% for i = 1:numel(idx)
% plot (position_AllTrials(idx(i),:)', '-', 'color',colors('brilliant rose')) % plot incorrect trials in dif colour
% end 
% hold on
% % mean trajectory
% plot(meanTrajectory, 'k', 'LineWidth',3)
% xlabel('Time (s)')
% ylabel('VR position (cm)')
% ylim([0 550])
% title('All trials')
% 
% %% Cleaned up, stiched (remove slow) and remove incorrect
% % to do remove slow parts and stitch together 
% subplot(4,3,11)
% 
% axis square
% hold on
% idx = find (trial_outcome == 1);% dont plot incorrect trials
% for i = 1:numel(idx)
%     plot (position_AllTrials(idx(i),:)', '-', 'color',colors('pastel green')) % plot incorrect trials in dif colour
%     hold on
%     plot(nanmean(position_AllTrials(idx(i),:))', '-', 'color',colors('salmon')) 
% end
% hold on
% xlabel('time (s)')
% ylabel('VR position')
% title('Filtered trials')
% ylim([0 550])
% 
% %%
% 
% %% rewards
% % reward times per trial
% 
% rewards_timestamps  = (Data.vr.RewardDelivery.TimeStamps); %seconds 
% for i = 1:numTrials
% 
%     theseTrialRewards    = rewards_timestamps(rewards_timestamps >= thisTrialStart_sec(i)  & rewards_timestamps <= thisTrialEnd_sec(i));
%     trialRewards_time{i} = theseTrialRewards;
% end 
% %% plotting rewards
% manual = sum( diff(rewards) <30); % ie dif between rewards is small so must have been manually delivered
% actual_rewards = numel( rewards)-manual;
% 
% subplot (3,4,12)
% bar (2, manual, 'FaceColor', 'w',  'EdgeColor', [1.000000 0.750000 0.000000], 'LineWidth', 2 )
% title (['manual rewards = ' num2str(manual) ' actual rewards =' num2str(correctTrial_count)])
% box off
% axis square
% hold on
% bar (1, actual_rewards, 'FaceColor', 'w',  'EdgeColor', [0.600000 0.400000 0.800000], 'LineWidth', 2 )
% xlabel('reward type')
% ylabel ('count')
% 
% somenames={'manual', 'manual' };
% 
% set(gca,'xticklabel',somenames)
%   
% %% Save figures
% 
% TitleFig = [ Data.vr.RatName(1:end-1) '_' Data.vr.Day(1:end-1) '_VR_' Data.vr.Experiment '_Session_' Data.vr.Session(1:end-1) ] ;
% saveas(gcf,TitleFig,'pdf');
% savefig(gcf,TitleFig );
% 
% 
% 
% 
