%Psychometric analysis for experiment 1 (spatial combination) of
%"Motion grouping: do we combine visual speed information over space and time?"

dataDir = uigetdir();
cd(dataDir)

participantCodes = {'AW' 'AX' 'AY' 'AZ' 'BA' 'BB' 'BD' 'BE' 'BF' 'AS'}; %

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    
    %load 0 deg gap data and extract the information we need for analysis
    
    zeroFileDir = strcat(dataDir,'/',...
        currParticipantCode, '/lateralLine_spatialGap_offset_0_*');
    zerofilenames = dir(zeroFileDir);
    zerofilenames = {zerofilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iZeroFiles = 1:length(zerofilenames)
        zerofilenamestr = char(zerofilenames(iZeroFiles));
        zeroDataFile(iZeroFiles) = load(zerofilenamestr); %loads all of the files to be analysed together
    end
    
    zeroExperimentData = [zeroDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = zeroDataFile.sessionInfo; %all of the session info data in one combined struct
    zeroResponseTable = struct2table(zeroExperimentData);
    
    %excluding invalid trials
    validZeroData = ~(zeroResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validZeroResponses = zeroResponseTable.response(validZeroData); %
    validZeroCondNumber = zeroResponseTable.condNumber(validZeroData);
    
    %converting the j and f responses into a logical. J = it got faster.
    zeroFRespCell = strfind(validZeroResponses, 'f');
    zeroJResponses = cellfun('isempty', zeroFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    zeroFasterResponses = validZeroCondNumber(zeroJResponses);
    allConds = unique(validZeroCondNumber);
    
    zeroNumPos = histc(zeroFasterResponses, allConds)'; %the number of it got faster responses for each level in the zero condition
    zeroOutOfNum = histc(validZeroCondNumber,allConds)'; %the number of trials in each level in the zero condition
    
    
    %load 2 deg gap data and extract the information we need for analysis
    
    twoFileDir = strcat(dataDir,'/',...
        currParticipantCode, '/lateralLine_spatialGap_offset_2_*');
    twofilenames = dir(twoFileDir);
    twofilenames = {twofilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for itwoFiles = 1:length(twofilenames)
        twofilenamestr = char(twofilenames(itwoFiles));
        twoDataFile(itwoFiles) = load(twofilenamestr); %loads all of the files to be analysed together
    end
    
    twoExperimentData = [twoDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = twoDataFile.sessionInfo; %all of the session info data in one combined struct
    twoResponseTable = struct2table(twoExperimentData);
    
    %excluding invalid trials
    validtwoData = ~(twoResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validtwoResponses = twoResponseTable.response(validtwoData); %
    validtwoCondNumber = twoResponseTable.condNumber(validtwoData);
    
    %converting the j and f responses into a logical. J = it got faster.
    twoFRespCell = strfind(validtwoResponses, 'f');
    twoJResponses = cellfun('isempty', twoFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    twoFasterResponses = validtwoCondNumber(twoJResponses);
    allConds = unique(validtwoCondNumber);
    
    twoNumPos = histc(twoFasterResponses, allConds)';
    twoOutOfNum = histc(validtwoCondNumber,allConds)';
    
    %load 4 deg gap data and extract the information we need for analysis
    
    fourFileDir = strcat(dataDir, '/', ...
        currParticipantCode, '/lateralLine_spatialGap_offset_4_*');
    fourfilenames = dir(fourFileDir);
    fourfilenames = {fourfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for ifourFiles = 1:length(fourfilenames)
        fourfilenamestr = char(fourfilenames(ifourFiles));
        fourDataFile(ifourFiles) = load(fourfilenamestr); %loads all of the files to be analysed together
    end
    
    fourExperimentData = [fourDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = fourDataFile.sessionInfo; %all of the session info data in one combined struct
    fourResponseTable = struct2table(fourExperimentData);
    
    %excluding invalid trials
    validfourData = ~(fourResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validfourResponses = fourResponseTable.response(validfourData); %
    validfourCondNumber = fourResponseTable.condNumber(validfourData);
    
    %converting the j and f responses into a logical. J = it got faster.
    fourFRespCell = strfind(validfourResponses, 'f');
    fourJResponses = cellfun('isempty', fourFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    fourFasterResponses = validfourCondNumber(fourJResponses);
    allConds = unique(validfourCondNumber);
    
    fourNumPos = histc(fourFasterResponses, allConds)';
    fourOutOfNum = histc(validfourCondNumber,allConds)';
    
    %load 6 deg gap data and extract the information we need for analysis
    
    sixFileDir = strcat(dataDir, '/', ...
        currParticipantCode, '/lateralLine_spatialGap_offset_6_*');
    sixfilenames = dir(sixFileDir);
    sixfilenames = {sixfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for isixFiles = 1:length(sixfilenames)
        sixfilenamestr = char(sixfilenames(isixFiles));
        sixDataFile(isixFiles) = load(sixfilenamestr); %loads all of the files to be analysed together
    end
    
    sixExperimentData = [sixDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = sixDataFile.sessionInfo; %all of the session info data in one combined struct
    sixResponseTable = struct2table(sixExperimentData);
    
    %excluding invalid trials
    validsixData = ~(sixResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validsixResponses = sixResponseTable.response(validsixData); %
    validsixCondNumber = sixResponseTable.condNumber(validsixData);
    
    %converting the j and f responses into a logical. J = it got faster.
    sixFRespCell = strfind(validsixResponses, 'f');
    sixJResponses = cellfun('isempty', sixFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    sixFasterResponses = validsixCondNumber(sixJResponses);
    allConds = unique(validsixCondNumber);
    
    sixNumPos = histc(sixFasterResponses, allConds)';
    sixOutOfNum = histc(validsixCondNumber,allConds)';
    
    %creating the matrices used in the PAL_PFML_FitMultiple
    StimLevels = repmat([10 15 18 20 22 25 30], 4,1);
    NumPos = vertcat(zeroNumPos, twoNumPos, fourNumPos, sixNumPos); %matrix of "it got faster" responses in each of the four conditions
    OutOfNum = vertcat(zeroOutOfNum, twoOutOfNum, fourOutOfNum, sixOutOfNum); %matrix of number of trials in each condition for each of the four conditions
    paramsValues = [19 0.1 0.3 0.3];
    
    
    %fitting the psychometric function
    paramsFree = [1 1 0 1];
    PF = @PAL_CumulativeNormal;
    
    searchGrid.alpha  = linspace(min(StimLevels(1,:)),max(StimLevels(1,:)),101);
    %beta corresponds to the slope.  The magnitude of these can be very
    %different depending on the chosen psychometric function!
    searchGrid.beta   = linspace(0,(30/max(StimLevels(1,:))),101);
    %Gamma is the guess rate. Going to set it to 50% for now
    searchGrid.gamma  = 0;
    %For fitting the lapse rate we'll use a 0 to 6% range.
    searchGrid.lambda = linspace(0,.2,201);
    
    %lapsefits parameters
    thresholdsLapseFits = 'unconstrained';
    slopeLapseFits = 'unconstrained';
    lapseFits = 'constrained';
    lapseFit = 'iAPLE';
    
    results = struct();
    [results.paramsValues results.LL results.exitflag results.output] = ...
        PAL_PFML_FitMultiple(StimLevels, NumPos, OutOfNum, ...
        paramsValues, PF, 'lapserates', lapseFits,...
        'thresholds', thresholdsLapseFits, 'slopes', slopeLapseFits, 'lapseLimits',[0 .3], 'lapseFit', lapseFit, 'gammaeqlambda', 1);
    
    results.PF        = PF;
    results.StimLevels = StimLevels;
    results.NumPos    = NumPos;
    results.OutOfNum   = OutOfNum;
    results.fiftyPercentPoints = results.paramsValues(:,1);
    
    for iVal = 1:length(results.paramsValues)
        results.threshold75(iVal) = PAL_CumulativeNormal(results.paramsValues(iVal,:), 0.75, 'Inverse');
        results.Slope(iVal) = PAL_CumulativeNormal(results.paramsValues(iVal,:),...
            results.threshold75(iVal), 'Derivative');
    end
    
    %Create simple plot for each condition separately
    
    for iCondRow = 1:4
        proportionFaster=results.NumPos(iCondRow, :)./results.OutOfNum(iCondRow, :);
        StimLevelsFineGrain=[min(results.StimLevels(1,:)):max(results.StimLevels(1,:))./1000:max(results.StimLevels(1,:))];
        ProportionCorrectModel = PF(results.paramsValues(iCondRow,:),StimLevelsFineGrain);
        currentCond = num2str(iCondRow);
        graphtitle = strcat(currParticipantCode, '_', currentCond);
        
        figure;
        axes
        hold on
        plot(StimLevelsFineGrain,ProportionCorrectModel,'-','color',[0 .7 0],'linewidth',4);
        plot(results.StimLevels(1,:),proportionFaster,'-k.','markersize',40);
        set(gca, 'fontsize',16);
        set(gca, 'Xtick', results.StimLevels(1,:));
        axis([min(results.StimLevels(1,:)) max(results.StimLevels(1,:)) 0 1]);
        xlabel('Speed (deg/s)');
        ylabel('proportion faster responses');
        title(graphtitle, 'interpreter', 'none');
        
        figFileName = strcat(graphtitle, '_spatial_int_lapse_psychometric_analysis.pdf');
        saveas(gcf, figFileName);
        
    end
    
    dataToSave = vertcat(results.fiftyPercentPoints', results.threshold75, results.Slope, results.paramsValues');
    resultsTable = table(dataToSave);
    resultsFileName = strcat(currParticipantCode, '_spatial_int_lapse_psychometric_analysis.csv');
    writetable(resultsTable, resultsFileName);
    
end
