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
    subroutine xhmsat(yachai, option, meca, thmc, ther,&
                      hydr, imate, ndim, dimenr,&
                      dimcon, nbvari, yamec, addeme,&
                      adcome, advihy, advico, vihrho, vicphi,&
                      addep1, adcp11, congem, congep, vintm,&
                      vintp, dsde, epsv, depsv, p1,&
                      dp1, t, phi, rho11,&
                      sat, retcom, tbiot, rinstp,&
                      angmas, aniso, phenom, yaenrh, adenhy, nfh)
        integer :: nbvari
        integer :: dimcon
        integer :: dimenr
        aster_logical :: yachai
        character(len=16) :: option
        character(len=16) :: meca
        character(len=16) :: thmc
        character(len=16) :: ther
        character(len=16) :: hydr
        integer :: imate
        integer :: ndim
        integer :: yamec
        integer :: addeme
        integer :: adcome
        integer :: advihy
        integer :: advico
        integer :: vihrho
        integer :: vicphi
        integer :: addep1
        integer :: adcp11
        real(kind=8) :: congem(dimcon)
        real(kind=8) :: congep(dimcon)
        real(kind=8) :: vintm(nbvari)
        real(kind=8) :: vintp(nbvari)
        real(kind=8) :: dsde(dimcon, dimenr)
        real(kind=8) :: epsv
        real(kind=8) :: depsv
        real(kind=8) :: p1
        real(kind=8) :: dp1
        real(kind=8) :: t
        real(kind=8) :: phi
        real(kind=8) :: rho11
        real(kind=8) :: sat
        integer :: retcom
        real(kind=8) :: tbiot(6)
        real(kind=8) :: rinstp
        real(kind=8) :: angmas(3)
        integer :: aniso
        character(len=16) :: phenom
        integer :: yaenrh
        integer :: adenhy
        integer :: nfh
    end subroutine xhmsat
end interface 
