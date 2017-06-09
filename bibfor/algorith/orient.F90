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

subroutine orient(mdgene, sst, jcoor, ino, coordo,&
                  itran)
    implicit none
!
!     BUT: CALCUL DES COORDONNEES D'UN NOEUD D'UNE SOUS-STRUCTURE
!          DANS LE REPERE PHYSIQUE
!
! IN  : MDGENE : NOM UTILISATEUR DU MODELE GENERALISE
! IN  : SST    : NOM DE LA SOUS-STRUCTURE
! IN  : JCOOR  : ADRESSE JEVEUX DU .COORDO.VALE DU MAILLAGE DE SST
! IN  : INO    : DECALAGE DONNANT L'ADRESSE JEVEUX DU NOEUD
! OUT : COORDO : COORDONNEES DU NOEUD DANS LE REPERE PHYSIQUE
! IN  : ITRAN  : ENTIER = 1 : PRISE EN COMPTE DE LA TRANSLATION
!                       = 0 : NON PRISE EN COMPTE DE LA TRANSLATION
!
! ----------------------------------------------------------------------
!
!
!
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/intet0.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/pmppr.h"
#include "asterfort/r8inir.h"
!
!
!-----------------------------------------------------------------------
    integer :: ibid, itran, k, l, llrot, lltra, nbcmpm
!
!-----------------------------------------------------------------------
    parameter   (nbcmpm=10)
    character(len=8) :: sst
    character(len=24) :: mdgene
    integer :: jcoor, ino
    real(kind=8) :: matrot(nbcmpm, nbcmpm), xanc(3), xnew, coordo(3), r8bid
    real(kind=8) :: matbuf(nbcmpm, nbcmpm), mattmp(nbcmpm, nbcmpm)
!
!     ------------------------------------------------------------------
!
    call jemarq()
    call jenonu(jexnom(mdgene(1:14)//'.MODG.SSNO', sst), ibid)
    call jeveuo(jexnum(mdgene(1:14)//'.MODG.SSOR', ibid), 'L', llrot)
    call jeveuo(jexnum(mdgene(1:14)//'.MODG.SSTR', ibid), 'L', lltra)
!
    call intet0(zr(llrot), mattmp, 3)
    call intet0(zr(llrot+1), matrot, 2)
    r8bid = 0.d0
    call r8inir(nbcmpm*nbcmpm, r8bid, matbuf, 1)
    call pmppr(mattmp, nbcmpm, nbcmpm, 1, matrot,&
               nbcmpm, nbcmpm, 1, matbuf, nbcmpm,&
               nbcmpm)
    r8bid = 0.d0
    call r8inir(nbcmpm*nbcmpm, r8bid, matrot, 1)
    call intet0(zr(llrot+2), mattmp, 1)
    call pmppr(matbuf, nbcmpm, nbcmpm, 1, mattmp,&
               nbcmpm, nbcmpm, 1, matrot, nbcmpm,&
               nbcmpm)
!
    do 10 k = 1, 3
        xanc(k)=zr(jcoor+(ino-1)*3+k-1)
10  end do
!
    do 20 k = 1, 3
        xnew=0.d0
        do 30 l = 1, 3
            xnew=xnew+matrot(k,l)*xanc(l)
30      continue
        if (itran .eq. 1) then
            coordo(k)=xnew+zr(lltra+k-1)
        else if (itran.eq.0) then
            coordo(k)=xnew
        else
            ASSERT(.false.)
        endif
20  end do
!
    call jedema()
end subroutine
