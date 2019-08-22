clearvars;
%cd /Users/Abigail/Documents/psychtoolboxProjects/psychMaster/Data %lab mac
cd /Users/aril/Documents/Repositories/psychtoolboxProjects/psychMaster/Data %macbook


load('');

ResponseTable = struct2table(experimentData);
wantedData = ~(ResponseTable.validTrial == 0); %creates a logical of which trials in the data table were valid
validIsResponseCorrect = ResponseTable.isResponseCorrect(wantedData);

totalValidResp = length(validIsResponseCorrect);

%How many correct in the whole block?
totalCorrect = sum(validIsResponseCorrect);
lengthValid = length(validIsResponseCorrect);

dispMessage1 = strcat('In the full block_', num2str(totalCorrect),'/', num2str(lengthValid), ' responses were correct');
disp(dispMessage1);

%How many correct in the final 10?
final10start = totalValidResp - 9;

final10validResp = validIsResponseCorrect(final10start:totalValidResp);
correctFinal10 = sum(final10validResp);

dispMessage2 = strcat('In the final 10 responses in this block_', num2str(correctFinal10), '/10 responses were correct');

disp(dispMessage2);
