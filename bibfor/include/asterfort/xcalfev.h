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
    subroutine xcalfev(elrefp, ndim, nnop, basloc, stano, he,&
                       lsn, lst, geom, kappa, mu, ff, fk,&
                       dfdi, dkdgl, face,&
                       nnop_lin, ff_lin, dfdi_lin)
        character(len=8), intent(in) :: elrefp
        integer :: nnop
        integer :: ndim
        integer :: stano(*)
        real(kind=8) :: he
        real(kind=8) :: ff(*)
        real(kind=8) :: lsn(*)
        real(kind=8) :: lst(*)
        real(kind=8) :: basloc(*)
        real(kind=8) :: kappa
        real(kind=8) :: mu
        real(kind=8) :: fk(27,3,3)
        real(kind=8), optional :: dkdgl(27,3,3,3)
        real(kind=8), optional :: dfdi(nnop,ndim)
        character(len=4), optional :: face
        real(kind=8) :: geom(*)
        integer, optional :: nnop_lin
        real(kind=8), optional :: ff_lin(:)
        real(kind=8), optional :: dfdi_lin(:,:)
    end subroutine xcalfev
end interface
