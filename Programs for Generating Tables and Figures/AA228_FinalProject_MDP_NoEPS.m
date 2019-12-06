%Project 1
%Nadia Galindo Mendez
%Kochenderfer
%AA 228
fileID = fopen('notes2_no_eps.txt','r');
formatSpec = '%f';
A=fscanf(fileID,formatSpec);
fclose(fileID);
h=histogram(A,'Normalization','pdf')
h.NumBins=50;
h.BinWidth=30;
h.FaceColor=[0.3010 0.7450 0.9330];
h.EdgeColor=[0.3010 0.7450 0.9330];
fileID_2 = fopen('notes2_small_eps.txt','r');
A_2=fscanf(fileID_2,formatSpec);
fclose(fileID_2);
hold on
h_2=histogram(A_2,'Normalization','pdf')
h_2.NumBins=50;
h_2.BinWidth=30;
h_2.FaceColor=[0.4660 0.6740 0.1880];
h_2.EdgeColor=[0.4660 0.6740 0.1880];
fileID_3= fopen('notes2_medium_eps.txt','r');
A_3=fscanf(fileID_3,formatSpec);
fclose(fileID_3);
h_3=histogram(A_3,'Normalization','pdf')
h_3.NumBins=50;
h_3.BinWidth=30;
h_3.FaceColor=[0.4940 0.1840 0.5560];
h_3.EdgeColor=[0.4940 0.1840 0.5560];
fileID_4= fopen('notes2_large_eps.txt','r');
A_4=fscanf(fileID_4,formatSpec);
fclose(fileID_4);
h_4=histogram(A_4,'Normalization','pdf')
h_4.NumBins=50;
h_4.BinWidth=30;
h_4.FaceColor=[1 0 0];
h_4.EdgeColor=[1 0 0];
fileID_5 = fopen('notes.txt','r');
A_5=fscanf(fileID_5,formatSpec);
fclose(fileID_5);
%h_5=histogram(A_5,'Normalization','pdf')
%h_5.NumBins=50;
%h_5.BinWidth=30;
%h_5.FaceColor=[0.9290 0.6940 0.1250];
%h_5.EdgeColor=[0.9290 0.6940 0.1250];
xlim([-43 2242])
ax = gca;
ax.FontSize = 13;
title('Final Score Comparison (1000 Simulations Each)')
legend({'MMAB\epsilon=0','MMAB\epsilon=0.1','MMAB\epsilon=0.5','MMAB\epsilon=0.9','Game Theory'},'Location','best')
xlabel('Final Score') 
ylabel('Probability Density') 
