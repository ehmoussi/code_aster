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

subroutine ordre1(numcle, nomnoe, ddl, coef, coefc,&
                  nbterm)
    implicit none
!
!
    integer, intent(in) :: nbterm
    integer, intent(inout) :: numcle(nbterm)
    real(kind=8), intent(inout) :: coef(nbterm)
    complex(kind=8), intent(inout) :: coefc(nbterm)
    character(len=8), intent(inout) :: nomnoe(nbterm)
    character(len=8), intent(inout) :: ddl(nbterm)
!
! ------------------------------------------------------------------
!     REARRANGEMENT DES TABLEAUX D'UNE RELATION LINEAIRE PAR ORDRE
!     DE NOEUD CROISSANT OU DE DDL CROISSANT
! ------------------------------------------------------------------
!  NUMCLE(NBTERM) - VAR    - I    - : NUMEROS DES NOEUDS OU DES DDLS
!                 -        -      -   DE LA RELATION
! ------------------------------------------------------------------
!  NOMNOE(NBTERM) - VAR    - K8   - : NOMS DES NOEUDS DE LA
!                 -        -      -   RELATION
! ------------------------------------------------------------------
!  DDL(NBTERM)    - VAR    - K8   - : NOMS DES DDLS DE LA
!                 -        -      -   RELATION
! ------------------------------------------------------------------
!  COEF(NBTERM)   - VAR    - R    - : COEFFICIENTS REELS DES TERMES
!                 -        -      -   DE LA RELATION
! ------------------------------------------------------------------
!  COEFC(NBTERM)  - VAR    - C    - : COEFFICIENTS COMPLEXES DES
!                 -        -      -   TERMES DE LA RELATION
! ------------------------------------------------------------------
!  NBTERM         - IN     - I    - : NOMBRE DE TERMES DE LA
!                 -        -      -   RELATION
! ------------------------------------------------------------------
!
    complex(kind=8) :: coec
    character(len=8) :: nono, nodl
    integer :: i, j, k
    real(kind=8) :: coe
!
! --------- FIN  DECLARATIONS  VARIABLES LOCALES -------------------
!
    do j = 2, nbterm
        k = numcle(j)
        nono = nomnoe(j)
        nodl = ddl(j)
        coe = coef(j)
        coec = coefc(j)
        do i = j-1, 1, -1
            if (numcle(i) .le. k) goto 30
            numcle(i+1) = numcle(i)
            nomnoe(i+1) = nomnoe(i)
            ddl(i+1) = ddl(i)
            coef(i+1) = coef(i)
            coefc(i+1) = coefc(i)
        enddo
        i = 0
30      continue
        numcle(i+1) = k
        nomnoe(i+1) = nono
        ddl(i+1) = nodl
        coef(i+1) = coe
        coefc(i+1) = coec
    end do
end subroutine
