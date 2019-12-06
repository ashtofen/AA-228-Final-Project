%Project 1
%Nadia Galindo Mendez
%Kochenderfer
%AA 228
fileID = fopen('battles_won.txt','r');
formatSpec = '%f';
A=fscanf(fileID,formatSpec);
fclose(fileID);
% vec=zeros(1000,1);
% clear vec
% for i=1:10:10000
%     vec(i,1)=i/100;
% end
vec = (1:2000) / 100;
A=A/1000;
% A = A(A ~= 0);
mean(A)
plot(vec,A,'*')
title('Percentage of Battles Won (10 Rounds per Opponent)')
xlabel('Expected Conformity') 
ylabel('Percentage of Battles Won') 
ax = gca;
ax.FontSize = 16;