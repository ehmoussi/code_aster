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

subroutine cpnpq8_2(main,numa,coor,ind,nomnoe)
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
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
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
!
!
! ----------------------------------------------------------------------
!         CREATION DES DDL SUPPLEMENTAIRES 
!         SUR LA FACE DE LA ZONE DE CONTACT ESCLAVE
!         CAS HEXA 8
! ----------------------------------------------------------------------
! IN        MAIN    MAILLAGE INITIAL
! IN        NUMA    NUMERO DE LA MAILLE COURANTE
! IN        IND     INDICE DU PREMIER NOEUD AJOUTE
! IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
! IN/OUT    COOR    COORDONNEES DES NOEUDS
! ----------------------------------------------------------------------
!
!
    integer :: lino(8), jtab, lgnd, iret
    integer :: inc1, inc2, aux, nbso
    real(kind=8) ::xe(3), xp(3), tabar(8*3), tole
!
    character(len=8) :: nomnd,eletyp,mailut
    character(len=24) :: valk
    character(len=6) :: knume
! ----------------------------------------------------------------------
!
    call jemarq()

    tole=1.d-9
    nbso=4
    eletyp='QU4'
    mailut=main
    call jeveuo(jexnum(mailut//'.CONNEX',numa),'L',jtab)   
!
! - INSERTION DU NOUVEAU NOEUD
! ------ NOM DU NOEUD CREE
    call codent(ind, 'G', knume)
    lgnd = lxlgut(knume)
    if (lgnd+2 .gt. 8) then
        call utmess('F', 'ALGELINE_16')
    endif
    nomnd = 'C' // knume
! ------ DECLARATION DU NOEUD CREE
    call jeexin(jexnom(nomnoe, nomnd), iret)
    if (iret .eq. 0) then
        call jecroc(jexnom(nomnoe, nomnd))
    else
        valk = nomnd
        call utmess('F', 'ALGELINE4_5', sk=valk)
    endif
! --- CALCUL DES COORDONNEES DES NOUVEAUX NOEUDS

    do  inc1=1, nbso
        lino(inc1)= zi(jtab+inc1-1) 
    end do
    aux=1
    do inc1=1,nbso
        do inc2=1,3
                tabar(aux+inc2-1) =  coor(inc2,lino(inc1))    
        end do
        aux=aux+3
    end do 

! --- NOEUD 1 
    xp(1:3)=0.d0
    xe(1:3)=0.d0
    call reerel(eletyp, nbso, 3, tabar, xe, xp)
    coor(1:3,ind) = xp(1:3)

    call jedema()
end subroutine
