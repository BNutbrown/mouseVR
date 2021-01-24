function [ vr ] = InitialiseDAQStimTTL( vr )
if strcmpi(vr.ComputerName, 'WINDOWS-9AEMBGN')
    % this is the rig pc... so offload the daq output to python
    vr.daqstimTTL.daqSessStim      = 0; % opens the session...
    vr.daqstimTTL.AddCh            = 0; %is this correct
    vr.daqstimTTL.TTLPeak          = 0;
    vr.daqstimTTL.TTLDuration      = 0;
    vr.daqstimTTL.TTLSignal        = 0;
    vr.daqstimTTL.TTLSignal(end+1) = 0;
    
    % for saving
    vr.daqstimTTL.Positions  = [];
    vr.daqstimTTL.TimeStamps = [] ;
    vr.daqstimTTL.NumStims   = 0; % increases during the reccording
        
else  % the training boxes
    
    % add digital channel to prepare to send TTL pulse
    vr.daqstimTTL.daqSessStim = daq.createSession('ni'); % opens the session...
    vr.daqstimTTL.AddCh       = addAnalogOutputChannel(vr.daqstimTTL.daqSessStim, vr.devNames{5}, 'ao1','Voltage'); %is this correct
    
    % make the ttl pulse
    vr.daqstimTTL.TTLPeak          = 5; %peak voltage;
    vr.daqstimTTL.TTLDuration      = 5; %ms, how long to keep it on?
    vr.daqstimTTL.TTLSignal        = repmat(vr.daqstimTTL.TTLPeak,1,vr.daqstimTTL.TTLDuration); % creates the TTL
    vr.daqstimTTL.TTLSignal(end+1) = 0; % adds one more data point and sets it to 0...
    
    
    %empty and set some stuff for saving
    vr.daqstimTTL.Positions  = [];
    vr.daqstimTTL.TimeStamps = [] ;
    vr.daqstimTTL.NumStims   = 0; % increases during the reccording
end
