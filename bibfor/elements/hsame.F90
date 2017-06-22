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

subroutine hsame(vectt, dudx, hsm1, hsm2)
!
    implicit none
!
#include "asterfort/matsa.h"
#include "asterfort/promat.h"
    real(kind=8) :: vectt ( 3 , 3 )
!
    real(kind=8) :: dudx ( 9 )
!
    real(kind=8) :: hsm1 ( 3 , 9 )
!
    real(kind=8) :: hsm2 ( 3 , 9 )
!
    real(kind=8) :: hfm ( 3 , 6 )
!
    real(kind=8) :: sa1 ( 6 , 9 )
!
    real(kind=8) :: sa2 ( 6 , 9 )
!
!DEB
!
!
!     CONSTRUCTION DE  HFM  ( 3 , 6 ) MEMBRANE-FLEXION
!                                     ( ROUTINE HFMSS )
!
!
    hfm(1,1)=vectt(1,1)*vectt(1,1)
    hfm(1,2)=vectt(1,2)*vectt(1,2)
    hfm(1,3)=vectt(1,3)*vectt(1,3)
    hfm(1,4)=vectt(1,1)*vectt(1,2)
    hfm(1,5)=vectt(1,1)*vectt(1,3)
    hfm(1,6)=vectt(1,2)*vectt(1,3)
!
    hfm(2,1)=vectt(2,1)*vectt(2,1)
    hfm(2,2)=vectt(2,2)*vectt(2,2)
    hfm(2,3)=vectt(2,3)*vectt(2,3)
    hfm(2,4)=vectt(2,1)*vectt(2,2)
    hfm(2,5)=vectt(2,1)*vectt(2,3)
    hfm(2,6)=vectt(2,2)*vectt(2,3)
!
    hfm(3,1)=2*vectt(1,1)*vectt(2,1)
    hfm(3,2)=2*vectt(1,2)*vectt(2,2)
    hfm(3,3)=2*vectt(1,3)*vectt(2,3)
    hfm(3,4)=vectt(2,1)*vectt(1,2)+vectt(1,1)*vectt(2,2)
    hfm(3,5)=vectt(2,1)*vectt(1,3)+vectt(1,1)*vectt(2,3)
    hfm(3,6)=vectt(2,2)*vectt(1,3)+vectt(1,2)*vectt(2,3)
!
!
!---- MATRICES
!      SA1 ( 6 , 9 ) = ( S ) + 1 / 2 ( A ( DUDX ) ) POUR DEF TOT
!      SA2 ( 6 , 9 ) = ( S ) +       ( A ( DUDX ) ) POUR DEF DIF
!
    call matsa(dudx, sa1, sa2)
!
!---- MATRICE
    hsm1 ( 3 , 9 ) = hfm(3,6) * sa1 ( 6 , 9 )
!
    call promat(hfm, 3, 3, 6, sa1,&
                6, 6, 9, hsm1)
!
!---- MATRICE
    hsm2 ( 3 , 9 ) = hfm(3,6) * sa2 ( 6 , 9 )
!
    call promat(hfm, 3, 3, 6, sa2,&
                6, 6, 9, hsm2)
!
!
!
!FIN
!
end subroutine
