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
    subroutine ircrrl(ifi, nbno, desc, nec, dg,&
                      ncmpmx, vale, nomcmp, nomnoe, lcor,&
                      ndim, coor, numnoe, nbcmpt, nucmpu,&
                      lsup, borsup, linf, borinf, lmax,&
                      lmin, formr)
        integer :: ifi
        integer :: nbno
        integer :: desc(*)
        integer :: nec
        integer :: dg(*)
        integer :: ncmpmx
        real(kind=8) :: vale(*)
        character(len=*) :: nomcmp(*)
        character(len=*) :: nomnoe(*)
        aster_logical :: lcor
        integer :: ndim
        real(kind=8) :: coor(*)
        integer :: numnoe(*)
        integer :: nbcmpt
        integer :: nucmpu(*)
        aster_logical :: lsup
        real(kind=8) :: borsup
        aster_logical :: linf
        real(kind=8) :: borinf
        aster_logical :: lmax
        aster_logical :: lmin
        character(len=*) :: formr
    end subroutine ircrrl
end interface
