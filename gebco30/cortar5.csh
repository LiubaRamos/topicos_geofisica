#!/bin/csh

set BATHYFILE0=gebco_08.nc
set BATHYFILE1=cortado.grd
set REGION=-105.0/-68.0/-30.0/05.0

#echo cut the bathymetry domain...
gmt grdcut $BATHYFILE0 -G$BATHYFILE1 -R$REGION -V 
gmt grd2xyz $BATHYFILE1 -R$REGION -s -fig -fog -V > salida.asc

# Resample the bathymetry
#set REGION0=-79.0/-76.0/-15.0/-12.0
#grdsample $BATHYFILE1 -Gtemp1.grd -I30c/30c -R$REGION -V 
#grdmath temp1.grd -1 MUL -V = temp3.grd
#grd2xyz temp3.grd -R$REGION -s -fig -fog -V > salida2.xyz

#echo Transform to raster...
#set PSPATH=c:\programs\gs9.02\bin\gswin64c
#ps2raster %PSFILE% -A -Tg -V -G%PSPATH%    

rm temp*.*
rm cortado.grd
