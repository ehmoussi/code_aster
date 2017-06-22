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

subroutine prstoc(vecsol, vestoc, j, k, iad,&
                  nbvale, nbrefe, nbdesc)
    implicit none
!
!
!         ROUTINE STOCKANT LE VECTEUR PRESSION
!         ISSUE D' UNE RESOLUTION DE LAPLACE
! IN : VECSOL : VECTEUR SOLUTION K19
! IN : J : INDICE DE BOUCLE
! IN : IAD : ADRESSE DU VECTEUR DES NOMS DES CHAMNOS STOCKES
! IN : NBVALE,NBREFE,NBDESC : DIMENSIONS DE VECTEURS POUR UN CHAMNO
!---------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "blas/dcopy.h"
    integer ::    ivalp, idesp, irefp, j, k
    integer :: nbrefe, nbvale, nbdesc, iad, nbvec
    character(len=19) :: vecsol, vestoc
    character(len=24) :: chaine
!
! -------------------------------------------------------------------
!----------------CREATION DU VECTEUR PRESSION -----------------------
!
! -----------CREATION DU TABLEAU DE VECTEURS CONTENANT---------------
!--------------------------LA PRESSION-------------------------------
!
!-----------------------------------------------------------------------
    integer :: kb
    real(kind=8), pointer :: vale(:) => null()
    character(len=24), pointer :: refe(:) => null()
    integer, pointer :: desc(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    chaine = 'CBIDON'
!
    call codent(j, 'D0', chaine(1:5))
    zk24(iad+k-1) = vestoc(1:14)//chaine(1:5)
!
    call wkvect(zk24(iad+k-1)(1:19)//'.VALE', 'V V R', nbvale, ivalp)
    call wkvect(zk24(iad+k-1)(1:19)//'.REFE', 'V V K24', nbrefe, irefp)
    call wkvect(zk24(iad+k-1)(1:19)//'.DESC', 'V V I', nbdesc, idesp)
!
    call jeveuo(vecsol//'.VALE', 'L', vr=vale)
    call jelira(vecsol//'.VALE', 'LONMAX', nbvec)
    call jeveuo(vecsol//'.DESC', 'L', vi=desc)
    call jeveuo(vecsol//'.REFE', 'L', vk24=refe)
!
!-------------STOCKAGE DANS LE VECTEUR CREE -------------------------
!
    call dcopy(nbvec, vale, 1, zr(ivalp), 1)
!
    do 13 kb = 1, nbdesc
        zi(idesp+kb-1) = desc(kb)
13  continue
!
    do 14 kb = 1, nbrefe
        zk24(irefp+kb-1) = refe(kb)
14  continue
!
!
    call detrsd('CHAM_NO', vecsol)
!
    call jedema()
end subroutine
