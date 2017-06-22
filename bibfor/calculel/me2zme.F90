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

subroutine me2zme(modelz, chsigz, vecelz)
    implicit none
!
!
!     ARGUMENTS:
!     ----------
! ......................................................................
!     BUT:
!         CALCUL DE TOUS LES SECONDS MEMBRES ELEMENTAIRES PERMETTANT
!         DE CALCULER L'ESTIMATEUR D'ERREUR SUR LES CONTRAINTES
!
!                 OPTION : 'SECM_ZZ1'
!
!     ENTREES:
!
!     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
!        MODELZ : NOM DU MODELE
!        CHSIGZ : NOM DU CHAMP DE CONTRAINTES CALCULEES
!        VECELZ : NOM DU VEC_ELE (N RESUELEM) PRODUIT
!                 SI VECEL EXISTE DEJA, ON LE DETRUIT.
!
!     SORTIES:
! ......................................................................
!
!
!
!
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
    character(len=8) :: modele
    character(len=19) :: vecel
    character(len=8) :: lpain(2), lpaout(6)
    character(len=16) :: option
    character(len=24) :: lchin(2), lchout(6), ligrmo, chgeom, chsig
    character(len=*) :: modelz, chsigz, vecelz
!
!
!-----------------------------------------------------------------------
    integer :: ibid
!-----------------------------------------------------------------------
    call jemarq()
    modele = modelz
    chsig = chsigz
    vecel = vecelz
!
    call megeom(modele, chgeom)
!
    call detrsd('VECT_ELEM', vecel)
    call memare('V', vecel, modele, ' ', ' ',&
                'SECM_ZZ1')
!
    lpaout(1) = 'PVECTR1'
    lpaout(2) = 'PVECTR2'
    lpaout(3) = 'PVECTR3'
    lpaout(4) = 'PVECTR4'
    lpaout(5) = 'PVECTR5'
    lpaout(6) = 'PVECTR6'
!
    lchout(1) = '&&ME2ZME.VE001'
    lchout(2) = '&&ME2ZME.VE002'
    lchout(3) = '&&ME2ZME.VE003'
    lchout(4) = '&&ME2ZME.VE004'
    lchout(5) = '&&ME2ZME.VE005'
    lchout(6) = '&&ME2ZME.VE006'
!
    call corich('E', lchout(1), -1, ibid)
    call corich('E', lchout(2), -1, ibid)
    call corich('E', lchout(3), -1, ibid)
    call corich('E', lchout(4), -1, ibid)
    call corich('E', lchout(5), -1, ibid)
    call corich('E', lchout(6), -1, ibid)
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpain(2) = 'PSIEF_R'
    lchin(2) = chsig
    ligrmo = modele//'.MODELE'
!
    option = 'SECM_ZZ1'
!
    call calcul('S', option, ligrmo, 2, lchin,&
                lpain, 6, lchout, lpaout, 'V',&
                'OUI')
    call reajre(vecel, lchout(1), 'V')
    call reajre(vecel, lchout(2), 'V')
    call reajre(vecel, lchout(3), 'V')
    call reajre(vecel, lchout(4), 'V')
    call reajre(vecel, lchout(5), 'V')
    call reajre(vecel, lchout(6), 'V')
!
    call jedema()
end subroutine
