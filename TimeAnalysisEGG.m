%Extracts and graphs pieces of the EGG filter signal
%use this to find important features from the EGGfilt data.
%load the data first then change the variable name.
x1 = linspace(1,2921,2921); %range of data points to plot
x1 = x1 * (1/fs); %change to time scale
figure
subplot(2,1,1);
plot(x1,data(10480:13400));
dataextract = data(10480:13400);
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
x1 = linspace(1,2920,2920);
x1 = x1 * (1/fs); %change to time scale
plot((x1),datadiff);
xlim([0 domainRange(1,2)]) %change domain


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%   Finding general parameters i.e. max, min , period, freq   %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
               iterPeriod = time2 - time1;
               period = iterPeriod * 1/fs;
               break
           end
           i = i+20;
       end
       i = i+1;
end
%Fundamental frequenecy
fundFreq = 1/period;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%  Calculating speed quotients of each EGG signal %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sQuotientIndex = 1; 
startingFlag = 0;
maxMinFlag = 0; %max = 0, min = 1
startingIt = 0;
sQmax = 0;
sQmin = 0;
sQmaxI = 0;
sQminI = 0;

for i = 1:size(dataextract)
    %Determine when we start sampling, i.e. switch on startingFlag when threshold is > 0.09
    if dataextract(i,1) > 0.09 && startingFlag == 0
        startingFlag = 1;
        startingIt = i;
    end
    
    if startingFlag == 1
        %Looking for max
        if (i < startingIt + floor(iterPeriod/2)) && (maxMinFlag == 0)
            if dataextract(i,1) >= sQmax
                sQmax = dataextract(i,1);
                sQmaxI = i;
            end
        %Looking for min
        elseif  (i < startingIt + floor(iterPeriod/2)) && (maxMinFlag == 1)
            if dataextract(i,1) <= sQmin
                sQmin = dataextract(i,1);
                sQminI = i;
            end
        end 
             
        if i == startingIt + floor(iterPeriod/2)
            startingIt = i;
            if maxMinFlag == 0
                sQmin = 0;
                maxMinFlag = 1;
            else
                maxMinFlag = 0;
                sQmax = 0;
                sQuotient(sQuotientIndex,1) = (sQminI - sQmaxI) / (iterPeriod - (sQminI - sQmaxI)) ;
                sQuotientIndex = sQuotientIndex + 1;
            end
        end    
    end 
     
end
      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%   Calculate Glottal Closed Quotient of each EGG signal  %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Calculate citerion level
if index == 1 
    criterionLevel = (dataextract(index,1) + abs(minRange)) / (abs(minRange)+abs(maxRange));
else
     criterionLevel = (dataextract(index-1,1) + abs(minRange)) / (abs(minRange)+abs(maxRange));
end

GCQIndex = 1; 
startingFlag = 0;
maxMinFlag = 0; %max = 0, min = 1
startingIt = 0;
GCQmax = 0;
GCQmin = 0;
GCQmaxI = 0;
GCQminI = 0;
firstCrit = 0;
secondCrit = 0;


for i = 1:size(dataextract)
    
    %calculate the criterion level threshold
    criterionThreshold = ((abs(minRange)+abs(maxRange))*criterionLevel)+minRange; 
    
    if dataextract(i,1) >= criterionThreshold
        
    end
    
    
    
    %%TEMP CODE%%
        
%     if i == startingIt + floor(iterPeriod/2)
%         startingIt = i;
%         if maxMinFlag == 0 %max->min
%             maxMinFlag = 1;
%         else %min->max
%             startingITS(o,1) = startingIt;
%         o = o + 1;
%             %calculate the criterion level intersections
%             flagCrit = 0;
%             p1 = GCQmax
%             p2 = GCQmin
%             criterionThreshold = ((GCQmax-GCQmin)*criterionLevel)+GCQmin; 
%             j = (i-(iterPeriod+floor(iterPeriod/2)));
%             while j <= i
%                 if (dataextract(j,1) >= (criterionThreshold - 0.003)) && dataextract(j,1) <= (criterionThreshold + 0.003)
%                     if flagCrit == 0
%                         firstCrit = j;
%                         flagCrit = 1;
%                     else 
%                         secondCrit = j;
%                     end
%                     j = j + 4;
%                 end
%                 j = j + 1;
%             end
%             GCQmax = 0;
%             GCQmin = 0;
%             maxMinFlag = 0;
%             if secondCrit > firstCrit    
%                 GCQValues(GCQIndex,1) = (iterPeriod - (secondCrit - firstCrit)) / (iterPeriod);
%             else
%                 GCQValues(GCQIndex,1) = (iterPeriod - (firstCrit - secondCrit)) / (iterPeriod);
%             end
%             GCQIndex = GCQIndex + 1;
%         end
%     end    

     
end


