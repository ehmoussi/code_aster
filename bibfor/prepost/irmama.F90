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

subroutine irmama(noma, nbma, nomai, nbgr, nogrm,&
                  nummai, nbmat, noltop)
! person_in_charge: nicolas.sellenet at edf.fr
    implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/juveca.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    character(len=*) :: noma, nomai(*), nogrm(*), nummai, noltop
    integer :: nbma, nbgr, nbmat
! ----------------------------------------------------------------------
!     BUT :   TROUVER LES NUMEROS DES MAILLES TROUVES DANS
!             UNE LISTE DE MAILLES ET DE GROUP_MA
!     ENTREES:
!        NOMA   : NOM DU MAILLAGE.
!        NBMA   : NOMBRE DE MAILLES
!        NBGR   : NOMBRE DE GROUPES DE MAILLES
!        NOMAI  : NOM DES  MAILLES
!        NOGRM  : NOM DES  GROUP_MA
!     SORTIES:
!        NBMAT  : NOMBRE TOTAL DE NOEUDS A IMPRIMER
!        NUMMAI : NOM DE L'OBJET CONTENANT LES NUMEROS
!                 DES MAILLES TROUVES.
! ----------------------------------------------------------------------
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
    character(len=8) :: nomma
    integer :: jnuma, ima, iad, in, jtopo, imai, igr, iret, nbn, lnuma
    integer ::  nbmama,  numa
    integer, pointer :: mailles(:) => null()
    integer, pointer :: dime(:) => null()
!
!
    call jemarq()
    nomma=noma
    nbmat= 0
    call jeveuo(noltop, 'E', jtopo)
    call jeveuo(nummai, 'E', jnuma)
    call jelira(nummai, 'LONMAX', lnuma)
!
!  --- TRAITEMENT DES LISTES DE MAILLES----
    if (nbma .ne. 0) then
!     --- RECUPERATION DU NUMERO DE MAILLE----
        do 12 imai = 1, nbma
            call jenonu(jexnom(nomma//'.NOMMAI', nomai(imai)), ima)
            if (ima .eq. 0) then
                valk (1) = nomai(imai)
                call utmess('A', 'PREPOST5_30', sk=valk(1))
                nomai(imai) = ' '
            else
                zi(jtopo-1+6) = zi(jtopo-1+6) + 1
                nbmat = nbmat + 1
                if (nbmat .gt. lnuma) then
                    lnuma=2*lnuma
                    call juveca(nummai, lnuma)
                    call jeveuo(nummai, 'E', jnuma)
                endif
                zi(jnuma-1+nbmat)=ima
            endif
12      continue
    endif
!  --- TRAITEMENT DES LISTES DE GROUPES DE MAILLES---
    if (nbgr .ne. 0) then
!     --- RECUPERATION DU NUMERO DE MAILLE----
        call jeveuo(nomma//'.DIME', 'L', vi=dime)
        nbmama = dime(3)
        AS_ALLOCATE(vi=mailles, size=nbmama)
        do 13 igr = 1, nbgr
            call jeexin(jexnom(nomma//'.GROUPEMA', nogrm(igr)), iret)
            if (iret .eq. 0) then
                valk (1) = nogrm(igr)
                call utmess('A', 'PREPOST5_31', sk=valk(1))
                nogrm(igr) = ' '
            else
                call jelira(jexnom(nomma//'.GROUPEMA', nogrm(igr)), 'LONMAX', nbn)
                if (nbn .eq. 0) then
                    valk (1) = nogrm(igr)
                    valk (2) = ' '
                    call utmess('A', 'PREPOST5_32', nk=2, valk=valk)
                    nogrm(igr) = ' '
                else
                    zi(jtopo-1+8) = zi(jtopo-1+8) + 1
                    call jeveuo(jexnom(nomma//'.GROUPEMA', nogrm(igr)), 'L', iad)
                    do 14 in = 1, nbn
                        numa = zi(iad+in-1)
                        if (mailles(numa) .eq. 0) then
                            nbmat=nbmat+1
                            if (nbmat .gt. lnuma) then
                                lnuma=2*lnuma
                                call juveca(nummai, lnuma)
                                call jeveuo(nummai, 'E', jnuma)
                            endif
                            zi(jnuma-1+nbmat)=numa
                            mailles(numa)=1
                        endif
14                  continue
                endif
            endif
13      continue
        AS_DEALLOCATE(vi=mailles)
    endif
!
    call jedema()
end subroutine
