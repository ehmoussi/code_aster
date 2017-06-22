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
    subroutine speph1(intphy, intmod, nomu, cham, specmr,&
                      specmi, nnoe, nomcmp, nbmode, nbn,&
                      nbpf)
        integer :: nbpf
        integer :: nbn
        aster_logical :: intphy
        aster_logical :: intmod
        character(len=8) :: nomu
        real(kind=8) :: cham(nbn, *)
        real(kind=8) :: specmr(nbpf, *)
        real(kind=8) :: specmi(nbpf, *)
        character(len=8) :: nnoe(*)
        character(len=8) :: nomcmp(*)
        integer :: nbmode
    end subroutine speph1
end interface
