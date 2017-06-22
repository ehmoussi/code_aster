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
    subroutine xcinem(axi, igeom, nnop, nnos, idepl, grand, ndim, he,&
                      nfiss, nfh, nfe, ddls, ddlm,&
                      fk, dkdgl, ff, dfdi, f, eps, grad, heavn)
        aster_logical, intent(in) :: axi
        integer, intent(in) :: igeom
        integer, intent(in) :: nnop
        integer, intent(in) :: nnos
        integer, intent(in) :: idepl
        aster_logical, intent(in) :: grand
        integer, intent(in) :: ndim
        real(kind=8), intent(in) :: he(nfiss)
        integer, intent(in) :: nfiss
        integer, intent(in) :: nfh
        integer, intent(in) :: nfe
        integer, intent(in) :: ddls
        integer, intent(in) :: ddlm
        real(kind=8), intent(in)::  fk(27,3,3)
        real(kind=8), intent(in)::  dkdgl(27,3,3,3)
        real(kind=8), intent(in) :: ff(nnop)
        real(kind=8), intent(in) :: dfdi(nnop, ndim)
        real(kind=8), intent(out) :: f(3, 3)
        real(kind=8), intent(out) :: eps(6)
        real(kind=8), intent(out) :: grad(ndim, ndim)
        integer, intent(in) :: heavn(nnop, 5)
    end subroutine xcinem
end interface
