function vr = TriggerStimTTL(vr)
% deliver the VR trigger eith via TCP or directly
if strcmpi(vr.ComputerName, 'WINDOWS-9AEMBGN')
    fwrite(vr.tcp.t, vr.tcp.STIM)
else
    if ~vr.daqstimTTL.daqSessStim.IsRunning
        queueOutputData( vr.daqstimTTL.daqSessStim, vr.daqstimTTL.TTLSignal' );
        vr.daqstimTTL.daqSessStim.startBackground();
    else
        disp('--- ERROR')
    end
end

%% Log Stim data...
% fwrite(vr.daqstimTTL.StimTTL, [vr.timeElapsed vr.pos], 'double');
vr.daqstimTTL.NumStims   = vr.daqstimTTL.NumStims + 1;
vr.daqstimTTL.TimeStamps = [vr.daqstimTTL.TimeStamps; vr.timeElapsed];
vr.daqstimTTL.Positions  = [vr.daqstimTTL.Positions; vr.pos];
