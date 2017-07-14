
%Extracts and graphs pieces of the EGG filter signal
%use this to find important features from the EGGfilt data.
%load the data first then change the variable name.
x1 = linspace(1,320,320); %range of data points to plot
x1 = x1 * (1/fs); %change to time scale
figure
subplot(2,1,1);
plot(x1,data(49820:50139));
dataextract = data(49820:50139);
title('EGG signal of the word "When the" at 2km/h speed ');
xlabel('Time (s)');
ylabel('Amplitude (VFCA)');
xlim([0 0.02]) %change domain

%Differentiate the data extracted from above to find the criterion level
%to identify when the vocal folds are open or closed. 
h = 0.01;
datadiff = diff(dataextract)/h;
subplot(2,1,2);
x1 = linspace(1,319,319);
x1 = x1 * (1/fs); %change to time scale
xlim([0 0.03]) %change domain
plot((x1),datadiff);

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

%Calculates criterion level
criterionLevel = (dataextract(index-1,1) + abs(minRange)) / (abs(minRange)+abs(maxRange));
