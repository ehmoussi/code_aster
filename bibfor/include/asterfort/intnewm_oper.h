! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine intnewm_oper(nbequ, par, mgen, kgen, agen, &
                            ktilda, ftild1, ftild2, ftild3)
        integer     , intent(in)  :: nbequ
        real(kind=8)              :: par(:)
        real(kind=8), pointer  :: mgen(:)
        real(kind=8), pointer  :: kgen(:)
        real(kind=8), pointer  :: agen(:)
        real(kind=8), pointer :: ktilda(:)
        real(kind=8), pointer :: ftild1(:)
        real(kind=8), pointer :: ftild2(:)
        real(kind=8), pointer :: ftild3(:)
    end subroutine intnewm_oper
end interface
