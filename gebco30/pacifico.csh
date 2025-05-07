#!/bin/csh

set REGION=130.0/180.0/-60.0/55.0
set BATHYFILE0=/media/cjimenez/datos/Topografia/gebco30/GridOne.nc
set BATHYFILE1=cortado.grd

#echo cut the bathymetry domain...
gmt grdcut $BATHYFILE0 -G$BATHYFILE1 -R$REGION -V 
#gmt grd2xyz $BATHYFILE1 -R$REGION -s -fig -fog -V > salida.asc

# Resample the bathymetry
#set REGION0=-78.0/-70.0/-21.0/-13.0
gmt grdsample $BATHYFILE1 -Gtemp1.grd -I300c/300c -R$REGION -V 
gmt grdmath temp1.grd -1 MUL -V = temp3.grd
gmt grd2xyz temp3.grd -R$REGION -s -fig -fog -V > salida1.xyz

#echo Transform to raster...
#set PSPATH=c:\programs\gs9.02\bin\gswin64c
#ps2raster %PSFILE% -A -Tg -V -G%PSPATH%    

rm temp*.*
rm cortado.grd

#gmt xyz2grd salida.xyz -D+xm+ym+zm -Gsalida.grd -R130/292/-60/55 -I300s
