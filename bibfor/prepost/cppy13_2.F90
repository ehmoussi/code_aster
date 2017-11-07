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

subroutine cppy13_2(main  , maout , inc   , jcoor , jcnnpa, conloc,&
                    limane, nomnoe, nbno  , jmacou, jmacsu, macou ,&
                    macsu , ind   , ind1)
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/jelira.h"
#include "asterfort/cpclma.h"
#include "asterfort/jenonu.h"
#include "asterfort/cnpc.h"
#include "asterfort/cpncpy13.h"
#include "asterfort/cpmcpy13_2.h"
#include "asterfort/cpnoq.h"
!
    character(len=8), intent(in) :: main
    character(len=8), intent(in) :: maout
    integer, intent(in) :: inc
    integer, intent(in) :: jcoor
    integer, intent(in) :: jcnnpa
    character(len=24), intent(in) :: conloc
    character(len=24), intent(in) :: limane
    character(len=24), intent(in) :: nomnoe
    integer, intent(in) :: nbno
    integer, intent(in) :: jmacou
    integer, intent(in) :: jmacsu
    integer, intent(in) :: macou
    integer, intent(in) :: macsu
    integer, intent(out) :: ind
    integer, intent(out) :: ind1
! -------------------------------------------------------------------------------------------------
!        CREATION DES NOUVEAUX NOEUDS ET NOUVELLES MAILLES CAS PENTA5 BASE TRIA3
! -------------------------------------------------------------------------------------------------
! -------------------------------------------------------------------------------------------------
    integer :: patch
    integer :: jlimane
    integer :: jconneo
    integer :: jconloc
    character(len=24) :: conneo
! -------------------------------------------------------------------------------------------------
    call jemarq()
!
    call jecroc(jexnum(maout//'.PATCH',inc+1))
    call jeecra(jexnum(maout//'.PATCH',inc+1), 'LONMAX', ival=2)
    call jeecra(jexnum(maout//'.PATCH',inc+1), 'LONUTI', ival=2)
    call jeveuo(jexnum(maout//'.PATCH',inc+1), 'E', patch)
! --- TYPE DE MAILLE PATCH
    zi(patch-1+1) = 19
! --- DDL INTERNE
    zi(patch-1+2)=nbno+ind1+3
    zi(jcnnpa+nbno+ind1+3-1) = inc
! --- CREATION DU NOEUD DDL INTERNE
    call cpnoq(main,macou,zr(jcoor),nbno+ind1,nomnoe)
! --- NOUVEAUX ELEMENTS DE PEAU
    call jeecra(jexnum(conloc,ind), 'LONMAX', ival=6)
    call jeecra(jexnum(conloc,ind), 'LONUTI', ival=6)
    call jeveuo(jexnum(conloc,ind), 'E', jconloc)
    zi(jconloc+1-1)=zi(jmacou+1-1)
    zi(jconloc+2-1)=zi(jmacou+2-1)
    zi(jconloc+3-1)=nbno+ind1+3
    zi(jconloc+4-1)=zi(jmacou+4-1)
    zi(jconloc+5-1)=nbno+ind1+1
    zi(jconloc+6-1)=nbno+ind1
    call jeecra(jexnum(conloc,ind+1), 'LONMAX', ival=6)
    call jeecra(jexnum(conloc,ind+1), 'LONUTI', ival=6)
    call jeveuo(jexnum(conloc,ind+1), 'E', jconloc)
    zi(jconloc+1-1)=zi(jmacou+2-1)
    zi(jconloc+2-1)=zi(jmacou+3-1)
    zi(jconloc+3-1)=nbno+ind1+3
    zi(jconloc+4-1)=zi(jmacou+5-1)
    zi(jconloc+5-1)=nbno+ind1+2
    zi(jconloc+6-1)=nbno+ind1+1
    call jeecra(jexnum(conloc,ind+2), 'LONMAX', ival=6)
    call jeecra(jexnum(conloc,ind+2), 'LONUTI', ival=6)
    call jeveuo(jexnum(conloc,ind+2), 'E', jconloc)
    zi(jconloc+1-1)=zi(jmacou+3-1)
    zi(jconloc+2-1)=zi(jmacou+1-1)
    zi(jconloc+3-1)=nbno+ind1+3
    zi(jconloc+4-1)=zi(jmacou+6-1)
    zi(jconloc+5-1)=nbno+ind1
    zi(jconloc+6-1)=nbno+ind1+2
! --- CREATION DES NOEUDS DDL DANS LE VOLUME
    conneo='&&PT151.CNORD'
    call cnpc(main, macou, macsu, conneo)
    call jeveuo(conneo,'L',jconneo)
    call cpncpy13(main, macsu, zr(jcoor), nbno+ind1+4, nomnoe, zi(jconneo))
! --- NOUVEAUX ELEMENTS DE CORPS
    call cpmcpy13_2(conloc, jmacsu, nbno+ind1, ind+3, zi(jconneo))
! --- CONNECTIVITE ANCIENS NOUVEAUX ELEMENTS (Peau)??
    call jeveuo(jexnum(limane, macou), 'E', jlimane)
    zi(jlimane+1-1)=ind
    zi(jlimane+2-1)=ind+1
    zi(jlimane+3-1)=ind+2
! --- INFO PATCH LIE
    zi(jlimane+4-1)=inc
! --- CONNECTIVITE ANCIENS NOUVEAUX ELEMENTS (Volume)??
    call jeveuo(jexnum(limane, macsu), 'E', jlimane)
    zi(jlimane+1-1)=ind+3
    zi(jlimane+2-1)=ind+4
    zi(jlimane+3-1)=ind+5
    zi(jlimane+4-1)=ind+6
! --- Nettoyage / mis à jour
    ind=ind+7
    ind1=ind1+6
    call jedetr(conneo)
!
    call jedema()
end subroutine
