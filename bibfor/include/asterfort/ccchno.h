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
    subroutine ccchno(option, numord, resuin, resuou, lichou,&
                      mesmai, nomail, modele, carael, basopt,&
                      ligrel, ligmod, codret)
        character(len=16) :: option
        integer :: numord
        character(len=8) :: resuin
        character(len=8) :: resuou
        character(len=24) :: lichou(2)
        character(len=24) :: mesmai
        character(len=8) :: nomail
        character(len=8) :: modele
        character(len=8) :: carael
        character(len=1) :: basopt
        character(len=24) :: ligrel
        aster_logical :: ligmod
        integer :: codret
    end subroutine ccchno
end interface
