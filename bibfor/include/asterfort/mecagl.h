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
! aslint: disable=W1504
#include "asterf_types.h"
!
interface
    subroutine mecagl(option, result, modele, depla, thetai,&
                      mate, compor, lischa, symech, chfond, &
                      nnoff, iord, ndeg, liss, &
                      milieu, ndimte, extim, &
                      time, nbprup, noprup, chvite, chacce, &
                      lmelas, nomcas, kcalc, fonoeu, lincr, coor, &
                      norfon, connex)
        character(len=16) :: option
        character(len=8)  :: result
        character(len=8)  :: modele
        character(len=24) :: depla
        character(len=8)  :: thetai
        character(len=24) :: mate
        character(len=24) :: compor
        character(len=19) :: lischa
        character(len=8)  :: symech
        character(len=24) :: chfond
        integer           :: nnoff
        integer           :: iord
        integer           :: ndeg
        aster_logical     :: lincr
        character(len=24) :: liss
        aster_logical     :: milieu
        integer           :: ndimte
        aster_logical     :: extim
        real(kind=8)      :: time
        integer           :: nbprup
        character(len=16) :: noprup(*)
        character(len=24) :: chvite
        character(len=24) :: chacce
        aster_logical     :: lmelas
        character(len=16) :: nomcas
        character(len=8)  :: kcalc
        character(len=24) :: fonoeu
        integer           :: coor
        character(len=24) :: norfon
        aster_logical     :: connex
    end subroutine mecagl
end interface
