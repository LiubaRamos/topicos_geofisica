      parameter (IF = 600, IJ = 240)
      real H0(IF,IJ),H(IF*IJ)   ! H(i,j) i:y�@j:x
	  open(1,file='prueba.asc')
	  open(2,file='prueba.dat')
	  iz=IF*IJ
	  do 10 i=1,iz
	  read(1,*)H(i) 
   10 continue
	  ii=0
	  do 15 i=1,IF
	   do 15 j=1,IJ
	   ii=ii+1
            H0(i,j)=-H(ii)
   15 continue 
	  do i=1,IF
	  write(2,'(1641f15.2)')(H0(i,j),j=1,IJ)
	  end do
	  end
	  