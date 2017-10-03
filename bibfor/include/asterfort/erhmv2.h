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
    subroutine erhmv2(axi, perman, deltat, dimdep, dimdef,&
                      nmec, np1, np2, ndim, nno,&
                      nnos, npg, nddls, nddlm,&
                      dimuel, ipoids, ivf, idfde, ipoid2,&
                      ivf2, idfde2, elem_coor, fovo, deplp,&
                      deplm, sielnp, sielnm, nbcmp, biot,&
                      unsurm, fpx, fpy, frx, fry,&
                      addeme, addep1,&
                      addep2, addete, tm2h1v)
        integer :: dimuel
        integer :: nnos
        integer :: nno
        integer :: ndim
        integer :: dimdef
        integer :: dimdep
        aster_logical :: axi
        aster_logical :: perman
        real(kind=8) :: deltat
        integer :: nmec
        integer :: np1
        integer :: np2
        integer :: npg
        integer :: nddls
        integer :: nddlm
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        integer :: ipoid2
        integer :: ivf2
        integer :: idfde2
        real(kind=8) :: elem_coor(ndim, nno)
        real(kind=8) :: fovo(ndim)
        real(kind=8) :: deplp(nno*dimdep)
        real(kind=8) :: deplm(nno*dimdep)
        real(kind=8) :: sielnp(140)
        real(kind=8) :: sielnm(140)
        integer :: nbcmp
        real(kind=8) :: biot
        real(kind=8) :: unsurm
        real(kind=8) :: fpx
        real(kind=8) :: fpy
        real(kind=8) :: frx(9)
        real(kind=8) :: fry(9)
        integer :: addeme
        integer :: addep1
        integer :: addep2
        integer :: addete
        real(kind=8) :: tm2h1v(3)
    end subroutine erhmv2
end interface 
