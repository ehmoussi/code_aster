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

subroutine zerlag(nbddl, ideeq, vectr, vectz )
    implicit none
!
!                             FONCTION
!    _________________________________________________________________
!   | ANNULER LES DDL DE LAGRANGE DANS UN VECTEUR (.VALE D'UN CHAMNO) |
!   |_________________________________________________________________|
!
!
!   EXEMPLES : call zerlag (neq, zi(jdeeq), zr(jvect))
!              call zerlag (neq, zi(jdeeq), vectz=zc(jvect))
!
!                     DESCRIPTIVE DES VARIABLES
!   ___________________________________________________________________
!  | IN > NBDDL  : NOMBRE DE DDL PHYSIQUES / TAILLE DU VECTEUR      [I]|
!  | IN > IDEEQ  : VECTEUR DES DESCRIPTEURS D'EQUATIONS DU NUME_DDL [I]|
!  | IN > VECTR  : VECTEUR REEL DE TAILLE NBDDL A TRAITER          [R8]|
!  |OUT <                      (SI COMPL.EQ.0 )                        |
!  | IN > VECTZ  : VECTEUR COMPLEXE DE TAILLE NBDDL A TRAITER     [C16]|
!  |OUT <                      (SI COMPL.EQ.1 )                        |
!   ___________________________________________________________________
!
#include "jeveux.h"
!   ___________________________________________________________________
!
!  - 0 - INITIALISATIONS DIVERSES
!   ___________________________________________________________________
!
!     0.1 - DECLARATION DES VARIABLES D'ENTREE/SORTIE
!
    integer :: nbddl, ideeq(2*nbddl)
    real(kind=8), intent(out), optional :: vectr(nbddl)
    complex(kind=8), intent(out), optional :: vectz(nbddl)
!
!     0.2 - DECLARATION DES VARIABLES LOCALES
!
    integer :: i, ityp
!  ____________________________________________________________________
!
!  - 1 - RECHERCHE DES DDL DE LAGRANGE ET REMPLISSAGE LES VALEURS DES
!        CORRESPONDANTS PAR DES ZEROS (REELS OU COMPLEXES SELON LE CAS)
!  ____________________________________________________________________
!
!     1.1 - CAS REEL
    if (present(vectr)) then
        do i = 1, nbddl
            ityp = ideeq(2*i)
            if (ityp .le. 0) vectr(i)=0.d0
        end do
    endif
    if (present(vectz)) then
!     1.2 - CAS COMPLEXE
        do i = 1, nbddl
            ityp = ideeq(2*i)
            if (ityp .le. 0) vectz(i)=dcmplx(0.d0,0.d0)
        end do
    endif
!  ____________________________________________________________________
!
end subroutine
