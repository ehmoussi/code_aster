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

subroutine nomgfa(nogr, nbgr, dgf, nogrf, nbgf)
!     ------------------------------------------------------------------
! person_in_charge: nicolas.sellenet at edf.fr
!  ENTREES :
!     NOGR   = NOMS DES GROUPES D ENTITES
!     NBGR   = NOMBRE DE GROUPES
!     DGF    = DESCRIPTEUR-GROUPE DE LA FAMILLE (VECTEUR ENTIERS)
!  SORTIES :
!     NOGRF  = NOMS DES GROUPES D ENTITES DE LA FAMILLE
!     NBGF   = NOMBRE DE GROUPES DE LA FAMILLE
!     ------------------------------------------------------------------
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterfort/exigfa.h"
    integer :: nbgf, nbgr
    integer :: dgf(*)
    character(len=80) :: nogrf(*)
    character(len=24) :: nogr(nbgr)
!
! 0.2. ==> COMMUNS
!
! 0.3. ==> VARIABLES LOCALES
!
    character(len=56) :: saux56
    integer :: iaux
!
!     ------------------------------------------------------------------
!
    saux56 = ' '
!
    nbgf = 0
    do 10 , iaux = 1,nbgr
    if (exigfa(dgf,iaux)) then
        nbgf = nbgf + 1
        nogrf(nbgf)(1:24) = nogr(iaux)
        nogrf(nbgf)(25:80) = saux56
    endif
    10 end do
!
end subroutine
