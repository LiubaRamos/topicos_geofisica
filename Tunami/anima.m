% Realiza la animacion de los frames z1**
% Copyleft: Cesar Jimenez 30 Jun 2011
clear all; %close all;
load grid_a5.grd;
load xya;
cd zfolder  % Directorio de los archivos de salida z*
ind=find(grid_a5 <= 0);
TF = input ('Tiempo (min) entre cada marco (TF=DT*KA/60) = '); 
contour(xa-360,ya,grid_a5',[0 0],'b'); hold on

for k = 1 : 60
    filename = ['z' num2str(k+1000-1)];
    eval(['load ' filename]);
    X = eval(filename);
    X(ind)=nan;
    pcolor(xa-360,ya,X'); shading flat; colorbar; caxis([-0.05 0.1]); 
    axis equal, grid on
    xlim([min(xa-360) max(xa-360)]);
    ylim([min(ya) max(ya)]);
    xlabel('Longitud');
    ylabel('Latitud');
    text (-77.10, -12.05,'Callao');
    text (-76.21, -13.71,'Pisco');
    text (-78.61, -09.07,'Chimbote');
    text (-75.16, -15.34,'San Juan');
    text (-78.98, -08.22,'Salaverry');
    text (-72.71, -16.62,'Camana');
    text (-79.93, -06.83,'Pimentel');
    text (-77.76, -10.75,'Barranca');
%    text (-187.5272,  -41.3597,'New Zealand');
%    text (-219.4480,   37.1403,'Japon');
%    text (-155.5205,   19.9935,'Hawaii');
    if mod(k,1/TF) == 1
        linea = [num2str((k-1)*TF),'.0 min'];
    end
    if mod(k,1/TF) == 0
        linea = [num2str((k-1)*TF),' min'];
    end
    title(['Propagacion del Maremoto  T = ',linea])
    M(:,k) = getframe;
    eval(['clear ' filename]);
end
cd ..
