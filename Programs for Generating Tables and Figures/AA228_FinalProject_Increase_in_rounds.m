%Project 1
%Nadia Galindo Mendez
%Kochenderfer
%AA 228
x=[1 5 10 25 50 100 500 1000 5000];
%y=[0.482 0.557 0.61 0.6918 0.7969 0.85476 0.89426 0.9322 0.9326 0.9337 0.9386];
y=[0.481 0.575 0.671 0.805 0.896 0.956 0.997 0.998 0.998];
s=semilogx(x,y,'-*')
title('Average Percent of Battles Won vs Number of Battles per Opponent')
xlabel('Number of Battles per Opponent') 
ylabel('Percentage of Battles Won') 
s.Color=[0.4660 0.6740 0.1880]
ax = gca;
ax.FontSize = 16;