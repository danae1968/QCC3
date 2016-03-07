function [subNo,dataFilename,dataFilenamePrelim,practice,manipulation]=getInfo
%gives subject number

prompt1='subject number:';
subNo=input(prompt1);

prompt2='practice:';
practice=input(prompt2);

% prompt3='manipulation:';
% manipulation=input(prompt3);
%task 1:manipulate delay 2:manipulate interference time
manipulation = 1;
% prompt2='day:';
% day=input(prompt2);

if practice==0
    dataFilename = sprintf('ColorFun_s%d_pilot2.mat',subNo);
    dataFilenamePrelim=sprintf('CF_s%d_pilot2_pre.mat',subNo);
elseif practice==1
    dataFilename = sprintf('ColorFun_s%d_pilot2_practice.mat',subNo);
    dataFilenamePrelim=sprintf('CF_s%d_pilot2_pre.mat',subNo);
end

if exist (dataFilename,'file')
    randAttach = round(rand*10000);
    dataFilename = strcat(dataFilename, sprintf('_%d.mat',randAttach));  
end

