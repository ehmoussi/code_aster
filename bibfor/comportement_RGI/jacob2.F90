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

subroutine jacob2(a, d, s)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!
!       DIAGONALISATION DE A      SYMETRIQUE
!   ENTREEES
!        A(3,3) = MATRICE A DIAGONALISER  A(1,3)=A(2,3)=0.
!                                         A(3,1)=A(3,2)=0.
!   SORTIES
!        D(3)   =  LES 3 VALEURS PROPRES D(1) > D(2) ET D(3)=A(3,3)
!        S(3,3) =  VECTEURS PROPRES    S(I,3)=0. 0. 1.
!
!        RECUPERATION INCA FEVRIER 85    EBERSOLT
!====================================================================
    implicit none
#include "asterc/r8prem.h"
    real(kind=8) :: a(3, *)
    real(kind=8) :: d(*)
    real(kind=8) :: s(3, *)
    real(kind=8) :: x1, x2, x3, x4, x5, x6, x7
!
    x1  =2.*a(1,2)
    x2  =a(1,1)-a(2,2)
    x3  =sqrt(x2*x2+x1*x1)
    d(1)=0.5*(a(1,1)+a(2,2)+x3)
    d(2)=d(1)-x3
    d(3)=a(3,3)
    s(3,1)=0.
    s(3,2)=0.
    s(1,3)=0.
    s(2,3)=0.
    s(3,3)=1.
    if (abs(x2).lt.r8prem()) goto 70
    x4=x1/x2
    if (abs(x4) .lt. 1.e+10) goto 50
!
 70 continue
    x5    =sqrt(2.d0)*.5
    s(1,1)=x5
    s(2,1)=sign(x5,x1)
    s(1,2)=-s(2,1)
    s(2,2)=x5
    goto 100
!
 50 continue
    x5=1. + x4*x4
    x5=sign(1.d0,x2)/sqrt(x5)
    x6=(1.+x5)*.5
    x6=sqrt(x6)
    x7=(1.-x5)*.5
    x7=sign(1.d0,x1)*sqrt(x7)
    s(1,1)= x6
    s(2,1)= x7
    s(1,2)=-x7
    s(2,2)= x6
100 continue
 end subroutine
