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

subroutine hsash(vectt, dudx, hss1, hss2)
!
    implicit none
!
#include "asterfort/matsa.h"
#include "asterfort/promat.h"
    real(kind=8) :: vectt ( 3 , 3 )
!
    real(kind=8) :: dudx ( 9 )
!
    real(kind=8) :: hss1 ( 2 , 9 )
!
    real(kind=8) :: hss2 ( 2 , 9 )
!
    real(kind=8) :: hsh ( 2 , 6 )
!
    real(kind=8) :: sa1 ( 6 , 9 )
!
    real(kind=8) :: sa2 ( 6 , 9 )
!
!     CONSTRUCTION DE  HSH  ( 2 , 6 ) SHEAR
!
!
!DEB
!
!
!---- MATRICES
!      SA1 ( 6 , 9 ) = ( S ) + 1 / 2 ( A ( DUDX ) ) DEF TOT
!      SA2 ( 6 , 9 ) = ( S ) +       ( A ( DUDX ) ) DEF DIF
!
    call matsa(dudx, sa1, sa2)
!
!     CONSTRUCTION DE  HSH  ( 2 , 6 ) SHEAR ( ROUTINE HFMSS )
!
    hsh (1,1)=2*vectt(1,1)*vectt(3,1)
    hsh (1,2)=2*vectt(1,2)*vectt(3,2)
    hsh (1,3)=2*vectt(1,3)*vectt(3,3)
    hsh (1,4)=vectt(3,2)*vectt(1,1)+vectt(3,1)*vectt(1,2)
    hsh (1,5)=vectt(1,1)*vectt(3,3)+vectt(3,1)*vectt(1,3)
    hsh (1,6)=vectt(3,3)*vectt(1,2)+vectt(1,3)*vectt(3,2)
!
    hsh (2,1)=2*vectt(2,1)*vectt(3,1)
    hsh (2,2)=2*vectt(2,2)*vectt(3,2)
    hsh (2,3)=2*vectt(3,3)*vectt(2,3)
    hsh (2,4)=vectt(2,1)*vectt(3,2)+vectt(3,1)*vectt(2,2)
    hsh (2,5)=vectt(2,1)*vectt(3,3)+vectt(3,1)*vectt(2,3)
    hsh (2,6)=vectt(2,2)*vectt(3,3)+vectt(2,3)*vectt(3,2)
!
!---- MATRICE
    hss1 ( 2 , 9 ) = hsh(2,6) * sa1 ( 6 , 9 )
!
    call promat(hsh, 2, 2, 6, sa1,&
                6, 6, 9, hss1)
!
!---- MATRICE
    hss2 ( 2 , 9 ) = hsh(2,6) * sa2 ( 6 , 9 )
!
    call promat(hsh, 2, 2, 6, sa2,&
                6, 6, 9, hss2)
!
!
!
!FIN
!
end subroutine
