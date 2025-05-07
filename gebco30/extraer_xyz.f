c Extraer una matriz mas pequeña de un archivo XYZ %%%
c Copyleft = Cesar Jimenez cesarsud86@hotmail.com
c Updated: 21 Mar 2013
c
      integer I, N
      real lon, lat, z, lats, latn, lonw, lone
c
      open(1,file='bati_peru.xyz')
      open(2,file='salida.xyz')
c
      N = 432000
c     N : numero de datos
c
      write(*,*), 'Introducir las coordenadas del rectangulo: '
      print*, 'Latitud sur    = '
      read*, lats
      print*, 'Latitud norte  = '
      read*, latn
      print*, 'Longitud izq   = '
      read*, lonw
      if (lonw < 0) lonw = lonw+360
      print*, 'Longitud der   = '
      read*, lone
      if (lone < 0) lone = lone+360
c
      write(*,*), 'Leyendo el archivo de datos ...'
      I = 1

10    if (mod(I,1000).EQ.0) then
         WRITE(*,'(A10,I8,A7,I8)')   'Numero  : ',I,'-th de ',N
         endif
         READ(1,*,end=20) (lon, lat, z,J=1,3)
         if (lon < 0) lon=lon+360
         if (lat>latn.OR.lat<lats.OR.lon>lone.OR.lon<lonw) then
         write(2,'(2F12.6, 1F12.1)')(lon,lat,z,J=1,3)
         else
      end if
      I = I +1
      goto 10
20    write(*,*) 'Se grabo el archivo salida.xyz'
      close(1)
      close(2)
      stop
      end

