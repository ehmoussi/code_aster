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
! aslint: disable=W1504
!
interface 
    subroutine xcomhm(option, imate, compor, instap,&
                      ndim, dimdef, dimcon, nbvari,&
                      yamec, yap1, yap2, yate,&
                      addeme, adcome, addep1, adcp11,&
                      addep2, addete, defgem,&
                      defgep, congem, congep, vintm,&
                      vintp, dsde, pesa, retcom, kpi,&
                      npg, dimenr,&
                      idecpg, angmas, yaenrh, adenhy, nfh)
        integer :: dimenr
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        character(len=16) :: option
        integer :: imate
        character(len=16) :: compor(*)
        real(kind=8) :: instap
        integer :: yamec
        integer :: yap1
        integer :: yap2
        integer :: yate
        integer :: addeme
        integer :: adcome
        integer :: addep1
        integer :: adcp11
        integer :: addep2
        integer :: addete
        real(kind=8) :: defgem(1:dimdef)
        real(kind=8) :: defgep(1:dimdef)
        real(kind=8) :: congem(1:dimcon)
        real(kind=8) :: congep(1:dimcon)
        real(kind=8) :: vintm(1:nbvari)
        real(kind=8) :: vintp(1:nbvari)
        real(kind=8) :: dsde(1:dimcon, 1:dimenr)
        real(kind=8) :: pesa(3)
        integer :: retcom
        integer :: kpi
        integer :: npg
        integer :: idecpg
        real(kind=8) :: angmas(3)
        integer :: yaenrh
        integer :: adenhy
        integer :: nfh
    end subroutine xcomhm
end interface 
