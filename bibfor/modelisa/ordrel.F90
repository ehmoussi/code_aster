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

subroutine ordrel(numnoe, nomnoe, ddl, coef, coefc,&
                  nbocno, nbterm, nomcmp, nddla)
!
    implicit none
!
#include "asterc/indik8.h"
#include "asterfort/ordre1.h"
!
!
    integer, intent(in) :: nbterm
    integer, intent(in) :: nddla
    character(len=8), intent(in)  :: nomcmp(nddla)
    integer, intent(inout) :: numnoe(nbterm)
    integer, intent(inout) :: nbocno(nbterm)
    real(kind=8), intent(inout) :: coef(nbterm)
    complex(kind=8), intent(inout) :: coefc(nbterm)
    character(len=8), intent(inout) :: nomnoe(nbterm)
    character(len=8), intent(inout) :: ddl(nbterm)
!
! --------------------------------------------------------------------------------------------------
!
! Rearrangement of nodes, dof and relation coefficient tables in ascending order of nodes and dof
! for a given node
!
! --------------------------------------------------------------------------------------------------
!  NUMNOE(NBTERM) - VAR    - I    - : NUMEROS DES NOEUDS DE LA
!                 -        -      -   RELATION EN ENTREE
!                 -        -      -   CONTIENT PAR LA SUITE  LES
!                 -        -      -   NUMEROS DES DDLS
!                 -        -      -   SERT DE CLE POUR LE TRI
! -----------------------------------------------------------------
!  NOMNOE(NBTERM) - VAR    - K8   - : NOMS DES NOEUDS DE LA
!                 -        -      -   RELATION
! -----------------------------------------------------------------
!  DDL(NBTERM)    - VAR    - K8   - : NOMS DES DDLS DE LA
!                 -        -      -   RELATION
! -----------------------------------------------------------------
!  COEF(NBTERM)   - VAR    - R    - : COEFFICIENTS REELS DES TERMES
!                 -        -      -   DE LA RELATION
! -----------------------------------------------------------------
!  COEFC(NBTERM)  - VAR    - C    - : COEFFICIENTS COMPLEXES DES
!                 -        -      -   TERMES DE LA RELATION
! -----------------------------------------------------------------
!  NBOCNO(NBTERM) - VAR    - I    - : NOMBRE D'OCCURENCES DE CHAQUE
!                 -        -      -   TERME DANS LA RELATION
! -----------------------------------------------------------------
!  NBTERM         - IN     - I    - : NOMBRE DE TERMES DE LA
!                 -        -      -   RELATION
! -----------------------------------------------------------------
!  NOMCMP(NDDLA)  - IN     - K8   - : NOMS DES COMPOSANTES POSSIBLES
!                 -        -      -   AUX NOEUDS DU MAILLAGE
! -----------------------------------------------------------------
!  NDDLA          - IN     - I    - : NOMBRE MAX DE COMPOSANTES
!                 -        -      -   POSSIBLES EN UN NOEUD
! -----------------------------------------------------------------
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, ind, j, k
!
! --------------------------------------------------------------------------------------------------
!
    do i = 1, nbterm
        nbocno(i) = 1
    end do
!
! - Sort by nodes number
!
    call ordre1(numnoe, nomnoe, ddl, coef, coefc,&
                nbterm)
!
! - Determination of table NBOCNO giving the number of instances of nodes in the list LISTE_RELA
!
    do i = 1, nbterm - 1
        do j = i+1, nbterm
            if (numnoe(i) .eq. numnoe(j)) then
                nbocno(i) = nbocno(i) + 1
            endif
        end do
    end do
!
! - Rearrangement of nodes, dof and relation coefficient tables in ascending order of dof for a
! - given node
!
    k = 0
!
! - First node
!
    if (nbocno(1) .gt. 1) then
        do j = 1, nbocno(1)
            k = k+1
            numnoe(k) = indik8(nomcmp,ddl(k),1,nddla)
        enddo
!
! ----- Sort by dof number
!
        call ordre1(numnoe, nomnoe, ddl, coef, coefc,&
                    nbocno(1))
    else
        k = k+1
    endif
!
! - Other nodes
!
    do i = 2, nbterm
!
! ----- Using  the fact that if nodes are equal, they are consequential
!
        if (nomnoe(i) .eq. nomnoe(i-1)) goto 50
        if (nbocno(i) .gt. 1) then
            do j = 1, nbocno(i)
                k = k + 1
                numnoe(k) = indik8(nomcmp,ddl(k),1,nddla)
            enddo
            ind = k - nbocno(i) + 1
!
! --------- Sort by dof number
!
            call ordre1(numnoe(ind), nomnoe(ind), ddl(ind), coef(ind), coefc(ind),&
                        nbocno(i))
        else
            k = k+1
        endif
50      continue
    end do
end subroutine
