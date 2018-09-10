! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

SUBROUTINE b3d_degre3(as0,as1,as2,xr1,xi1,&
                                                 xr2,xi2,xr3,xi3)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!   passage test en double precision A.Sellier dim. 29 août 2010 07:48:35
                       
implicit none
      real (kind=8) :: TR,Q,R,D,SOM,DIF,SD,S1,S2
      real (kind=8) :: as1,as2,as0,xr1,xi1,xr2,xi2,xr3
      real (kind=8) :: xi3,ARG,RO
!-INC CCOPTIO                                                           
!                                                                       
!                                                                       
!        POLYNOME DE DEGRE 3 SOUS LA FORME                              
!        X3 + as2*X2 + as1*X + as0 = 0                                  
!                                                                       
!                                                                       
!                                                                       
    TR=dSQRT(3.D0)
    Q=as1/3.D0-as2*as2/9.D0
    R=(as1*as2-3.D0*as0)/6.D0-as2*as2*as2/27.D0
    D=Q*Q*Q+R*R                                                         
    
    if (D.gt.0) then
        SD=dSQRT(D)
        S1=dSIGN(1.D0,R+SD)*((dABS(R+SD))**(1.D0/3.D0))
        S2=dSIGN(1.D0,R-SD)*((dABS(R-SD))**(1.D0/3.D0))
        xr1=S1+S2-as2/3.D0
        xi1=0.D0
        xr2=-(S1+S2)/2.D0-as2/3.D0
        xi2=TR*(S1-S2)/2.D0
        xr3=xr2
        xi3=-xi2
    else
        SD=dSQRT(-D)
        RO=(R*R-D)**(1.D0/6.D0)
        ARG=DATAN2(SD,R)/3.D0
        if (dabs(arg).lt. 1.d-7) arg=0.d0
        SOM=RO*dCOS(ARG)
        DIF=RO*dSIN(ARG)
        xr1=SOM*2.D0-as2/3.D0
        xi1=0.D0
        xr2=-SOM   -as2/3.D0-TR*DIF
        xi2=0.D0
        xr3=-SOM   -as2/3.D0+TR*DIF
        xi3=0.D0
    endif
end subroutine
