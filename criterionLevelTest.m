%Extracts and graphs pieces of the EGG filter signal
%use this to find important features from the EGGfilt data.
%load the data first then change the variable name.
x1 = linspace(1,5001,5001); %range of data points to plot
x1 = x1 * (1/fs); %change to time scale
figure
subplot(2,1,1);
plot(x1,data(10000:15000));
dataextract = data(10000:15000);
title('EGG signal of the word "When the" at 2km/h speed ');
xlabel('Time (s)');
ylabel('Amplitude (VFCA)');
domainRange = size(x1)*(1/fs);
xlim([0 domainRange(1,2)]) %change domain

%Differentiate the data extracted from above to find the criterion level
%to identify when the vocal folds are open or closed. 
h = 0.0000625;
datadiff = diff(dataextract)/h;
subplot(2,1,2);
x1 = linspace(1,5000,5000);
x1 = x1 * (1/fs); %change to time scale
plot((x1),datadiff);
xlim([0 domainRange(1,2)]) %change domain


%Finding the index of the maximum gradient 
max = 0;
index = 1;
for i = 1:size(datadiff)
    if datadiff(i,1) > max
        max = datadiff(i,1);
        index = i;
    end
end

%Find max and min range of the extracted EGG signal
minRange = 0;
maxRange = 0;
for i = 1:size(dataextract)
    if dataextract(i,1) > maxRange
        maxRange = dataextract(i,1);
    end
    
    if dataextract(i,1) < minRange
        minRange = dataextract(i,1);
    end
end

%Find period
i = 1;
time1=0;
time2=0;
[a,b] = size(datadiff);
while i <= a
       if datadiff(i,1) > 450
           if time1 == 0
               time1 = i;
           else
               time2 = i;
               tempPeriod = time2 - time1;
               period = tempPeriod * 1/fs;
               break
           end
           i = i+20;
       end
       i = i+1;
end

%Calculate speed quotients
sQuotientIndex = 1; 
startingFlag = 0;
maxMinFlag = 0;
startingIt = 0;
sQmax = 0;
sQmin = 0;
sQmaxI = 0;
sQminI = 0;

for i = 1:size(dataextract)
    if dataextract(i,1) > 0.09 && startingFlag == 0
        startingFlag = 1;
        startingIt = i;
    end
    
    if startingFlag == 1
        if i < startingIt + tempPeriod/2 && maxMinFlag == 0 
            if dataextract(i,1) > sQmax
                sQmax = dataextract(i,1);
                sQmaxI = i;
            end
        elseif  i < startingIt + tempPeriod/2 && maxMinFlag == 1
            if dataextract(i,1) < sQmin
                sQmin = dataextract(i,1);
                sQminI = i;
            end
        end 
    end 
        
    if i == startingIt + floor(tempPeriod/2) && startingFlag == 1
        startingIt = i;
        if maxMinFlag == 0
            maxMinFlag = 1;
        else
            sQmax = 0;
            sQmin = 0;
            sQuotient(sQuotientIndex,1) = (sQminI - sQmaxI) / (tempPeriod - (sQminI - sQmaxI)) ;
            sQuotientIndex = sQuotientIndex + 1;
            maxMinFlag = 0;
        end
    end           
end
      

%Calculates citerion level
if index == 1 
    criterionLevel = (dataextract(index,1) + abs(minRange)) / (abs(minRange)+abs(maxRange))
else
     criterionLevel = (dataextract(index-1,1) + abs(minRange)) / (abs(minRange)+abs(maxRange))
end

