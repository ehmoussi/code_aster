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
    subroutine regini(option, nomte, ivf, ivf2, idfde,&
                      idfde2, jgano, ndim, ipoids, ipoid2,&
                      npi, dimdef, nddls, nddlm, dimcon,&
                      typmod, dimuel, nno, nnom, nnos,&
                      regula, axi)
        character(len=16) :: option
        character(len=16) :: nomte
        integer :: ivf
        integer :: ivf2
        integer :: idfde
        integer :: idfde2
        integer :: jgano
        integer :: ndim
        integer :: ipoids
        integer :: ipoid2
        integer :: npi
        integer :: dimdef
        integer :: nddls
        integer :: nddlm
        integer :: dimcon
        character(len=8) :: typmod(2)
        integer :: dimuel
        integer :: nno
        integer :: nnom
        integer :: nnos
        integer :: regula(6)
        aster_logical :: axi
    end subroutine regini
end interface
