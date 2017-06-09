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

subroutine nmsssv(modelz, mate, carele, lischa, vesstf)
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/memare.h"
#include "asterfort/ss2mme.h"
    character(len=*) :: modelz
    character(len=24) :: mate, carele
    character(len=19) :: vesstf, lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - SOUS-STRUCTURATION)
!
! CALCUL DU VECTEUR CHARGEMENT SUR MACRO-ELEMENTS
!
! ----------------------------------------------------------------------
!
!
!
!
!
!
    character(len=8) :: modele
    character(len=24) :: fomul2
    integer :: iret
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    modele = modelz
    fomul2 = lischa(1:19)//'.FCSS'
!
! --- CALCUL
!
    call jeexin(fomul2, iret)
    if (iret .eq. 0) then
        ASSERT(.false.)
    else
        call memare('V', vesstf, modele, mate, carele(1:8),&
                    'CHAR_MECA')
        call jedetr(vesstf//'.RELC')
        call ss2mme(modele(1:8), 'SOUS_STRUC', vesstf, 'V')
    endif
!
    call jedema()
!
end subroutine
