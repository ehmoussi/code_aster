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

subroutine kajgr2(igrap, vr, cokaj1, cokaj2)
    implicit none
! CALCUL DES COEFFICIENTS ADIMENSIONNELS DE FORCE DE RAIDEUR
! GRAPPE2
!-----------------------------------------------------------------------
!  IN : IGRAP  : INDICE CARACTERISTIQUE DE LA CONFIGURATION
!                EXPERIMENTALE DE REFERENCE
!  IN : VR     : VITESSE REDUITE
! OUT : COKAJ1 : COEFFICIENT ADIMENSIONNEL DE FORCE DE RAIDEUR
!                POUR UN MOUVEMENT DE TRANSLATION
! OUT : COKAJ2 : COEFFICIENT ADIMENSIONNEL DE FORCE DE RAIDEUR
!                POUR UN MOUVEMENT DE ROTATION
!-----------------------------------------------------------------------
!     UN COMMON AJOUTE POUR RESORBER UNE GLUTE ANTIQUE (VOIR HISTOR):
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ulisop.h"
#include "asterfort/ulopen.h"
#include "asterfort/wkvect.h"
    character(len=8) :: typflu
    common  / kop144 / typflu
!
    integer :: igrap, nkamax, iflag, unit
    real(kind=8) :: vr, cokaj1, cokaj2
    real(kind=8) :: coeca1(20, 11), coeca2(20, 11)
    real(kind=8) :: coef1(20, 11), coef2(20, 11)
    character(len=16) :: k16nom
    character(len=24) :: nom1, nom2
    save         coeca1, coeca2
! ----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, iret, iunit, j, nbloc, nbomax
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    call jemarq()
    nkamax = 11
    nbomax = 20
    zero = 0.0d0
!
    nom1 = '&&KAJGR2.FLAG'
    nom2 = typflu//'.UNIT_GRAPPES'
!
    call jeexin(nom1, iret)
    if (iret .eq. 0) then
!
! --- LECTURE DU FICHIER DE DONNEES
!     =============================
        call jeveuo(nom2, 'L', iunit)
        unit = zi(iunit-1+2)
        k16nom = ' '
        if (ulisop ( unit, k16nom ) .eq. 0) then
            call ulopen(unit, ' ', ' ', 'NEW', 'O')
        endif
!
! ---    BLOC D'INITIALISATION
        do 10 i = 1, nbomax
            do 20 j = 1, nkamax
                coeca1(i,j) = zero
                coeca2(i,j) = zero
                coef1(i,j) = zero
                coef2(i,j) = zero
20          continue
10      continue
!
        read (unit,*) nbloc
        do 30 i = 1, nbloc
            read (unit,*) (coef1(i,j),j = 1,nkamax)
            read (unit,*) (coef2(i,j),j = 1,nkamax)
            read (unit,*)
30      continue
        do 40 i = 1, nbomax
            do 50 j = 1, nkamax
                coeca1(i,j) = coef1(i,j)
                coeca2(i,j) = coef2(i,j)
50          continue
40      continue
        call wkvect(nom1, 'V V I', 1, iflag)
        zi(iflag+1-1) = 1
!        FERMETURE DU FICHIER
        call ulopen(-unit, ' ', ' ', ' ', ' ')
        goto 60
    endif
!
60  continue
!
!
!-----1.CONFIG. ECOULEMENT ASCENDANT TIGE DE COMMANDE CENTREE
!
    if (igrap .eq. 1) then
!
        cokaj1 = coeca1(1,8) + coeca1(1,7)/vr
        cokaj2 = coeca2(1,8) + coeca2(1,7)/vr
!
!-----2.CONFIG. ECOULEMENT ASCENDANT TIGE DE COMMANDE EXCENTREE
!
    else if (igrap.eq.2) then
!
        cokaj1 = coeca1(2,8) + coeca1(2,7)/vr
        cokaj2 = coeca2(2,8) + coeca2(2,7)/vr
!
!-----3.CONFIG. ECOULEMENT DESCENDANT TIGE DE COMMANDE CENTREE
!
    else if (igrap.eq.3) then
!
        cokaj1 = coeca1(3,8) + coeca1(3,7)/vr
        cokaj2 = coeca2(3,8) + coeca2(3,7)/vr
!
!-----4.CONFIG. ECOULEMENT DESCENDANT TIGE DE COMMANDE EXCENTREE
!
    else
!
        cokaj1 = coeca1(4,8) + coeca1(4,7)/vr
        cokaj2 = coeca2(4,8) + coeca2(4,7)/vr
!
    endif
!
    call jedema()
!
end subroutine
