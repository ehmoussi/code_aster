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

subroutine zbinte(rho, rhomin, rhomax, rhoexm, rhoexp)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    real(kind=8) :: rho
    real(kind=8) :: rhomin, rhomax, rhoexm, rhoexp
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECH. LINE. - UTILITAIRE)
!
! GESTION DES BORNES POUR LE RHO
!
! ----------------------------------------------------------------------
!
! I/O RHO    : RHO AVEC RESPECT DES BORNES
! IN  RHOMIN : BORNE INFERIEURE DE RECHERCHE
! IN  RHOMAX : BORNE SUPERIEURE DE RECHERCHE
! IN  RHOEXM : INTERVALLE [RHOEXM,RHOEXP] POUR EXCLUSION
! IN  RHOEXP : INTERVALLE [RHOEXM,RHOEXP] POUR EXCLUSION
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: rhotmp
!
!-----------------------------------------------------------------------
!
    rhotmp = rho
    if (rhotmp .lt. rhomin) rho = rhomin
    if (rhotmp .gt. rhomax) rho = rhomax
    if (rhotmp .lt. 0.d0 .and. rhotmp .ge. rhoexm) rho = rhoexm
    if (rhotmp .ge. 0.d0 .and. rhotmp .le. rhoexp) rho = rhoexp
!
end subroutine
