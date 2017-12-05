! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "jeveux.h"
!
!
interface
subroutine aflrch(lisrez, chargz, type_liai, elim, detr_lisrez)
    character(len=*), intent(in) :: lisrez
    character(len=*), intent(in) :: chargz
    character(len=*), intent(in) :: type_liai
    character(len=*), intent(in), optional :: elim
    aster_logical   , intent(in), optional :: detr_lisrez
end subroutine aflrch
end interface
