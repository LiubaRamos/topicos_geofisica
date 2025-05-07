function [lat, lon] = setltln(map, maplegend, r, c)
%SETLTLN Compute latitude and longitude for a matrix cell
%
%   [LAT, LON] = SETLTLN(MAP, MAPLEGEND, R, C)
%   devuelve la latitud y longitud del punto en la fila R y columna C
%   de la matriz MAP, usando el vector MAPLEGEND.

% Extraer información del maplegend
cells_per_degree = maplegend(1);
lat_north = maplegend(2);
lon_west = maplegend(3);

% Tamaño de celda en grados
cellsize = 1 / cells_per_degree;

% Número de filas
[m, ~] = size(map);

% Convertir fila-columna a lat-lon
lat = lat_north - (r - 1) * cellsize;
lon = lon_west + (c - 1) * cellsize;

end 
