! Cambiar formato de archivos xyz 3 columnas
! de (lon lat z) a (lon+360 lat z)
! Copyleft Cesar Jimenez 05 Nov 2014
! Update: 16 Abr 2022

      integer I, N
      real lon, lat, z, lats, latn, lonw, lone
c
      open(1,file='salida.asc')
      open(2,file='salida.xyz')

      N = 1000000
c     N : numero de datos
c
c
      write(*,*), 'Leyendo el archivo de datos ...'
      I = 1
10    if (mod(I,10000).EQ.0) then
         WRITE(*,'(A10,I8)')   'Numero  : ',I
      endif
      READ(1,*,end=20) (lon, lat, z,J=1,3)
      if (lon < 0) lon=lon+360
      write(2,'(2F11.6, 1F8.1)')(lon,lat,-z,J=1,3)
      I = I +1
      goto 10
      
20    write(*,*) 'Se grabo el archivo salida.xyz'
      close(1)
      close(2)
      stop
      end

