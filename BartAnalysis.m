function BART=BartAnalysis(fname)
fid = fopen(fname); 
BART=sum(fread(fid,inf,'char')==10); 
BART=BART-73; % lines # for all trials
fclose(fid);