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
    subroutine irmfac(ioccur, formaf, ifichi, versio,&
                      modele, nomail, nomare, resure, lgmsh)
        integer :: ioccur
        character(len=8) :: formaf
        integer :: ifichi
        integer :: versio
        character(len=8) :: modele
        character(len=8) :: nomail
        character(len=8) :: nomare
        character(len=8) :: resure
        aster_logical :: lgmsh
    end subroutine irmfac
end interface
