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
    subroutine comthm_vf(option   , j_mater  ,&
                         type_elem, angl_naut,&
                         ndim     , nbvari   ,&
                         thmc     , hydr     ,&
                         dimdef   , dimcon   ,&
                         ifa      , valfac   , valcen, &
                         adcome   , adcote   , adcp11, adcp12, adcp21, adcp22,&
                         addeme   , addete   , addep1, addep2,&
                         advico   , advihy   ,&
                         vihrho   , vicphi   , vicpvp  , vicsat,&
                         compor   , carcri   ,&
                         defgem   , defgep   ,& 
                         congem   , congep   ,&
                         vintm    , vintp    ,&
                         time_prev, time_curr,&
                         dsde     , gravity  , retcom)
        character(len=16), intent(in) :: option
        integer, intent(in) :: j_mater
        character(len=8), intent(in) :: type_elem(2)
        real(kind=8), intent(in) :: angl_naut(3)
        character(len=16), intent(in) :: thmc, hydr
        integer, intent(in) :: ndim, nbvari
        integer, intent(in) :: dimdef, dimcon
        integer, intent(in) :: adcome, adcote, adcp11, adcp12, adcp21, adcp22
        integer, intent(in) :: addeme, addete, addep1, addep2
        integer, intent(in) :: advihy, advico
        integer, intent(in) :: vihrho, vicphi, vicpvp, vicsat
        character(len=16), intent(in)  :: compor(*)
        real(kind=8), intent(in) :: carcri(*)
        real(kind=8), intent(in) :: defgem(1:dimdef), defgep(1:dimdef)
        real(kind=8), intent(in) :: congem(1:dimcon)
        real(kind=8), intent(inout) :: congep(1:dimcon)
        real(kind=8), intent(in) :: vintm(1:nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        real(kind=8), intent(in) :: time_prev, time_curr
        real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
        real(kind=8), intent(out) :: gravity(3)
        integer, intent(out) :: retcom
        integer, intent(in) :: ifa
        integer, parameter :: maxfa = 6
        real(kind=8), intent(inout) :: valcen(14, 6)
        real(kind=8), intent(inout) :: valfac(maxfa, 14, 6)
    end subroutine comthm_vf
end interface 
