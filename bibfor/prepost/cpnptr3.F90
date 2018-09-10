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

subroutine cpnptr3(main,numa,coor,ind,nomnoe)
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
    integer, intent(in) :: ind
    integer, intent(in) :: numa
    real(kind=8),intent(out) :: coor(3, *)
    character(len=8), intent(in) :: main
    character(len=24), intent(in) :: nomnoe
!
!
! ----------------------------------------------------------------------
!         CREATION DES DDL SUPPLEMENTAIRES
!         SUR LA FACE DE LA ZONE DE CONTACT ESCLAVE
!         CAS QUAD 8
! ----------------------------------------------------------------------
! IN        MAIN    MAILLAGE INITIAL
! IN        NUMA    NUMERO DE LA MAILLE COURANTE
! IN        IND     INDICE DU PREMIER NOEUD AJOUTE
! IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
! IN/OUT    COOR    COORDONNEES DES NOEUDS
! ----------------------------------------------------------------------
!
!
    integer :: lino(2), jtab, lgnd, iret
    integer :: inc1, inc2
    real(kind=8) ::xe(2), xp(2), tabar(3*2)
!
    character(len=8) :: nomnd,eletyp
    character(len=24) :: valk
    character(len=16) :: knume
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - INSERTION DU NOUVEAU NOEUD
! ------ NOM DU NOEUD CREE
    call codent(ind, 'G', knume)
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
! --- CALCUL DES COORDONNEES DES NOUVEAUX NOEUDS

    call jeveuo(jexnum(main//'.CONNEX',numa),'L',jtab)
    do  inc1=1, 2
        lino(inc1)= zi(jtab+inc1-1)
    end do
    do inc1=1,2
        do inc2=1,2
            tabar((inc1-1)*2+inc2) =  coor(inc2,lino(inc1))
        end do
    end do
    eletyp='SE2'
! --- NOEUD 1
    xp(1)=0.d0
    xp(2)=0.d0
    xe(1)=0.d0
    xe(2)=0.d0
    call reerel(eletyp, 2, 2, tabar, xe, xp)
    coor(1,ind) = xp(1)
    coor(2,ind) = xp(2)
!
    call jedema()
end subroutine
