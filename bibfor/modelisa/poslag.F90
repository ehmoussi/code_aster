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

subroutine poslag(typlaz, ilag1, ilag2)
    implicit none
#include "asterfort/utmess.h"
    character(len=*) :: typlaz
!     BUT : INDICATEUR DE LA POSITION A AFFECTER AUX MULTIPLICATEURS
!           DE LAGRANGE ASSOCIES A UNE RELATION
!
! TYPLAG        - IN - K2  - : TYPE DES MULTIPLICATEURS DE LAGRANGE
!                              ASSOCIES A LA RELATION :
!                              SI = '12'  LE PREMIER LAGRANGE EST AVANT
!                                         LE NOEUD PHYSIQUE
!                                         LE SECOND LAGRANGE EST APRES
!                              SI = '22'  LE PREMIER LAGRANGE EST APRES
!                                         LE NOEUD PHYSIQUE
!                                         LE SECOND LAGRANGE EST APRES
! ILAG1         - OUT - I  - : INDICATEUR DE POSITION DU PREMIER
!                              LAGRANGE :
!                              SI AVANT LE NOEUD PHYSIQUE ILAG1 = +1
!                              SI APRES LE NOEUD PHYSIQUE ILAG1 = -1
! ILAG2         - OUT - I  - : INDICATEUR DE POSITION DU SECOND
!                              LAGRANGE :
!                              SI APRES LE NOEUD PHYSIQUE ILAG2 = -2
!                              (C'EST LA SEULE POSSIBILITE POUR LE
!                               MOMENT)
!-----------------------------------------------------------------------
!
    character(len=2) :: typlag
!
!-----------------------------------------------------------------------
    integer :: ilag1, ilag2
!-----------------------------------------------------------------------
    typlag = typlaz
!
    if (typlag(1:1) .eq. '1') then
        ilag1 = 1
    else if (typlag(1:1).eq.'2') then
        ilag1 = -1
    else
        call utmess('F', 'MODELISA6_30', sk=typlag)
    endif
!
    if (typlag(2:2) .eq. '2') then
        ilag2 = -2
    else
        call utmess('F', 'MODELISA6_30', sk=typlag)
    endif
!
end subroutine
