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
    subroutine calcco(option, perman, nume_thmc,&
                      hydr, imate, ndim, dimdef,&
                      dimcon, nbvari, yamec, yate, addeme,&
                      adcome, advihy, advico, addep1, adcp11,&
                      adcp12, addep2, adcp21, adcp22, addete,&
                      adcote, congem, congep, vintm, vintp,&
                      dsde, deps, epsv, depsv, p1,&
                      p2, dp1, dp2, temp, dtemp,&
                      phi, pvp, pad, h11, h12,&
                      kh, rho11, satur,&
                      retcom, tbiot, vihrho, vicphi,&
                      vicpvp, vicsat, angl_naut)
        integer, intent(in) :: nume_thmc
        aster_logical, intent(in) :: perman
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: angl_naut(3)
        integer, intent(in) :: ndim, nbvari
        integer, intent(in) :: dimdef, dimcon
        integer, intent(in) :: adcome, adcote, adcp11 
        integer, intent(in) :: addeme, addete, addep1
        integer, intent(in) :: advico, advihy, vihrho, vicphi
        real(kind=8), intent(in) :: temp
        real(kind=8), intent(in) :: dtemp, dp1
        real(kind=8), intent(in) :: epsv, depsv, deps(6), tbiot(6)
        real(kind=8), intent(in) :: congem(dimcon)
        real(kind=8), intent(inout) :: congep(dimcon)
        real(kind=8), intent(in) :: vintm(nbvari)
        real(kind=8), intent(inout) :: vintp(nbvari)
        real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
        real(kind=8), intent(out) :: phi, rho11, satur
        integer, intent(out) :: retcom

        integer :: yamec, yate
        integer :: adcp12, adcp21, adcp22
        integer :: addep2
        integer :: vicpvp, vicsat, imate
        real(kind=8) :: p1, p2, dp2
        real(kind=8) :: pvp, pad, h11, h12, kh
        character(len=16) :: hydr
    end subroutine calcco
end interface 
