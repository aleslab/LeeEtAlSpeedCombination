%Psychometric analysis for experiment 2 (temporal combination) of
%"Motion grouping: do we combine visual speed information over space and time?"

dataDir = uigetdir();
cd(dataDir)

participantCodes = {'AJ' 'AK' 'AN' 'AO' 'AP' 'AQ' 'AR' 'AS' 'AT'}; %AM did not finish the experiment and AN may need to be excluded 

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    
    %load fast conditions
    
    fastFileDir = strcat(dataDir, '/Participant_', ...
        currParticipantCode, '/lateralLine_gap_fast_*');
    fastfilenames = dir(fastFileDir);
    fastfilenames = {fastfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for ifastFiles = 1:length(fastfilenames)
        fastfilenamestr = char(fastfilenames(ifastFiles));
        fastDataFile(ifastFiles) = load(fastfilenamestr); %loads all of the files to be analysed together
    end
    
    fastExperimentData = [fastDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = fastDataFile.sessionInfo; %all of the session info data in one combined struct
    fastResponseTable = struct2table(fastExperimentData);
    
    %excluding invalid trials
    validfastData = ~(fastResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validfastResponses = fastResponseTable.response(validfastData); %
    validfastCondNumber = fastResponseTable.condNumber(validfastData);
    
    %converting the j and f responses into a logical. J = it got faster.
    fastFRespCell = strfind(validfastResponses, 'f');
    fastJResponses = cellfun('isempty', fastFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    fastFasterResponses = validfastCondNumber(fastJResponses);
    allConds = unique(validfastCondNumber);
    
    histFastNumPos = histc(fastFasterResponses, allConds)'; %the number of it got faster responses for each level in the fast condition
    histFastOutOfNum = histc(validfastCondNumber,allConds)'; %the number of trials in each level in the fast condition
    
    %reshaping the number of it got faster responses and trial numbers so
    %it's easier to put each condition separately into the NumPos Matrix
    %for doing the psychometric analysis once we also have the slow data
    %added.
    fastNumPos = reshape(histFastNumPos, [7,3])';
    fastOutOfNum = reshape(histFastOutOfNum, [7,3])';
    
    
    %load slow conditions
    
    slowFileDir = strcat(dataDir, '/Participant_',...
        currParticipantCode, '/lateralLine_gap_slow_*');
    slowfilenames = dir(slowFileDir);
    slowfilenames = {slowfilenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for islowFiles = 1:length(slowfilenames)
        slowfilenamestr = char(slowfilenames(islowFiles));
        slowDataFile(islowFiles) = load(slowfilenamestr); %loads all of the files to be analysed together
    end
    
    slowExperimentData = [slowDataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = slowDataFile.sessionInfo; %all of the session info data in one combined struct
    slowResponseTable = struct2table(slowExperimentData);
    
    %excluding invalid trials
    validslowData = ~(slowResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validslowResponses = slowResponseTable.response(validslowData); %
    validslowCondNumber = slowResponseTable.condNumber(validslowData);
    
    %converting the j and f responses into a logical. J = it got faster.
    slowFRespCell = strfind(validslowResponses, 'f');
    slowJResponses = cellfun('isempty', slowFRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    slowFasterResponses = validslowCondNumber(slowJResponses);
    allConds = unique(validslowCondNumber);
    
    histslowNumPos = histc(slowFasterResponses, allConds)'; %the number of it got faster responses for each level in the slow condition
    histslowOutOfNum = histc(validslowCondNumber,allConds)'; %the number of trials in each level in the slow condition
    
    %reshaping the number of it got faster responses and trial numbers so
    %it's easier to put each condition separately into the NumPos Matrix
    %for doing the psychometric analysis
    slowNumPos = reshape(histslowNumPos, [7,3])';
    slowOutOfNum = reshape(histslowOutOfNum, [7,3])';
    
    slowStimLevels = repmat([1 1.5 1.8 2 2.2 2.5 3], 3,1);
    fastStimLevels = repmat([10 15 18 20 22 25 30], 3, 1);
    
    slowParamsValues = repmat([1.8 3 0.03 0.03],3,1);
    fastParamsValues = repmat([18 0.3 0.03 0.03],3,1);
    
    %preparing for psychometric analysis
    StimLevels = vertcat(fastStimLevels, slowStimLevels);
    NumPos = vertcat(fastNumPos, slowNumPos);
    OutOfNum = vertcat(fastOutOfNum, slowOutOfNum);
    paramsValues = vertcat(fastParamsValues, slowParamsValues);
    
    %fitting the psychometric function
    paramsFree = [1 1 0 1];
    PF = @PAL_CumulativeNormal;
            
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

    
    
    for iCondRow = 1:6
        proportionFaster=results.NumPos(iCondRow, :)./results.OutOfNum(iCondRow, :);
        StimLevelsFineGrain=[min(results.StimLevels(iCondRow,:)):max(results.StimLevels(iCondRow,:))./1000:max(results.StimLevels(iCondRow,:))];
        ProportionCorrectModel = PF(results.paramsValues(iCondRow,:),StimLevelsFineGrain);
        currentCond = num2str(iCondRow);
        graphtitle = strcat(currParticipantCode, '_', currentCond);
        
        figure;
        axes
        hold on
        plot(StimLevelsFineGrain,ProportionCorrectModel,'-','color',[0 .7 0],'linewidth',4);
        plot(results.StimLevels(iCondRow,:),proportionFaster,'-k.','markersize',40);
        set(gca, 'fontsize',16);
        set(gca, 'Xtick', results.StimLevels(iCondRow,:));
        axis([min(results.StimLevels(iCondRow,:)) max(results.StimLevels(iCondRow,:)) 0 1]);
        xlabel('Speed (deg/s)');
        ylabel('proportion faster responses');
        title(graphtitle, 'interpreter', 'none');
        
        figFileName = strcat(graphtitle, '_temporal_int_lapse_psychometric_analysis.pdf');
        saveas(gcf, figFileName);
        
    end
    
    dataToSave = vertcat(results.fiftyPercentPoints', results.threshold75, results.Slope, results.paramsValues');
    resultsTable = table(dataToSave);
    resultsFileName = strcat(currParticipantCode, '_temporal_int_lapse_psychometric_analysis.csv');
    writetable(resultsTable, resultsFileName);
end
