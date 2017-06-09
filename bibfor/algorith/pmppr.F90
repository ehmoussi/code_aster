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

subroutine pmppr(amat, na1, na2, ka, bmat,&
                 nb1, nb2, kb, cmat, nc1,&
                 nc2)
!
    implicit none
!
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: ka
    integer, intent(in) :: kb
    integer, intent(in) :: na1
    integer, intent(in) :: na2
    integer, intent(in) :: nb1
    integer, intent(in) :: nb2
    integer, intent(in) :: nc1
    integer, intent(in) :: nc2
    real(kind=8), intent(in) :: amat(na1, na2)
    real(kind=8), intent(in) :: bmat(nb1, nb2)
    real(kind=8), intent(out) :: cmat(nc1, nc2)
!
! --------------------------------------------------------------------------------------------------
!
! PRODUIT DE DEUX MATRICES STOCKEE PLEINE AVEC PRISE EN COMPTE
! DE TRANSPOSITION PAR L'INTERMEDIAIRE D'INDICATEUR K
!
! --------------------------------------------------------------------------------------------------
!
! AMAT     /I/: PREMIERE MATRICE
! NA1      /I/: NOMBRE DE LIGNE DE LA PREMIERE MATRICE
! NA2      /I/: NOMBRE DE COLONNE DE LA PREMIERE MATRICE
! KB       /I/: INDICATEUR TRANSPOSITION PREMIERE MATRICE
! BMAT     /I/: DEUXIEME MATRICE
! NB1      /I/: NOMBRE DE LIGNE DE LA DEUXIEME MATRICE
! NB2      /I/: NOMBRE DE COLONNE DE LA DEUXIEME MATRICE
! KB       /I/: INDICATEUR TRANSPOSITION DEUXIEME MATRICE
! CMAT     /I/: MATRICE RESULTAT
! NC1      /I/: NOMBRE DE LIGNE DE LA MATRICE RESULTAT
! NC2      /I/: NOMBRE DE COLONNE DE LA MATRICE RESULTAT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k
!
! --------------------------------------------------------------------------------------------------
!
    if (ka .eq. 1 .and. kb .eq. 1) then
        if (na2 .ne. nb1) then
            ASSERT(.false.)
        endif
        if (nc1 .ne. na1 .or. nc2 .ne. nb2) then
            ASSERT(.false.)
        endif
        do i = 1, na1
            do j = 1, nb2
                cmat(i,j)=0.d0
                do k = 1, nb1
                    cmat(i,j)=cmat(i,j)+amat(i,k)*bmat(k,j)
                enddo
            enddo
        enddo
    endif
!
    if (ka .eq. -1 .and. kb .eq. 1) then
        if (na1 .ne. nb1) then
            ASSERT(.false.)
        endif
        if (nc1 .ne. na2 .or. nc2 .ne. nb2) then
            ASSERT(.false.)
        endif
        do i = 1, na2
            do j = 1, nb2
                cmat(i,j)=0.d0
                do k = 1, nb1
                    cmat(i,j)=cmat(i,j)+amat(k,i)*bmat(k,j)
                enddo
            enddo
        enddo
    endif
!
    if (ka .eq. 1 .and. kb .eq. -1) then
        if (na2 .ne. nb2) then
            ASSERT(.false.)
        endif
        if (nc1 .ne. na1 .or. nc2 .ne. nb1) then
            ASSERT(.false.)
        endif
        do i = 1, na1
            do j = 1, nb1
                cmat(i,j)=0.d0
                do k = 1, na2
                    cmat(i,j)=cmat(i,j)+amat(i,k)*bmat(j,k)
                enddo
            enddo
        enddo
    endif
!
    if (ka .eq. -1 .and. kb .eq. -1) then
        if (na1 .ne. nb2) then
            ASSERT(.false.)
        endif
        if (nc1 .ne. na2 .or. nc2 .ne. nb1) then
            ASSERT(.false.)
        endif
        do i = 1, na2
            do j = 1, nb1
                cmat(i,j)=0.d0
                do k = 1, nb2
                    cmat(i,j)=cmat(i,j)+amat(k,i)*bmat(j,k)
                enddo
            enddo
        enddo
    endif
!
end subroutine
