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

subroutine xmelin(typma, typint, nnint)
!
    implicit none
#include "asterfort/assert.h"
    character(len=8) :: typma
    integer :: typint
    integer :: nnint
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT GRAND GLISSEMENTS (METHODE XFEM - UTILITAIRE)
!
! RETOURNE LE NOMBRE DE POINTS D'INTEGRATION POUR UN ELEMENT DE CONTACT
! SUIVANT LE TYPE DE SCHEMA D'INTEGRATION
!
! ----------------------------------------------------------------------
!
!
! IN  TYPMA  : NOM DU TYPE DE MAILLE
! IN  TYPINT : TYPE SCHEMA INTEGRATION
!                 1 NOEUDS
!                 2 GAUSS
!                 3 SIMPSON
!                 4 SIMPSON_1
!                 5 SIMPSON_2
!                 6 NEWTON-COTES
!                 7 NEWTON-COTES_1
!                 8 NEWTON-COTES_2
!                 12 FPG2 (GAUSS 2 POINTS)
!                 13 FPG3
!                 14 FPG4
!                 16 FPG6
!                 17 FPG7
! OUT NNINT  : NOMBRE DE POINTS D'INTEGRATION DE CET ELEMENT
!
! ----------------------------------------------------------------------
!
!
! ----------------------------------------------------------------------
!
!
    if (typint .eq. 1) then
        if (typma(1:3) .eq. 'SE2') nnint = 2
        if (typma(1:3) .eq. 'SE3') nnint = 3
        if (typma(1:3) .eq. 'TR3') nnint = 3
        if (typma(1:3) .eq. 'TR6') nnint = 6
    else if (typint .eq. 13) then
        if (typma(1:2) .eq. 'SE') nnint = 3
        if (typma(1:2) .eq. 'TR') nnint = 6
    else if (typint .eq. 23) then
        if (typma(1:2) .eq. 'SE') nnint = 5
        if (typma(1:2) .eq. 'TR') nnint =15
    else if (typint .eq. 34) then
        if (typma(1:2) .eq. 'SE') nnint = 4
        if (typma(1:2) .eq. 'TR') nnint =10
    else if (typint .eq. 54) then
        if (typma(1:2) .eq. 'SE') nnint = 6
        if (typma(1:2) .eq. 'TR') nnint =21
    else if (typint .eq. 84) then
        if (typma(1:2) .eq. 'SE') nnint = 9
        if (typma(1:2) .eq. 'TR') nnint = 45
    else if (typint .eq. 12) then
        if (typma(1:2) .eq. 'SE') nnint = 2
        if (typma(1:2) .eq. 'TR') nnint = 3
    else if (typint .eq. 22) then
        if (typma(1:2) .eq. 'SE') nnint = 2
        if (typma(1:2) .eq. 'TR') nnint = 3
    else if (typint .eq. 32) then
        if (typma(1:2) .eq. 'SE') nnint = 3
        if (typma(1:2) .eq. 'TR') nnint = 4
    else if (typint .eq. 42) then
        if (typma(1:2) .eq. 'SE') nnint = 4
        if (typma(1:2) .eq. 'TR') nnint = 6
    else if (typint .eq. 52) then
        if (typma(1:2) .eq. 'SE') nnint = 5
        if (typma(1:2) .eq. 'TR') nnint = 7
    else if (typint .eq. 62) then
        if (typma(1:2) .eq. 'SE') nnint = 6
        if (typma(1:2) .eq. 'TR') nnint = 12
    else if (typint .eq. 72) then
        if (typma(1:2) .eq. 'SE') nnint = 7
        if (typma(1:2) .eq. 'TR') nnint = 12
    else if (typint .eq. 82) then
        if (typma(1:2) .eq. 'SE') nnint = 8
        if (typma(1:2) .eq. 'TR') nnint = 16
    else if (typint .eq. 92) then
        if (typma(1:2) .eq. 'SE') nnint = 9
        if (typma(1:2) .eq. 'TR') nnint = 19
    else if (typint .eq. 102) then
        if (typma(1:2) .eq. 'SE') nnint = 10
        if (typma(1:2) .eq. 'TR') nnint = 25
    else
        ASSERT(.false.)
    endif
end subroutine
