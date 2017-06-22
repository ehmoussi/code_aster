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

subroutine recddl(nbcmp, lino, nbno, nbec, ideeq,&
                  neq, mcoddl, idec)
!    P. RICHARD     DATE 20/02/91
!-----------------------------------------------------------------------
!  BUT: ETABLIR LA LISTE DES DDL ASSOCIES A UNE LISTE DE NOEUDS
    implicit none
!       REMPLIR UNE MATRICE A DEUX COLONNES
!
!   COLONNE 1 : ENTIERS CODES POUR DES DDL PHYSIQUES ASSEMBLES
!   COLONNE 2 : ENTIERS CODES DES DDL LAGRANGE BLOQUAGE ASSEMBLES
!
!-----------------------------------------------------------------------
!
!  NBCMP   /I/: NOMBRE DE COMPOSANTE MAX DE LA GRANDEUR SOUS-JACENTE
!  LINO    /I/: VECTEUR LISTE DES NOEUDS
!  NBNO    /I/: NOMBRE DE NOEUDS DE LA LISTE LINO
!  IDEEQ   /I/: VECTEUR DEEQ DU NUMDDL
!  NEQ     /I/: NOMBRE DE DDL ASSEMBLES PAR L'UTILISATEUR
!  MCODDL  /O/: MATRICE CREEE (NBNO*2)
!  IDEC    /M/: VECTEUR ENTIER DE TRAVAIL DE  DECODAGE
!
!-----------------------------------------------------------------------
!
#include "asterfort/iscode.h"
    integer :: lino(nbno), ideeq(2, neq), mcoddl(nbno*nbec, 2), idec(nbcmp, 2)
    integer :: i, ino, ityp, j, jno, k, nbcmp
    integer :: nbec, nbno, neq
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!
    if (nbno .eq. 0) goto 9999
!
!  MISE A ZERO DU COMPTEUR DE DDL ACTIFS
!
!
    do 10 j = 1, nbno
        do 30 k = 1, nbcmp
            idec(k,1)=0
            idec(k,2)=0
30      continue
!
        jno=lino(j)
        do 20 i = 1, neq
            ino=ideeq(1,i)
            if (jno .eq. ino) then
                ityp=ideeq(2,i)
                if (ityp .lt. 0) idec(-ityp,2)=1
                if (ityp .gt. 0) idec(ityp,1)=1
            endif
20      continue
        call iscode(idec(1, 1), mcoddl((j-1)*nbec+1, 1), nbcmp)
        call iscode(idec(1, 2), mcoddl((j-1)*nbec+1, 2), nbcmp)
10  end do
!
9999  continue
end subroutine
