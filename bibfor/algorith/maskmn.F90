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

subroutine maskmn(nbcmp, nbno, nbec, mcoddl, imask,&
                  numord, nbdef)
!    P. RICHARD     DATE 20/02/91
!-----------------------------------------------------------------------
!  BUT:       CAS MAC NEAL
    implicit none
!
!    CONTROLER LES DEFORMEES A CALCULER EN TENANT COMPTE DE
!   LA TABLE DES ENTIERS CODES DES DDL AU NOEUD ET DE LA LISTE
!    DES ENTIER CODES DES MASQUES AUX NOEUDS
!
!   TABLE DES ENTIER CODE:  COLONNE 1 DDL PHYSIQUES
!                           COLONNE 2 DDL LAGRANGES
!
!  LE RESULTAT EST POUR CHAQUE NOEUD UN ENTIER CODES DONNANT LA LISTE
!    DES TYPES DE DDL POUR LESQUELS UNE DEFORMEE DOIT ETRE CALCULEE
!
!-----------------------------------------------------------------------
!
!  NBCMP    /I/: NOMBRE DE COMPOSANTES DE LA GRANDEUR SOUS-JACENTE
! NBNO     /I/: NOMBRE DE NOEUDS DE LA TABLE
! MCODDL   /I/: TABLEAU DES ENTIER CODES
! IMASK    /M/: LISTE DES ENTIERS CODES MASQUES EN ENTREE
! NUMORD   /O/: NUMERO ORDRE PREMIERE DEFORME DE CHAQUE NOEUD
! NBDEF    /M/: NUMERO ORDRE DE LA DERNIERE DEFORMEE CALCULEE
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
#include "asterfort/isdeco.h"
#include "asterfort/isgeco.h"
    integer :: i, iec, iexcmp, j, nbcmp, nbcpmx, nbdef
    integer :: nbec, nbecmx, nbno
!-----------------------------------------------------------------------
    parameter (nbcpmx = 300)
    parameter (nbecmx =  10)
    integer :: mcoddl(nbno*nbec, 2), imask(nbno*nbec)
    integer :: idec(nbcpmx), numord(nbno), icoco(nbecmx), icici(nbecmx)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!      IF(NBNO.EQ.0) RETURN
!
    do 10 i = 1, nbecmx
        icoco(i) = 0
        icici(i) = 0
10  continue
!
    do 20 i = 1, nbno
!
        call isgeco(mcoddl((i-1)*nbec+1, 1), mcoddl((i-1)*nbec+1, 2), nbcmp, -1, icoco)
        call isgeco(icoco, imask((i-1)*nbec+1), nbcmp, -1, icici)
!
        iexcmp = 0
        do 30 iec = 1, nbec
            imask((i-1)*nbec+iec) = icici(iec)
            if (icici(iec) .gt. 1) then
                iexcmp = 1
            endif
30      continue
        if (iexcmp .eq. 1) then
            numord(i)=nbdef+1
            call isdeco(icici, idec, nbcmp)
            do 40 j = 1, nbcmp
                nbdef=nbdef+idec(j)
40          continue
        endif
!
20  end do
!
end subroutine
