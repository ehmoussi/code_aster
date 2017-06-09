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
    subroutine dilele(option, typmod, npi, ndim, dimuel,&
                      nddls, nddlm, nno, nnos, nnom,&
                      axi, regula, dimcon, ipoids, ipoid2,&
                      ivf, ivf2, interp, idfde, idfde2,&
                      compor, geom, deplp, contp, imate,&
                      dimdef, matuu, vectu)
        integer :: dimdef
        integer :: dimcon
        integer :: dimuel
        integer :: ndim
        integer :: npi
        character(len=16) :: option
        character(len=8) :: typmod(2)
        integer :: nddls
        integer :: nddlm
        integer :: nno
        integer :: nnos
        integer :: nnom
        aster_logical :: axi
        integer :: regula(6)
        integer :: ipoids
        integer :: ipoid2
        integer :: ivf
        integer :: ivf2
        character(len=2) :: interp
        integer :: idfde
        integer :: idfde2
        character(len=16) :: compor(*)
        real(kind=8) :: geom(ndim, *)
        real(kind=8) :: deplp(dimuel)
        real(kind=8) :: contp(dimcon*npi)
        integer :: imate
        real(kind=8) :: matuu(dimuel*dimuel)
        real(kind=8) :: vectu(dimuel)
    end subroutine dilele
end interface
