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

subroutine merigy(modele, mate, cara, compor, matel,& 
                  nchar, lchar)
    implicit none
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/exlima.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/mecara.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/utmess.h"
#include "asterfort/exisd.h"
    character(len=8) :: modele, cara, lchar(*)
    character(len=19) :: matel
    character(len=24) :: mate
    character(len=*) :: compor
    integer :: nchar
! ----------------------------------------------------------------------
!     CALCUL DES MATRICES ELEMENTAIRES DE RAIDEUR GYROSCOPIQUE
!     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
!     ENTREES:
!        MODELE : NOM DU MODELE
!        MATE   : CHAMP DE MATERIAUX
!        CARA   : CARACTERISTIQUES ELEMENTAIRES
!     SORTIES:
!        MATEL  : NOM DU MATEL (MATRICE ELEMENTAIRE) PRODUIT
!
! ----------------------------------------------------------------------
! ---------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=8) :: lpain(12), lpaout(1)
    character(len=16) :: option
    character(len=19) :: chvarc
    character(len=24) :: chgeom, chcara(18), lchin(12), lchout(1)
    character(len=24) :: ligrel, chrota
    data chvarc /'&&MERIGY.CHVARC'/
    integer :: icha, iret, nbro
!
!
    call jemarq()
!
    ASSERT(modele.ne.' ')
    ASSERT(mate.ne.' ')
!
    call jedetr(matel//'.RERR')
    call jedetr(matel//'.RELR')
!
    call memare('G', matel, modele, mate, ' ',&
                'RIGI_GYRO')
!
    call megeom(modele, chgeom)
    ASSERT(chgeom.ne.' ')
!
    nbro = 0
    do 10 icha = 1,nchar
        call exisd('CHAMP_GD',lchar(icha)//'.CHME.ROTAT',iret)
        if (iret.ne.0) then
          chrota = lchar(icha)//'.CHME.ROTAT.DESC'
          nbro = nbro + 1
        end if
 10 continue
!
!    CHAMP DE CARACTERISTIQUES ELEMENTAIRES
    call mecara(cara, chcara)
!
!
    lpaout(1) = 'PMATUNS'
    lchout(1) = matel(1:8)//'.ME001'
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpain(2) = 'PMATERC'
    lchin(2) = mate
    lpain(3) = 'PCAORIE'
    lchin(3) = chcara(1)
    lpain(4) = 'PCAGNPO'
    lchin(4) = chcara(6)
    lpain(5) = 'PCADISM'
    lchin(5) = chcara(3)
    lpain(6) = 'PCINFDI'
    lchin(6) = chcara(15)
    lpain(7) = 'PCAARPO'
    lchin(7) = chcara(9)
    lpain(8) = 'PNBSP_I'
    lchin(8) = chcara(16)
    lpain(9) = 'PFIBRES'
    lchin(9) = chcara(17)
    lpain(10) = 'PCOMPOR'
    lchin(10) = compor
    lpain(11) = 'PROTATR'
    lchin(11) = chrota
    lpain(12) = 'PVARCPR'
    lchin(12) = chvarc
    call exlima(' ', 1, 'G', modele, ligrel)
    option = 'RIGI_GYRO'
!
!
    call calcul('S', option, ligrel, 12, lchin,&
                lpain, 1, lchout, lpaout, 'G',&
                'OUI')
!
    call reajre(matel, lchout(1), 'G')
!
    call jedema()
!
end subroutine
