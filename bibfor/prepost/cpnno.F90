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

subroutine cpnno(main,numa,coor,inc,nbno,nomnoe)
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
#include "asterfort/reerel.h"
#include "asterfort/assert.h"
!
    integer :: nbno, inc, numa
    real(kind=8) :: coor(3, *)
    character(len=8) :: main
    character(len=24) :: nomnoe
    

!
!
! ----------------------------------------------------------------------
!         CREATION DU NOEUD INTERNE SUPPLEMENTAIRE
! ----------------------------------------------------------------------
! IN        NBNO    NOMBRE DE NOEUDS DU MAILLAGE INITIAL
! IN        NUMA    NUMERO DE LA MAILLE COURANTE
! IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
! VAR       COOR    COORDONNEES DES NOEUDS
! ----------------------------------------------------------------------
!
!
    integer :: lino(6), jtab, lgnd, iret, nbso
    integer :: inc1, inc2, aux
    real(kind=8) ::xe(3), xp(3), tabar(6*3), tole
!
    character(len=8) :: nomnd,eletyp, mailut
    character(len=24) :: valk
    character(len=6) :: knume
! ----------------------------------------------------------------------
!
!
!
    tole=1.d-9

    nbso=3
    eletyp='TR3'
    mailut=main
    call jeveuo(jexnum(mailut//'.CONNEX',numa),'L',jtab)        

! - INSERTION DU NOUVEAU NOEUD
!
!      NOM DU NOEUD CREE
     call codent(nbno+inc, 'G', knume)
     lgnd = lxlgut(knume)
     if (lgnd+2 .gt. 8) then
         call utmess('F', 'ALGELINE_16')
     endif
     nomnd = 'C' // knume
!
!      DECLARATION DU NOEUD CREE
     call jeexin(jexnom(nomnoe, nomnd), iret)
     if (iret .eq. 0) then
         call jecroc(jexnom(nomnoe, nomnd))
     else
         valk = nomnd
         call utmess('F', 'ALGELINE4_5', sk=valk)
     endif

! --- Preparation de la geometrie
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
!
! - CALCUL DES COORDONNEES DU NOUVEAU NOEUD
! --- CENTRE DE GRAVITE
    xp(1)=0.d0
    xp(2)=0.d0
    xp(3)=0.d0
    xe(1)=1.d0/3.d0
    xe(2)=1.d0/3.d0
    xe(3)=0.d0
    call reerel(eletyp, nbso, 3, tabar, xe, xp)
    coor(1,nbno+inc) = xp(1)
    coor(2,nbno+inc) = xp(2)  
    coor(3,nbno+inc) = xp(3)

!
end subroutine
