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

subroutine mefgmn(noma, nbgma, ligrma)
    implicit none
!
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/gmgnre.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: noma
    character(len=24) :: ligrma(*)
    integer :: nbgma
!     CREATION DE GROUPES DE NOEUDS A PARTIR DES GROUPES DE MAILLES
!     POUR CHAQUE TUBES DU FAISCEAU. LES GROUPES DE NOEUDS CREES ONT
!     LE MEME NOM QUE LES GROUPES DE MAILLES.
! ----------------------------------------------------------------------
! IN  : NOMA   : NOM DU MAILLAGE.
! IN  : NBGMA  : NOMBRE DE GROUPES DE MAILLES A TRAITER.
! IN  : LIGRMA : LISTE DES NOMS DES GROUPES DE MAILLES.
!-----------------------------------------------------------------------
!
    character(len=8) :: numgno
    character(len=24) :: grpma, grpno, nomgma
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ialima, ialino, ianbno, igrno, iret
    integer :: j, n1, nbma, nbnoto
!-----------------------------------------------------------------------
    call jemarq()
    grpma = noma//'.GROUPEMA       '
!
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbnoto)
    if (nbnoto .eq. 0) goto 999
    if (nbgma .eq. 0) then
        call utmess('F', 'ALGELINE_82')
    endif
!
!
! --- TABLEAUX DE TRAVAIL
!
    call wkvect('&&MEFGMN.LISTE_NO ', 'V V I', (nbgma+1)*nbnoto, ialino)
    call wkvect('&&MEFGMN.NB_NO    ', 'V V I', nbgma, ianbno)
!
!
! --- ON REMPLIT L'OBJET DE TRAVAIL QUI CONTIENT LES GROUP_NO
! --- A AJOUTER:
!
    do i = 1, nbgma
        nomgma = ligrma(i)
        call jeexin(jexnom(grpma, nomgma), iret)
        if (iret .eq. 0) then
            call utmess('F', 'ELEMENTS_62', sk=nomgma)
        endif
        call jelira(jexnom(grpma, nomgma), 'LONUTI', nbma)
        call jeveuo(jexnom(grpma, nomgma), 'L', ialima)
        call gmgnre(noma, nbnoto, zi(ialino), zi(ialima), nbma,&
                    zi(ialino+ i*nbnoto), zi(ianbno-1+i), 'TOUS')
    end do
!
!
! --- CREATION DES GROUPES DE NOEUDS
!
!
    do i = 1, nbgma
        n1 = zi(ianbno-1+i)
        call codent(i, 'D0', numgno)
        grpno='&&MEFGMN.'//numgno//'       '
        call wkvect(grpno, 'V V I', n1, igrno)
        do j = 1, n1
            zi(igrno+j-1)=zi(ialino+i*nbnoto+j-1)
        end do
    end do
!
999 continue
!
! -- MENAGE
    call jedetr('&&MEFGMN.LISTE_NO ')
    call jedetr('&&MEFGMN.NB_NO    ')
    call jedema()
end subroutine
