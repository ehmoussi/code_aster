! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
! BUT : Construction de l'intersection des listes de noeuds entre occurrences
!       de VIS_A_VIS
!       On cherche l'intersection des noeuds de l'occurrence courante avec
!       l'union des noeuds des occurrences précédentes.
!
!       Renvoie le nom de l'object liste dans : nameLNodeInterc
!       et sa longueur dans : nbNodeInterc
!       De plus a chaque appel, on construit une liste de noeud correspondant
!       a l'union des noeuds présents dans les occurrences de VIS_A_VIS déjà
!       traitées dans nameLNodeVerif
!       
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
    lonListInterc = 0
    
    call jeexin(nameLNodeVerif, iexi)
    if (iexi .gt. 0) then
!       nodes from previous occurrencies
        call jeveuo(nameLNodeVerif, 'E', vi=listNodeVerif)
        call jelira(nameLNodeVerif, 'LONMAX', nbNodeVerif)
        
!       intersection dans listNodeInterc
        call jeexin(nameLNodeInterc, iexi)
        if (iexi .le. 0) then
            lonListInterc = min(nbNodeVerif, nbNodeOcc) + 1
            call wkvect(nameLNodeInterc, 'V V I', lonListInterc, vi=listNodeInterc)
        else
            call jeveuo(nameLNodeInterc, 'E', vi=listNodeInterc)
            call jelira(nameLNodeInterc, 'LONMAX', lonListInterc)
        endif
        ASSERT(lonListInterc .gt. 0)
        
        call utlisi('INTER', listNodeVerif, nbNodeVerif, listNodeOcc, nbNodeOcc,&
                    listNodeInterc, lonListInterc-1 , nbNodeInterc)
        if (nbNodeInterc.lt.0)then
!           listNodeInterc n'est pas assez long
            nbNodeInterc = - nbNodeInterc
            lonListInterc = nbNodeInterc + 1
            call jedetr(nameLNodeInterc)
            call wkvect(nameLNodeInterc, 'V V I', lonListInterc, vi=listNodeInterc)
            call utlisi('INTER', listNodeVerif, nbNodeVerif, listNodeOcc, nbNodeOcc,&
                        listNodeInterc, lonListInterc, nbNodeInterc)
            ASSERT(nbNodeInterc.ge.0)
        endif
        listNodeInterc(nbNodeInterc+1) = numOcc

!       union dans listNodeVerif (pour iteration suivante)
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
        ASSERT(numOcc .eq.1)
        nbNodeVerif = nbNodeOcc
        call wkvect(nameLNodeVerif, 'V V I', nbNodeVerif, vi=listNodeVerif)
        listNodeVerif(1:nbNodeOcc) = listNodeOcc(1:nbNodeOcc)
        nbNodeInterc = 0
    endif
    
    if (finalOcc) call jedetr(nameLNodeVerif)
    
    call jedema()
            
end subroutine
