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

subroutine mecanb(modele, matel)
    implicit none
!
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
    character(len=8) :: modele
    character(len=19) :: matel
! ----------------------------------------------------------------------
!
!     CALCUL DES SECONDS MEMBRES ELEMENTAIRES CONTENANT LES NORMALES
!     AUX ARETES AUX NOEUDS SOMMETS (EN FAIT LA SOMME DES 2 NORMALES)
!             ( VALABLE POUR LE 2D )
!
!     ENTREE :
!        MODELE : NOM DU MODELE
!
! ----------------------------------------------------------------------
!
!     FONCTIONS EXTERNES:
!     -------------------
!
!     VARIABLES LOCALES:
!     ------------------
    character(len=8) :: lpain(1), lpaout(1)
    character(len=16) :: option
    character(len=24) :: chgeom, lchin(1), lchout(1)
    character(len=24) :: ligrmo
!
!
!
!     -- CALCUL DE .RERR:
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    call memare('V', matel, modele, ' ', ' ',&
                'CHAR_MECA')
!
    call jedetr(matel//'.RELR')
!
    call megeom(modele, chgeom)
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpaout(1) = 'PVECTUR'
    lchout(1) = matel(1:8)//'.VE001'
    ligrmo = modele//'.MODELE'
    option = 'CALC_NOEU_BORD'
    call calcul('S', option, ligrmo, 1, lchin,&
                lpain, 1, lchout, lpaout, 'V',&
                'OUI')
    call reajre(matel, lchout(1), 'V')
!
    call jedema()
end subroutine
