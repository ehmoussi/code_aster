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
#include "asterf_types.h"
!
! aslint: disable=W1504
!
interface 
    subroutine hmlvga(yachai, option, meca, ther, hydr,&
                      imate, ndim, dimdef, dimcon, nbvari,&
                      yamec, yate, addeme, adcome, advihy,&
                      advico, vihrho, vicphi, vicpvp, vicsat,&
                      addep1, adcp11, adcp12, addep2, adcp21,&
                      adcp22, addete, adcote, congem, congep,&
                      vintm, vintp, dsde, epsv, depsv,&
                      p1, p2, dp1, dp2, t,&
                      dt, phi, padp, pvp, h11,&
                      h12, kh, rho11, &
                      sat, retcom, thmc, tbiot, rinstp,&
                      angmas, deps, aniso, phenom)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        aster_logical :: yachai
        character(len=16) :: option
        character(len=16) :: meca
        character(len=16) :: ther
        character(len=16) :: hydr
        integer :: imate
        integer :: yamec
        integer :: yate
        integer :: addeme
        integer :: adcome
        integer :: advihy
        integer :: advico
        integer :: vihrho
        integer :: vicphi
        integer :: vicpvp
        integer :: vicsat
        integer :: addep1
        integer :: adcp11
        integer :: adcp12
        integer :: addep2
        integer :: adcp21
        integer :: adcp22
        integer :: addete
        integer :: adcote
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: congep(dimcon)
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: vintp(nbvari)
        real(kind=8) :: dsde(dimcon, dimdef)
        real(kind=8) :: epsv
        real(kind=8) :: depsv
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: dp1
        real(kind=8) :: dp2
        real(kind=8) :: t
        real(kind=8) :: dt
        real(kind=8) :: phi
        real(kind=8) :: padp
        real(kind=8) :: pvp
        real(kind=8) :: h11
        real(kind=8) :: h12
        real(kind=8) :: kh
        real(kind=8) :: rho11
        real(kind=8) :: sat
        integer :: retcom
        character(len=16) :: thmc
        real(kind=8) :: tbiot(6)
        real(kind=8) :: rinstp
        real(kind=8) :: angmas(3)
        real(kind=8) :: deps(6)
        integer :: aniso
        character(len=16) :: phenom
    end subroutine hmlvga
end interface 
