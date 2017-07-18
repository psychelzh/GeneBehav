function sublist = check_sublist(path)
%

filesInfo = dir(path);
filesName = {filesInfo(:).name}';
filesName = filesName(3:end); % The first two are pwd and parent path.
% Replace file names with easy-to-use names: i.e. remove trailing confusing
% date strings formated 'DD-MMM-YYYY'.
repFilesName = regexprep(filesName, '\d{2}-[a-zA-Z]{3}-\d{4}', ''); % Regular expression is used here. Use 'doc regexp' to learn more.
% Find out subject list.
matchStr = regexp(repFilesName, '(?<=\D)\d{3,5}(?=\D)', 'match', 'once');
sublist = str2double(unique(matchStr));
%Delete some illegal subject code.
sublist(isnan(sublist) | ...
    (sublist > 279 & sublist < 2001) | ...
    (sublist > 2342 & sublist <3001) | ...
    (sublist > 3999 & sublist < 15001) | ...
    sublist > 19999) = [];
sublist = sort(sublist);