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
interface
    subroutine corddl(admodl, lcmodl, idprn1, idprn2, ili,&
                      mode, nec, ncmp, n, k,&
                      nddloc, pos)
        integer :: admodl
        integer :: lcmodl
        integer :: idprn1
        integer :: idprn2
        integer :: ili
        integer :: mode
        integer :: nec
        integer :: ncmp
        integer :: n
        integer :: k
        integer :: nddloc
        integer :: pos(1)
    end subroutine corddl
end interface
