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
    subroutine asexc2(motfac, nbocc, nbmode, momec, amort,&
                      corfre, noma, ndir, nomsup, nomspe,&
                      dirspe, echspe, nature, nbsupm, nsupp,&
                      knoeu, kvspe, kaspe, nopara, nordr)
        integer :: nbmode
        character(len=*) :: motfac
        integer :: nbocc
        character(len=*) :: momec
        real(kind=8) :: amort(*)
        aster_logical :: corfre
        character(len=8) :: noma
        integer :: ndir(*)
        character(len=8) :: nomsup(3, *)
        character(len=8) :: nomspe(3, *)
        real(kind=8) :: dirspe(3, *)
        real(kind=8) :: echspe(3, *)
        integer :: nature(3, *)
        integer :: nbsupm
        integer :: nsupp(*)
        character(len=*) :: knoeu
        character(len=*) :: kvspe
        character(len=*) :: kaspe
        character(len=24) :: nopara(*)
        integer :: nordr(*)
    end subroutine asexc2
end interface
