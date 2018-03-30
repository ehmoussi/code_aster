! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine pjreco(listNodeOcc, nbNodeOcc, numOcc, finalOcc, nameLNodeInterc,&
                  nbNodeInterc)
    implicit none
! ----------------------------------------------------------------------
!     COMMANDE:  PROJ_CHAMP/VIS_A_VIS
! BUT : construction de l'intersection des listes de noeuds entre occurrences
!       renvoie le nom de l'object liste et sa longueur
!       rq : on stocke le numero d'occurrence de VIS_a_VIS dans la liste 
!            en derniere position
! ----------------------------------------------------------------------
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utlisi.h"
#include "asterfort/wkvect.h"
    integer, intent(in) :: listNodeOcc(*)
    integer, intent(in) :: nbNodeOcc
    integer, intent(in) :: numOcc
    aster_logical, intent(in) ::finalOcc
    character(len=16) :: nameLNodeInterc
    integer, intent(out) :: nbNodeInterc
! --------------------------------------------------------------------------------------------------
! --------------------------------------------------------------------------------------------------
    character(len=16) :: nameLNodeVerif
    integer :: nbNodeVerif, lonListInterc, lonListVerif
    integer :: nbNodeUnion, iexi
    integer, pointer :: listNodeVerif(:) => null()
    integer, pointer :: listNodeCopy(:) => null()
    integer, pointer :: listNodeInterc(:) => null()
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    nameLNodeVerif  = '&&PJRECO.LINOVER'
    nameLNodeInterc = '&&PJRECO.LINOINT'
    
    call jeexin(nameLNodeVerif, iexi)
    if (iexi .gt. 0) then
!       nodes from previous occ
        call jeveuo(nameLNodeVerif, 'E', vi=listNodeVerif)
        call jelira(nameLNodeVerif, 'LONMAX', nbNodeVerif)
        
!       intersection
        call jeexin(nameLNodeInterc, iexi)
        if (iexi .le. 0) then
            lonListInterc = min(nbNodeVerif, nbNodeOcc)
            call wkvect(nameLNodeInterc, 'V V I', lonListInterc+1, vi=listNodeInterc)
        endif
        
        
        call utlisi('INTER', listNodeVerif, nbNodeVerif, listNodeOcc, nbNodeOcc,&
                    listNodeInterc, lonListInterc, nbNodeInterc)
        if (nbNodeInterc.lt.0)then
            nbNodeInterc = - nbNodeInterc
            lonListInterc = nbNodeInterc
            call jedetr(nameLNodeInterc)
            call wkvect(nameLNodeInterc, 'V V I', lonListInterc+1, vi=listNodeInterc)
            call utlisi('INTER', listNodeVerif, nbNodeVerif, listNodeOcc, nbNodeOcc,&
                        listNodeInterc, lonListInterc, nbNodeInterc)
            ASSERT(nbNodeInterc.ge.0)
        endif
        listNodeInterc(nbNodeInterc+1) = numOcc

!       union 
        AS_ALLOCATE(vi=listNodeCopy, size=nbNodeVerif)
        listNodeCopy(1:nbNodeVerif) = listNodeVerif(1:nbNodeVerif)
        call jedetr(nameLNodeVerif)
        
        lonListVerif = nbNodeVerif+nbNodeOcc-nbNodeInterc
        call wkvect(nameLNodeVerif, 'V V I', lonListVerif, vi=listNodeVerif)
        
        call utlisi('UNION', listNodeCopy, nbNodeVerif, listNodeOcc, nbNodeOcc,&
                    listNodeVerif, lonListVerif, nbNodeUnion)
        ASSERT(nbNodeUnion.eq.lonListVerif)
        AS_DEALLOCATE(vi=listNodeCopy)
    else
!       first occ
        nbNodeVerif = nbNodeOcc
        call wkvect(nameLNodeVerif, 'V V I', nbNodeVerif, vi=listNodeVerif)
        listNodeVerif(1:nbNodeOcc) = listNodeOcc(1:nbNodeOcc)
        nbNodeInterc = 0
    endif
    
    if (finalOcc) call jedetr(nameLNodeVerif)
    
    call jedema()
            
end subroutine
