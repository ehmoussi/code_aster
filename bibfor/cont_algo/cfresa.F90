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

subroutine cfresa(ndim, fctc, norm, rnx, rny,&
                  rnz, rn)
!
!
!
    implicit     none
#include "jeveux.h"
    integer :: ndim
    real(kind=8) :: fctc(3)
    real(kind=8) :: norm(3)
    real(kind=8) :: rnx
    real(kind=8) :: rny
    real(kind=8) :: rnz
    real(kind=8) :: rn
!
! ======================================================================
! ROUTINE APPELEE PAR : CFRESU
! ======================================================================
!
! CALCUL DES REACTIONS NORMALES DE CONTACT
!
! IN  NDIM   : DIMENSION DU MODELE
! IN  FCTC   : FORCES DE CONTACT NODALES
! IN  NORM   : NORMALE
! OUT RNX    : FORCE DE REACTION NORMALE PROJETEE SUR X
! OUT RNY    : FORCE DE REACTION NORMALE PROJETEE SUR Y
! OUT RNZ    : FORCE DE REACTION NORMALE PROJETEE SUR Z
! OUT RN     : FORCE DE REACTION NORMALE RESULTANTE
!
!
!
!
!
    real(kind=8) :: proj
!
! ----------------------------------------------------------------------
!
    proj = fctc(1) * norm(1) + fctc(2) * norm(2)
!
    if (ndim .eq. 3) then
        proj = proj + fctc(3) * norm(3)
    endif
!
    rnx = proj * norm(1)
    rny = proj * norm(2)
    rnz = 0.d0
!
    if (ndim .eq. 3) then
        rnz = proj * norm(3)
    endif
!
    rn = sqrt(rnx**2+rny**2+rnz**2)
!
end subroutine
