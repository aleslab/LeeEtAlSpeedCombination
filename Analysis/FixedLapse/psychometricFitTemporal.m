function [results ] = psychometricFitTemporal( analysisOptions, participantData )
%WARNING, this is experimental. 

%Pull out the specific data needed. 
[nCorrect, nTrials] = build2AfcResponseMatrix(participantData.sessionInfo,participantData.experimentData);

%Split into different condition groups
conditionGroups = groupConditionsByField(participantData.sessionInfo.conditionInfo,...
    analysisOptions.groupingField);

nGroups = length(conditionGroups);


%Whatfield should we use for the xAxis.
xAxisField = analysisOptions.xAxisField;


%Fit data for each condition grouping:

for iGroup = 1:nGroups,
    
    condList = conditionGroups{iGroup};
    xVal = ([participantData.sessionInfo.conditionInfo(condList).(xAxisField)]);        
    thisGroupValue = participantData.sessionInfo.conditionInfo(condList(1)).(analysisOptions.groupingField);
    %  plot(xVal,percentCorrect(iPpt,condList),'o')

    conditionLabels{iGroup} = [analysisOptions.groupingField ' = '...
        num2str(thisGroupValue,3)];
    
    %Now setup parameters for palamedes fits.  This is using variable to
    %stay consistent with names in example code from Palamedes for ease of
    %reading. 
    options = PAL_minimize('options'); %options structure containing default    
    %This sets the guess rate fixed and lets the offset/slope/lapse rate vary. 
    paramsFree = [1 1 0 0];
    PF = @PAL_CumulativeNormal;    
    %Now here's a tricky one. We don't know what xVal has. Maybe 0 to 10, or
    %say -10 to 0, or maybe -10 to 10. We're going to treat -10 to 0 as if
    %it was 0 -> +10. 
    %
    if any(sign(xVal)==1) && any(sign(xVal)==-1) ; %Checkes if there are both postive and negative
        StimLevels = xVal;
    else
        StimLevels = abs(xVal);
    end
    %Sort stim levels. 
    [StimLevels, sortIdx] = sort(StimLevels);
        
    NumPos   = nCorrect(condList(sortIdx));
    OutOfNum = nTrials(condList(sortIdx));
    
    %If options for the search aren't specified lets make one up with some
    %heuristics. 
    if ~isfield(analysisOptions,'searchGrid') || isempty(analysisOptions.searchGrid)
        %alpha is the offset parameter so lets use a search space that goes
        %from the limits of x xaxis. 
        searchGrid.alpha  = linspace(min(StimLevels),max(StimLevels),101);
        %beta corresponds to the slope.  The magnitude of these can be very
        %different depending on the chosen psychometric function! 
        searchGrid.beta   = linspace(0,(30/max(xVal)),101);
        %Gamma is the guess rate. Going to set it to 50% for now
        searchGrid.gamma  = 0;
        %For fitting the lapse rate we'll use a 0 to 6% range. 
        searchGrid.lambda = 0;
    end
    
    %Now lets do the fit. Returning all results as cell arrays. 
    %All outputs here are named consistent with Palamedes naming
    %conventions
    %Consider changing both names and type. 
    [results.paramsValues{iGroup} results.LL{iGroup} results.exitflag{iGroup} results.output{iGroup}] = ...
        PAL_PFML_Fit(StimLevels, NumPos, OutOfNum, ...
        searchGrid, paramsFree, PF,'lapseLimits',[0 .1], 'searchOptions',options);
    results.PF{iGroup}         = PF;
    results.StimLevels{iGroup} = StimLevels;
    results.NumPos{iGroup}     = NumPos;
    results.OutOfNum{iGroup}   = OutOfNum; 
    results.fiftyPercentPoint{iGroup} = results.paramsValues{iGroup}(1);
    results.threshold75{iGroup} = PAL_CumulativeNormal(results.paramsValues{iGroup}, 0.75, 'Inverse');
    results.Slope{iGroup} = PAL_CumulativeNormal(results.paramsValues{iGroup},...
        results.threshold75{iGroup}, 'Derivative');
    BootNo = 1000;
    
     [SD, paramsSim, LLSim, converged] = PAL_PFML_BootstrapNonParametric(...
                    StimLevels, NumPos, OutOfNum, [], paramsFree, BootNo, PF,...
                    'searchGrid',searchGrid, 'lapseLimits',[0 .1], 'searchOptions',options);
    results.paramsBoot{iGroup} = paramsSim;
    %Now lets evaluate the function so we can use for easy plotting:
    results.functionFitX{iGroup} = linspace(StimLevels(1),StimLevels(end),100);
    results.functionFitY{iGroup} = PF(results.paramsValues{iGroup}, results.functionFitX{iGroup});
    bootFuncFit = NaN(BootNo, 100);
    boot75threshold = NaN(BootNo);
    bootSlopeAt75Threshold = NaN(BootNo);
    
    for iBoot = 1:BootNo
        theseParams =  paramsSim(iBoot,:);
        bootFuncFit(iBoot, :)  = PF(theseParams, results.functionFitX{iGroup});
        
        boot75threshold(iBoot, :) = PAL_CumulativeNormal(theseParams, 0.75, 'Inverse');
        
        bootSlopeAt75Threshold(iBoot, :) = PAL_CumulativeNormal(theseParams, boot75threshold(iBoot), 'Derivative');
   
    end
    
    
     
    loIdx = round(0.025 * BootNo);
    hiIdx = round(0.975 * BootNo);
    
    sortedBootFuncFit = sort(bootFuncFit, 1, 'ascend');
    results.functionFitBootLo{iGroup} = sortedBootFuncFit(loIdx,:);
    results.functionFitBootHi{iGroup} = sortedBootFuncFit(hiIdx,:);
    
    sortedBootThres = sort(boot75threshold,1, 'ascend');
    results.bootThresLo{iGroup} = sortedBootThres(loIdx);
    results.bootThresHi{iGroup} = sortedBootThres(hiIdx);
    
    sortedBootSlope = sort(bootSlopeAt75Threshold,1, 'ascend');
    results.bootSlopeLo{iGroup} = sortedBootSlope(loIdx);
    results.bootSlopeHi{iGroup} = sortedBootSlope(hiIdx);
        
end


results.paradigmName = participantData.sessionInfo.expInfo.paradigmName;
results.conditionLabels = conditionLabels;

if isfield(analysisOptions,'xlabel')
    results.xlabel = analysisOptions.xlabel;
else
    results.xlabel = xAxisField;
end


end

