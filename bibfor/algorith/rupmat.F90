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

subroutine rupmat(fami, kpg, ksp, imat, vim,&
                  lgpg, e, sigd)
    implicit none
#include "asterfort/rcvalb.h"
    integer :: kpg, ksp, imat, lgpg, cerr(1), i
    real(kind=8) :: e, vim(*), sigd(6), coef(1)
    character(len=*) :: fami
! =================================================================
!   IN  FAMI   :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!     KPG,KSP : NUMERO DU (SOUS)POINT DE GAUSS
!     IMAT    : ADRESSE DU MATERIAU CODE
!     VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
!     LGPG  : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!           CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
!   OUT E    :  MODULE D YOUNG DEGRADE PAR UN COEF DONNE MATERIAU
!     SIGD   :  CHAMPS DE CONTRAINTES DES ELE. ENDOMMAGES
! =================================================================
    if (vim (lgpg) .lt. 0.5d0) then
        goto 999
    endif
!
    call rcvalb(fami, kpg, ksp, '+', imat,&
                ' ', 'CRIT_RUPT', 0, ' ', [0.d0],&
                1, 'COEF', coef, cerr, 1)
!
    e = e /coef(1)
!
    do 100 i = 1, 6
        sigd(i)=0.d0
100  end do
!
999  continue
end subroutine
