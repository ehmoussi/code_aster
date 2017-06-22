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

function jxhcod(chain, lrep)
! aslint: disable=W1304,C1002,W0405
    implicit none
#include "asterc/strmov.h"
    integer :: jxhcod, lrep
    character(len=*) :: chain
    integer :: i1, j(4)
    integer(kind=4) :: i(8)
    equivalence (i(1), j(1))
!
!   ATTENTION, IL FAUT IMPERATIVEMENT UTILISER UN TABLEAU I AYANT
!   POUR LONGUEUR TOTALE 32 OCTETS (ICI 4*8) POUR S'ALIGNER SUR LA
!   CHAINE PASSEE EN ARGUMENT (32 CARACTERES MAXIMUM)
!
!-----------------------------------------------------------------------
    integer :: k
!-----------------------------------------------------------------------
    call strmov(chain, 1, 32, j, 1)
    do k = 2, 8
        i(1) = ieor( i(1) , i(k) )
    end do
    i1=i(1)
    jxhcod = 1 + mod(i1,lrep)
end function
