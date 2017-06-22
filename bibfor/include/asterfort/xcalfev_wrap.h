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
interface
    subroutine xcalfev_wrap(ndim, nnop, basloc, stano, he,&
                            lsn, lst, geom, kappa, mu, ff, fk,&
                            dfdi, dkdgl, face, elref, nnop2, ff2,&
                            dfdi2, kstop)
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
        real(kind=8) :: geom(*)
        real(kind=8), optional :: dkdgl(27,3,3,3)
        real(kind=8), optional :: dfdi(nnop,ndim)
        character(len=1), optional :: kstop
        character(len=4), optional :: face
        character(len=8), optional :: elref
        integer, optional :: nnop2
        real(kind=8), optional :: ff2(:)
        real(kind=8), optional :: dfdi2(:,:)
    end subroutine xcalfev_wrap
end interface
