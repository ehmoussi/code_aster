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

subroutine mmlagc(lambds, dlagrc, iresof, lambda)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    integer :: iresof
    real(kind=8) :: lambds, lambda, dlagrc
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! CHOIX DU SEUIL DE FROTTEMENT (PRESSION DE CONTACT)
!
! ----------------------------------------------------------------------
!
!
! IN  IRESOF : ALGO. DE RESOLUTION POUR LE FROTTEMENT
!              0 - POINT FIXE
!              1 - NEWTON COMPLET
! IN  LAMBDS : VALEUR DU MULT. DE CONTACT (SEUIL FIXE)
! IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! OUT LAMBDA : LAGRANGIEN DE CONTACT
!
! ----------------------------------------------------------------------
!
    lambda = lambds
!
    if (iresof .ne. 0) then
        if (dlagrc .ne. 0) lambda = dlagrc
    endif
!
end subroutine
