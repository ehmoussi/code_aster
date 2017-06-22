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

subroutine cfnewj(ndim, coorde, coordp, norm, jeu)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit    none
    integer :: ndim
    real(kind=8) :: jeu
    real(kind=8) :: coorde(3), coordp(3)
    real(kind=8) :: norm(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
!
! CALCUL DU JEU SUR LA NORMALE
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  COORDE : COORDONNEES DU NOEUD ESCLAVE E
! IN  COORDP : COORDONNEES DE LA PROJECTION DU NOEUD ESCLAVE E
! IN  NORM   : NORMALE
! OUT JEU    : JEU
!
! ----------------------------------------------------------------------
!
!
!
! --- CALCUL JEU
!
    jeu = (coordp(1)-coorde(1))*norm(1) + (coordp(2)-coorde(2))*norm(2)
    if (ndim .eq. 3) then
        jeu = jeu + (coordp(3)-coorde(3))*norm(3)
    endif
!
end subroutine
