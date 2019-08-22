%Psychometric analysis for experiment 3 (temporal combination follow-up) of
%"Motion grouping: do we combine visual speed information over space and time?"

cd /Users/Abigail/Documents/Experiment_Data/Experiment_8
participantCodes = {'BL' 'BK' 'BJ' 'BH' 'BG'}; 

for iParticipant = 1:length(participantCodes)
    
    currParticipantCode = cell2mat(participantCodes(iParticipant));
    
    %load fast conditions
    
    FileDir = strcat('/Users/Abigail/Documents/Experiment_Data/Experiment_8/',...
        currParticipantCode, '/lateralLine_flipped_gap_fast_*');
    filenames = dir(FileDir);
    filenames = {filenames.name}; %makes a cell of filenames from the same
    %participant and condition to be loaded together
    
    for iFiles = 1:length(filenames)
        filenamestr = char(filenames(iFiles));
        DataFile(iFiles) = load(filenamestr); %loads all of the files to be analysed together
    end
    
    ExperimentData = [DataFile.experimentData]; %all of the experiment data in one combined struct
    allSessionInfo = DataFile.sessionInfo; %all of the session info data in one combined struct
    ResponseTable = struct2table(ExperimentData);
    
    %excluding invalid trials
    validData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
    validResponses = ResponseTable.response(validData); %
    validCondNumber = ResponseTable.condNumber(validData);
    
    %converting the j and f responses into a logical. J = it got faster.
    FRespCell = strfind(validResponses, 'f');
    JResponses = cellfun('isempty', FRespCell); %creates a logical where j responses are 1s and f responses are 0
    
    %need number of it got faster responses for each condition
    %need row vector of how many trials there were for each condition
    
    FasterResponses = validCondNumber(JResponses);
    allConds = unique(validCondNumber);
    
    histNumPos = histc(FasterResponses, allConds)'; %the number of it got faster responses for each level in the fast condition
    histOutOfNum = histc(validCondNumber,allConds)'; %the number of trials in each level in the fast condition
    
    %reshaping the number of it got faster responses and trial numbers so
    %it's easier to put each condition separately into the NumPos Matrix
    %for doing the psychometric analysis once we also have the slow data
    %added.

    %preparing for psychometric analysis
    StimLevels = repmat([10 15 18 20 22 25 30], 3, 1);
    NumPos = reshape(histNumPos, [7,3])';
    OutOfNum = reshape(histOutOfNum, [7,3])';
    paramsValues = repmat([18 0.3 0.03 0.03],3,1);
    
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
        
        for iVal = 1:3
            results.threshold75(iVal) = PAL_CumulativeNormal(results.paramsValues(iVal,:), 0.75, 'Inverse');
            results.Slope(iVal) = PAL_CumulativeNormal(results.paramsValues(iVal,:),...
                results.threshold75(iVal), 'Derivative');
        end
        
        %Create simple plot for each condition separately

    
    
    for iCondRow = 1:3
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
        
        figFileName = strcat(graphtitle, '_flipped_temporal_int_lapse_psychometric_analysis.pdf');
        saveas(gcf, figFileName);
        
    end
    
    dataToSave = vertcat(results.fiftyPercentPoints', results.threshold75, results.Slope, results.paramsValues');
    resultsTable = table(dataToSave);
    resultsFileName = strcat(currParticipantCode, '__flipped_temporal_int_lapse_psychometric_analysis.csv');
    writetable(resultsTable, resultsFileName);
end
