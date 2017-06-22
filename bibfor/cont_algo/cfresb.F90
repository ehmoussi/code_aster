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

subroutine cfresb(ndim, typlia, fctf, tau1, tau2,&
                  rtx, rty, rtz)
!
implicit none
!
#include "asterf_types.h"
!
!
    integer :: ndim
    character(len=2) :: typlia
    real(kind=8) :: fctf(3)
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: rtx
    real(kind=8) :: rty
    real(kind=8) :: rtz
!
!
! ======================================================================
! ROUTINE APPELEE PAR : CFRESU
! ======================================================================
!
! CALCUL DES FORCES TANGENTIELLES DE CONTACT/FROTTEMENT
!
! IN  NDIM   : DIMENSION DU MODELE
! IN  LAG2D  : VAUT .TRUE. SI LAGRANGIEN 2D
! IN  TYPLIA : TYPE DE LIAISON (F0/F1/F2/GL)
!                'F0': FROTTEMENT (2D) OU FROTTEMENT SUIVANT LES DEUX
!                  DIRECTIONS SIMULTANEES (3D)
!                'F1': FROTTEMENT SUIVANT LA PREMIERE DIRECTION (3D)
!                'F2': FROTTEMENT SUIVANT LA SECONDE DIRECTION (3D)
!                'GL': POUR LE CALCUL DES FORCES DE GLISSEMENT
! IN  FCTF   : FORCES DE FROTTEMENT NODALES
! IN  TANG   : TANGENTES
! OUT RTX    : FORCE TANGENTIELLE PROJETEE SUR X
! OUT RTY    : FORCE TANGENTIELLE PROJETEE SUR Y
! OUT RTZ    : FORCE TANGENTIELLE PROJETEE SUR Z
!
!
!
!
    real(kind=8) :: proj1, proj2
!
! ----------------------------------------------------------------------
!
    if ((typlia.eq.'F0') .or. (typlia.eq.'GL')) then
        proj1 = fctf(1) * tau1(1) + fctf(2) * tau1(2)
        proj2 = fctf(1) * tau2(1) + fctf(2) * tau2(2)
        if (ndim .eq. 3) then
            proj1 = proj1 + fctf(3) * tau1(3)
            proj2 = proj2 + fctf(3) * tau2(3)
        endif
    else if (typlia.eq.'F1') then
        proj1 = fctf(1) * tau1(1) + fctf(2) * tau1(2)
        proj2 = 0.d0
        if (ndim .eq. 3) then
            proj1 = proj1 + fctf(3) * tau1(3)
        endif
    else if (typlia.eq.'F2') then
        proj1 = 0.d0
        proj2 = fctf(1) * tau2(1) + fctf(2) * tau2(2)
        if (ndim .eq. 3) then
            proj1 = 0.d0
            proj2 = proj2 + fctf(3) * tau2(3)
        endif
    endif
!
    rtx = proj1 * tau1(1) + proj2 * tau2(1)
    rty = proj1 * tau1(2) + proj2 * tau2(2)
    rtz = 0.d0
    if (ndim .eq. 3) then
        rtz = proj1 * tau1(3) + proj2 * tau2(3)
    endif
!
end subroutine
