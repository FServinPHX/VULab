clear 
close all



currentFileName  = "C:\Users\servinf\Documents\1.0 Vanderbilt\Dr. Miga Lab\Jupyter Notebook\gp-search-20220829-084332.csv";
%Load in the patent data
iData = readtable(currentFileName);
%

all.title = string(iData{:,2});
all.assignee = string(iData{:,3});
all.inventor_author =  string(iData{:,4});
all.priorityDate =  string(iData{:,5});
all.filing_creationDate =  string(iData{:,6});
all.grantDate =  string(iData{:,7});

%%

%Split the patent assignee
strNew = [];
count = 0;
for i =  1:length(all.assignee)
        newStr = split(all.assignee(i),[", "]);    
        strNew = [strNew; newStr]; 
end
all.assigneeS = strNew;
all.assigneeT = table(all.assigneeS );
all.assigneeTS = groupsummary(all.assigneeT,'Var1');

%Split the patent inventor author
strNew = [];
count = 0;
for i =  1:length(all.inventor_author)
        newStr = split(all.inventor_author(i),[", "]);    
        strNew = [strNew; newStr]; 
end
all.inventor_authorS = strNew;
all.inventor_authorT = table(all.inventor_authorS);
all.inventor_authorTS = groupsummary(all.inventor_authorT,'Var1');

