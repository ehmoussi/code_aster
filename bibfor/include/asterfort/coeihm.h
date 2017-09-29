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
#include "asterf_types.h"
!
interface 
    subroutine coeihm(option, l_steady, resi, rigi, j_mater,&
                      compor, instam, instap, nomail,&
                      ndim, dimdef, dimcon, nbvari,&
                      addeme, adcome, addep1, adcp11, adcp12,&
                      addlh1, adcop1, addep2, adcp21, adcp22,&
                      addete, adcote, defgem, defgep,&
                      kpi, npg, npi, sigm, sigp,&
                      varim, varip, res, drde, retcom)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        character(len=16) :: option
        aster_logical :: l_steady
        aster_logical :: resi
        aster_logical :: rigi
        integer :: j_mater
        character(len=16) :: compor(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        character(len=8) :: nomail
        integer :: addeme
        integer :: adcome
        integer :: addep1
        integer :: adcp11
        integer :: adcp12
        integer :: addlh1
        integer :: adcop1
        integer :: addep2
        integer :: adcp21
        integer :: adcp22
        integer :: addete
        integer :: adcote
        real(kind=8) :: defgem(1:dimdef)
        real(kind=8) :: defgep(1:dimdef)
        integer :: kpi
        integer :: npg
        integer :: npi
        real(kind=8) :: sigm(dimcon)
        real(kind=8) :: sigp(dimcon)
        real(kind=8) :: varim(nbvari)
        real(kind=8) :: varip(nbvari)
        real(kind=8) :: res(dimdef)
        real(kind=8) :: drde(dimdef, dimdef)
        integer :: retcom
    end subroutine coeihm
end interface 
