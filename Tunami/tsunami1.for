C Simulacion numerica de la propagacion del Maremoto para 1 grilla A
C**** EN LA MALLA "A" SE USA COORDENADAS ESFERICAS, TEORIA LINEAL
C Modificado por Cesar Jimenez, 22 Abr 2011
C Updated: 29 Ago 2022
c IA,JA          : Dimensiones de la grilla A
c IDS,IDE,JDS,JDE: Posicion relativa de la grilla de deformacion
c DX             : Resolucion de la grilla (en grados)
c DT             : Paso de tiempo en seg
c KE             : Numero total de pasos de computo
c KD             : Razon de muestreo del mareograma
c KA             : Separacion entre los snapshops
c NG             : Numero de mareografos virtuales
   
      PARAMETER(IDS= 1,IDE=2280,JDS= 1,JDE= 1440)
      PARAMETER(IA=2280, JA=1440)
      PARAMETER(DX=30.0/3600.0)
      PARAMETER(DT=0.75)
      PARAMETER(KE=9600,KD=40,KA=160)
      PARAMETER(NG=3)
      PARAMETER(RT=6.37E+6)
      REAL MA,NA
      CHARACTER PNAME
C  
      integer fecha, time1, time2, mm,hh,ss
      dimension fecha(3), time1(3), time2(3)
      DIMENSION IP(NG),JP(NG)
      DIMENSION PNAME(NG),PZ(NG)
      COMMON /AXA/ ZA(IA,JA,2),MA(IA,JA,2),NA(IA,JA,2),ZMXA(IA,JA)
      COMMON /AHA/ HA(IA,JA),RXA(JA),CJA(JA),TMX(IA,JA),ZMX(IA,JA)
      COMMON /ADA/ HMA(IA,JA),HNA(IA,JA),XXA(IA,JA),YYA(IA,JA)
C    
      call itime(time1)
      PI=4.0*ATAN(1.0)

C*****INPUT: BLAT = EXTREMO SUR DE LATITUD (EN GRADOS)
      BLATA=-59.9306
C
C*****PASO DE MALLA EN RADIANES
      DA=PI*DX/180.0
C
      OPEN(1,FILE='grid_a5.grd')
      OPEN(2,FILE='deform_a.grd')
      OPEN(3,FILE='tidal.dat',STATUS='OLD')
      OPEN(4,FILE='zfolder/green.dat')

C ***** Input Datos de Mareografos *****

      DO IN=1,NG
      READ(3,*)PNAME(IN),IP(IN),JP(IN)
      END DO
      CLOSE(3)

C ********   INPUT GRID    ***********
C
      CALL INPUTA(HA,IA,JA) 
      CALL HMN(IA,JA,HA,HMA,HNA)
      CALL CEROS(IA,JA,ZA,MA,NA)
      CALL DEFORMA(IA,JA,ZA,IDS,IDE,JDS,JDE)
C
C*****CALCULOS PRELIMINARES
C
      CALL PRELIM(IA,JA,RT,DA,DT,HMA,HNA,BLATA,RXA,CJA,XXA,YYA)                             
C
C ================= CHECK TIDE GAUGE LOCATION =================

      WRITE(*,'(A30)')
     &'OUTPUT POINT   ( I,  J ) DEPTH'
      DO IN=1,NG
      WRITE(*,'(I10,2I6,F9.1)') IN,IP(IN),JP(IN),HA(IP(IN),JP(IN))
        IF(HA(IP(IN),JP(IN)).LT.0) THEN
        WRITE(*,*) 'Tidal gauge located on ground'
        END IF
      END DO
      WRITE(*,*)'No tidal gauge locate on ground'

C *********    MAIN CALCULATION    ********** 
C
      DO  10  K = 1 , KE
      KK=K-1
      IF(MOD(K,10).EQ.0) THEN
         WRITE(*,'(A10,I5,A7,I5)')   'Numero  : ',K,'-th de ',KE
      ENDIF       
      CALL MASS(IA,JA,ZA,MA,NA,HA,RXA,CJA)
      CALL BOUT(IA,JA,ZA,MA,NA,HA)
      CALL MMNT(IA,JA,ZA,MA,NA,HA,XXA,YYA)

      IF(MOD(KK,KD).EQ.0) THEN
      DO KG=1,NG
         PZ(KG)=ZA(IP(KG),JP(KG),2)
      END DO
      WRITE(4,'(F5.1,100F9.4)')KK*DT/60.0,(PZ(KG),KG=1,NG)

C      WRITE(4,33) ZA(826,50,2),ZA(841,192,2),ZA(906,355,2),
C     & ZA(919,492,2),ZA(942,620,2),ZA(529,656,2),ZA(961,772,2)
C        
            CALL ZMAX(IA,JA,ZA,ZMXA)
            CALL TMAX(IA,JA,TMX,ZMX,ZA,KK,DT)

            ELSE
            ENDIF
		  
            IF(MOD(KK,KA).EQ.0) THEN
            CALL MOVIE(KK,KA,IA,JA,ZA)

            ELSE
            ENDIF 

33    FORMAT(300F10.4)

      CALL CHAN(IA,JA,ZA,MA,NA)

10    CONTINUE
      CLOSE(4)
C Solo inversion
      OPEN(5,FILE='zfolder/tmax_a.grd')
      DO 20 I=1,IA
20    WRITE(5,50) (TMX(I,J),J=1,JA)
      CLOSE(5)

      OPEN(6,FILE='zfolder/zmax_a.grd')
      DO 30 I=1,IA
30    WRITE(6,50) (ZMXA(I,J),J=1,JA)
      CLOSE(6)

50    FORMAT(4000F8.2)
C Fin solo inversion
      call itime(time2)  
      hh = time2(1)-time1(1)
      mm = time2(2)-time1(2)
      ss = time2(3)-time1(3)
      if (ss < 0) then
        mm = mm-1
        ss = ss+60
      end if
      if (mm < 0) then
        mm = mm+60
      end if
      write(*,'(A20,I2,A1,I2)') 'Tiempo de corrida: ', mm,':',ss

      STOP
      END
C***** DE AQUI EN DELANTE NO ALTERAR
C*******************************************************
C*******************************************************
C*******************************************************
C*******************************************************
C**** SE LEEN LA BATIMETRIA DEL DOMINIO A
      SUBROUTINE INPUTA(HA,IA,JA) 
      DIMENSION HA(IA,JA)
      
C     OPEN(1,FILE='grid_a5.grd')
      DO 10 I=1,IA
10    READ(1,*) (HA(I,J),J=1,JA)
      CLOSE(1)

      DO 20 J=1,JA
      DO 20 I=1,IA
20    IF(HA(I,J).GT.0.0.AND.HA(I,J).LT.10.0) HA(I,J)=10.0
        
      RETURN
      END
C
C*****SE LEE LA DEFORMACION O CONDICION INICIAL
C
      SUBROUTINE DEFORMA(IA,JA,Z,IDS,IDE,JDS,JDE)
      DIMENSION Z(IA,JA,2)
   
C     OPEN(2,FILE='deform_a.grd')
      DO 10 I=IDS,IDE
10    READ(2,*) (Z(I,J,1),J=JDS,JDE)
      CLOSE(2)

      RETURN
      END
C
C*****MOM (MAXIMUM OF MAXIMUM)
C
	SUBROUTINE ZMAX(II,JJ,Z,ZMX)

      DIMENSION Z(II,JJ,2),ZMX(II,JJ)

      DO 10 J=1,JJ
      DO 10 I=1,II
10    IF(Z(I,J,2).GT.ZMX(I,J)) ZMX(I,J)=Z(I,J,2)

      RETURN
      END
C
C************** Tsunami Travel Time Matrix   **********************************
C
      SUBROUTINE TMAX(IA,JA,TMX,ZMX,Z,KK,DT)
C     TMX = travel time matrix (minutes)
      DIMENSION Z(IA,JA,2),ZMX(IA,JA)
      DIMENSION TMX(IA,JA)
      
      DO 10 J=2,JA
      DO 10 I=2,IA

        IF (ZMX(I,J).GT.0.9)  GO TO 10

        IF(  Z(I,J,2) .GT. 0.005) THEN
        ZMX(I,J)=1.0
        TMX(I,J)=FLOAT(KK)*DT/60.0

        ELSE
        ENDIF

10    CONTINUE

      RETURN
      END
C
C**** WRITE TSUNAMI FRAMES AT "KA" TIME STEPS
C
      SUBROUTINE MOVIE(KK,KA,IA,JA,ZA)
 	DIMENSION ZA(IA,JA,2)
    	CHARACTER NAME*50

      KT=KK/KA
   	WRITE(NAME,100) KT + 1000
100   FORMAT('zfolder/z',I4)    
      OPEN(7,FILE=NAME)
	DO 10 I=1,IA
10    WRITE(7,22) (ZA(I,J,2),J=1,JA)
      CLOSE(7)
22	FORMAT(4000F9.2)

	RETURN
      END	   
C
C****CALCULOS PRELIMINARES PARA CONSERVACION DE MASA Y MOMENTO 
C    RZ=LATITUD EN NODOS DE ELEVACION
C    RN=LATITUD EN NODOS DE VELOCIDAD MERIDIONAL
C    RT=RADIO DE LA TIERRA
C    RX=FACTOR EN CONSERVACION DE MASA
C    CJ=FACTOR EN CONSERVACION DE MASA
C    XX=FACTOR EN CONSERVACION DE MOMENTO LONGITUDINAL
C    YY=FACTOR EN CONSERVACION DE MOMENTO MERIDIONAL
C    DY=PASO DE MAYA EN RADIANES
C    DT=PASO DE TIEMPO EN SEGUNDOS
C    BLAT=EXTREMO SUR DE LATITUD EN GRADOS (+N, -S)
      SUBROUTINE PRELIM(IA,JA,RT,DY,DT,HM,HN,BLAT,RX,CJ,XX,YY) 
      DIMENSION  RX(JA),CJ(JA),HM(IA,JA),HN(IA,JA)
      DIMENSION  XX(IA,JA),YY(IA,JA)

      PI=4.0*ATAN(1.0)
      GG=9.8

	RZ=BLAT*PI/180.0
	RN=RZ+DY/2.0

      DO 30 J=1,JA
	RX(J)=DT/(RT*COS(RZ)*DY)
	CJ(J)=COS(RN)
      RZ=RZ + DY
      RN=RN + DY
30    CONTINUE

	DO 40 J=1,JA
	DO 40 I=1,IA
	XX(I,J)=RX(J)*GG*HM(I,J)
	YY(I,J)=DT*GG*HN(I,J)/(RT*DY)
40    CONTINUE

      RETURN
      END
C*****
C*****SE CALCULAN LAS PROFUNDIDADES EN LOS PUNTOS EN DONDE SE EVALUAN
C*****LAS DESCARGAS.

      SUBROUTINE HMN(IF,JF,HZ,HM,HN)
 
      DIMENSION HZ(IF,JF),HM(IF,JF),HN(IF,JF)
 
      DO 10 J=1,JF
        DO 10 I=1,IF
          IF(I.EQ.IF) GO TO 11
          HH=0.5*(HZ(I,J)+HZ(I+1,J))
       
          HM(I,J)=HH
          GO TO 12
11        HM(I,J)=HZ(I,J)
12        IF(J.EQ.JF) GO TO 13
          HH=0.5*(HZ(I,J)+HZ(I,J+1))
 
          HN(I,J)=HH
          GO TO 10
13        HN(I,J)=HZ(I,J)
10    CONTINUE
 
      RETURN
      END      
C
C*****CONSERVACION DE MASA EN ESFERICAS (LINEAL)
C
      SUBROUTINE MASS(IA,JA,Z,M,N,H,RX,CJ)

      REAL M,N
      DIMENSION Z(IA,JA,2),M(IA,JA,2),N(IA,JA,2),H(IA,JA)
      DIMENSION RX(JA),CJ(JA)

      DO 10 J=2,JA
        DO 10 I=2,IA
          IF(H(I,J).GT.0.0)THEN 
          Z(I,J,2)=Z(I,J,1)-RX(J)*( M(I,J,1)-M(I-1,J,1) )
     &  -RX(J)*( N(I,J,1)*CJ(J) - N(I,J-1,1)*CJ(J-1) )
          IF(ABS(Z(I,J,2)).LT.1.0E-5) Z(I,J,2)=0.0
          ELSE
            Z(I,J,2)=0.0
          ENDIF
   10 CONTINUE 
      RETURN
      END 
C
C***** CONSERVACION DE MOMENTO LINEAL EN ESFERICAS (SIN FRICCION)
C
      SUBROUTINE MMNT(IA,JA,Z,M,N,H,XX,YY)
	           
      REAL M,N     
      DIMENSION Z(IA,JA,2),M(IA,JA,2),N(IA,JA,2)
      DIMENSION H(IA,JA)
      DIMENSION XX(IA,JA),YY(IA,JA)

      DO 10 J=2,JA
        DO 10 I=2,IA-1        
        IF(H(I,J).GT.0.0.AND.H(I+1,J).GT.0.0)THEN
        M(I,J,2)=M(I,J,1)-XX(I,J)*( Z(I+1,J,2)-Z(I,J,2) )
          IF(ABS(M(I,J,2)).LT.1.0E-5) M(I,J,2)=0.0
          ELSE
            M(I,J,2)=0.0
          ENDIF
   10 CONTINUE
      
      DO 20 J=2,JA-1
        DO 20 I=2,IA
        IF(H(I,J).GT.0.0.AND.H(I,J+1).GT.0.0) THEN      
        N(I,J,2)=N(I,J,1)-YY(I,J)*(Z(I,J+1,2)-Z(I,J,2))
          IF(ABS(N(I,J,2)).LT.1.0E-5) N(I,J,2)=0.0
          ELSE
            N(I,J,2)=0.0
          ENDIF

   20 CONTINUE
      RETURN
      END
C
C**** CONDICIONES DE FRONTERA ABIERTA EN EL DOMINIO "A"

      SUBROUTINE BOUT(IA,JA,ZA,MA,NA,HA)

      REAL MA,NA
      DIMENSION ZA(IA,JA,2),MA(IA,JA,2),NA(IA,JA,2),HA(IA,JA)
 
      DO 10 KK=1,2
        J=2
        IF(KK.EQ.2)J=JA
        DO 10 I=2,IA-1
          IF(HA(I,J).LT.0.0)GOTO 10
          CC=SQRT(9.8*HA(I,J))
          UU=0.5*ABS(MA(I,J,2)+MA(I-1,J,2))
          IF(J.EQ.2)UU=SQRT(UU**2+NA(I,J,2)**2)
          IF(J.EQ.JA)UU=SQRT(UU**2+NA(I,J-1,2)**2)
          ZZ=UU/CC
          IF(J.EQ.2.AND.NA(I,J,2).GT.0.0)ZZ=-ZZ
          IF(J.EQ.JA.AND.NA(I,J-1,2).LT.0.0)ZZ=-ZZ
          ZA(I,J,2)=ZZ
   10 CONTINUE
      DO 20 KK=1,2
        I=2
        IF(KK.EQ.2)I=IA
        DO 20 J=2,JA-1
          IF(HA(I,J).LT.0.0)GOTO 20
          CC=SQRT(9.8*HA(I,J))
          UU=0.5*ABS(NA(I,J,2)+NA(I,J-1,2))
          IF(I.EQ.2)UU=SQRT(UU**2+MA(I,J,2)**2)
          IF(I.EQ.IA)UU=SQRT(UU**2+MA(I-1,J,2)**2)
          ZZ=UU/CC
          IF(I.EQ.2.AND.MA(I,J,2).GT.0.0)ZZ=-ZZ
          IF(I.EQ.IA.AND.MA(I-1,J,2).LT.0.0)ZZ=-ZZ
          ZA(I,J,2)=ZZ
   20 CONTINUE
 
      RETURN
      END
C****
C
      SUBROUTINE CHAN(IF,JF,Z,M,N)
C
      REAL M,N
      DIMENSION Z(IF,JF,2),M(IF,JF,2),N(IF,JF,2)
      DO 10 J=1,JF
      DO 10 I=1,IF
      Z(I,J,1) = Z(I,J,2)
      M(I,J,1) = M(I,J,2)
      N(I,J,1) = N(I,J,2)
10    CONTINUE
      RETURN
      END
C
      SUBROUTINE CEROS(IF,JF,Z,M,N)
C
      REAL M,N
      DIMENSION Z(IF,JF,2),M(IF,JF,2),N(IF,JF,2)
        
      DO 100 L=1,2
      DO 10 J=1,JF
      DO 10 I=1,IF
      Z(I,J,L)=0.0 
      M(I,J,L)=0.0 
      N(I,J,L)=0.0           
10    CONTINUE 
100   CONTINUE
      RETURN
      END
C
