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
    subroutine gcouro(base, resu, noma, nomno, coorn,&
                      lobj2, trav1, trav2, trav3, dir,&
                      nomnoe, fond, direc, stok4)
        character(len=1) :: base
        character(len=24) :: resu
        character(len=8) :: noma
        character(len=24) :: nomno
        character(len=24) :: coorn
        integer :: lobj2
        character(len=24) :: trav1
        character(len=24) :: trav2
        character(len=24) :: trav3
        real(kind=8) :: dir(3)
        character(len=8) :: nomnoe(*)
        character(len=8) :: fond
        aster_logical :: direc
        character(len=24) :: stok4
    end subroutine gcouro
end interface
