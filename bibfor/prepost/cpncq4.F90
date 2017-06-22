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

subroutine cpncq4(main,numa,coor,ind,nomnoe, conneo)
!
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/jecroc.h"
#include "asterfort/jeexin.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/reerel.h"
#include "asterfort/assert.h"
!
    integer, intent(in) :: ind
    integer, intent(in) :: numa
    real(kind=8),intent(out) :: coor(3, *)
    character(len=8), intent(in) :: main
    character(len=24), intent(in) :: nomnoe
    integer, intent(in) :: conneo(*)
!
!
! ----------------------------------------------------------------------
!         CREATION DU NOEUD SUPPLEMENTAIRE 
!         SUR LE VOLUME 'DE LA ZONE DE CONTACT ESCLAVE'
! ----------------------------------------------------------------------
! IN        NUMA    NUMERO DE LA MAILLE COURANTE
! IN        IND     INDICE DU PREMIER NOEUD AJOUTE
! IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
! VAR       COOR    COORDONNEES DES NOEUDS
! IN        CONNEO  CONNECTIVIT2 DES ORDRE DES NOEUDS DU VOLUME 
!                   ET DE LA FACE CORRESPONDANTE
! ----------------------------------------------------------------------
!
!
    integer :: lino(4), jtab, lgnd, iret
    integer :: inc1, inc2
    real(kind=8) ::xe(3), xp(3), tabar(4*3)
!
    character(len=8) :: nomnd,eletyp
    character(len=24) :: valk
    character(len=6) :: knume
   
! ----------------------------------------------------------------------
!
! - INSERTION DES NOUVEAUX NOEUDS
    do inc1=1,2
! ------ NOM DU NOEUD CREE
        call codent(ind+inc1-1, 'G', knume)
        lgnd = lxlgut(knume)
        if (lgnd+2 .gt. 8) then
            call utmess('F', 'ALGELINE_16')
        endif
        nomnd = 'DL' // knume
! ------ DECLARATION DU NOEUD CREE
        call jeexin(jexnom(nomnoe, nomnd), iret)
        if (iret .eq. 0) then
            call jecroc(jexnom(nomnoe, nomnd))
        else
            valk = nomnd
            call utmess('F', 'ALGELINE4_5', sk=valk)
        endif
    end do
!
! - CALCUL DES COORDONNEES DES NOUVEAUX NOEUDS
    call jeveuo(jexnum(main//'.CONNEX',numa),'L',jtab)
    do  inc1=1, 4
        lino(inc1)= zi(jtab+inc1-1) 
    end do
    do inc1=1,4
        do inc2=1,2
            tabar((inc1-1)*2+inc2) =  coor(inc2,lino(inc1))      
        end do
    end do
    eletyp='QU4' 
    if (conneo(1) .ne. 0 .and. conneo(2) .ne. 0) then
    ! --- NOEUD 1 
        xp(1:3) = 0.d0
        xe(1) = -1.d0/3.d0
        xe(2) = 0.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(1)-1) = xp(1)
        coor(2,ind+conneo(1)-1) = xp(2)
    ! --- NOEUD 2 
        xp(1:3) = 0.d0
        xe(1) = 1.d0/3.d0
        xe(2) = 0.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(2)-1) = xp(1)
        coor(2,ind+conneo(2)-1) = xp(2)
    elseif (conneo(2) .ne. 0 .and. conneo(3) .ne. 0) then
    ! --- NOEUD 1 
        xp(1:3) = 0.d0
        xe(1) = 0.d0
        xe(2) = -1.d0/3.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(2)-1) = xp(1)
        coor(2,ind+conneo(2)-1) = xp(2)
    ! --- NOEUD 2 
        xp(1:3) = 0.d0
        xe(1) = 0.d0
        xe(2) = 1.d0/3.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(3)-1) = xp(1)
        coor(2,ind+conneo(3)-1) = xp(2)
    elseif (conneo(3) .ne. 0 .and. conneo(4) .ne. 0) then
    ! --- NOEUD 1 
        xp(1:3) = 0.d0
        xe(1) = -1.d0/3.d0
        xe(2) = 0.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(4)-1) = xp(1)
        coor(2,ind+conneo(4)-1) = xp(2)
    ! --- NOEUD 2 
        xp(1:3) = 0.d0
        xe(1) = 1.d0/3.d0
        xe(2) = 0.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(3)-1) = xp(1)
        coor(2,ind+conneo(3)-1) = xp(2)
    elseif (conneo(4) .ne. 0 .and. conneo(1) .ne. 0 ) then
    ! --- NOEUD 1 
        xp(1:3) = 0.d0
        xe(1) = 0.d0
        xe(2) = 1.d0/3.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(4)-1) = xp(1)
        coor(2,ind+conneo(4)-1) = xp(2)
    ! --- NOEUD 2 
        xp(1:3) = 0.d0
        xe(1) = 0.d0
        xe(2) = -1.d0/3.d0
        call reerel(eletyp, 4, 2, tabar, xe, xp)
        coor(1,ind+conneo(1)-1) = xp(1)
        coor(2,ind+conneo(1)-1) = xp(2)
 !
    else 
        ASSERT(.false.)
    endif

!
end subroutine
