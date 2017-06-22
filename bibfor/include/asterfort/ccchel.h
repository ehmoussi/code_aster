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
    subroutine ccchel(option, modele, resuin, resuou, numord,&
                      nordm1, mateco, carael, typesd, ligrel,&
                      exipou, exitim, lischa, nbchre, ioccur,&
                      suropt, basopt, resout)
        character(len=16) :: option
        character(len=8) :: modele
        character(len=8) :: resuin
        character(len=8) :: resuou
        integer :: numord
        integer :: nordm1
        character(len=24) :: mateco
        character(len=8) :: carael
        character(len=16) :: typesd
        character(len=24) :: ligrel
        aster_logical :: exipou
        aster_logical :: exitim
        character(len=19) :: lischa
        integer :: nbchre
        integer :: ioccur
        character(len=24) :: suropt
        character(len=1) :: basopt
        character(len=24) :: resout
    end subroutine ccchel
end interface
