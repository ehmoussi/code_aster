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
    subroutine cabthm(nddls, nddlm, nno, nnos, nnom,&
                      dimuel, dimdef, ndim, kpi, ipoids,&
                      ipoid2, ivf, ivf2, idfde, idfde2,&
                      dfdi, dfdi2, geom, poids, poids2,&
                      b, nmec, yamec, addeme, yap1,&
                      addep1, yap2, addep2, yate, addete,&
                      np1, np2, axi)
        integer :: ndim
        integer :: dimdef
        integer :: dimuel
        integer :: nnos
        integer :: nno
        integer :: nddls
        integer :: nddlm
        integer :: nnom
        integer :: kpi
        integer :: ipoids
        integer :: ipoid2
        integer :: ivf
        integer :: ivf2
        integer :: idfde
        integer :: idfde2
        real(kind=8) :: dfdi(nno, 3)
        real(kind=8) :: dfdi2(nnos, 3)
        real(kind=8) :: geom(ndim, nno)
        real(kind=8) :: poids
        real(kind=8) :: poids2
        real(kind=8) :: b(dimdef, dimuel)
        integer :: nmec
        integer :: yamec
        integer :: addeme
        integer :: yap1
        integer :: addep1
        integer :: yap2
        integer :: addep2
        integer :: yate
        integer :: addete
        integer :: np1
        integer :: np2
        aster_logical :: axi
    end subroutine cabthm
end interface
