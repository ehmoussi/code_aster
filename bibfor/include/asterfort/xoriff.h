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
    subroutine xoriff(info, nfon, jfono, jbaso, jtailo,&
                      nmafon, listpt, goinop, jfon, jnofaf, jbas,&
                      jtail, fonmul, nbfond)
        character(len=19) :: info
        integer :: nfon
        integer :: jfono
        integer :: jbaso
        integer :: jtailo
        integer :: nmafon
        character(len=19) :: listpt
        aster_logical :: goinop
        integer :: jfon
        integer :: jnofaf
        integer :: jbas
        integer :: jtail
        character(len=24) :: fonmul
        integer :: nbfond
    end subroutine xoriff
end interface
