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
    subroutine dicorn(irmetg, nbt, neq, iterat, icodma,&
                      ul, dul, utl, sim, varim,&
                      klv, klv2, varip)
        integer :: neq
        integer :: nbt
        integer :: irmetg
        integer :: iterat
        integer :: icodma
        real(kind=8) :: ul(neq)
        real(kind=8) :: dul(neq)
        real(kind=8) :: utl(neq)
        real(kind=8) :: sim(neq)
        real(kind=8) :: varim(7)
        real(kind=8) :: klv(nbt)
        real(kind=8) :: klv2(nbt)
        real(kind=8) :: varip(7)
    end subroutine dicorn
end interface
