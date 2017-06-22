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
interface 
    subroutine xcabhm(nddls, nddlm, nnop, nnops, nnopm,&
                      dimuel, ndim, kpi, ff, ff2,&
                      dfdi, dfdi2, b, nmec, yamec,&
                      addeme, yap1, addep1, np1, axi,&
                      ivf, ipoids, idfde, poids, coorse,&
                      nno, geom, yaenrm, adenme, dimenr,&
                      he, heavn, yaenrh, adenhy, nfiss, nfh)
        integer :: dimenr
        integer :: ndim
        integer :: dimuel
        integer :: nnops
        integer :: nnop
        integer :: nddls
        integer :: nddlm
        integer :: nnopm
        integer :: kpi
        real(kind=8) :: ff(nnop)
        real(kind=8) :: ff2(nnops)
        real(kind=8) :: dfdi(nnop, ndim)
        real(kind=8) :: dfdi2(nnops, ndim)
        real(kind=8) :: b(dimenr, dimuel)
        integer :: nmec
        integer :: yamec
        integer :: addeme
        integer :: yap1
        integer :: addep1
        integer :: np1
        aster_logical :: axi
        integer :: ivf
        integer :: ipoids
        integer :: idfde
        integer :: heavn(nnop,5)
        real(kind=8) :: poids
        real(kind=8) :: coorse(81)
        integer :: nno
        real(kind=8) :: geom(ndim, nnop)
        integer :: yaenrm
        integer :: adenme
        real(kind=8) :: he(nfiss)
        integer :: yaenrh
        integer :: adenhy
        integer :: nfiss
        integer :: nfh
    end subroutine xcabhm
end interface 
