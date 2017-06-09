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
    subroutine irmasu(ifc, ndim, nno, coordo, nbma,&
                      connex, point, typma, typel, codgra,&
                      codphy, codphd, permut, maxnod, lmod,&
                      noma, nbgrn, nogn, nbgrm, nogm,&
                      lmasu, nomai, nonoe, versio)
        integer :: maxnod
        integer :: ifc
        integer :: ndim
        integer :: nno
        real(kind=8) :: coordo(*)
        integer :: nbma
        integer :: connex(*)
        integer :: point(*)
        integer :: typma(*)
        integer :: typel(*)
        integer :: codgra(*)
        integer :: codphy(*)
        integer :: codphd(*)
        integer :: permut(maxnod, *)
        aster_logical :: lmod
        character(len=8) :: noma
        integer :: nbgrn
        character(len=24) :: nogn(*)
        integer :: nbgrm
        character(len=24) :: nogm(*)
        aster_logical :: lmasu
        character(len=8) :: nomai(*)
        character(len=8) :: nonoe(*)
        integer :: versio
    end subroutine irmasu
end interface
