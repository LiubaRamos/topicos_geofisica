% Conseguir datos de Etopo5

clear , clc
[A, maplegend] = etopo(1, [-60 65], [130 298]);

[IA JA] = size(A');
lat = maplegend(2);
lon = maplegend(3);
resol = 300;
% Especular reflexion
%for j = 1:JA
%     k = JA-j+1;
%     B(:,j) = A(:,k);
%     if mod(j,10)==0
%         fprintf ('%6.0f %s %5.0f\n',j,' of',JA);
%     end
%end
%clear A;

xa = 0:IA-1; xa = resol*xa/3600; xa = xa + lon; %267; %extremo izquierdo
ya = JA-1:-1:0; ya = resol*ya/3600; ya = -ya + lat;%(-43); %extremo inferior

hold on
pcolor(xa,ya,A), shading flat, axis equal, grid on
contour(xa,ya,A,[0 0],'black'), axis equal

save pacifico.mat A xa ya -mat
