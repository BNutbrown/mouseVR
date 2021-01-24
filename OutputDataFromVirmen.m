function OutputDataFromVirmen(vr)
Data = [];

%% Behaviour
BehaviourData = fopen(['Behaviour_' vr.SessionTimeStamp '.data'],'r');

Behaviour          = transpose(fread(BehaviourData,[9,Inf],'double'));
Data.pos.ts        = Behaviour(:,1);
Data.pos.interval  = [diff(Data.pos.ts);NaN];
Data.pos.pos       = Behaviour(:,2);

Data.pos.speed     = Behaviour(:,3);
Data.pos.speed(1)  = Data.pos.speed(1+1);
Data.pos.Trial     = Behaviour(:,4);
Data.pos.paused    = Behaviour(:,5);
Data.pos.StimFrame = Behaviour(:,6);
Data.pos.frameflip = Behaviour(:,7);
Data.pos.StimTrial = Behaviour(:,8);
Data.pos.currentWorld = Behaviour(:,9);

Data.pos.dp        = Data.pos.interval.*Data.pos.speed;
Data.pos.dp(end)   = Data.pos.dp(end-1);
Data.pos.CumulativeDistance = nansum(abs(Data.pos.dp)); % Cumulative distance (abs to get rid of direction (if negative it would be backward)...

clear Behaviour; fclose(BehaviourData); clear BehaviourData;


%% Add things relative to the GAIN - only if any change in the GAIN has been conducted...

if isfield(vr,'AnimalDisplacement')
    vr.GainManipulation.POSTHOC = fopen('GainManipulation.data','r');
    % read all data from the file into the matrix
    vr.GainManipulation.POSTHOCData = transpose(fread(vr.GainManipulation.POSTHOC,[2,Inf],'double'));
    Data.GainManipulation.ts = vr.GainManipulation.POSTHOCData(:,1);
    Data.GainManipulation.Gain = vr.GainManipulation.POSTHOCData(:,2);
    vr = rmfield(vr,'GainManipulation');
    vr.AnimalDisplacement.POSTHOC = fopen('AnimalDisplacement.data','r');
    % read all data from the file into the matrix
    vr.AnimalDisplacement.POSTHOCData= transpose(fread(vr.AnimalDisplacement.POSTHOC,[2,Inf],'double'));
    Data.pos.PIdp = vr.AnimalDisplacement.POSTHOCData(:,2);
    Data.pos.PIspeed = Data.pos.PIdp ./ Data.pos.interval ;
    
    vr.PositionPI.POSTHOC = fopen('PositionPI.data','r');
    vr.PositionPI.POSTHOCData = transpose(fread(vr.PositionPI.POSTHOC,[2,Inf],'double'));
    Data.pos.PIpos = vr.PositionPI.POSTHOCData(:,2);
    
    vr = rmfield(vr,'AnimalDisplacement');
    vr = rmfield(vr,'PositionPI');
end


%% save also the vr structure before closing it...
Data.vr = vr;

%% Save into directory previously saved...
tmpfile = ['Mouse_' vr.RatName(1:end-1) '_' vr.Day(1:end-1) '_Session_' vr.Session(1:end-1) '_' vr.SessionTimeStamp(10:end) ];
cd(vr.DirectoryName)
eval([ 'save(' char(39) tmpfile char(39) ',' char(39) 'Data' char(39) ');;' ])
%cd(vr.FileStoreDirectoryName)
%eval([ 'save(' char(39) tmpfile char(39) ',' char(39) 'Data' char(39) ');;' ])

DisplaySummaryOfTrial;
disp ([tmpfile ' saved into right directory' ]);

