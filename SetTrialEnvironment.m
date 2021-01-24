function [ vr ] = SetTrialEnvironment( vr )
% Simply search for the name of the worlds... and returns the indices...

vr.EnvironmentSettings.Evironments = {};
vr.EnvironmentSettings.LabelEnvironment = [];

for iWorld = 1 : numel(vr.exper.worlds);
    vr.EnvironmentSettings.Evironments{iWorld} = vr.exper.worlds{iWorld}.name;
    vr.EnvironmentSettings.LabelEnvironment(iWorld) = iWorld;
end
vr.WorldIndexWithReward = find(strcmp(vr.EnvironmentSettings.Evironments, vr.WorldNameWithReward));
