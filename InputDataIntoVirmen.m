function [vr ] = InputDataIntoVirmen( vr)
% Where to save and store the data recorded...
vr.Path = ['C:\behaviour_local\']; %save local copy

%% Trial information...
vr         = InsertRatNameAndTrial(vr);
vr.RatName = [vr.TrialInfo.Answers{find(strcmp(vr.TrialInfo.Prompt,'Mouse:'))} '\'];
vr.Day     = [vr.TrialInfo.Answers{find(strcmp(vr.TrialInfo.Prompt,'Date:'))} '\'];
vr.Session = [vr.TrialInfo.Answers{find(strcmp(vr.TrialInfo.Prompt,'Session:'))} '\'];
vr.DirectoryName = [vr.Path vr.Experiment '\' vr.RatName vr.Day ] ; 
vr.Setup = str2double([vr.TrialInfo.Answers{find(strcmp(vr.TrialInfo.Prompt,'VRSETUP'))} ])  ; 

%% Set Windows right...
if vr.Setup ==2;
    vr.exper.windows{1}.transformation =2;
    vr.exper.windows{1}.monitor = 5;

    vr.exper.windows{2}.transformation =3;
    vr.exper.windows{2}.monitor = 4;

    vr.exper.windows{3}.transformation =4;
    vr.exper.windows{3}.monitor = 3;

    vr.exper.windows{4}.transformation =1;
    vr.exper.windows{4}.monitor = 6;

    vr.exper.windows{5}.transformation =1;
    vr.exper.windows{5}.monitor = 2;
end


%% Behaviour information...
vr=InsertBehaviourRequired(vr);
vr.DetectLicking     = [str2double(vr.BehaviourInfo.Answers{find(strcmp(vr.BehaviourInfo.Prompt, 'Detect licking:'))}) ];
vr.RewardIfLicking   = [str2double(vr.BehaviourInfo.Answers{find(strcmp(vr.BehaviourInfo.Prompt, 'Include Licking Criteria:'))}) ];
vr.MaxNumberOfLicks  = [str2double(vr.BehaviourInfo.Answers{find(strcmp(vr.BehaviourInfo.Prompt, 'Max number of licks:' ))}) ];
vr.RewardWindowWidth = [str2double(vr.BehaviourInfo.Answers{find(strcmp(vr.BehaviourInfo.Prompt, 'Reward Window Width:' ))}) ];
if strcmp(vr.Experiment,'Multicompartment');
    vr.DiscriminateRewardedAreas = [str2double(vr.BehaviourInfo.Answers{find(strcmp(vr.BehaviourInfo.Prompt, 'Discriminate the rewarded areas:' ))}) ];
end

%% Create directories...
mkdir(vr.DirectoryName);
cd(vr.DirectoryName);
