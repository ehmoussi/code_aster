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

subroutine vectan(nb1, nb2, xi, xr, vecta,&
                  vectn, vectpt)
    implicit none
!
    integer :: nb1, nb2, l1, l2, i1, i2, j, i, k
    real(kind=8) :: xi(3, *), xr(*)
    real(kind=8) :: vecta(9, 2, 3), vectn(9, 3), vectpt(9, 2, 3)
!
!-----------------------------------------------------------------------
    integer :: ib, l
    real(kind=8) :: rnorm
!-----------------------------------------------------------------------
    l1=828
    l2=900
!
!     CONSTRUCTION DES VECTEURS AA AUX NB2 NOEUDS I
!     (STOCKE DANS VECTA)
!
    do 10 i = 1, nb2
        i1=l1+8*(i-1)
        i2=l2+8*(i-1)
        do 20 k = 1, 3
            vecta(i,1,k)=0.d0
            vecta(i,2,k)=0.d0
            do 30 j = 1, nb1
                vecta(i,1,k)=vecta(i,1,k)+xr(i1+j)*xi(k,j)
                vecta(i,2,k)=vecta(i,2,k)+xr(i2+j)*xi(k,j)
30          end do
20      end do
!
!     CONSTRUCTION DU VECTEUR N AUX NB2 NOEUDS I
!     (STOCKE DANS VECTN)
!
        vectn(i,1)= vecta(i,1,2)*vecta(i,2,3) -vecta(i,1,3)*vecta(i,2,&
        2)
        vectn(i,2)= vecta(i,1,3)*vecta(i,2,1) -vecta(i,1,1)*vecta(i,2,&
        3)
        vectn(i,3)= vecta(i,1,1)*vecta(i,2,2) -vecta(i,1,2)*vecta(i,2,&
        1)
!
        rnorm=sqrt(vectn(i,1)*vectn(i,1)+vectn(i,2)*vectn(i,2)&
        +vectn(i,3)*vectn(i,3))
        vectn(i,1)=vectn(i,1)/rnorm
        vectn(i,2)=vectn(i,2)/rnorm
        vectn(i,3)=vectn(i,3)/rnorm
!
!     CONSTRUCTION DES VECTEURS TA AUX NOEUDS I
!     (STOCKE DANS VECTPT)
!
        rnorm=sqrt(vecta(i,1,1)*vecta(i,1,1) +vecta(i,1,2)*vecta(i,1,&
        2) +vecta(i,1,3)*vecta(i,1,3))
        do 25 k = 1, 3
            vectpt(i,1,k)=vecta(i,1,k)/rnorm
25      end do
!
        vectpt(i,2,1)= vectn(i,2)*vectpt(i,1,3) -vectn(i,3)*vectpt(i,&
        1,2)
        vectpt(i,2,2)= vectn(i,3)*vectpt(i,1,1) -vectn(i,1)*vectpt(i,&
        1,3)
        vectpt(i,2,3)= vectn(i,1)*vectpt(i,1,2) -vectn(i,2)*vectpt(i,&
        1,1)
10  end do
!
!     STOCKAGE DES NB2 MATRICES DE PASSAGE LOCALES GLOBALE (3,3) DANS XR
!
    do 40 ib = 1, nb2
        l=9*(ib-1)
        do 50 j = 1, 3
            do 60 i = 1, 3
                k=l+(j-1)*3+i
                if (i .le. 2) then
                    xr(1090+k)=vectpt(ib,i,j)
                else
                    xr(1090+k)=vectn(ib,j)
                endif
60          end do
50      end do
40  end do
!
end subroutine
