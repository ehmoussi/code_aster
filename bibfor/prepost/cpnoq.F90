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

subroutine cpnoq(main,numa,coor,ind,nomnoe)
!
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
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
!
    integer :: ind, numa
    real(kind=8) :: coor(3, *)
    character(len=8) :: main
    character(len=24) :: nomnoe
!
!
! ----------------------------------------------------------------------
!         CREATION DES DDL SUPPLEMENTAIRES
!         SUR LA FACE DE LA ZONE DE CONTACT ESCLAVE
! ----------------------------------------------------------------------
! IN        MAIN    MAILLAGE INITIAL
! IN        NUMA    NUMERO DE LA MAILLE COURANTE
! IN        IND     INDICE DU PREMIER NOEUD AJOUTE
! IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
! VAR       COOR    COORDONNEES DES NOEUDS
! ----------------------------------------------------------------------
!
!
    integer :: lino(6), jtab, lgnd, iret
    integer :: inc1, inc2, aux
    real(kind=8) ::xe(3), xp(3), tabar(6*3)
!
    character(len=8) :: nomnd,eletyp
    character(len=24) :: valk
    character(len=16) :: knume
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - INSERTION DES NOUVEAUX NOEUDS
    do inc1=1,4
! ------ NOM DU NOEUD CREE
        call codent(ind+inc1-1, 'G', knume)
        if (knume(1:1)=='*') then
            ASSERT(.false.)
        endif
        lgnd = lxlgut(knume)
        if (lgnd+1 .gt. 8) then
            call utmess('F', 'ALGELINE_16')
        endif
        nomnd = 'C' // knume(1:lgnd)
! ------ DECLARATION DU NOEUD CREE
        call jeexin(jexnom(nomnoe, nomnd), iret)
        if (iret .eq. 0) then
            call jecroc(jexnom(nomnoe, nomnd))
        else
            valk = nomnd
            call utmess('F', 'ALGELINE4_5', sk=valk)
        endif
    end do
! --- CALCUL DES COORDONNEES DES NOUVEAUX NOEUDS

    call jeveuo(jexnum(main//'.CONNEX',numa),'L',jtab)
    do  inc1=1, 6
        lino(inc1)= zi(jtab+inc1-1)
    end do
    aux=1
    do inc1=1,6
        do inc2=1,3
            tabar(aux+inc2-1) =  coor(inc2,lino(inc1))
        end do
        aux=aux+3
    end do
    eletyp='TR6'
! --- MILIEU DU SEGMENT [NOEUDS1 CENTRE DE GRAVITE]
    xp(1)=0.d0
    xp(2)=0.d0
    xp(3)=0.d0
    xe(1)=1/6.d0
    xe(2)=1.d0/6.d0
    xe(3)=0.d0
    call reerel(eletyp, 6, 3, tabar, xe, xp)
    coor(1,ind) = xp(1)
    coor(2,ind) = xp(2)
    coor(3,ind) = xp(3)
! --- MILIEU DU SEGMENT [NOEUDS2 CENTRE DE GRAVITE]
    xp(1)=0.d0
    xp(2)=0.d0
    xp(3)=0.d0
    xe(1)=4.d0/6.d0
    xe(2)=1.d0/6.d0
    xe(3)=0.d0
    call reerel(eletyp, 6, 3, tabar, xe, xp)
    coor(1,ind+1) = xp(1)
    coor(2,ind+1) = xp(2)
    coor(3,ind+1) = xp(3)
! --- MILIEU DU SEGMENT [NOEUDS3 CENTRE DE GRAVITE]
    xp(1)=0.d0
    xp(2)=0.d0
    xp(3)=0.d0
    xe(1)=1.d0/6.d0
    xe(2)=4.d0/6.d0
    xe(3)=0.d0
    call reerel(eletyp, 6, 3, tabar, xe, xp)
    coor(1,ind+2) = xp(1)
    coor(2,ind+2) = xp(2)
    coor(3,ind+2) = xp(3)
! --- MILIEU DU CENTRE DE GRAVITE
    xp(1)=0.d0
    xp(2)=0.d0
    xp(3)=0.d0
    xe(1)=1.d0/3.d0
    xe(2)=1.d0/3.d0
    xe(3)=0.d0
    call reerel(eletyp, 6, 3, tabar, xe, xp)
    coor(1,ind+3) = xp(1)
    coor(2,ind+3) = xp(2)
    coor(3,ind+3) = xp(3)
!

    call jedema()
end subroutine
