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

subroutine cpmctr3(conloc, jmacsu, indno, indma, conneo)
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
#include "asterfort/assert.h"

!
    integer, intent(in) :: indma
    integer, intent(in) :: indno
    integer, intent(in) :: jmacsu
    integer, intent(in) :: conneo(*)
    character(len=24), intent(in) :: conloc
!
! -------------------------------------------------------------------------------------------------
!         CREATION DES MAILLES DES NOUVELLES MAILLES VOLUMIQUE 
!         ASSOCIEE A LA ZONE DE CONTACT ESCLAVE
!         CAS QUAD 20
! -------------------------------------------------------------------------------------------------
! IN        CONLOC  CONNECTIVITE LOCALE
! IN        NUMA    NUMERO DE LA MAILLE COURANTE
! IN        INDNO   INDICE DU PREMIER NOEUD AJOUTE
! IN        INDMA   INDICE DE LA PREMIERE MAILLE AJOUTEE
! -------------------------------------------------------------------------------------------------
    integer :: lino(20), jconloc
! -------------------------------------------------------------------------------------------------
    call jemarq()
! -------------------------------------------------------------------------------------------------
    if (conneo(1) .ne. 0 .and. conneo(2) .ne. 0) then
! -------------------------------------------------------------------------------------------------
        lino(1) = 1
        lino(2) = 2
        lino(3) = 3
        !write(*,*) '1'
! -------------------------------------------------------------------------------------------------
    elseif (conneo(2) .ne. 0 .and. conneo(3) .ne. 0 ) then
!--------------------------------------------------------------------------------------------------
        lino(1) = 2
        lino(2) = 3
        lino(3) = 1
        !write(*,*) '2'
! -------------------------------------------------------------------------------------------------
    elseif (conneo(3) .ne. 0 .and. conneo(1) .ne. 0) then
!--------------------------------------------------------------------------------------------------
        lino(1) = 3
        lino(2) = 1
        lino(3) = 2
        !write(*,*) '3'

! -------------------------------------------------------------------------------------------------
    else
        ASSERT(.false.)
    endif
! -------------------------------------------------------------------------------------------------
    call jeecra(jexnum(conloc,indma), 'LONMAX', ival=3)
    call jeecra(jexnum(conloc,indma), 'LONUTI', ival=3)
    call jeveuo(jexnum(conloc,indma), 'E', jconloc)
    zi(jconloc+1-1) = zi(jmacsu+lino(1)-1)
    zi(jconloc+2-1) = indno
    zi(jconloc+3-1) = zi(jmacsu+lino(3)-1)
   
! =================================================================================================
    call jeecra(jexnum(conloc,indma+1), 'LONMAX', ival=3)
    call jeecra(jexnum(conloc,indma+1), 'LONUTI', ival=3)
    call jeveuo(jexnum(conloc,indma+1), 'E', jconloc)
    zi(jconloc+1-1) = indno
    zi(jconloc+2-1) = zi(jmacsu+lino(2)-1)
    zi(jconloc+3-1) = zi(jmacsu+lino(3)-1)
   

! -------------------------------------------------------------------------------------------------
    call jedema()
end subroutine
