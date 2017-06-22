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

subroutine dil2gr(imate, compor, ndim, regula, dimdef,&
                  defgep, sigp, dsde2g)
! --- BUT : CALCUL DE LA LOI DE COMPORTEMENT ELASTIQUE POUR LA PARTIE --
! ---       SECOND GRADIENT --------------------------------------------
! ======================================================================
    implicit none
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
    integer :: imate, ndim, dimdef, regula(6)
    real(kind=8) :: sigp(ndim), dsde2g(ndim, ndim), defgep(dimdef)
    character(len=16) :: compor(*)
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j, adder2
    real(kind=8) :: val(5)
    integer :: icodre(5), kpg, spt
    character(len=8) :: ncra(5), fami, poum
! ======================================================================
! --- DEFINITION DES DONNEES INITIALES ---------------------------------
! ======================================================================
    data ncra  / 'A1','A2','A3','A4','A5' /
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    if (compor(1) .eq. 'ELAS') then
        do 10 i = 1, ndim
            do 20 j = 1, ndim
                dsde2g(j,i)=0.0d0
20          continue
10      continue
        call rcvalb(fami, kpg, spt, poum, imate,&
                    ' ', 'ELAS_2NDG', 0, ' ', [0.0d0],&
                    1, ncra(1), val(1), icodre(1), 1)
        call rcvalb(fami, kpg, spt, poum, imate,&
                    ' ', 'ELAS_2NDG', 0, ' ', [0.0d0],&
                    1, ncra(3), val(3), icodre(3), 1)
        do 30 i = 1, ndim
            dsde2g(i,i)=(1+ndim)*(val(1)-val(3))
30      continue
!
        adder2 = regula(2)
        do 40 i = 1, ndim
            sigp(i)=0.0d0
            do 50 j = 1, ndim
                sigp(i)=sigp(i)+dsde2g(i,j)*defgep(adder2-1+j)
50          continue
40      continue
    else
        call utmess('F', 'ALGORITH4_50', sk=compor(1))
    endif
! ======================================================================
end subroutine
