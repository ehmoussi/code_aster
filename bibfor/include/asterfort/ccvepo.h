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
    subroutine ccvepo(modele, resuin, typesd, lisord, nbordr,&
                      option,&
                      nbchre, ioccur, suropt, ligrel, exipou)
        character(len=8) :: modele
        character(len=8) :: resuin
        integer :: nbordr
        character(len=19) :: lisord
        character(len=16) :: typesd
        character(len=16) :: option
        integer :: ioccur
        character(len=24) :: suropt
        character(len=24) :: ligrel
        aster_logical :: exipou
        integer :: nbchre
    end subroutine ccvepo
end interface
