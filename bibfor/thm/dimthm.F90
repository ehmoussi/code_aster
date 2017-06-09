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

subroutine dimthm(ndlno, ndlnm, ndim)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/lteatt.h"
!
!
    integer, intent(in)  :: ndim
    integer, intent(out) :: ndlno
    integer, intent(out) :: ndlnm
!
! --------------------------------------------------------------------------------------------------
!
! THM - Initializations
!
! Get number of dof on boundary
!
! --------------------------------------------------------------------------------------------------
!
!     NDDLNO NOMBRE DE DDL DES NOEUDS EXTREMITE DE SEGMENTS
!     NDDLM  NOMBRE DE DDL DES NOEUDS MILIEU DE SEGMENTS OU FACE
!
! --------------------------------------------------------------------------------------------------
!
    ndlno = 0
    ndlnm = 0
    if (lteatt('TYPMOD3','SUSHI')) then
        ndlnm = 2
    else
        if (lteatt('MECA','OUI')) then
            ndlnm = ndim
        endif
    endif
!
    if (lteatt('TYPMOD3','SUSHI')) then
        ndlno = 0
    else
        if (lteatt('MECA','OUI')) then
            ndlno = ndim
        endif
        if (lteatt('THER','OUI')) then
            ndlno = ndlno + 1
        endif
        if (lteatt('HYDR1','1') .or. lteatt('HYDR1','2')) then
            ndlno = ndlno + 1
        endif
        if (lteatt('HYDR2','1') .or. lteatt('HYDR2','2')) then
            ndlno = ndlno + 1
        endif
    endif
!
end subroutine
