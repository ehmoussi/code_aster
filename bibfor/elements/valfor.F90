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

subroutine valfor(indn, lt1, lt2, l1, l2,&
                  l3)
!
!
! ......................................................................
!     FONCTION :  CALCUL DES POINTEURS DES FONCTIONS DE FORMES
!
!                 LT1 LT2   : TRANSLATION
!                 L1 L2 L3  : ROTATION
!
!                 SELON INTEGRATION
!
! ......................................................................
!
!
!
    implicit none
#include "asterfort/utmess.h"
!
    integer :: indn
!
    integer :: lt1, lt2
!
    integer :: l1, l2, l3
!
!DEB
!
!
!---- LES ADRESSES DES FONCTIONS DE FORME ET DE LEURS DERIVEES
!     SELON INDN ( VOIR ROUTINE BTDFN )
!
!
!
!------- NOEUDS DE SERENDIP POUR LA TRANSLATION
!
!            D N ( 1 ) D QSI 1      LT1 POUR  I1
!            D N ( 1 ) D QSI 2      LT2 POUR  I2
!
!------- NOEUDS DE LAGRANGE POUR LA ROTATION
!
!              N ( 2 )              L1  POUR  I3
!            D N ( 2 ) D QSI 1      L2  POUR  I4
!            D N ( 2 ) D QSI 2      L3  POUR  I5
!
!
    if (indn .eq. 1) then
!
!------- INDN =  1 INTEGRATION NORMALE
!
!        VOIR ROUTINE INI080 ET VECTGT
!
        lt1 = 207
        lt2 = 279
!
!        VOIR ROUTINE BTDFN
!
        l1 = 459
        l2 = 540
        l3 = 621
!
    else if (indn .eq. 0) then
!
!------- INDN =  0 INTEGRATION REDUITE
!
!        VOIR ROUTINE BTDMSR
!
        lt1 = 44
        lt2 = 76
!
        l1 = 351
        l2 = 387
        l3 = 423
!
    else
!
        call utmess('F', 'ELEMENTS4_57')
!
    endif
!
!FIN
!
end subroutine
