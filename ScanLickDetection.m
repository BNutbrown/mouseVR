function [vr] = ScanLickDetection(vr)

% get lick count - compare to previous count. if increased mouse has licked since last frame.
prevCount = vr.LickDetection.count;
currCount = vr.LickDetection.currCount ;  % comes from rotary encoder
vr.LickDetection.count = currCount;  % save the curent frames count to use next frame

% is the mouse licking this frame?
thisFrameLickCount = currCount - prevCount;
vr.LickDetection.Licking = thisFrameLickCount > 0;

% keep record of number licks, time of licks, position of licks.
vr.LickDetection.LickEvents = vr.LickDetection.LickEvents + vr.LickDetection.Licking;
if vr.LickDetection.Licking; 
    vr.LickDetection.LickTimeStamps = [vr.LickDetection.LickTimeStamps; vr.timeElapsed];
    vr.LickDetection.LickPositions  = [vr.LickDetection.LickPositions; vr.pos];
    fwrite(vr.LickDetection.fidLicking, [vr.LickDetection.LickTimeStamps(end) vr.LickDetection.LickPositions(end) vr.LickDetection.LickEvents]','double');
end
