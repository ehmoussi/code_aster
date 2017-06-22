! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine hsj1f(intsn, xr, epais, vectg, vectt,&
                 hsf, kwgt, hsj1fx, wgt)
    implicit none
#include "asterfort/jacbm1.h"
    integer :: intsn, kwgt
    real(kind=8) :: xr(*)
    real(kind=8) :: vectg(2, 3), vectt(3, 3), matj(3, 3), jm1(3, 3), epais, detj
    real(kind=8) :: hsf(3, 9), hsj1fx(3, 9), wgt
!
!     CONSTRUCTION DE J-1 AUX PTS DE GAUSS NORMAL.    J = JACOBIEN
!
!-----------------------------------------------------------------------
    integer :: i, j, j1, jb, k, k1
    real(kind=8) :: wgt1
!-----------------------------------------------------------------------
    call jacbm1(epais, vectg, vectt, matj, jm1,&
                detj)
!
!     CONSTRUCTION DE HFM * S * JTILD-1 AUX PTS D'INTEGRATION NORMAL
!
!     HFM * S = HSF = ( HSF11 , HSF12 , HSF13 )  OU   HSF1J (3,3)
!
!               J-1 0  0
!     JTILD-1 = 0  J-1 0                       OU   J-1   (3,3)
!               0   0  J-1
!
!           IB=1,1
    do 10 jb = 1, 3
        do 20 i = 1, 3
            do 30 j = 1, 3
                j1=j+3*(jb-1)
                hsj1fx(i,j1)=0.d0
                do 40 k = 1, 3
                    k1=k+3*(jb-1)
                    hsj1fx(i,j1)=hsj1fx(i,j1)+hsf(i,k1)*jm1(k,j)
40              end do
30          end do
20      end do
10  end do
!
!     DEFINTION DE WGT = PRODUIT DES POIDS ASSOCIES AUX PTS
!      DE GAUSS (NORMAL)  ET DE DETJ
!
!
    wgt1=  xr(127-1+intsn)
!
    wgt =wgt1*detj
!
!     STOCKAGE DE WGT DANS XR : A PARTIR DE L'ADRESSE 1181
!
    kwgt=kwgt+1
    xr(1180+kwgt)=wgt
!
end subroutine
