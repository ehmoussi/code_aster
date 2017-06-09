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
    subroutine pieigv(neps, tau, imate, vim, epsm,&
                      epspc, epsdc, typmod, etamin, etamax,&
                      copilo)
        integer :: neps
        real(kind=8) :: tau
        integer :: imate
        real(kind=8) :: vim(2)
        real(kind=8) :: epsm(neps)
        real(kind=8) :: epspc(neps)
        real(kind=8) :: epsdc(neps)
        character(len=8) :: typmod(2)
        real(kind=8) :: etamin
        real(kind=8) :: etamax
        real(kind=8) :: copilo(2, 2)
    end subroutine pieigv
end interface
