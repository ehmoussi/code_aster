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

subroutine mmelin(noma, numa, typint, nnint)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
#include "asterfort/mmelty.h"
    character(len=8) :: noma
    integer :: numa
    integer :: typint
    integer :: nnint
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! RETOURNE LE NOMBRE DE POINTS D'INTEGRATION POUR UN ELEMENT DE CONTACT
! SUIVANT LE TYPE DE SCHEMA D'INTEGRATION
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NUMA   : NUMERO ABSOLU DE LA MAILLE
! IN  TYPINT : TYPE D'INTEGRATION
!      / 1 'AUTO'    (ON CHOISIT LE SCHEMA LE PLUS ADAPTE)
!      /X2 'GAUSS'   (X EST LE DEGRE DES POLYNOMES DE LEGENDRE)
!      /Y3 'SIMPSON' (Y EST LE NOMBRE DE SUBDIVISIONS)
!      /Z4 'NCOTES'  (Z EST LE DEGRE DU POLYNOME INTERPOLATEUR)
! OUT NNINT  : NOMBRE DE POINTS D'INTEGRATION DE CET ELEMENT
!
! ----------------------------------------------------------------------
!
    character(len=8) :: alias
    integer :: param
!
! ----------------------------------------------------------------------
!
    call mmelty(noma, numa, alias)
!
!     'AUTO'
    if (typint .eq. 1) then
        if (alias(1:3) .eq. 'SE2') then
            nnint = 2
        else if (alias(1:3).eq.'SE3') then
            nnint = 3
        else if (alias(1:3).eq.'TR3') then
            nnint = 3
        else if (alias(1:3).eq.'TR6') then
            nnint = 6
        else if (alias(1:3).eq.'TR7') then
            nnint = 6
        else if (alias(1:3).eq.'QU4') then
            nnint = 4
        else if (alias(1:3).eq.'QU8') then
            nnint = 9
        else if (alias(1:3).eq.'QU9') then
            nnint = 9
        else
            ASSERT(.false.)
        endif
!
!     'GAUSS'
    else if (mod(typint,10) .eq. 2) then
        param = typint/10
        if (alias(1:2) .eq. 'SE') then
            nnint = param
        else if (alias(1:2) .eq. 'TR') then
            if (param .eq. 1) then
                nnint = 1
            else if (param .eq. 2) then
                nnint = 3
            else if (param .eq. 3) then
                nnint = 4
            else if (param .eq. 4) then
                nnint = 6
            else if (param .eq. 5) then
                nnint = 7
            else if (param .eq. 6) then
                nnint = 12
            else
                ASSERT(.false.)
            endif
        else if (alias(1:2) .eq. 'QU') then
            nnint = param**2
        else
            ASSERT(.false.)
        endif
!
!     'SIMPSON'
    else if (mod(typint,10) .eq. 3) then
        param = typint/10
        if (alias(1:2) .eq. 'SE') then
            nnint = 2*param+1
        else if (alias(1:2) .eq. 'TR') then
            nnint = 2*(param**2)+3*param+1
        else if (alias(1:2) .eq. 'QU') then
            nnint = (2*param+1)**2
        else
            ASSERT(.false.)
        endif
!
!     'NCOTES'
    else if (mod(typint,10) .eq. 4) then
        param = typint/10
        if (alias(1:2) .eq. 'SE') then
            nnint = param+1
        else if (alias(1:2) .eq. 'TR') then
            nnint = (param+1)*(param+2)/2
        else if (alias(1:2) .eq. 'QU') then
            nnint = (param+1)**2
        else
            ASSERT(.false.)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
