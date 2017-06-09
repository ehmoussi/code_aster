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

subroutine pjnout(modele)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: modele
!
!     BUT : CREER SUR LA BASE 'V' L'OBJET SD_MODELE.NOEUD_UTIL
!
!     LONG(.NOEUD_UTIL)= NB_NO(MAILLAGE(MODELE))
!     NOEUD_UTIL(INO) = 1 : INO APPARTIENT A UN ELEMENT
!                           DU LIGREL DU MODELE
!     NOEUD_UTIL(INO) = 0 =>: SINON
!     ------------------------------------------------------------------
!
    character(len=8) :: noma
    integer :: nbnoeu, jnout, ima, nbno, j,  nbmail
!     ------------------------------------------------------------------
!
!     FONCTIONS "FORMULES" POUR ACCEDER RAPIDEMENT A LA CONNECTIVITE :
    integer ::  iconx2
    integer, pointer :: connex(:) => null()
    integer, pointer :: maille(:) => null()
#define zzconx(imail,j) connex(zi(iconx2+imail-1)+j-1)
#define zznbne(imail) zi(iconx2+imail) - zi(iconx2+imail-1)
!     ------------------------------------------------------------------
!
!
    call jemarq()
!
    call dismoi('NOM_MAILLA', modele, 'MODELE', repk=noma)
    call dismoi('NB_NO_MAILLA', modele, 'MODELE', repi=nbnoeu)
    call jedetr(modele//'.NOEUD_UTIL')
    call wkvect(modele//'.NOEUD_UTIL', 'V V I', nbnoeu, jnout)
!
    call dismoi('NB_MA_MAILLA', modele, 'MODELE', repi=nbmail)
    if (nbmail .eq. 0) goto 290
!
    call jeveuo(noma//'.CONNEX', 'L', vi=connex)
    call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', iconx2)
    call jeveuo(modele//'.MAILLE', 'L', vi=maille)
!
    do ima = 1, nbmail
        if (maille(ima) .eq. 0) goto 280
        nbno = zznbne(ima)
        do j = 1, nbno
            zi(jnout-1+zzconx(ima,j)) = 1
        end do
280     continue
    end do
290 continue
!
    call jedema()
end subroutine
