function FlushThePump(t)
% t = seconds

s =  analogoutput('nidaq', 'Dev1');
channel = 0; % the AO number
addchannel(s,[channel] , {'RewardChannel'});%,'voltage');
set(s,'samplerate',1000);

TTLPeak = 5;  % peak voltage;
if ~isempty(t)
    TTLDuration = t*1000;  % in 1 ms unit, if 4 means 400 ms...
    TTLSignal = [repmat(TTLPeak,1,TTLDuration)];  % creates the TTL
    TTLSignal([1,end+1]) = [0];  % adds one more data point and sets it to 0...
    
    putdata(s,TTLSignal');  % loads the gun....
    start(s)
    wait(s,TTLDuration+1);
    beep
    disp(['Flushed for ' num2str(t) ' seconds...']);
else
end