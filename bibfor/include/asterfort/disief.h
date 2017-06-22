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
    subroutine disief(nbt, neq, nno, nc, pgl,&
                      klv, dul, sim, ilogic, duly,&
                      sip, fono, force, dimele)
        integer :: neq
        integer :: nbt
        integer :: nno
        integer :: nc
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: klv(nbt)
        real(kind=8) :: dul(neq)
        real(kind=8) :: sim(neq)
        integer :: ilogic
        real(kind=8) :: duly
        real(kind=8) :: sip(neq)
        real(kind=8) :: fono(neq)
        real(kind=8) :: force(3)
        integer :: dimele
    end subroutine disief
end interface
