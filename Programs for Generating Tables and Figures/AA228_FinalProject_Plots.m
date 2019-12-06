%Project 1
%Nadia Galindo Mendez
%Kochenderfer
%AA 228
fileID = fopen('notes.txt','r');
formatSpec = '%f';
A=fscanf(fileID,formatSpec);
fclose(fileID);
h=histogram(A,'Normalization','pdf')
h.NumBins=50;
h.BinWidth=30;
h.FaceColor=[0.9290 0.6940 0.1250];
h.EdgeColor=[0.9290 0.6940 0.1250];
hold on
x= 1681:.5:2302;
mu = mean(A);
sigma = std(A);
f = exp(-(x-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
plot(x,f,'LineWidth',2, 'Color', [0.4940 0.1840 0.5560])
xlim([1681 2302])
ax = gca;
ax.FontSize = 13;
title('Final Scores Obtained Using Game Theory Approach (1000 simulations)')
legend({'Normalized histogram','Probability distribution'},'Location','northeast')
xlabel('Final Score') 
ylabel('Probability Density') 
