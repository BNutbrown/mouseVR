function [ vr ] = InitialiseDAQFrameTTL( vr )
vr.frameflip = 0;

daqreset

if strcmpi(vr.ComputerName, 'WINDOWS-9AEMBGN')  % the rig pc
    vr.daqframeTTL.daqSessFrame = 0;
    vr.daqframeTTL.AddCh = 0;
    
else
    vr.daqframeTTL.daqSessFrame     = daq.createSession('ni'); % opens the session...
    vr.daqframeTTL.AddCh            = addDigitalChannel(vr.daqframeTTL.daqSessFrame,vr.devNames{4},'Port0/Line0','OutputOnly');
    % vr.daqframeTTL.AddCh            = addDigitalChannel(vr.daqframeTTL.daqSessFrame,vr.devNames{4},'Port1/Line0','OutputOnly');
end