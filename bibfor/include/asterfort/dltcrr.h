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
    subroutine dltcrr(result, neq, nbordr, iarchi, texte,&
                      t0, lcrea, typres, masse, rigid,&
                      amort, dep0, vit0, acc0, fexte,&
                      famor, fliai, numedd, nume, nbtyar,&
                      typear)
        integer :: nbtyar
        integer :: neq
        character(len=8) :: result
        integer :: nbordr
        integer :: iarchi
        character(len=*) :: texte
        real(kind=8) :: t0
        aster_logical :: lcrea
        character(len=16) :: typres
        character(len=8) :: masse
        character(len=8) :: rigid
        character(len=8) :: amort
        real(kind=8) :: dep0(neq)
        real(kind=8) :: vit0(neq)
        real(kind=8) :: acc0(neq)
        real(kind=8) :: fexte(2*neq)
        real(kind=8) :: famor(2*neq)
        real(kind=8) :: fliai(2*neq)
        character(len=24) :: numedd
        integer :: nume
        character(len=16) :: typear(nbtyar)
    end subroutine dltcrr
end interface
