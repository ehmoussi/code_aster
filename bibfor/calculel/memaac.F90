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

subroutine memaac(modele, mate, mateco, matel)
    implicit none
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/utmess.h"
    character(len=8) :: modele
    character(len=19) :: matel
    character(len=*) :: mate, mateco
!
!     CALCUL DES MATRICES ELEMENTAIRES DE MASSE_ACOUSTIQUE
!                ( 'MASS_ACOU', ISO )
!
!     ENTREES:
!
!     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
!        MODELE : NOM DU MODELE
!*       MATE   : CARTE DE MATERIAU CODE
!        MATEL  : NOM DU MAT_ELE(N RESUELEM) PRODUIT
!
!     SORTIES:
!        MATEL  : EST CALCULE
!
! ----------------------------------------------------------------------
!
!     FONCTIONS EXTERNES:
!     -------------------
!
!     VARIABLES LOCALES:
!     ------------------
!*
!*
    character(len=8) :: lpain(4), lpaout(1)
    character(len=16) :: option
!*
    character(len=24) :: chgeom, lchin(4), lchout(1)
    character(len=24) :: ligrmo
!
!
!-----------------------------------------------------------------------
    integer :: ilires, iret
!-----------------------------------------------------------------------
    call jemarq()
    if (modele(1:1) .eq. ' ') then
        call utmess('F', 'CALCULEL3_50')
    endif
!
    call megeom(modele, chgeom)
!
    call jeexin(matel//'.RERR', iret)
    if (iret .gt. 0) then
        call jedetr(matel//'.RERR')
        call jedetr(matel//'.RELR')
    endif
    call memare('G', matel, modele, mate, ' ',&
                'MASS_ACOU')
!
    lpaout(1) = 'PMATTTC'
    lchout(1) = matel(1:8)//'.ME000'
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
!**
    lpain(2) = 'PMATERC'
    lchin(2) = mateco
!**
!
    ligrmo = modele//'.MODELE'
    option = 'MASS_ACOU'
    ilires = 0
    ilires = ilires + 1
    call codent(ilires, 'D0', lchout(1) (12:14))
    call calcul('S', option, ligrmo, 2, lchin,&
                lpain, 1, lchout, lpaout, 'G',&
                'OUI')
    call exisd('CHAMP_GD', lchout(1) (1:19), iret)
    call reajre(matel, lchout(1), 'G')
!
    call jedema()
end subroutine
