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
    subroutine evali2(isz, pg, nma, phi, valpar,&
                      posmai, ipg, pdgi, icmp, nocmpi,&
                      sphi)
        character(len=8) :: isz
        character(len=19) :: pg
        integer :: nma
        character(len=19) :: phi
        real(kind=8) :: valpar(7)
        integer :: posmai
        integer :: ipg
        real(kind=8) :: pdgi
        integer :: icmp
        character(len=8) :: nocmpi
        character(len=19) :: sphi
    end subroutine evali2
end interface
