function vr=InsertRatNameAndTrial(vr)
vr.TrialInfo.Prompt = {'Mouse:' 'Experiment:' 'Date:' 'Session:' 'Max Trial Length (min):' 'Max Number of Trials:' 'VRSETUP'};% 'Detect licking:' 'Valve Open for (ms):' 'Reward Speed onset:' 'Max Trial Length (min):' 'Max Number of Trials:' 'Include Licking Criteria:'};
dlg_title = 'Trial';
num_lines = 1;
vr.Setup = 3;
defaultans = {'RN000', vr.Experiment datestr(now, 'YYYYmmDD') '1' '60' '500' num2str(vr.Setup)};
vr.TrialInfo.Answers = inputdlg(vr.TrialInfo.Prompt,dlg_title,num_lines,defaultans);
