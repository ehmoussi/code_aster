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

subroutine vectpe(nb1, nb2, vecu, vectn, vecnph,&
                  vecpe)
!
    implicit none
!
#include "asterfort/r8inir.h"
    integer :: nb1, nb2
!
    integer :: ii
!
    integer :: in
!
    real(kind=8) :: vectn ( 9 , 3 )
!
    real(kind=8) :: vecnph ( 9 , 3 )
!
    real(kind=8) :: vecu ( 8 , 3 )
!
    real(kind=8) :: vecpe ( 51 )
!
!DEB
!
!---- INITIALISATION
!
    call r8inir(51, 0.d0, vecpe, 1)
!
    do 200 in = 1, nb1
!
!----------- NOEUDS DE SERENDIP
!
        do 210 ii = 1, 3
!
            vecpe ((in-1)*6+ ii )= vecu ( in , ii )
!
            vecpe ((in-1)*6+ ii + 3 )= vecnph ( in , ii ) - vectn&
            ( in , ii )
!
210      continue
!
200  end do
!
!---- SUPERNOEUD
!
    do 220 ii = 1, 3
!
        vecpe ( (nb1)*6+ ii )= vecnph ( nb2, ii ) - vectn ( nb2, ii )
!
220  end do
!
!
!
!
!
!FIN
!
end subroutine
