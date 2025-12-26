% Calculo de la posicion de los mareografos
% Copyleft: Cesar Jimenez 31 Ene 2011
% Updated: 16 Nov 2021
clc
close all
disp ('Posicion de los Mareografos Virtuales')
grilla = input ('Elegir grilla: ','s');

disp ('Elegir una opcion: ')
s = input ('Click en Mapa (1) o Por Teclado (2): ','s');
disp (' ');
%A = load ('grid_d.grd'); 
eval(['load grid_',grilla,'.grd']);
eval(['A = grid_',grilla,';']);
%eval(['load xy',grilla]);
load xya
%load yya
%xd = xya;
xd = xa;
yd = ya;
%yd = yya;
%load xyd;
[m n] = size(A);
if s == '1'
    contour (A',[0,0],'k'), axis equal, grid, zoom
    xlim([1 m]); ylim([1 n])
    xlabel ('Hacer 3 clicks');
    [a, b] = ginput(3);
    fprintf ('%6.0f  %10.0f\n',a(1), b(1));
    fprintf ('%6.0f  %10.0f\n',a(2), b(2));
    fprintf ('%6.0f  %10.0f\n',a(3), b(3));
end

if s == '2'
    eval(['xd = x',grilla,';']);
    eval(['yd = y',grilla,';']);
    contour (xd-360,yd,A',[0,0],'k'), axis equal, grid, zoom
    xlim([min(xd-360) max(xd-360)]); ylim([min(yd) max(yd)])
    %contour(xd,yd,grid_d');
    lat = input ('Latitud  = ');
    lon = input ('Longitud = ');
    if lon < 0
        lon = lon + 360;
    end
    B = find (yd > lat);
    n = B(1);
    A = find (xd > lon);
    m = A(1);
    fprintf ('%6.0f  %10.0f\n',m, n);
    hold on
    text (lon-360, lat, '*')
end
disp ('Editar la linea 116 de TSUNAMI.FOR')
