%Project 1
%Nadia Galindo Mendez
%Kochenderfer
%AA 228
fileID = fopen('updt_1.txt','r');
formatSpec = '%f';
A=fscanf(fileID,formatSpec);
fclose(fileID);
x=0:1:10000;
semilogx(x,A)
hold on
semilogx(x,ones(size(x))*0.5,'--')
hold on
fileID_2= fopen('updt_2.txt','r');
A_2=fscanf(fileID_2,formatSpec);
fclose(fileID_2);
semilogx(x,A_2)
hold on
semilogx(x,ones(size(x))*0.2,'--')
fileID_3= fopen('updt_3.txt','r');
A_3=fscanf(fileID_3,formatSpec);
fclose(fileID_3);
semilogx(x,A_3)
hold on
semilogx(x,ones(size(x))*0.3,'--')
%xlim([0 5000])
ax = gca;
ax.FontSize = 13;
title('Actual and Estimated Population Means')
legend({'Rock (Estimated)','Rock (Actual)','Paper (Estimated)','Paper (Actual)','Scissors (Estimated)','Scissors (Actual)'},'Location','best')
xlabel('Round Number') 
ylabel('Population Mean') 