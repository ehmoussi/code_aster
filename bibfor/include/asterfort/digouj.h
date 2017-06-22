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
    subroutine digouj(option, compor, nno, nbt, neq,&
                      nc, icodma, dul, sim, varim,&
                      pgl, klv, klc, varip, fono,&
                      sip, nomte)
        integer :: neq
        integer :: nbt
        character(len=16) :: option
        character(len=16) :: compor(*)
        integer :: nno
        integer :: nc
        integer :: icodma
        real(kind=8) :: dul(neq)
        real(kind=8) :: sim(neq)
        real(kind=8) :: varim(*)
        real(kind=8) :: pgl(3, 3)
        real(kind=8) :: klv(nbt)
        real(kind=8) :: klc(neq, neq)
        real(kind=8) :: varip(*)
        real(kind=8) :: fono(neq)
        real(kind=8) :: sip(neq)
        character(len=16) :: nomte
    end subroutine digouj
end interface
