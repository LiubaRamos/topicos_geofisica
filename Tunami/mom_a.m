clear all; close all; clc

disp ('Cargando archivo, espere un momento ... ')
load xya.mat;
load xyo.mat; %lee  xo yo I0 J0 L W Az echado
Az = 193;
echado = 14; % cambiar para cada caso
load grid_a5.grd; 
cd zfolder; % entra al directorio donde estan los z*** archivos
load zmax_a.grd; 
load tmax_a.grd;
%cd ..
%********************************************************
%********************************************************
figure, hold on
contour(xa-360,ya,grid_a5',[0 0],'k');
ind=find(grid_a5 <= 0);
X = zmax_a;
X(ind)=nan;
pcolor(xa-360,ya,X'); shading flat; colorbar; caxis([-0.20 0.40]);
axis equal, grid on
xlim([min(xa-360) max(xa-360)]);
ylim([min(ya) max(ya)]);
    text (-79.93, -06.83,'Pimentel');
%    text (-78.98, -08.22,'Salaverry');
    text (-78.61, -09.07,'Chimbote');
%    text (-77.76, -10.75,'Barranca');
    text (-77.612, -11.115,'Huacho');
    text (-77.10, -12.05,'Callao');
%    text (-76.40, -13.09,'Canete');
%    text (-76.21, -13.71,'Pisco');
    text (-75.16, -15.34,'San Juan');
    text (-72.71, -16.62,'Camana');

title ('Mapa de maxima energia irradiada por el maremoto')

dip=echado*pi/180;
a1=-(Az-90)*pi/180; a2=-(Az)*pi/180;
r1=L; r2=W*cos(dip);
r1=r1/(60*1853); r2=r2/(60*1853);
sx(1)=0;          sy(1)=0;
sx(2)=r1*cos(a1); sy(2)=r1*sin(a1);
sx(4)=r2*cos(a2); sy(4)=r2*sin(a2);
sx(3)=sx(4)+sx(2);sy(3)=sy(4)+sy(2);
sx(5)=sx(1)      ;sy(5)=sy(1);

px=sx + xa(I0); py=sy + ya(J0);
%plano='Plano de Falla';

[m n]=size(grid_a5);
ha=max(zmax_a); 
ind=find(grid_a5 <= 0);
h = max(max(zmax_a));
zmax_d(ind)=nan*zmax_a(ind);%Se elimina todo lo que no se mojo para graficar.

figure;
pcolor(xa(2:m),ya(2:n),zmax_a(2:m,2:n)');shading flat; %colormap jet;
caxis([-h/2 h]);colorbar
hold on;
contour(xa(2:m),ya(2:n),grid_a5(2:m,2:n)',[0 0],'black');
contour(xa(2:m),ya(2:n),grid_a5(2:m,2:n)',[5200 5200],'k');
cs=contour(xa(2:m),ya(2:n),tmax_a(2:m,2:n)',[0:10:60],'w'); %clabel(cs);
axis equal;
axis([min(xa) max(xa) min(ya) max(ya)]);

plot(px,py,'k','linewidth',[2]);

xlabel('Longitud','fontsize',11); ylabel('Latitud','fontsize',11);
title('Escala de colores: maximo nivel del agua (m)','fontsize',11);

figure;
plot(ya,ha); %plot(xa-360,ha);
axis([min(ya)+1 max(ya)-1 0 max(ha)]); grid, zoom xon
xlabel('Latitude','fontsize',11); ylabel('Run up (m)','fontsize',11);
%title('Maxima altura de la ola en la linea de costa','fontsize',11');
cd ..
B = [ya' ha'];
save altura.txt B -ascii
clear B;

% cambiar de formato para GMT
A = X';
[m n] = size(A);
for i = 1:m
    for j = 1:n
        k = m-i+1;
        B(i,j) = A(k,j);
    end
end
save maximo.grd B -ascii
