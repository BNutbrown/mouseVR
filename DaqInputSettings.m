function [ vr ] = DaqInputSettings( vr )

% rotary encoder 
vr.daqInputSess = daq.createSession('ni'); % opens the session...
vr.RotaryEncoder.counterCh = vr.daqInputSess.addCounterInputChannel(vr.devNames{1}, 'ctr0', 'Position');
vr.RotaryEncoder.counterCh.EncoderType = 'X4';%it was X4 from TW...
vr.GainManipulation.Value = 1;
resetCounter( vr.RotaryEncoder.counterCh );

% licking
% set up daq session. use a counter channel - detects rising edges from lickometer
vr.LickDetection.counterCh = vr.daqInputSess.addCounterInputChannel(vr.devNames{2}, 'ctr1', 'EdgeCount');
resetCounter(vr.LickDetection.counterCh);

% init vr struct for licking data
vr.LickDetection.Licking          = 0; % that will increase during recordings
vr.LickDetection.LickEvents       = 0; % that will increase during recordings
vr.LickDetection.LickTimeStamps   = [] ; % that will increase during recordings
vr.LickDetection.LickPositions    = [] ; % that will increase during recordings
vr.LickDetection.VoltageThreshold = 1 ; % the voltage threshold for detection

% open binary files for writing temp data (noit sure this is necc)
vr.LickDetection.fidLicking   = fopen(['VoltageLicking_' vr.SessionTimeStamp '.data'],'w');%creates the file where the behavioural data is stored (better than updating this into the vr structure)...
vr.LickDetection.fidDetection = fopen(['VoltageLickingDetection_' vr.SessionTimeStamp '.data'],'w');%creates the file where the photo sensor is constantly sampled...may be worth using it later on...

% store current values
data = vr.daqInputSess.inputSingleScan;
vr.RotaryEncoder.count     = data(1);
vr.RotaryEncoder.currCount = data(1);
vr.LickDetection.count     = data(2);  % prev frame
vr.LickDetection.currCount = data(2);  % 'this' frame
