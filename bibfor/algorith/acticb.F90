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

subroutine acticb(nbcmp, nbno, nbec, mcoddl, icono,&
                  icodac)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 20/02/91
!-----------------------------------------------------------------------
!  BUT:    < DDL ACTIF CAS CRAIG BAMPTON >
!
! DETERMINER LES ENTIER CODES DES DDL ACTIFS A PARTIR DES ENTIERS CODES
!  DES DDL AUX NOEUDS ET DES ENTIERS CODES RELATIFS AUX DEFORMEES
!  CALCULEES POUR INTERFACE DE TYPE CRAIG-BAMPTON
!    ET DES DDL DEMANDES PAR L'UTILISATEUR
!
!-----------------------------------------------------------------------
!
! NBCMP    /I/: NOMBRE DE COMPOSANTES MAX DE LA GRANDEUR SOUS-JACENTE
! NBNO     /I/: NOMBRE DE NOEUDS DE LA TABLE
! MCODDL   /I/: TABLEAU DES ENTIERS CODES  DDL AUX NOEUDS
! ICONO    /I/: LISTE DES ENTIERS CODES DES DEFORMEES CALCULEES
! ICODAC   /M/: LISTE DES ENTIERS CODES DES DDL ACTIFS DEMANDES
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
#include "asterfort/iscode.h"
#include "asterfort/isgeco.h"
    integer :: i, nbcmp, nbcpmx, nbec, nbecmx, nbno
!-----------------------------------------------------------------------
    parameter (nbcpmx = 300)
    parameter (nbecmx =  10)
    integer :: mcoddl(nbno*nbec, 2), icono(nbno*nbec), icodac(nbno*nbec)
    integer :: idec(nbcpmx), itout(nbecmx), icoco(nbecmx), icici(nbecmx)
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
    do 10 i = 1, nbecmx
        itout(i) = 0
        icoco(i) = 0
        icici(i) = 0
10  continue
!
    do 20 i = 1, nbcmp
        idec(i)=1
20  continue
    call iscode(idec, itout, nbcmp)
!
    if (nbno .eq. 0) goto 9999
!
    do 30 i = 1, nbno
        call isgeco(itout, mcoddl((i-1)*nbec+1, 2), nbcmp, -1, icoco)
        call isgeco(icodac((i-1)*nbec+1), icoco, nbcmp, -1, icici)
        call isgeco(icici, mcoddl((i-1)*nbec+1, 2), nbcmp, -1, icoco)
        call isgeco(icoco, icono((i-1)*nbec+1), nbcmp, 1, icodac((i-1)* nbec+1))
30  end do
!
9999  continue
end subroutine
