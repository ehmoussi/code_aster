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

subroutine cbpesa(char, noma, ndim)
    implicit none
!     BUT: TRAITE LE MOT_CLE : PESANTEUR
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DE LA CHARGE
!      NOMA   : NOM DU MAILLAGE
!      NDIM   : DIMENSION DU PROBLEME
!
#include "asterc/getfac.h"
#include "asterfort/capesa.h"
    character(len=8), intent(in) :: char
    character(len=8), intent(in) :: noma
    integer, intent(in) :: ndim
!
    integer :: ipesa
!-----------------------------------------------------------------------
    call getfac('PESANTEUR', ipesa)
    if (ipesa .ne. 0) then
        call capesa(char, noma, ipesa, ndim)
    endif
end subroutine
