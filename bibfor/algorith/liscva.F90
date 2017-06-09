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

subroutine liscva(prefob, chamno)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=13) :: prefob
    character(len=19) :: chamno
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! DONNE LE NOM DU CHAM_NO
!
! ----------------------------------------------------------------------
!
! CETTE ROUTINE EST OBLIGATOIRE TANT QUE L'ON A DES VRAIS VECT_ASSE
! ET DES FAUX
! VRAIS VECT_ASSE: DANS LES OPERATEURS DE DYNAMIQUE
! FAUX  VECT_ASSE: LE CHAMP EST STOCKE DANS UN OBJET CREE DANS
!                  AFFE_CHAR_MECA
!
! IN  PREFOB : PREFIXE DE L'OBJET DE LA CHARGE
! OUT CHAMNO : NOM DU CHAMP
!
!
!
!
    character(len=8) :: charge
    character(len=24) :: nomobj
    integer :: jobje, iret
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    chamno = ' '
    charge = prefob(1:8)
!
! --- ON IDENTIFIE
!
    call exisd('CHAM_NO', charge, iret)
    if (iret .eq. 1) then
        chamno = charge
    else
        nomobj = prefob(1:13)//'.VEASS'
        call jeexin(nomobj, iret)
        ASSERT(iret.ne.0)
        call jeveuo(nomobj, 'L', jobje)
        chamno = zk8(jobje)
        call exisd('CHAM_NO', chamno, iret)
        ASSERT(iret.gt.0)
    endif
!
    call jedema()
end subroutine
