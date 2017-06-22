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
#include "asterf_types.h"
!
interface
    subroutine xteddl(ndim, nfh, nfe, ddls, nddl,&
                      nno, nnos, stano, lcontx, matsym,&
                      option, nomte, ddlm,&
                      nfiss, jfisno, mat, vect)
        integer, intent(in) :: nfiss
        integer, intent(in) :: nno
        integer, intent(in) :: ndim
        integer, intent(in) :: nfh
        integer, intent(in) :: nfe
        integer, intent(in) :: ddls
        integer, intent(in) :: nddl
        integer, intent(in) :: nnos
        integer, intent(in) :: stano(*)
        aster_logical, intent(in) :: lcontx
        aster_logical, intent(in) :: matsym
        character(len=16), intent(in) :: option
        character(len=16), intent(in) :: nomte
        integer, intent(in) :: ddlm
        integer, intent(in) :: jfisno
        real(kind=8), optional, intent(inout) :: mat(*)
        real(kind=8), optional, intent(out) :: vect(*)
    end subroutine xteddl
end interface
