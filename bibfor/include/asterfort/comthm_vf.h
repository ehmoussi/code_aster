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
    subroutine comthm_vf(option, perman, ifa, valfac,&
                      valcen, imate, typmod, compor, carcri,&
                      instam, instap, ndim, dimdef, dimcon,&
                      nbvari, yamec, yap1, yap2, yate,&
                      addeme, adcome, addep1, adcp11, adcp12,&
                      addep2, adcp21, adcp22, addete, adcote,&
                      defgem, defgep, congem, congep, vintm,&
                      vintp, dsde, pesa, retcom, kpi,&
                      npg, angl_naut,&
                      thmc, ther, hydr,&
                      advihy, advico, vihrho, vicphi, vicpvp, vicsat)
        integer, parameter :: maxfa=6
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        character(len=16) :: option
        aster_logical :: perman
        integer :: ifa
        real(kind=8) :: valfac(maxfa, 14, 6)
        real(kind=8) :: valcen(14, 6)
        integer :: imate
        character(len=8) :: typmod(2)
        character(len=16) :: compor(*)
        real(kind=8) :: carcri(*)
        real(kind=8) :: instam
        real(kind=8) :: instap
        integer :: yamec
        integer :: yap1
        integer :: yap2
        integer :: yate
        integer :: addeme
        integer :: adcome
        integer :: addep1
        integer :: adcp11
        integer :: adcp12
        integer :: addep2
        integer :: adcp21
        integer :: adcp22
        integer :: addete
        integer :: adcote
        real(kind=8) :: defgem(1:dimdef)
        real(kind=8) :: defgep(1:dimdef)
        real(kind=8) :: congem(1:dimcon)
        real(kind=8) :: congep(1:dimcon)
        real(kind=8) :: vintm(1:nbvari)
        real(kind=8) :: vintp(1:nbvari)
        real(kind=8) :: dsde(1:dimcon, 1:dimdef)
        real(kind=8) :: pesa(3)
        integer :: retcom
        integer :: kpi
        integer :: npg
        real(kind=8) :: angl_naut(3)
        character(len=16), intent(in) :: thmc
        character(len=16), intent(in) :: ther
        character(len=16), intent(in) :: hydr
        integer, intent(in) :: advihy
        integer, intent(in) :: advico
        integer, intent(in) :: vihrho
        integer, intent(in) :: vicphi
        integer, intent(in) :: vicpvp
        integer, intent(in) :: vicsat
    end subroutine comthm_vf
end interface 
