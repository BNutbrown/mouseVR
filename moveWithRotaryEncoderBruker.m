function vr = moveWithRotaryEncoderBruker(vr)

% Read data from NIDAQ
data = vr.daqInputSess.inputSingleScan;
vr.RotaryEncoder.currCount = data(1);
vr.LickDetection.currCount = data(2);
thisFrameEncoderCount = vr.RotaryEncoder.currCount - vr.RotaryEncoder.count;

% Remove NaN's from the data (these occur after NIDAQ has stopped)
if isnan(thisFrameEncoderCount)
    thisFrameEncoderCount = 0;
end

% Need to control for wheel going backwards (means counts go backwards from 2^32) %
if thisFrameEncoderCount >= 1024;
    thisFrameEncoderCount = thisFrameEncoderCount - 2^32;
end
if thisFrameEncoderCount <= -1024;
    thisFrameEncoderCount = thisFrameEncoderCount + 2^32;
end

% Convert to actual position offset 
% 4096 counts per cycle in a Kubler 05.2400.1122.1024 when used in 'X4' mode;
% wheel circumference wass 55.3cm (for nominal dia 7 inch) in TW settings
% but measured in GC is 62.8 (10 cm is the radius of the wheel...).
% 1 virmen unit = 1cm @ vr.movementGain = 1.  
pOff = (thisFrameEncoderCount/4096) * 16 * pi;  %Bruker 2 wheel diameter = 16cm... 16*pi =50.265

% adjust by gain value
pOff = pOff *-vr.GainManipulation.Value; % (-2)

% correct for obvious errors
if pOff > 100
    pOff = 0;
end
if pOff < -100
    pOff = 0;
end


displacement = [0 pOff 0 0];
movementType = 'displacement';

vr.movement = displacement;
vr.movementType = movementType;
vr.RotaryEncoder.count = vr.RotaryEncoder.currCount;


% output an analog voltage for current speed
% voltageOut = pOff / 5;  % divide by 5 just to scale it... 
% voltageOut(voltageOut>5) = 5;
% voltageOut(voltageOut<-5) = -5;
% outputSingleScan(vr.RotaryEncoder.daqSessRotEnc, voltageOut);
