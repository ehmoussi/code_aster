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

subroutine memzme(modele, matel)
    implicit none
!     CALCUL DES MATRICES ELEMENTAIRES DE MASSE MECA
!
! ----------------------------------------------------------------------
! IN  : MODELE : NOM DU MODELE (OBLIGATOIRE)
! IN  : MATEL  : NOM DU MATR_ELEM RESULTAT
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/utmess.h"
    character(len=19) :: matel
    character(len=8) :: lpain(1), lpaout(1), modele
    character(len=24) :: ligrmo, lchin(1), lchout(1), option, chgeom
!
!-----------------------------------------------------------------------
    character(len=24), pointer :: rerr(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    if (modele(1:1) .eq. ' ') then
        call utmess('F', 'CALCULEL2_82')
    endif
!
    call megeom(modele, chgeom)
!
    call memare('V', matel, modele, ' ', ' ',&
                'MASS_ZZ1')
    call jeveuo(matel//'.RERR', 'E', vk24=rerr)
    rerr(3) (1:3) = 'OUI'
!
    call jedetr(matel//'.RELR')
!
    lpaout(1) = 'PMATZZR'
    lchout(1) = matel(1:8)//'.ME001'
!
    ligrmo = modele//'.MODELE'
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
!
    option = 'MASS_ZZ1'
    call calcul('S', option, ligrmo, 1, lchin,&
                lpain, 1, lchout, lpaout, 'V',&
                'OUI')
    call reajre(matel, lchout(1), 'V')
!
    call jedema()
end subroutine
