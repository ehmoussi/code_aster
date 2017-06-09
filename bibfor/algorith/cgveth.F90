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

subroutine cgveth(typfis, cas)
    implicit none
#include "asterfort/utmess.h"
!
    character(len=8) :: typfis
    character(len=16) :: cas
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : VERIFICATION DES DONNEES RELATIVES AU(X) CHAMP(S) THETA
!
!  IN :
!    TYPFIS : TYPE DE LA SD DECRIVANT LE FOND DE FISSURE
!            ('THETA' OU 'FONDIFSS' OU 'FISSURE')
!    CAS    : '2D', '3D LOCAL' OU '3D GLOBAL'
! ======================================================================
!
!     SI LE CHAMP THETA EST FOURNI
    if (typfis .eq. 'THETA') then
!
!       ON NE DOIT PAS ETRE DANS UN CALCUL 3D LOCAL
        if (cas .eq. '3D_LOCAL') then
            call utmess('F', 'RUPTURE0_57')
        endif
!
!     SI LE CHAMP THETA N'EST PAS FOURNI
!      ELSE
!
    endif
!
end subroutine
