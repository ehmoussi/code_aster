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
    subroutine pcstru(n, in, ip, icpl, icpc,&
                      icpd, icpcx, icplx, niveau, complt,&
                      lca, imp, ier)
        integer :: n
        integer :: in(n)
        integer(kind=4) :: ip(*)
        integer :: icpl(0:n)
        integer(kind=4) :: icpc(*)
        integer :: icpd(n)
        integer :: icpcx(*)
        integer :: icplx(0:n)
        integer :: niveau
        aster_logical :: complt
        integer :: lca
        integer :: imp
        integer :: ier
    end subroutine pcstru
end interface
