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

!
!
#include "asterf_types.h"
!
interface
    subroutine gcour3(resu, noma, coorn, lnoff, trav1,&
                      trav2, trav3, chfond, connex, grlt, liss, &
                      basfon, nbre, milieu,&
                      ndimte, typdis, nomfis)
        character(len=8) :: resu
        character(len=8) :: noma
        character(len=24) :: coorn
        integer :: lnoff
        character(len=24) :: trav1
        character(len=24) :: trav2
        character(len=24) :: trav3
        character(len=24) :: chfond
        aster_logical :: connex
        character(len=19) :: grlt
        character(len=24) :: liss
        character(len=24) :: basfon
        integer :: nbre
        aster_logical :: milieu
        integer :: ndimte
        character(len=16) :: typdis
        character(len=8) :: nomfis
    end subroutine gcour3
end interface
