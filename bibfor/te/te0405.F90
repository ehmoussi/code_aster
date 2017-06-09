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

subroutine te0405(option, nomte)
!
!
! ----------------------------------------------------------------------
! FONCTION REALISEE: RETOURNE -1 POUR LES ELEMENTS POUR LESQUELS
! ON NE SAIT PAS ENCORE CALCULER LA CONDITION DE COURANT
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/jevech.h"
    character(len=16) :: option, nomte
!
    integer :: icour
! DEB ------------------------------------------------------------------
!
    call jevech('PCOURAN', 'E', icour)
!
    zr(icour) = -1.d0
!
! FIN ------------------------------------------------------------------
end subroutine
