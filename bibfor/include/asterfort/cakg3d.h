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
    subroutine cakg3d(option, result, modele, depla, thetai,&
                      mate, compor, lischa, symech,&
                      chfond, nnoff, basloc, courb, iord,&
                      ndeg, liss, ndimte, extim,&
                      time, nbprup, noprup,&
                      fiss, lmelas, nomcas, lmoda, puls,&
                      milieu, connex, coor, iadnoe, typdis)
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
        character(len=24) :: basloc
        character(len=24) :: courb
        integer           :: iord
        integer           :: ndeg
        character(len=24) :: liss
        integer           :: ndimte
        aster_logical     :: extim
        real(kind=8)      :: time
        integer           :: nbprup
        character(len=16) :: noprup(*)
        character(len=8)  :: fiss
        aster_logical     :: lmelas
        character(len=16) :: nomcas
        aster_logical     :: lmoda
        real(kind=8)      :: puls
        aster_logical     :: milieu
        aster_logical     :: connex
        integer :: coor
        integer :: iadnoe        
        character(len=16), intent(in), optional :: typdis
    end subroutine cakg3d
end interface
