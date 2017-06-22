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

subroutine recbbn(basmod, nbmod, nbddr, nbdax, tetgd,&
                  iord, iorg, iora, cmode, vecmod,&
                  neq, beta)
    implicit none
#include "jeveux.h"
#include "asterfort/dcapno.h"
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: nbmod, nbddr, nbdax, iord(nbddr), iorg(nbddr), iora(nbdax), neq
    real(kind=8) :: beta
    complex(kind=8) :: cmode(nbmod+nbddr+nbdax), vecmod(neq)
    character(len=8) :: basmod
    character(len=24) :: tetgd
!-----------------------------------------------------------------------
!
!  BUT:        < RESTITUTION CRAIG_BAMPTON BAS NIVEAU >
!
!    CALCUL DU VECTEUR COMPLEXE EN DDL PHYSIQUES A PARTIR DU MODE
!   COMPLEXE ISSU DU CALCUL CYCLIQUE ET DES VECTEURS DES NUMERO ORDRE
!  DES DEFORMEES RELATIVES AUX INTERFACES DROITE GAUCHE ET AXE DE TYPE
!   CRAIG-BAMPTON
!  AINSI QUE DE LA MATRICE TETGD
!
!-----------------------------------------------------------------------
!
! BASMOD   /I/: NOM UT DE LA BASE MODALE EN AMONT
! NBMOD    /I/: NOMBRE DE MODES PROPRES UTILISES POUR CALCUL CYCLIQUE
! NBDDR    /I/: NOMBRE DE DEFORMEES INTERFACE DROITE (ET GAUCHE)
! NBDAX    /I/: NOMBRE DE DEFORMEES INTERFACE AXE
! TETGD    /I/: NOM K24 DE MATRICE DE PASSAGE GAUCHE-DROITE
! IORD     /I/: VECTEUR DES NUMEROS ORDRE DEFORMEES DE DROITE
! IORG     /I/: VECTEUR DES NUMEROS ORDRE DES DEFORMEES DE GAUCHE
! IORA     /I/: VECTEUR DES NUMEROS ORDRE DES DEFORMEES  AXE
! CMODE    /I/: MODE COMPLEXES ISSU DU CALCUL CYCLIQUE
! VECMOD   /I/: VECTEUR MODAL COMPLEXE EN DDL PHYSIQUE
! NEQ      /I/: NOMBRE DE DDL PHYSIQUES ASSEMBLES
! BETA     /I/: DEPHASAGE INTER-SECTEUR
!
!
!
!
    integer :: i, j, iad, llcham, lltgd
    real(kind=8) :: abeta, bbeta
    complex(kind=8) :: dephc, cfact, cmult
    character(len=24) :: chaval
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
! --- MISE A ZERO DU MODE PROPRES RESULTAT
!
    do 10 i = 1, neq
        vecmod(i) = dcmplx( 0.d0,0.d0 )
10  end do
!
    abeta = cos(beta)
    bbeta = sin(beta)
    dephc = dcmplx( abeta,bbeta )
!
! --- CONTRIBUTION DES MODES PROPRES
!
    do 20 i = 1, nbmod
        call dcapno(basmod, 'DEPL    ', i, chaval)
        call jeveuo(chaval, 'L', llcham)
        do 22 j = 1, neq
            cfact = dcmplx( zr(llcham+j-1),0.d0 )
            vecmod(j) = vecmod(j) + cmode(i)*cfact
22      continue
        call jelibe(chaval)
20  end do
!
! --- CONTRIBUTION DES DEFORMEES DE DROITE
!
    do 30 i = 1, nbddr
        call dcapno(basmod, 'DEPL    ', iord(i), chaval)
        call jeveuo(chaval, 'L', llcham)
        do 32 j = 1, neq
            cfact = dcmplx( zr(llcham+j-1),0.d0 )
            vecmod(j) = vecmod(j) + cmode(i+nbmod)*cfact
32      continue
        call jelibe(chaval)
30  end do
!
! --- CONTRIBUTION DES DEFORMEES DE GAUCHE
!
    call jeveuo(tetgd, 'L', lltgd)
!
    do 40 i = 1, nbddr
        call dcapno(basmod, 'DEPL    ', iorg(i), chaval)
        call jeveuo(chaval, 'L', llcham)
!
        cmult = dcmplx( 0.d0,0.d0 )
        do 42 j = 1, nbddr
            iad = lltgd + ((j-1)*nbddr) + i - 1
            cfact = dcmplx( zr(iad),0.d0 )*cmode(j+nbmod)
            cmult = cmult + cfact
42      continue
!
        do 44 j = 1, neq
            cfact = dcmplx( zr(llcham+j-1),0.d0 )
            vecmod(j) = vecmod(j) + dephc*cfact*cmult
44      continue
!
        call jelibe(chaval)
40  end do
    call jelibe(tetgd)
!
! --- EVENTUELLE CONTRIBUTION DE L'AXE
!
    if (nbdax .gt. 0) then
        do 50 i = 1, nbdax
            call dcapno(basmod, 'DEPL    ', iora(i), chaval)
            call jeveuo(chaval, 'L', llcham)
            do 52 j = 1, neq
                cfact = dcmplx( 2*zr(llcham+j-1),0.d0 )
                vecmod(j) = vecmod(j) + cfact*cmode(i+nbmod+nbddr)
52          continue
            call jelibe(chaval)
50      continue
    endif
!
    call jedema()
end subroutine
