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
    subroutine spephy(ioptch, intphy, intmod, nomu, table,&
                      freq, cham, specmr, specmi, disc,&
                      nnoe, nomcmp, nuor, nbmr, nbn,&
                      imod1, nbpf, nbm, ivitef)
        integer :: nbm
        integer :: nbpf
        integer :: nbn
        integer :: nbmr
        integer :: ioptch
        aster_logical :: intphy
        aster_logical :: intmod
        character(len=8) :: nomu
        character(len=8) :: table
        real(kind=8) :: freq(2, nbm, *)
        real(kind=8) :: cham(nbn, nbmr)
        real(kind=8) :: specmr(nbpf, *)
        real(kind=8) :: specmi(nbpf, *)
        real(kind=8) :: disc(*)
        character(len=8) :: nnoe(nbn)
        character(len=8) :: nomcmp
        integer :: nuor(nbmr)
        integer :: imod1
        integer :: ivitef
    end subroutine spephy
end interface
