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
    subroutine onmetl(nbnd, nadj, xadjd, adjncy, invpnd,&
                      permnd, supnd, parent, nbsn, nbops,&
                      fctnzs, lgind, niv)
        integer(kind=4) :: nbnd
        integer(kind=4) :: nadj
        integer(kind=4) :: xadjd
        integer(kind=4) :: adjncy
        integer(kind=4) :: invpnd
        integer(kind=4) :: permnd
        integer(kind=4) :: supnd
        integer(kind=4) :: parent
        integer(kind=4) :: nbsn
        real(kind=8) :: nbops
        integer(kind=4) :: fctnzs
        integer(kind=4) :: lgind
        integer :: niv
    end subroutine onmetl
end interface
