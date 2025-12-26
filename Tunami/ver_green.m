% Ver las funciones de Green
% Copyleft: Cesar Jimenez 30 may 2011
% Update 05 Jun 2023

clear, close all; clc
cd zfolder
disp ('Ver las funciones de Green')
dir green*.dat
fname = input ('Nombre de archivo: ','s');
A = load (fname);
[m n] = size(A);
t = A(:,1);

for k = 1:n-1
    y = A(:,k+1);
    % Filtro pasabaja
    for j = 2:m-1
        yf(j) = (y(j-1)+y(j)+y(j+1))/3;
    end
    yf(1)=y(1); yf(m)=y(m); y = max(y)/max(yf)*yf;
    
    plot (t,y), grid, zoom on
    %ylim ([-0.2 0.2])
    title (['Estacion: ',num2str(k)]);
    xlabel ('t (min)')
    ylabel ('H (m)')
    pause(1);
end
cd ..
    