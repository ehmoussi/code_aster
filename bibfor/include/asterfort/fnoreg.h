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
    subroutine fnoreg(dimuel, dimdef, nno, nnos, nnom,&
                      ndim, npi, dimcon, geom, ipoids,&
                      ipoid2, ivf, ivf2, idfde, idfde2,&
                      nddls, nddlm, axi, regula, deplm,&
                      contm, imate, vectu)
        integer :: dimcon
        integer :: npi
        integer :: ndim
        integer :: dimdef
        integer :: dimuel
        integer :: nno
        integer :: nnos
        integer :: nnom
        real(kind=8) :: geom(ndim, *)
        integer :: ipoids
        integer :: ipoid2
        integer :: ivf
        integer :: ivf2
        integer :: idfde
        integer :: idfde2
        integer :: nddls
        integer :: nddlm
        aster_logical :: axi
        integer :: regula(6)
        real(kind=8) :: deplm(dimuel)
        real(kind=8) :: contm(dimcon*npi)
        integer :: imate
        real(kind=8) :: vectu(dimuel)
    end subroutine fnoreg
end interface
