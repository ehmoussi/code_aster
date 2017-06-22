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

subroutine vectrn(nb2, vectpt, vectn, vecthe, vecnph,&
                  blam)
!
    implicit none
!
#include "asterfort/marota.h"
#include "asterfort/promat.h"
#include "asterfort/r8inir.h"
    integer :: nb2
!
    integer :: ii, jj
!
    integer :: in
!
    real(kind=8) :: vectn ( 9 , 3 )
!
    real(kind=8) :: vecthe ( 9 , 3 )
!
    real(kind=8) :: vecnph ( 9 , 3 )
!
    real(kind=8) :: vecni ( 3 ), vecnpi ( 3 )
!
    real(kind=8) :: theta ( 3 ), lambda ( 3 , 3 )
    real(kind=8) :: lambd0 ( 3 , 3 )
    real(kind=8) :: barl ( 3 , 3 )
!
    real(kind=8) :: blam ( 9 , 3 , 3 )
!
    real(kind=8) :: vectpt ( 9 , 2 , 3 )
!
!DEB
!
!---- INITIALISATIONS
!
    call r8inir(9 * 3, 0.d0, vecnph, 1)
!
    call r8inir(9 * 3 * 3, 0.d0, blam, 1)
!
!---- EN CHAQUE NOEUD
!
    do 100 in = 1, nb2
!
!---- COMPOSANTE PAR COMPOSANTE
!
        do 110 ii = 1, 3
!
!---------- NORMALE INITIALE
!
            vecni ( ii ) = vectn ( in , ii )
!
!---------- VECTEUR DE ROTATION
!
            theta ( ii ) = vecthe ( in , ii )
!
!---------- TERMES DE LA LAMBD0
!
            lambd0 ( ii , 1 ) = vectpt ( in , 1 , ii )
            lambd0 ( ii , 2 ) = vectpt ( in , 2 , ii )
            lambd0 ( ii , 3 ) = vectn ( in , ii )
!
110      continue
!
!------- TRANSFORMEE DE LA NORMALE PAR GRANDE ROTATION
!
!------- MATRICE DE ROTATION
!
        call marota(theta, lambda)
!
!------- TRANSFORMEE DE LA NORMALE
!
        call promat(lambda, 3, 3, 3, vecni,&
                    3, 3, 1, vecnpi)
!
!------- MATRICE DE ROTATION TOTALE
!
        call promat(lambda, 3, 3, 3, lambd0,&
                    3, 3, 3, barl)
!
!
        do 130 jj = 1, 3
!
!---------- EN CHAQUE NOEUD
!
            vecnph ( in , jj ) = vecnpi ( jj )
!
            do 140 ii = 1, 3
!
                blam ( in , ii , jj ) = barl ( ii , jj )
!
140          continue
!
130      continue
!
100  end do
!
!FIN
!
end subroutine
