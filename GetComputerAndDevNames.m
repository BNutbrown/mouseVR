function vr = GetComputerAndDevNames( vr )
% get a timestamp for the current session
vr.SessionTimeStamp = datestr(now,'YYYYmmDD_HHMMSS');

% get computer name
vr.ComputerName     = getenv('COMPUTERNAME');

% read the computer-device mapping cfg file
fid = fopen('ComputerNIMappings.cfg');
tmp = textscan(fid,'%s','delimiter','\n');
tmp = tmp{1}; % becasue it's nested
fclose(fid);

% find the row containg this computer name
thisMappingIdx =  find( ~cellfun(@isempty, strfind(tmp, vr.ComputerName)));   % finds which row of the txt file has the computer name
tmp2 = tmp{thisMappingIdx};

% split the row of text by comma. each element should now be a
% string listing the device name
tmp2 = strsplit(tmp2, ', ');
tmp2 = tmp2(2:end);
vr.devNames = tmp2;  % remove the computer name from first element
