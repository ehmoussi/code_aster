! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
#include "MeshTypes_type.h"
!
interface
    subroutine lrmtyp(nbtyp, nomtyp, nnotyp, typgeo, renumd,&
                      modnum, nuanom, numnoa)
        integer :: nbtyp
        character(len=8) :: nomtyp(MT_NTYMAX)
        integer :: nnotyp(MT_NTYMAX), typgeo(MT_NTYMAX)
        integer :: renumd(MT_NTYMAX), modnum(MT_NTYMAX)
        integer :: nuanom(MT_NTYMAX, MT_NNOMAX)
        integer :: numnoa(MT_NTYMAX, MT_NNOMAX)
    end subroutine lrmtyp
end interface
