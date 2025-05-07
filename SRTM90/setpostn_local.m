function [r, c] = setpostn_local(A, maplegend, lat, lon)
    % Extrae datos del maplegend
    cellsPerDegree = maplegend(1);
    lat_n = maplegend(2);
    lon_w = maplegend(3);
    
    % Calcula los desplazamientos desde el origen
    row = floor((lat_n - lat) * cellsPerDegree) + 1;
    col = floor((lon - lon_w) * cellsPerDegree) + 1;

    % Asegura que no se salga del rango de la matriz
    row = min(max(row, 1), size(A,1));
    col = min(max(col, 1), size(A,2));

    r = row;
    c = col;
end
