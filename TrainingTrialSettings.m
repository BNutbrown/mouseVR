function [vr ] = TrainingTrialSettings(vr)
%% Specify a bunch of props such number of trials ecc...
vr.TrialSettings.movementFunctionAfterPause = vr.exper.movementFunction;
vr.exper.movementFunction = vr.TrialSettings.movementFunctionAfterPause;
%vr.experimentEnded= ~strcmp(vr.exper.worlds{vr.currentWorld}.name,'FirstIntermediatePipe');
vr.TrialSettings.MaxNumerTrials = str2double(vr.TrialInfo.Answers{find(strcmp(vr.TrialInfo.Prompt,'Max Number of Trials:'))}) ;;           %sets the number of trials...
vr.TrialSettings.iTrial =0 ;                  %is updated everytime is teletransported back at the pos = 0;
vr.TrialSettings.iTrialBO =0 ; %ending the trial for BO
%vr.TrialSettings.InterTrialStopMean = 5;      %pause lenght in time...
%vr.TrialSettings.InterTrialStopSigma = .1;    %pause lenght in time...
%vr.TrialSettings.InterTrialStop = normrnd(vr.TrialSettings.InterTrialStopMean,vr.TrialSettings.InterTrialStopSigma,vr.TrialSettings.MaxNumerTrials ,1); % in seconds...
vr.TimeStampsAcrossTrials =[];  %every time a new trial is begun the time stamp of it is stored
vr.RewardMovementOnset = str2double(vr.BehaviourInfo.Answers{find(strcmp(vr.BehaviourInfo.Prompt,'Reward Speed onset:' ))}) ;    %Reward where the speed onset occurs...
vr.RewardMovementSpeedThreshold = 4;    %Minimum speed to elicit reward...
vr.MaxNumberRewardsPerTrial = 50;
vr.MaxTrialLength = str2double(vr.TrialInfo.Answers{find(strcmp(vr.TrialInfo.Prompt,'Max Trial Length (min):'))}) ;


%% Beckie EXTRAS: (put in text boxes) maybe blackout should start one 1
% set to not in blackout
vr.blackout = 0;
vr.whiteout = 0;
vr.blackoutduration = 5;
vr.whiteoutduration = 5;
vr.RewardDel =[];
vr.WhiteoutTimeOnset = [];
vr.WhiteoutPosOnset  = [];
vr.BlackoutTimeOnset = [];
vr.BlackoutPosOnset  = [];
vr.reward=[];
vr.Rewardduration = 1;
vr.rewarddel=0;
vr.RzoneEntrytime = [];


end