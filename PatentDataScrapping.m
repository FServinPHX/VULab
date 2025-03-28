
clear
cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Jupyter Notebook' 
names = dir('*.jpeg');
set(gcf,'color','k');
for i = 1:length(names)
    
    filePath = fullfile(names(i).folder , names(i).name);
    data=imread(filePath);
    imshow(data)
    pause(.7)
end 

%%
clear


cd 'C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Jupyter Notebook' 
names = dir('*.txt');
CombinedText = [];
for i = 1:length(names)
    fileID = fopen( names(i).name);

    % Read all lines & collect in cell array
    txt = textscan(fileID,'%s','delimiter','\n'); 

    CombinedText =[ CombinedText;  string(txt{1,1})  ] ;

    fclose(fileID);
end 
%%

C = categorical(CombinedText);
figure
wordcloud(C);
title("All Patents Word Cloud")
