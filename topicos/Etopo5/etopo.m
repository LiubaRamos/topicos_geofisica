function [A, maplegend] = etopo(res, latlim, lonlim)
% ETOPO  Lee datos de batimetría ETOPO5 desde archivo ETOPO5.DAT
% Uso: [A, maplegend] = etopo(1, [latmin latmax], [lonmin lonmax])
% Los límites de longitud deben estar entre 0 y 360
% La resolución está fija a 5 minutos (1 punto por cada 1/12 grado)

% Leer archivo binario (Big-endian, como se provee)
fid = fopen('ETOPO5.DAT', 'r', 'ieee-be');
if fid == -1
    error('No se pudo abrir el archivo ETOPO5.DAT');
end
data = fread(fid, [4320, 2160], 'int16');
fclose(fid);

% Procesar y voltear para que concuerde con latitud creciente
data = flipud(data');  % [lat, lon]

% Crear vectores de latitud y longitud
lat = linspace(90, -90, 2160);       % desde 90°N a 90°S
lon = linspace(0, 360, 4320);        % desde 0° a 360°

% Encontrar índices dentro de los límites
ilat = find(lat >= latlim(1) & lat <= latlim(2));
ilon = find(lon >= lonlim(1) & lon <= lonlim(2));

if isempty(ilat) || isempty(ilon)
    error('Los límites geográficos están fuera del rango del ETOPO5.');
end

% Extraer el subconjunto de la batimetría
A = data(ilat, ilon);

% Crear leyenda (formato compatible con maplegend original)
% maplegend = [rows per degree, upper-left-lat, upper-left-lon]
maplegend = [12, lat(ilat(end)), lon(ilon(1))]; % 5 minutos = 1/12°
end


