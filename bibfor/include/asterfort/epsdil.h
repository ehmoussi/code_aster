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
    subroutine epsdil(npi, ipoids, ipoid2, ivf, ivf2,&
                      idfde, idfde2, geom, dimdef, dimuel,&
                      ndim, nddls, nddlm, nno, nnos,&
                      nnom, interp, axi, regula, deplp,&
                      defgep)
        integer :: ndim
        integer :: dimuel
        integer :: dimdef
        integer :: npi
        integer :: ipoids
        integer :: ipoid2
        integer :: ivf
        integer :: ivf2
        integer :: idfde
        integer :: idfde2
        real(kind=8) :: geom(ndim, *)
        integer :: nddls
        integer :: nddlm
        integer :: nno
        integer :: nnos
        integer :: nnom
        character(len=2) :: interp
        aster_logical :: axi
        integer :: regula(6)
        real(kind=8) :: deplp(dimuel)
        real(kind=8) :: defgep(npi*dimdef)
    end subroutine epsdil
end interface
