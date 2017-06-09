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
    subroutine epsthm(nddls, nddlm, nno, nnos, nnom,&
                      nmec, dimdef, dimuel, ndim, npi,&
                      ipoids, ipoid2, ivf, ivf2, idfde,&
                      idfde2, dfdi, dfdi2, b, geom,&
                      depla, mecani, press1, press2, tempe,&
                      np1, np2, axi, epsm)
        integer :: npi
        integer :: ndim
        integer :: dimuel
        integer :: dimdef
        integer :: nnos
        integer :: nno
        integer :: nddls
        integer :: nddlm
        integer :: nnom
        integer :: nmec
        integer :: ipoids
        integer :: ipoid2
        integer :: ivf
        integer :: ivf2
        integer :: idfde
        integer :: idfde2
        real(kind=8) :: dfdi(nno, 3)
        real(kind=8) :: dfdi2(nnos, 3)
        real(kind=8) :: b(dimdef, dimuel)
        real(kind=8) :: geom(ndim, nno)
        real(kind=8) :: depla(dimuel)
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        integer :: np1
        integer :: np2
        aster_logical :: axi
        real(kind=8) :: epsm(6, npi)
    end subroutine epsthm
end interface
