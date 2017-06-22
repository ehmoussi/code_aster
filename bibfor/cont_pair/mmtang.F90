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

subroutine mmtang(ndim, nno, coorma, dff, tau1,&
                  tau2)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
    integer :: ndim, nno
    real(kind=8) :: coorma(27)
    real(kind=8) :: dff(2, 9)
    real(kind=8) :: tau1(3), tau2(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
!
! CALCULE LES VECTEURS TANGENTS LOCAUX SUR UNE MAILLE
!
! ----------------------------------------------------------------------
!
!
! IN  NNO    : NOMBRE DE NOEUD SUR LA MAILLE
! IN  NDIM   : DIMENSION DE LA MAILLE (2 OU 3)
! IN  COORMA : COORDONNEES DES NOEUDS DE LA MAILLE
! IN  DFF    : DERIVEES PREMIERES DES FONCTIONS DE FORME
! I/O TAU1   : PREMIER VECTEUR TANGENT EN (KSI1,KSI2)
! I/O TAU2   : SECOND VECTEUR TANGENT EN (KSI1,KSI2)
!
! ----------------------------------------------------------------------
!
    integer :: idim, ino
!
! ----------------------------------------------------------------------
!
!
! --- VERIF CARACTERISTIQUES DE LA MAILLE
!
    if (nno .gt. 9) then
        ASSERT(.false.)
    endif
    if (ndim .gt. 3) then
        ASSERT(.false.)
    endif
    if (ndim .le. 1) then
        ASSERT(.false.)
    endif
!
! --- CALCUL DES TANGENTES
!
    do 41 idim = 1, ndim
        do 31 ino = 1, nno
            tau1(idim) = coorma(3*(ino-1)+idim)*dff(1,ino) + tau1( idim)
            if (ndim .eq. 3) then
                tau2(idim) = coorma(3*(ino-1)+idim)*dff(2,ino) + tau2( idim)
            endif
 31     continue
 41 end do
!
!
end subroutine
