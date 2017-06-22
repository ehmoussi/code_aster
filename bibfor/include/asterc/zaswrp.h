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
    subroutine zaswrp(numa, modele, nvar, ndef, nunit,&
                      instam, instap, nvarcm, nomvar, varplu,&
                      varmoi, varref, epsm, deps, sigm,&
                      vim, nopt, angeul, sigp, vip,&
                      dsidep, codret)
        integer :: numa
        integer :: modele
        integer :: nvar
        integer :: ndef
        integer :: nunit
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: nvarcm
        character(len=*) :: nomvar(*)
        real(kind=8) :: varplu(*)
        real(kind=8) :: varmoi(*)
        real(kind=8) :: varref(*)
        real(kind=8) :: epsm(*)
        real(kind=8) :: deps(*)
        real(kind=8) :: sigm(*)
        real(kind=8) :: vim(*)
        integer :: nopt
        real(kind=8) :: angeul(*)
        real(kind=8) :: sigp(*)
        real(kind=8) :: vip(*)
        real(kind=8) :: dsidep(*)
        integer :: codret
    end subroutine zaswrp
end interface
