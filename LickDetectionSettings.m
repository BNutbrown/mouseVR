function [vr] =  LickDetectionSettings(vr)

% set up daq session. use a counter channel - detects rising edges from lickometer
vr.LickDetection.daqSessLickDetection =  daq.createSession('ni'); 
vr.LickDetection.counterCh = vr.LickDetection.daqSessLickDetection.addCounterInputChannel(vr.devNames{2}, 'ctr1', 'EdgeCount');
resetCounter(vr.LickDetection.counterCh);
vr.LickDetection.count = vr.LickDetection.daqSessLickDetection.inputSingleScan;  % get the current value, to use in the next frame

% init vr struct for licking data
%vr.LickDetection.MinimumTimeDistance = 2; % Seconds (if the voltage is higher than threshold within minimum temporal lag is not stored as additional licking event...
vr.LickDetection.Licking          = 0; % that will increase during recordings
vr.LickDetection.LickEvents       = 0; % that will increase during recordings
vr.LickDetection.LickTimeStamps   = [] ; % that will increase during recordings
vr.LickDetection.LickPositions    = [] ; % that will increase during recordings
vr.LickDetection.VoltageThreshold = 1 ; % the voltage threshold for detection

% ope binary files for writing temp data (noit sure this is necc)
vr.LickDetection.fidLicking = fopen(['VoltageLicking_' vr.SessionTimeStamp '.data'],'w');%creates the file where the behavioural data is stored (better than updating this into the vr structure)...
vr.LickDetection.fidDetection = fopen(['VoltageLickingDetection_' vr.SessionTimeStamp '.data'],'w');%creates the file where the photo sensor is constantly sampled...may be worth using it later on...
