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

subroutine peenc2(champ, rcoef)
    implicit none
#include "jeveux.h"
#include "asterfort/celver.h"
#include "asterfort/digdel.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nbelem.h"
#include "asterfort/nbgrel.h"
#include "asterfort/utmess.h"
    character(len=*) :: champ
    real(kind=8) :: rcoef
!     FAIRE DES OPERATIONS SUR UN CHAM_ELEM DE TYPE ENERGIE
!            (NOTION D'INTEGRALE DU CHAMP SUR LE MODELE)
!     ------------------------------------------------------------------
! IN  : CHAMP  : NOM DU CHAM_ELEM
! IN  : RCOEF  : COEFFICIENT MULTIPLICATIF
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: ibid, nbgr, i, j, k, indic
    integer ::   lvale, mode, longt, nel, idecgr, icoef
    character(len=4) :: docu
    character(len=19) :: champ2, ligrel
    integer, pointer :: celd(:) => null()
    character(len=24), pointer :: celk(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
    champ2 = champ
!
!     --- ON RETROUVE LE NOM DU LIGREL ---
!
!     -- ON VERIFIE QUE LE CHAM_ELEM N'EST PAS TROP DYNAMIQUE :
    call celver(champ2, 'NBVARI_CST', 'STOP', ibid)
    call celver(champ2, 'NBSPT_1', 'STOP', ibid)
!
    call jelira(champ2//'.CELD', 'DOCU', cval=docu)
    if (docu .ne. 'CHML') then
        call utmess('F', 'CALCULEL3_52')
    endif
    call jeveuo(champ2//'.CELK', 'L', vk24=celk)
    ligrel = celk(1)(1:19)
!
    call jeveuo(champ2//'.CELD', 'L', vi=celd)
!
!     --- ON NE VERIFIE PAS LES LONGUEURS, CAR ELLES SONT DIFFERENTES
!         SUIVANT LE TYPE D'ELEMENT.
!     --- LA VALEUR "TOTALE" QUE L'ON VEUT RECUPERER EST PLACE EN 1
    nbgr = nbgrel( ligrel )
!
    call jeveuo(champ2//'.CELV', 'E', lvale)
    do 30 j = 1, nbgr
        mode=celd(celd(4+j) +2)
        if (mode .eq. 0) goto 30
        icoef=max(1,celd(4))
        longt = digdel(mode) * icoef
        nel = nbelem( ligrel, j )
        idecgr=celd(celd(4+j)+8)
        do 32 k = 1, nel
!
!            --- TOTALE ---
            i = 1
            indic = lvale-1+idecgr+(k-1)*longt+i-1
            zr(indic) = zr(indic) * rcoef
32      continue
30  continue
!
    call jedema()
end subroutine
