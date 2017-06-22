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
    subroutine ascalc(resu, masse, mome, psmo, stat,&
                      nbmode, neq, nordr, knomsy, nbopt,&
                      ndir, monoap, muapde, nbsup, nsupp,&
                      typcmo, temps, comdir, typcdi, tronc,&
                      amort, spectr, gamma0, nomsup, reasup,&
                      depsup, tcosup, corfre, f1gup, f2gup)
        integer :: nbsup
        character(len=*) :: resu
        character(len=*) :: masse
        character(len=*) :: mome
        character(len=*) :: psmo
        character(len=*) :: stat
        integer :: nbmode
        integer :: neq
        integer :: nordr(*)
        character(len=*) :: knomsy(*)
        integer :: nbopt
        integer :: ndir(*)
        aster_logical :: monoap
        aster_logical :: muapde
        integer :: nsupp(*)
        character(len=*) :: typcmo
        real(kind=8) :: temps
        aster_logical :: comdir
        character(len=*) :: typcdi
        aster_logical :: tronc
        real(kind=8) :: amort(*)
        real(kind=8) :: spectr(*)
        real(kind=8) :: gamma0(*)
        character(len=*) :: nomsup(*)
        real(kind=8) :: reasup(*)
        real(kind=8) :: depsup(*)
        integer :: tcosup(*)
        aster_logical :: corfre
        real(kind=8) :: f1gup
        real(kind=8) :: f2gup
    end subroutine ascalc
end interface
