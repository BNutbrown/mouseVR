function code = Bruker2_virmen_TCP
% Code to run experiment
% BN, LR 2019-2020

% Begin header code - DO NOT EDIT
code.initialization = @initializationCodeFun;
code.runtime = @runtimeCodeFun;
code.termination = @terminationCodeFun;
% End header code - DO NOT EDIT


% --- INITIALIZATION code: executes before the ViRMEn engine starts.
    function vr = initializationCodeFun(vr)
        vr.Experiment = 'LinearTrack';
        
        vr.paused = 0;
        
        % photostim
        vr.DoStim = 0;
        vr.stimCount_withinTrial = 1;
        vr.DoStim_interleave = 0;
        vr.thisStimTrial = 1;
        
        % world change
        vr.randomiseWorld = 0;
        vr.worldsEnabled = [1 1 1 1 1];
        vr.randomise_TrialCounter = 0;
        vr.randomise_numTrialsRequired = 0;
        
        vr = GetComputerAndDevNames(vr);
        
        % Text box input pop ups
        vr = InputDataIntoVirmen(vr);
        vr = TrainingTrialSettings(vr);
        vr = TrainingTrialEnvironmentSettings( vr );
        vr = BehaviourSettings(vr);
        daqreset;
        vr.frameflip = 0;
        vr = InitialiseDAQFrameTTL( vr );
        vr = InitialiseDAQStimTTL( vr );
        vr.condition =[];
        vr.startPosition = [-10 270]; % in vr units. will flick between these 2 numbers
        
        % new init stuff for delay before timeout
        vr.delayBeforeTimeout = 1;
        vr.blackoutDelayStarted = 0;
        vr.blackoutDelayTimerStart = nan;
        vr.rewardDelivered = false;
        
        vr.requireThisManyLicks = [5 0];
        vr.punishIfTooManyLicks = 999;
        
        vr.licksInRewardZone = 0;  % is a counter
        vr.licksOutsideRewardZone = 0;
        vr.firstTimeInRewardZone = 1;  % used to signify when animal enter reward zone for first time in a trial
        vr.numLicksWhenEnteredRewardZone = nan;
        vr.TrialOutcome = [];
        
        % tcp
        vr = InitialiseTCPConnection(vr);
        
        vr.incr = 1;
        
        
        %% configure daq inputs
        % <<< SET ROTARY ENCODER >>>
        %  if strcmp(char(vr.TrialSettings.movementFunctionAfterPause), 'moveWithRotaryEncoderBruker');
        %      vr = RotaryEncoderSettings(vr);
        %  end
        
        % <<< SET REWARD DELIVERY >>>
        vr = RewardDeliverySettings(vr);
        
        % <<< SET LICK DETECTOR >>>
        %  if vr.DetectLicking
        %      vr = LickDetectionSettings(vr);
        %  end
        
        vr = DaqInputSettings(vr);  % new - sets up encoder and lick counter. means only have to call inputsinglescan once... increase frame rate
        
        
        %% <<< TEXT BOX INITALISATION >>>
        
        vr.text(12).string = 'ID';           vr.text(12).position = [-.14  0.8];  vr.text(12).size = .05; vr.text(12).color = [1 0 1];  vr.text(12).window = 2;
        
        vr.text(4).string = 'TIME';          vr.text(4).position  = [-.14  0.6];   vr.text(4).size = .05; vr.text(4).color = [1 1 1];   vr.text(4).window = 2;
        vr.text(8).string = 'PAUSE';         vr.text(8).position  = [-.14  0.5];   vr.text(8).size = .05; vr.text(8).color = [1 1 0];   vr.text(8).window = 2;
        
        vr.text(6).string = 'TRIAL';         vr.text(6).position  = [-.14  0.3];   vr.text(6).size = .05; vr.text(6).color = [0 1 0];   vr.text(6).window = 2;
        vr.text(7).string = 'TRIAL OUTCOME'; vr.text(7).position  = [-.14  0.2];   vr.text(7).size = .05; vr.text(7).color = [0 1 0];   vr.text(7).window = 2;
        
        vr.text(10).string = 'LICKS';        vr.text(10).position = [-.14  0.0];  vr.text(10).size = .05; vr.text(10).color = [0 1 1];  vr.text(10).window =[2];
        vr.text(1).string = 'LICKS RQD';     vr.text(1).position  = [-.14  -.1];   vr.text(1).size = .05; vr.text(1).color = [1 1 0];   vr.text(1).window = 2;
        vr.text(5).string = 'REWARD';        vr.text(5).position  = [-.14  -.2];   vr.text(5).size = .05; vr.text(5).color = [1 1 0];   vr.text(5).window = 2;
        
        vr.text(9).string = 'POSITION';      vr.text(9).position  = [-.14  -.4];   vr.text(9).size = .05; vr.text(9).color = [0 1 1];   vr.text(9).window = 2;
        vr.text(3).string = 'SPEED';         vr.text(3).position  = [-.14  -.5];   vr.text(3).size = .05; vr.text(3).color = [0 1 1];   vr.text(3).window = 2;
        vr.text(11).string = 'START POS';    vr.text(11).position = [-.14  -.6];  vr.text(11).size = .05; vr.text(11).color = [1 1 0];  vr.text(11).window = 2;
        
        vr.text(13).string = 'STIM';         vr.text(13).position = [-.8   0.9];  vr.text(13).size = .05; vr.text(13).color = [.5 .5 .5];  vr.text(13).window = 2;
        
        % world change buttons
        vr.text(14).string = 'WORLD1';vr.text(14).position = [-.7 -.6];  vr.text(14).size = .05; vr.text(14).color = [.5 .5 .5];  vr.text(14).window = 2;
        vr.text(15).string = 'WORLD2';vr.text(15).position = [-.7 -.5];  vr.text(15).size = .05; vr.text(15).color = [.5 .5 .5];  vr.text(15).window = 2;
        vr.text(16).string = 'WORLD3';vr.text(16).position = [-.7 -.4];  vr.text(16).size = .05; vr.text(16).color = [.5 .5 .5];  vr.text(16).window = 2;
        vr.text(17).string = 'WORLD4';vr.text(17).position = [-.7 -.3];  vr.text(17).size = .05; vr.text(17).color = [.5 .5 .5];  vr.text(17).window = 2;
        vr.text(18).string = 'WORLD5';vr.text(18).position = [-.7 -.2];  vr.text(18).size = .05; vr.text(18).color = [.5 .5 .5];  vr.text(18).window = 2;
        vr.text(19).string = 'RANDOM';vr.text(19).position = [-.7 -.1];  vr.text(19).size = .05; vr.text(19).color = [.5 .5 .5];  vr.text(19).window = 2;
        vr.text(20).string = 'X';     vr.text(20).position = [-.8 -.6]; vr.text(20).size = .05;  vr.text(20).color = [.5 .5 .5];  vr.text(20).window = 2;
        vr.text(21).string = 'X';     vr.text(21).position = [-.8 -.5]; vr.text(21).size = .05;  vr.text(21).color = [.5 .5 .5];  vr.text(21).window = 2;
        vr.text(22).string = 'X';     vr.text(22).position = [-.8 -.4]; vr.text(22).size = .05;  vr.text(22).color = [.5 .5 .5];  vr.text(22).window = 2;
        vr.text(23).string = 'X';     vr.text(23).position = [-.8 -.3]; vr.text(23).size = .05;  vr.text(23).color = [.5 .5 .5];  vr.text(23).window = 2;
        vr.text(24).string = 'X';     vr.text(24).position = [-.8 -.2]; vr.text(24).size = .05;  vr.text(24).color = [.5 .5 .5];  vr.text(24).window = 2;
        vr.text(25).string = '0/0';   vr.text(25).position = [-.7 0]; vr.text(25).size = .05;  vr.text(25).color = [0 0 0];     vr.text(25).window = 2;
        
        vr.TrialSettings.iTrial = 1;
        [ vr ] = LoadEnvironments(vr);  % resets the visits across compartments...
        vr.NewTrialStarted = 0;
        
        %% <<< SET TRACK LENGTH >>>
        vr.TrackLength = 515; % change to length of track (currently in virmen units)actual length of track is 542 au but to make the rxzone function this value works better
        
        %% <<< DEFINING TRACK ZONES >>>
        vr.Rzone = [-18 25];
        vr.rewardZoneLocations = {[390 470],[390 470],[390 470],[390 470],[390 470]};
        vr.rewardedZones = {1, [1 2], [1 2], [1 2], 2};
        vr.whiteoutLocation = 500;
        
        % the indices of the first and last vertex of reward zone objects
        for i = 1:numel(vr.worlds)
            % zone 1
            vertexFirstLast = vr.worlds{i}.objects.vertices(vr.worlds{i}.objects.indices.rewardZone1Floor,:);
            vr.reward1FloorIndx(i,:) = vertexFirstLast(1):vertexFirstLast(2);
            vr.reward1FloorVals(i,:) = vr.worlds{i}.surface.vertices(2, vr.reward1FloorIndx(i,:)) - 390;  % centre on zero to allow easy offset
            
            vertexFirstLast = vr.worlds{i}.objects.vertices(vr.worlds{i}.objects.indices.rewardZone1RightWall,:);
            vr.reward1RightWallIndx(i,:) = vertexFirstLast(1):vertexFirstLast(2);
            vr.reward1RightWallVals(i,:) = vr.worlds{i}.surface.vertices(2, vr.reward1RightWallIndx(i,:)) - 390;
            
            vertexFirstLast = vr.worlds{i}.objects.vertices(vr.worlds{i}.objects.indices.rewardZone1LeftWall,:);
            vr.reward1LeftWallIndx(i,:) = vertexFirstLast(1):vertexFirstLast(2);
            vr.reward1LeftWallVals(i,:) = vr.worlds{i}.surface.vertices(2, vr.reward1LeftWallIndx(i,:)) - 390;
            
            % zone 2
            vertexFirstLast = vr.worlds{i}.objects.vertices(vr.worlds{i}.objects.indices.rewardZone2Floor,:);
            vr.reward2FloorIndx(i,:) = vertexFirstLast(1):vertexFirstLast(2);
            vr.reward2FloorVals(i,:) = vr.worlds{i}.surface.vertices(2, vr.reward2FloorIndx(i,:)) - 470;  % centre on zero to allow easy offset
            
            vertexFirstLast = vr.worlds{i}.objects.vertices(vr.worlds{i}.objects.indices.rewardZone2RightWall,:);
            vr.reward2RightWallIndx(i,:) = vertexFirstLast(1):vertexFirstLast(2);
            vr.reward2RightWallVals(i,:) = vr.worlds{i}.surface.vertices(2, vr.reward2RightWallIndx(i,:)) - 470;
            
            vertexFirstLast = vr.worlds{i}.objects.vertices(vr.worlds{i}.objects.indices.rewardZone2LeftWall,:);
            vr.reward2LeftWallIndx(i,:) = vertexFirstLast(1):vertexFirstLast(2);
            vr.reward2LeftWallVals(i,:) = vr.worlds{i}.surface.vertices(2, vr.reward2LeftWallIndx(i,:)) - 470;
        end
        
        
        %% trial start
        vr.trialStarted = false;
        vr.trialStartWaitTime = 0;
        vr.trialStartTime = nan;
        
        % put mouse in the start position
        vr.position(2) = vr.startPosition(1);
        
        
        %% store the world bg colors, allows blackouts and whiteouts to revert back to intended colour bg
        vr.BackupBGColors = [];
        for i = 1:numel(vr.worlds)
            vr.BackupBGColors(i,:) = vr.worlds{i}.backgroundColor;
        end
        
        
        %% for fps
        vr.text(26).string = 'FPS'; vr.text(26).position = [-.98 .93]; vr.text(26).size = .05;  vr.text(26).color = [1 1 1]; vr.text(26).window = 1;
        vr.frameTimes = nan(1,10);
        
        
        %% for new random trial order
        endWorlds = [1 5];
        intermediateWorlds = [2 3 4];
        numEndPointTrials = [2 2 1];
        numIntermediateTrials = [1 1 2 2];
        numLoops = 20;
        trialOrder = [];
        
        intermediateWorldToChoose = intermediateWorlds;
        endPointWorldToChoose = [endWorlds endWorlds];
        
        for i = 1:numLoops
            % end world
            endWorld = endPointWorldToChoose(randi(numel(endPointWorldToChoose),1));
            
            % enforce all 3 intermediates to be selected the same
            endPointWorldToChoose(endPointWorldToChoose==endWorld) = [];
            if isempty(endPointWorldToChoose)
                endPointWorldToChoose = [endWorlds endWorlds];
            end
            
            %intermeidate world
            intermediateWorld = intermediateWorldToChoose(randi(numel(intermediateWorldToChoose),1));
            
            % enforce all 3 intermediates to be selected the same
            intermediateWorldToChoose(intermediateWorldToChoose==intermediateWorld) = [];
            if isempty(intermediateWorldToChoose)
                intermediateWorldToChoose = intermediateWorlds;
            end
            
            % build master trial order
            % choose num of trial in each world
            thisNumEndTrials = numEndPointTrials(randi(numel(numEndPointTrials),1));
            thisNumIntermediteTrials = numIntermediateTrials(randi(numel(numIntermediateTrials),1));
            if thisNumIntermediteTrials > 1
                intermediateWorld2 = intermediateWorldToChoose(randi(numel(intermediateWorldToChoose),1));
                intermediateWorldToChoose(intermediateWorldToChoose==intermediateWorld) = [];
                if isempty(intermediateWorldToChoose)
                    intermediateWorldToChoose = intermediateWorlds;
                end
            end
            
            if thisNumIntermediteTrials > 1
                trialOrder = [trialOrder; ones(thisNumEndTrials,1)*endWorld; intermediateWorld;intermediateWorld2];
            else
                trialOrder = [trialOrder; ones(thisNumEndTrials,1)*endWorld; ones(thisNumIntermediteTrials,1)*intermediateWorld];
            end
        end
        vr.TrialOrder = trialOrder;
        
        
        %% for reward zone timeout
        vr.rewardZoneTimeoutDuration = 6;
        vr.rewardZoneTimeoutStart = 0;
        
    end


    %% --- RUNTIME code: executes on every iteration of the ViRMEn engine.
    function vr = runtimeCodeFun(vr)
        %% update fps display
        vr.frameTimes = [vr.timeElapsed vr.frameTimes(1:end-1)];
        fps = 1 / abs(mean(diff(vr.frameTimes)));
        if ~isnan(fps)
            vr.text(26).string = [num2str(fps,'%.1f') ' FPS'];
            vr.text(26).color = vr.BackupBGColors(vr.currentWorld,:) + 0.5;
            vr.text(26).color(vr.text(26).color>1) = 1;
        end
        
        %% set the reward zone position based on world number
        % move reward zones
        thisRewardLocation1 = vr.rewardZoneLocations{vr.currentWorld}(1);
        vr.worlds{vr.currentWorld}.surface.vertices(2, vr.reward1FloorIndx(vr.currentWorld,:))     = vr.reward1FloorVals(vr.currentWorld,:)     + thisRewardLocation1;
        vr.worlds{vr.currentWorld}.surface.vertices(2, vr.reward1RightWallIndx(vr.currentWorld,:)) = vr.reward1RightWallVals(vr.currentWorld,:) + thisRewardLocation1;
        vr.worlds{vr.currentWorld}.surface.vertices(2, vr.reward1LeftWallIndx(vr.currentWorld,:))  = vr.reward1LeftWallVals(vr.currentWorld,:)  + thisRewardLocation1;
        
        thisRewardLocation2 = vr.rewardZoneLocations{vr.currentWorld}(2);
        vr.worlds{vr.currentWorld}.surface.vertices(2, vr.reward2FloorIndx(vr.currentWorld,:))     = vr.reward2FloorVals(vr.currentWorld,:)     + thisRewardLocation2;
        vr.worlds{vr.currentWorld}.surface.vertices(2, vr.reward2RightWallIndx(vr.currentWorld,:)) = vr.reward2RightWallVals(vr.currentWorld,:) + thisRewardLocation2;
        vr.worlds{vr.currentWorld}.surface.vertices(2, vr.reward2LeftWallIndx(vr.currentWorld,:))  = vr.reward2LeftWallVals(vr.currentWorld,:)  + thisRewardLocation2;
        
        theseZoneLocations = vr.rewardZoneLocations{vr.currentWorld};
        theseRewardedZones = vr.rewardedZones{vr.currentWorld};
        
        rewardedVRpositions = [];
        for i = 1:numel(theseRewardedZones)
            theseBounds = vr.Rzone+theseZoneLocations(theseRewardedZones(i));
            rewardedVRpositions = [rewardedVRpositions theseBounds(1):theseBounds(2)];
        end
        
        
        %% get current position
        vr.pos = vr.position(2); % Store position data
        vr.StimFrame = 0;
        
        % work out if in one of the current reward zones:
        inRewardZone = 0;
        if ismember(round(vr.pos), rewardedVRpositions)
            inRewardZone = 1;
        end
        if inRewardZone && vr.firstTimeInRewardZone
            disp('--- IN REWARD ZONE')
            vr.firstTimeInRewardZone = 0;
            if vr.currentWorld==2  |  vr.currentWorld==3  |  vr.currentWorld==4
                vr.rewardZoneTimeoutStart = vr.timeElapsed;
                disp('--- REWARD ZONE TIMEOUT STARTED')
            end
        end
        if ~inRewardZone && ~vr.firstTimeInRewardZone  % means left first and now in second
            vr.firstTimeInRewardZone = 1;
            vr.licksInRewardZone = 0;  % reset lick counter for the second window
            disp('--- LEFT ZONE')
            if vr.currentWorld==2  |  vr.currentWorld==3  |  vr.currentWorld==4
                vr.rewardZoneTimeoutStart = vr.timeElapsed;
            end
        end
        if inRewardZone
            if vr.currentWorld==2  |  vr.currentWorld==3  |  vr.currentWorld==4
                if (vr.timeElapsed - vr.rewardZoneTimeoutStart) >= vr.rewardZoneTimeoutDuration
                    vr.blackout = 1;
                    % timer delay before doing blackout
                    if ~vr.blackoutDelayStarted
                        disp('--- REWARD ZONE TIMEOUT PASSED')
                        vr.blackoutDelayTimerStart = vr.timeElapsed;
                        disp('--- DELAY BEFORE BLACKOUT HAS STARTED')
                        vr.blackoutDelayStarted = 1;
                        
                        % records the time the black out timer started. this gets added
                        % to constantly due to the way it interacts with <when to teleport>
                        if isempty(vr.BlackoutTimeOnset) || vr.timeElapsed - vr.BlackoutTimeOnset(end) > vr.blackoutduration
                            vr.BlackoutTimeOnset = [vr.BlackoutTimeOnset; vr.timeElapsed]; % does this store pre trial? %HELP
                            vr.BlackoutPosOnset  = [vr.BlackoutPosOnset; vr.pos]; % where mouse is when Blackout onset
                        end
                        
                        % delay passed, now do
                        if vr.timerForBlackoutDelay >= vr.delayBeforeTimeout;
                            vr.worlds{vr.currentWorld}.surface.visible(:) = false;
                            vr.worlds{vr.currentWorld}.backgroundColor              = [0 0 0];
                            vr.dp(:) = 0;
                        end
                    end
                end
            end
        end
        
        %% <<< TEXT BOX INITIALISATION >>>
        if vr.timeElapsed==0
            vr.text(3).string = '  SPEED 0' ; %%datestr(now-vr.timeStarted,'MM.SS')];
        else
            vr.text(3).string = ['  SPEED ' num2str(round(vr.velocity(2)))  ]; %%datestr(now-vr.timeStarted,'MM.SS')];
        end
        vr.text(1).string  = ['* LICKS RQD= ' num2str(vr.requireThisManyLicks(1))];
        vr.text(4).string  = ['  TIME ' datestr(now-vr.timeStarted,'HH.MM.SS')];
        vr.text(5).string  = ['* REWARD ' num2str( numel(vr.RewardDelivery.ManualReward)), '/'  , num2str(sum(vr.RewardDelivery.ManualReward))]; %%datestr(now-vr.timeStarted,'MM.SS')];
        vr.text(6).string  = ['  TRIAL ' num2str(vr.TrialSettings.iTrial)] ;
        vr.text(7).string  = ['  SCORE ' num2str(sum(vr.TrialOutcome))  ];
        vr.text(8).string  = ['* PAUSE ' num2str(vr.paused)];
        vr.text(9).string  = ['  POSITION ' num2str(round(vr.pos))];
        vr.text(10).string = ['  LICKS ' num2str(vr.LickDetection.LickEvents) ];
        vr.text(11).string = ['* START POS= ' num2str(vr.startPosition(1))];
        vr.text(12).string = ['---- ' num2str(vr.RatName) ' ----'];
        
        
        if vr.DoStim
            if ~vr.DoStim_interleave  % not a stim trial
                vr.text(13).string = ['STIM ' repmat('- ', 1, numel(vr.stimDelivered)) ];
                vr.text(13).color = [1 .5 0];
            else  % is a stim trial
                vr.text(13).string = ['STIM ' strrep(num2str(vr.stimDelivered'), '  ',' ') ];
                vr.text(13).color = [1 .5 0];
            end
        else
            vr.text(13).string = ['STIM'];
            vr.text(13).color = [.5 .5 .5];
        end
        
        
        %% <<< CHECK FOR TEXT CLICKS >>>
        
        % if clicking on start position
        if vr.textClicked == 11
            vr.startPosition = fliplr(vr.startPosition);  % switch between short or long track.
            vr.text(11).string = ['* START POS= ' num2str(vr.startPosition(1))];
            vr.position(2) = [vr.startPosition(1)];
        end
        
        
        % if clicking on reward
        vr.ManualReward = 0;
        if vr.textClicked == 5
            vr.ManualReward = 1;
        end
        
        if vr.textClicked == 1
            vr.requireThisManyLicks = fliplr(vr.requireThisManyLicks);  % switch between short or long track.
            vr.text(1).string = ['* LICKS RQD= ' num2str(vr.requireThisManyLicks(1))];
            vr.condition = 0;
        end
        
        
        % PAUSE
        if vr.textClicked == 8  % pause clicked
            if vr.paused  % means you are clicking pause button, whilst paused... ie you are UNpausing
                vr.position(2) = 0;
            end
            vr.paused = ~vr.paused;
            
            % save the vr structure here...
            Data.vr = vr;
            % Save into directory previously saved...
            tmpfile = ['Mouse_' vr.RatName(1:end-1) '_' vr.Day(1:end-1) '_Session_' vr.Session(1:end-1) '_' vr.SessionTimeStamp(10:end) ];
            cd(vr.DirectoryName)
            eval([ 'save(' char(39) tmpfile char(39) ',' char(39) 'Data' char(39) ');;' ])
            disp ([tmpfile ' saved into right directory' ]);
        end
        
        
        % click on stim
        if vr.textClicked == 13  % stim clicked
            vr.DoStim = ~vr.DoStim;
            if vr.DoStim
                % load the stim position file...
                [filename, pathname] = uigetfile();
                tmp = load([pathname filename]);
                vr.StimOrder = tmp.virmen_StimLocations;
                vr.StimStartOnTrial = vr.TrialSettings.iTrial;
                vr.stimDelivered    = zeros(size(vr.StimOrder,2),1);
            end
        end
        
        % click on world number
        numWorlds = numel(vr.worlds);
        if vr.textClicked == 14
            vr.currentWorld = 1;
        end
        if vr.textClicked == 15
            vr.currentWorld = 2;
        end
        if vr.textClicked == 16
            if numWorlds >= 3
                vr.currentWorld = 3;
            else
                disp('ERROR: WORLD DOES NOT EXIST')
            end
        end
        if vr.textClicked == 17
            if numWorlds >= 4
                vr.currentWorld = 4;
            else
                disp('ERROR: WORLD DOES NOT EXIST')
            end
        end
        if vr.textClicked == 18
            if numWorlds >= 5
                vr.currentWorld = 5;
            else
                disp('ERROR: WORLD DOES NOT EXIST')
            end
        end
        
        
        % click on randomise world
        if vr.textClicked == 19
            vr.randomiseWorld = ~vr.randomiseWorld;
            if vr.randomiseWorld
                vr.text(19).color = [1 .5 0];
                vr.randomise_TrialCounter = 0;
                vr.text(25).color = [.5 .5 .5];
            else
                vr.text(19).color = [.5 .5 .5];
                vr.text(25).color = [0 0 0];
            end
        end
        if vr.textClicked == 20
            vr.worldsEnabled(1) = ~vr.worldsEnabled(1);
            if vr.worldsEnabled(1)
                vr.text(20).string = 'X';
            else
                vr.text(20).string = 'O';
            end
        end
        if vr.textClicked == 21
            vr.worldsEnabled(2) = ~vr.worldsEnabled(2);
            if vr.worldsEnabled(2)
                vr.text(21).string = 'X';
            else
                vr.text(21).string = 'O';
            end
        end
        if vr.textClicked == 22
            if numWorlds >= 3
                vr.worldsEnabled(3) = ~vr.worldsEnabled(3);
                if vr.worldsEnabled(3)
                    vr.text(22).string = 'X';
                else
                    vr.text(22).string = 'O';
                end
            else
                disp('ERROR: WORLD DOES NOT EXIST')
            end
        end
        if vr.textClicked == 23
            if numWorlds >= 4
                vr.worldsEnabled(4) = ~vr.worldsEnabled(4);
                if vr.worldsEnabled(4)
                    vr.text(23).string = 'X';
                else
                    vr.text(23).string = 'O';
                end
            else
                disp('ERROR: WORLD DOES NOT EXIST')
            end
        end
        if vr.textClicked == 24
            if numWorlds >= 5
                vr.worldsEnabled(5) = ~vr.worldsEnabled(5);
                if vr.worldsEnabled(5)
                    vr.text(24).string = 'X';
                else
                    vr.text(24).string = 'O';
                end
            else
                disp('ERROR: WORLD DOES NOT EXIST')
            end
        end
        
        
        %% DO PHOTOSTIM
        if vr.DoStim
            if vr.DoStim_interleave  %% do stim this trial
                % current stim trial
                %   thisStimTrial = vr.TrialSettings.iTrial - (vr.StimStartOnTrial-1);
                
                % get the positions to stimulate on this trial
                thesePositions = vr.StimOrder(vr.thisStimTrial,:);
                
                % if position... do stim
                if vr.position(2) >= thesePositions(vr.stimCount_withinTrial)  &  ~vr.stimDelivered(vr.stimCount_withinTrial)  &  ~vr.whiteout  &  ~vr.blackout
                    vr = TriggerStimTTL(vr);
                    vr.stimDelivered(vr.stimCount_withinTrial) = 1;
                    disp('STIM')
                    vr.stimCount_withinTrial = vr.stimCount_withinTrial +1;
                    vr.StimFrame = 1;
                    if vr.stimCount_withinTrial > numel(thesePositions)
                        vr.stimCount_withinTrial = numel(thesePositions);
                    end
                end
            end
        end
        
        
        %% choose random world on this trial?
        if vr.randomiseWorld
            % show a preview of next 5 trials
            vr.text(25).string = [num2str(vr.TrialOrder(vr.TrialSettings.iTrial+1)) ' '...
                num2str(vr.TrialOrder(vr.TrialSettings.iTrial+2)) ' ' num2str(vr.TrialOrder(vr.TrialSettings.iTrial+3)) ' '...
                num2str(vr.TrialOrder(vr.TrialSettings.iTrial+4)) ' ' num2str(vr.TrialOrder(vr.TrialSettings.iTrial+5)) ];
        end
                
        if vr.currentWorld==1
            vr.text(14).color = [1 1 1];
            vr.text(15).color = [.5 .5 .5];
            vr.text(16).color = [.5 .5 .5];
            vr.text(17).color = [.5 .5 .5];
            vr.text(18).color = [.5 .5 .5];
        elseif vr.currentWorld==2
            vr.text(14).color = [.5 .5 .5];
            vr.text(15).color = [1 1 1];
            vr.text(16).color = [.5 .5 .5];
            vr.text(17).color = [.5 .5 .5];
            vr.text(18).color = [.5 .5 .5];
            %             vr.worlds{vr.currentWorld}.backgroundColor = [0 0 .3];  % CHANGE THE BG COLOR
        elseif vr.currentWorld==3
            vr.text(14).color = [.5 .5 .5];
            vr.text(15).color = [.5 .5 .5];
            vr.text(16).color = [1 1 1];
            vr.text(17).color = [.5 .5 .5];
            vr.text(18).color = [.5 .5 .5];
            
        elseif vr.currentWorld==4
            vr.text(14).color = [.5 .5 .5];
            vr.text(15).color = [.5 .5 .5];
            vr.text(16).color = [.5 .5 .5];
            vr.text(17).color = [1 1 1];
            vr.text(18).color = [.5 .5 .5];
            
        elseif vr.currentWorld==5
            vr.text(14).color = [.5 .5 .5];
            vr.text(15).color = [.5 .5 .5];
            vr.text(16).color = [.5 .5 .5];
            vr.text(17).color = [.5 .5 .5];
            vr.text(18).color = [1 1 1];
        end
        
        
        %% test for screenshots
        %         vr.position(1) = 250;  % x
        %         vr.position(2) = 0;  % y
        %         vr.position(3) = 450;  % z
        %         vr.position(4) = deg2rad(-45);
        % swing the camera from left to right...
        %         if vr.position(4) > deg2rad(15)
        %             vr.incr = -deg2rad(.5);
        %         end
        %         if vr.position(4) < -deg2rad(15)
        %             vr.incr = deg2rad(.5);
        %         end
        %         vr.position(4) = vr.position(4) + vr.incr;
        
        
        %         vr.position(1) = 400;
        %         vr.position(2) = 350;
        %         hideIndx = vr.worlds{vr.currentWorld}.surface.vertices(1,:) >= 0;
        %         vr.worlds{vr.currentWorld}.surface.colors(1,hideIndx) = .5;
        %         vr.worlds{vr.currentWorld}.surface.colors(2,hideIndx) = .5;
        %         vr.worlds{vr.currentWorld}.surface.colors(3,hideIndx) = .5;
        %         vr.worlds{vr.currentWorld}.surface.colors(4,hideIndx) = 0;
        %         vr.worlds{vr.currentWorld}.surface.colors(4,~hideIndx) = 1;
        
        
        %% write to binary
        vr.NameOfCurrentEnvironment = vr.EnvironmentSettings.Evironments{find(vr.EnvironmentSettings.LabelEnvironment == vr.currentWorld)} ;
        fwrite(vr.Behaviour.fidBehaviour, [vr.timeElapsed vr.pos vr.velocity(2) vr.TrialSettings.iTrial vr.paused vr.StimFrame vr.frameflip vr.DoStim_interleave vr.currentWorld]','double');
        
        
        %% <<< WHEN TO TELEPORT >>>
        if ( vr.blackout) && (isempty(vr.BlackoutTimeOnset) || vr.timeElapsed - vr.BlackoutTimeOnset(end) > vr.blackoutduration);
            
            disp('--- BLACKOUT FINISHED')
            % before resetting values we can record how the last trial ended
            if vr.blackout==1
                vr.TrialOutcome (vr.TrialSettings.iTrial) = 1;
            elseif vr.whiteout ==1
                vr.TrialOutcome (vr.TrialSettings.iTrial) = 0;
            end
            
            vr.position(2)  = vr.startPosition(1); %resetting y position to 0 (start of track)
            vr.dp(:)        = 0; % prevent any additional movement during teleportation
            
            vr.rewardDelivered = false;
            vr.whiteout  = 0;
            vr.blackout  = 0;
            vr.reward    = 0;
            vr.rewarddel = 0;
            
            vr.licksInRewardZone      = 0;
            vr.licksOutsideRewardZone = 0;
            vr.firstTimeInRewardZone  = 1;  % used to signify when animal enter reward zone for first time in a trial
            vr.numLicksWhenEnteredRewardZone = nan;
            
            % stim stuff
            vr.stimCount_withinTrial = 1;
            if vr.DoStim
                vr.stimDelivered     = zeros(size(vr.StimOrder,2),1);
                if vr.DoStim_interleave  % this means this trial was a stim, so increment the stim counter
                    vr.thisStimTrial = vr.thisStimTrial + 1;
                end
                vr.DoStim_interleave = ~vr.DoStim_interleave;
            end
            
            % restore background colour
            vr.worlds{vr.currentWorld}.backgroundColor             = vr.BackupBGColors(vr.currentWorld,:);
            vr.worlds{vr.currentWorld}.surface.visible(:)          = true;
            
            if vr.randomiseWorld
                vr.randomise_TrialCounter = vr.randomise_TrialCounter + 1;
            end
            vr.trialStarted = 0;
            vr.trialStartTime = nan;
            
        elseif (vr.whiteout )&&(isempty(vr.WhiteoutTimeOnset) || vr.timeElapsed - vr.WhiteoutTimeOnset(end) > vr.whiteoutduration);
            
            disp('--- WHITEOUT FINISHED')
            
            % before resetting values we can record how the last trial ended
            if vr.blackout==1
                vr.TrialOutcome (vr.TrialSettings.iTrial) = 1;
            elseif vr.whiteout ==1
                vr.TrialOutcome (vr.TrialSettings.iTrial)  = 0;
            end
            
            vr.position(2) = vr.startPosition(1); %resetting y position to 0 (start of track)
            vr.dp(:)       = 0; % prevent any additional movement during teleportation
            
            vr.whiteout  = 0;
            vr.blackout  = 0;
            vr.reward    = 0;
            vr.rewarddel = 0;
            
            vr.licksInRewardZone = 0;
            vr.licksOutsideRewardZone = 0;
            vr.firstTimeInRewardZone = 1;  % used to signify when animal enter reward zone for first time in a trial
            vr.numLicksWhenEnteredRewardZone = nan;
            
            % stim stuff
            vr.stimCount_withinTrial = 1;
            if vr.DoStim
                vr.stimDelivered = zeros(size(vr.StimOrder,2),1);
                if vr.DoStim_interleave  % this means this trial was a stim, so increment the stim counter
                    vr.thisStimTrial = vr.thisStimTrial + 1;
                end
                vr.DoStim_interleave = ~vr.DoStim_interleave;
            end
            
            % restore bg colour
            vr.worlds{vr.currentWorld}.backgroundColor             = vr.BackupBGColors(vr.currentWorld,:);
            vr.worlds{vr.currentWorld}.surface.visible(:)          = true;
            
            if vr.randomiseWorld
                vr.randomise_TrialCounter = vr.randomise_TrialCounter + 1;
            end
            vr.trialStarted = 0;
            vr.trialStartTime = nan;
        end
        
        
        %% Is the animal licking in this specific frame?
        if vr.DetectLicking
            [vr] = ScanLickDetection(vr);  % %% Scan lick detection...% if vr.LickDetection.daqSessLickDetection.SamplesAcquired ~= 0% stop(vr.LickDetection.daqSessLickDetection);% [vr] = ScanLickDetection(vr);% start(vr.LickDetection.daqSessLickDetection);% end
        end
        
        % keep count of licks within windows
        if vr.LickDetection.Licking
            if inRewardZone
                vr.licksInRewardZone = vr.licksInRewardZone + 1;
            else  % must be out of reward zone
                vr.licksOutsideRewardZone = vr.licksOutsideRewardZone + 1;
            end
        end
        
        % if too many licks outside reward zone do something...
        if vr.licksOutsideRewardZone > vr.punishIfTooManyLicks
            vr.whiteout = 1;
        end
        
        
        %% <<< SET REWARD & PUNISHMENT ZONE >>>
        if inRewardZone  % if in reward zome
            if vr.velocity(2) <= 5  ||  vr.requireThisManyLicks(1)==0  % if going slow enough
                if vr.trialStarted
                    if vr.licksInRewardZone >= vr.requireThisManyLicks(1) && ~vr.rewarddel  ||  (vr.position(2)>mean(rewardedVRpositions)  &&  vr.requireThisManyLicks(1)==0 && ~vr.rewarddel) % if licked enough times
                        % set the reward flag and the blackout flag
                        vr.reward   = 1;
                        vr.whiteout = 0;
                        vr.blackout = 1;
                        
                        % timer delay before doing blackout
                        if ~vr.blackoutDelayStarted
                            vr.blackoutDelayTimerStart = vr.timeElapsed;
                            disp('--- DELAY BEFORE BLACKOUT HAS STARTED')
                        end
                        
                        % prevent reward if in intermediate world
                        if vr.currentWorld==2  ||  vr.currentWorld==3  ||  vr.currentWorld==4
                            vr.reward = 0;
                        end
                    end
                end
            end
            
        elseif vr.position(2) > vr.whiteoutLocation
            % run through the back, so do punishment
            vr.blackout  = 0;
            vr.reward    = 0;
            vr.whiteout  = 1;
        else
            vr.reward    = 0;
        end
        
        %% <<< REWARDS >>>
        % << ACTIVE >>
        if vr.reward  &&  vr.rewarddel==0    % ... && vr.timeElapsed>0 && strcmp((vr.RewardDelivery.daqSessRewardDelivery.Running),'Off')
            [vr] = StartReward(vr);
            vr.rewarddel = 1;
        end
        
        % << MANUAL >>
        if vr.ManualReward
            [vr] = StartReward(vr);
        end
        
        %% <<< WHITEOUT ONSET & DELAY >>>
        if vr.whiteout
            vr.dp(:) = 0;
            vr.worlds{vr.currentWorld}.surface.visible(:) = false;
            vr.worlds{vr.currentWorld}.backgroundColor                = [1 1 1];
            if isempty(vr.WhiteoutTimeOnset) ||   vr.timeElapsed -  vr.WhiteoutTimeOnset(end) > vr.whiteoutduration
                vr.WhiteoutTimeOnset = [vr.WhiteoutTimeOnset; vr.timeElapsed];
                vr.WhiteoutPosOnset  = [vr.WhiteoutPosOnset; vr.pos];
                
                % play sound on white out start
                %                 sound(vr.sound_error, vr.sound_error_fs)
            end
            %         elseif vr.whiteout && ~vr.blackout
            %             vr.worlds{vr.currentWorld}.backgroundColor                = [0 0 0];
            %             vr.worlds{vr.currentWorld}.surface.visible(:) = true;
        end
        
        %% <<< BLACKOUT ONSET & DELAY >>>
        vr.timerForBlackoutDelay = vr.timeElapsed - vr.blackoutDelayTimerStart;
        
        % freeze world if blackout delay is triggered
        if vr.blackoutDelayStarted
            vr.dp(:) = 0;
        end
        
        if vr.blackout
            vr.blackoutDelayStarted = 1;
            
            % records the time the black out timer started. this gets added
            % to constantly due to the way it interacts with <when to teleport>
            if isempty(vr.BlackoutTimeOnset) || vr.timeElapsed - vr.BlackoutTimeOnset(end) > vr.blackoutduration
                vr.BlackoutTimeOnset = [vr.BlackoutTimeOnset; vr.timeElapsed]; % does this store pre trial? %HELP
                vr.BlackoutPosOnset  = [vr.BlackoutPosOnset; vr.pos]; % where mouse is when Blackout onset
            end
            
            % delay passed, now do
            if vr.timerForBlackoutDelay >= vr.delayBeforeTimeout;
                vr.worlds{vr.currentWorld}.surface.visible(:) = false;
                vr.worlds{vr.currentWorld}.backgroundColor              = [0 0 0];
                vr.dp(:) = 0;
            end
        else
            % make world visible if not in whiteout
            if ~vr.whiteout
                vr.worlds{vr.currentWorld}.surface.visible(:) = true;
                vr.blackout = 0;% Make world invisible a.k.a black
                
                vr.blackoutDelayStarted = 0;
                vr.blackoutDelayTimerStart = nan;
            end
        end
        
        if vr.paused
            vr.dp(:) = 0;
            vr.worlds{vr.currentWorld}.surface.visible(:) = false;  %go black
        end
        
        
        %% do the trial start stuff here
        if ~vr.trialStarted
            
            if isnan(vr.trialStartTime)
                vr.trialStartTime = vr.timeElapsed;
                % play sound before fade
                %                 sound(vr.sound_start, vr.sound_start_fs)
            end
            trialStartTimeElapsed = vr.timeElapsed - vr.trialStartTime;
            if trialStartTimeElapsed > vr.trialStartWaitTime
                vr.TrialSettings.iTrial = vr.TrialSettings.iTrial+1;
                vr.trialStarted = 1;
                disp(['Trial ' num2str(vr.TrialSettings.iTrial)])
                % set the world
                if vr.randomiseWorld
                    vr.currentWorld = vr.TrialOrder(vr.TrialSettings.iTrial);
                end
                vr.worlds{vr.currentWorld}.surface.visible(:) = true;
                vr.worlds{vr.currentWorld}.backgroundColor = vr.BackupBGColors(vr.currentWorld,:);
                
                % play sound after fade
                %                 sound(vr.sound_start, vr.sound_start_fs)
                
            else
                vr.worlds{vr.currentWorld}.surface.visible(:) = false;
                vr.worlds{vr.currentWorld}.backgroundColor = ([.5 .5 .5] - [.5 .5 .5].*(trialStartTimeElapsed / vr.trialStartWaitTime));
                vr.dp(:) = 0;
            end
        end
        %% <<< END OF INITILISATION CODE >>>
        
        
    end


% --- TERMINATION code: executes after the ViRMEn engine stops.
    function vr = terminationCodeFun(vr)
        if strcmpi(vr.ComputerName, 'WINDOWS-9AEMBGN')  % rig pc
            fclose(vr.tcp.t);
        end
        
        fclose(vr.Behaviour.fidBehaviour);
        fclose(vr.LickDetection.fidLicking);
        OutputDataFromVirmen(vr);
    end
end
