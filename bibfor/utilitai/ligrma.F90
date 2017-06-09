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

subroutine ligrma(ma, listgr)
!
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: ma
    character(len=24) :: listgr
!
!   POUR CHAQUE MAILLE :
!   CREER LA LISTE DES GROUPES DE MAILLES CONTENANT CETTE MAILLE
!
!   IN
!       MA      : MAILLAGE
!
!   OUT
!       LISTGR  : LISTE DES GROUPES DE MAILLES
!
    integer :: nbma, iret, nbgma, i, iagma, n, ii, ima, jlong, jlist
    integer :: nbmat, jcpt
    character(len=24) :: long, vcpt
!
!
    call jemarq()
!
    call dismoi('NB_MA_MAILLA', ma, 'MAILLAGE', repi=nbma)
!
!     CREATION DU VECTEUR CONTENANT LE NOMBRE DE GROUPES PAR MAILLE
    long = '&&LIGRMA.LONG'
    call wkvect(long, 'V V I', nbma, jlong)
!
!     CREATION DU VECTEUR COMPTEUR
    vcpt = '&&LIGRMA.VCPT'
    call wkvect(vcpt, 'V V I', nbma, jcpt)
!
    call jeexin(ma//'.GROUPEMA', iret)
    nbgma = 0
    nbmat = 0
    if (iret .gt. 0) call jelira(ma//'.GROUPEMA', 'NUTIOC', nbgma)
!
!     ON PARCOURT LES GROUPES DE MAILLES ET ON REMPLIT L'OBJET LONG
    do i = 1, nbgma
        call jeveuo(jexnum(ma//'.GROUPEMA', i), 'L', iagma)
        call jelira(jexnum(ma//'.GROUPEMA', i), 'LONUTI', n)
        do ii = 1, n
            ima=zi(iagma-1+ii)
            zi(jlong-1+ima)=zi(jlong-1+ima)+1
            nbmat = nbmat +1
        end do
    end do
!
!     CREATION DE LA COLLECTION CONTINUE A NBMA LIGNES DE LONGUEUR
!     TOTALE EGALE A NBMAT
    call jecrec(listgr, 'V V I', 'NU', 'CONTIG', 'VARIABLE',&
                nbma)
    call jeecra(listgr, 'LONT', nbmat)
    do ima = 1, nbma
        call jeecra(jexnum(listgr, ima), 'LONMAX', zi(jlong-1+ima))
        call jecroc(jexnum(listgr, ima))
    end do
!
!     REMPLISSAGE DE LISTGR AVEC LES NUMEROS DES GROUPES
    do i = 1, nbgma
        call jeveuo(jexnum(ma//'.GROUPEMA', i), 'L', iagma)
        call jelira(jexnum(ma//'.GROUPEMA', i), 'LONUTI', n)
        do ii = 1, n
            ima=zi(iagma-1+ii)
            call jeveuo(jexnum(listgr, ima), 'E', jlist)
!         ON AJOUTE LE GROUPE I A LA LISTE DES GROUPES POUR CETTE MAILLE
            zi(jcpt-1+ima) = zi(jcpt-1+ima) + 1
            zi(jlist-1+zi(jcpt-1+ima)) = i
        end do
    end do
!
    call jedetr(long)
    call jedetr(vcpt)
!
    call jedema()
end subroutine
