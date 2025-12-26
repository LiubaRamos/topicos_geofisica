clear all; close all;
load grid_a5.grd;
load xya;
cd zfolder;
ind=find(grid_a5 <= 0);
TF = 1/60; % tiempo en horas
fig=figure;  
i=0;
contour(xa-360,ya,grid_a5',[0 0],'k'); hold on
for k = 1:120     
    disp (k-1)
    filename = ['z' num2str(k+1000-1)];
    eval(['load ' filename]);
    X = eval(filename); clear z1*; 
    %X = X'; % solo para tsunami_bound.f90 
    X(ind)=nan;
    pcolor(xa-360,ya,X'); shading flat; caxis([-0.5 1.0]); %colorbar;
    xlim([min(xa-360) max(xa-360)]);
    ylim([min(ya) max(ya)]);
    xlabel('Longitud');
    ylabel('Latitud');
    axis equal, grid on
    xlim([min(xa-360) max(xa-360)]);
    ylim([min(ya) max(ya)]);
    xlabel('Longitud');
    ylabel('Latitud');    
    text (-77.10, -12.05,'Callao');
    text (-76.21, -13.71,'Pisco');
    text (-78.61, -09.07,'Chimbote');
%   text (-75.16, -15.34,'San Juan');
%   text (-78.98, -08.22,'Salaverry');
%   text (-72.71, -16.62,'Camana');
    text (-79.93, -06.83,'Pimentel');
%   text (-77.76, -10.75,'Barranca');
    %text (-187.5272,  -41.3597,'New Zealand');
    %text (-219.4480,   37.1403,'Japon');
    %text (-155.5205,   19.9935,'Hawaii');
    if mod(k,1/TF) == 1
        linea = [num2str((k-1)*TF),'.0 h'];
    end
    if mod(k,1/TF) == 0
        linea = [num2str((k-1)*TF),' h'];
    end
    % text (-108.00, 41,linea);
    linea = [num2str((k-1)*2),' min'];
    title(['Tsunami de Japon 2011  T=',linea])
    image = X'; clear X; filename = sprintf('image%04i.png', k);    
    print('-dpng', sprintf('-r%i',100), filename);
    %text(261,19,num2str(k));
    %M(:,k) = getframe;
    
end
cd ..
%imwrite(transpose(image), filename);
%t = t + deltaT;
