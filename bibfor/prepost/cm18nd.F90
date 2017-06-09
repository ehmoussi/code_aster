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

subroutine cm18nd(nbno, nbnomi, prefix, ndinit, nomipe,&
                  nomnoe, coor)
    implicit none
!
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jexnom.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
!
    integer :: nbno, nbnomi, nomipe(8, nbnomi), ndinit
    real(kind=8) :: coor(3, *)
    character(len=8) :: prefix
    character(len=24) :: nomnoe
!
!
! ----------------------------------------------------------------------
!         CREATION DES NOEUDS MILIEUX (CREA_MAILLAGE PENTA15_18)
! ----------------------------------------------------------------------
! IN        NBNO    NOMBRE TOTAL DE NOEUDS DU MAILLAGE
! IN        NBNOMI  NOMBRE DE NOEUDS CREES DES FACES
! IN        PREFIX  PREFIXE POUR LE NOM DES NOEUDS (EX : N, NS, ...)
! IN        NDINIT  NUMERO INITIAL DES NOEUDS CREES
! IN        NOMIPE  LISTE DES PERES PAR NOEUDS CREES (NOEUDS SOMMETS)
! IN/JXVAR  NOMNOE  REPERTOIRE DE NOMS DES NOEUDS
! VAR       COOR    COORDONNEES DES NOEUDS
! ----------------------------------------------------------------------
!
!
    integer :: no, no1, no2, no3, no4, no5, no6, no7, no8, lgpref, lgnd, iret
!
    character(len=8) :: nomnd
    character(len=24) :: valk
    character(len=80) :: knume
! ----------------------------------------------------------------------
    call jemarq()
!
! - INSERTION DES NOUVEAUX NOEUDS
!
    lgpref = lxlgut(prefix)
    do 10 no = 1, nbnomi
!
!      NOM DU NOEUD CREE
        call codent(ndinit-1+no, 'G', knume)
        lgnd = lxlgut(knume)
        if (lgnd+lgpref .gt. 8) then
            call utmess('F', 'ALGELINE_16')
        endif
        nomnd = prefix(1:lgpref) // knume
!
!      DECLARATION DU NOEUD CREE
        call jeexin(jexnom(nomnoe, nomnd), iret)
        if (iret .eq. 0) then
            call jecroc(jexnom(nomnoe, nomnd))
        else
            valk = nomnd
            call utmess('F', 'ALGELINE4_5', sk=valk)
        endif
!
10  end do
!
! - CALCUL DES COORDONNEES DES NOUVEAUX NOEUDS DES FACES
    do 20 no = 1, nbnomi
        no1 = nomipe(1,no)
        no2 = nomipe(2,no)
        no3 = nomipe(3,no)
        no4 = nomipe(4,no)
        no5 = nomipe(5,no)
        no6 = nomipe(6,no)
        no7 = nomipe(7,no)
        no8 = nomipe(8,no)
        coor(1,no+nbno) = -(&
                          coor(1,no1) + coor(1,no2) + coor(1,no3) + coor(1,no4))/4.d0+ (coor(1,no&
                          &5) + coor(1,no6)+ coor(1,no7) + coor(1,no8)&
                          )/2.d0
!
        coor(2,no+nbno) = -(&
                          coor(2,no1) + coor(2,no2) + coor(2,no3) + coor(2,no4))/4.d0+ (coor(2,no&
                          &5) + coor(2,no6)+ coor(2,no7) + coor(2,no8)&
                          )/2.d0
!
        coor(3,no+nbno) = -(&
                          coor(3,no1) + coor(3,no2) + coor(3,no3) + coor(3,no4))/4.d0+ (coor(3,no&
                          &5) + coor(3,no6)+ coor(3,no7) + coor(3,no8)&
                          )/2.d0
20  end do
!
    call jedema()
end subroutine
