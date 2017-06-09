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

subroutine cpmph20(conloc, numa, indno, indma)
!
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"

!
    integer, intent(in) :: indma
    integer, intent(in) :: indno
    integer, intent(in) :: numa
    character(len=24), intent(in) :: conloc
!
!
! ----------------------------------------------------------------------
!         CREATION DES MAILLES DES NOUVELLES MAILLES DE PEAU 
!         SUR LA FACE DE LA ZONE DE CONTACT ESCLAVE
!         CAS QUAD 8
! ----------------------------------------------------------------------
! IN        CONLOC  CONNECTIVITE LOCALE
! IN        NUMA    NUMERO DE LA MAILLE COURANTE
! IN        INDNO   INDICE DU PREMIER NOEUD AJOUTE
! IN        INDMA   INDICE DE LA PREMIERE MAILLE AJOUTEE
! ----------------------------------------------------------------------
    integer :: jconloc
! ----------------------------------------------------------------------
    call jemarq()
! ----------------------------------------------------------------------
    call jeecra(jexnum(conloc,indma), 'LONMAX', ival=8)
    call jeecra(jexnum(conloc,indma), 'LONUTI', ival=8)
    call jeveuo(jexnum(conloc,indma), 'E', jconloc)
    zi(jconloc+1-1) = zi(numa+1-1)
    zi(jconloc+2-1) = zi(numa+2-1)
    zi(jconloc+3-1) = indno+1
    zi(jconloc+4-1) = indno
    zi(jconloc+5-1) = zi(numa+5-1)
    zi(jconloc+6-1) = indno+9
    zi(jconloc+7-1) = indno+4
    zi(jconloc+8-1) = indno+8
! ----------------------------------------------------------------------
    call jeecra(jexnum(conloc,indma+1), 'LONMAX', ival=8)
    call jeecra(jexnum(conloc,indma+1), 'LONUTI', ival=8)
    call jeveuo(jexnum(conloc,indma+1), 'E', jconloc)
    zi(jconloc+1-1) = zi(numa+2-1)
    zi(jconloc+2-1) = zi(numa+3-1)
    zi(jconloc+3-1) = indno+2
    zi(jconloc+4-1) = indno+1
    zi(jconloc+5-1) = zi(numa+6-1)
    zi(jconloc+6-1) = indno+10
    zi(jconloc+7-1) = indno+5
    zi(jconloc+8-1) = indno+9
! ----------------------------------------------------------------------
    call jeecra(jexnum(conloc,indma+2), 'LONMAX', ival=8)
    call jeecra(jexnum(conloc,indma+2), 'LONUTI', ival=8)
    call jeveuo(jexnum(conloc,indma+2), 'E', jconloc)
    zi(jconloc+1-1) = zi(numa+3-1)
    zi(jconloc+2-1) = zi(numa+4-1)
    zi(jconloc+3-1) = indno+3
    zi(jconloc+4-1) = indno+2
    zi(jconloc+5-1) = zi(numa+7-1)
    zi(jconloc+6-1) = indno+11
    zi(jconloc+7-1) = indno+6
    zi(jconloc+8-1) = indno+10
! ----------------------------------------------------------------------
    call jeecra(jexnum(conloc,indma+3), 'LONMAX', ival=8)
    call jeecra(jexnum(conloc,indma+3), 'LONUTI', ival=8)
    call jeveuo(jexnum(conloc,indma+3), 'E', jconloc)
    zi(jconloc+1-1) = zi(numa+4-1)
    zi(jconloc+2-1) = zi(numa+1-1)
    zi(jconloc+3-1) = indno
    zi(jconloc+4-1) = indno+3
    zi(jconloc+5-1) = zi(numa+8-1)
    zi(jconloc+6-1) = indno+8
    zi(jconloc+7-1) = indno+7
    zi(jconloc+8-1) = indno+11
! ----------------------------------------------------------------------
    call jeecra(jexnum(conloc,indma+4), 'LONMAX', ival=8)
    call jeecra(jexnum(conloc,indma+4), 'LONUTI', ival=8)
    call jeveuo(jexnum(conloc,indma+4), 'E', jconloc)
    zi(jconloc+1-1) = indno
    zi(jconloc+2-1) = indno+1
    zi(jconloc+3-1) = indno+2
    zi(jconloc+4-1) = indno+3
    zi(jconloc+5-1) = indno+4
    zi(jconloc+6-1) = indno+5
    zi(jconloc+7-1) = indno+6
    zi(jconloc+8-1) = indno+7
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    call jedema()    
end subroutine
