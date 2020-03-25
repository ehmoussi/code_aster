! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
! person_in_charge: nicolas.pignet at edf.fr
!
subroutine cgVerification(cgField, cgTheta)
!
use calcG_type
!
    implicit none
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
!
    type(CalcG_field), intent(in) :: cgField
    type(CalcG_theta), intent(in) :: cgTheta
!
!     CALC_G --- Utilities
!
!     Verification of inputs
!
! ======================================================================
!
    character(len=8) :: modele, mesh1, mesh2
!
    call jemarq()
!
    if(cgField%level_info>1) then
        call utmess('I', 'RUPTURE3_1')
    end if
!
!
!   TEST POUR IDENTIFIER SI LE MEME MAILLAGE EST UTILISÉ DANS LA SD FOND_FISS
!   ET LA SD RESU (test zzzz415a)
    call dismoi('MODELE', cgField%result_in, 'RESULTAT', repk=modele)
    call dismoi('NOM_MAILLA',modele,'MODELE', repk=mesh1)
    call dismoi('NOM_MAILLA',cgTheta%crack,'FOND_FISS', repk=mesh2)
    ASSERT(mesh1 .eq. mesh2)

    print*, "TODO: Finish verification"
!
    call jedema()
!
end subroutine
