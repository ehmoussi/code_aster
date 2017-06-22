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
    subroutine arlcp2(iocc,mail,nomo,typmai, &
                      nom1,nom2,marlel,modarl, &
                      jma1,jma2,tabcor,mailar,proj)
        aster_logical :: proj
        integer :: jma1
        integer :: jma2
        integer :: iocc
        character(len=16) :: typmai
        character(len=8) :: mail
        character(len=8) :: nomo
        character(len=8) :: marlel
        character(len=8) :: modarl
        character(len=8) :: mailar
        character(len=10) :: nom1
        character(len=10) :: nom2
        character(len=24) :: tabcor
        character(len=32) :: jexnum
    end subroutine arlcp2
end interface
