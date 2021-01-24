function [ vr ] = LoadEnvironments(vr)
% Creates  the field vr.EnvironmentsVisited equal to 0
for iWorld = 1:numel(vr.exper.worlds)
    eval([' vr.EnvironmentsVisited.' vr.exper.worlds{iWorld}.name '= 0;' ]);
end

