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
    subroutine lcumef(rela_plas, dep, depm, an, bn,&
                      cn, epsm, epsrm, epsrp, depsi,&
                      epsfm, sigi, nstrs, sigt)
        character(len=16), intent(in) :: rela_plas
        real(kind=8) :: dep(6, 6)
        real(kind=8) :: depm(6, 6)
        real(kind=8) :: an(6)
        real(kind=8) :: bn(6, 6)
        real(kind=8) :: cn(6, 6)
        real(kind=8) :: epsm(6)
        real(kind=8) :: epsrm
        real(kind=8) :: epsrp
        real(kind=8) :: depsi(6)
        real(kind=8) :: epsfm(6)
        real(kind=8) :: sigi(6)
        integer :: nstrs
        real(kind=8) :: sigt(6)
    end subroutine lcumef
end interface
