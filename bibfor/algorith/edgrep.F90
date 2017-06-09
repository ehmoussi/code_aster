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

subroutine edgrep(typmod, coord, anic, ani)
!
    implicit none
!
!
#include "asterc/r8prem.h"
    real(kind=8) :: coord(3), anic(6, 6), ani(6, 6)
    character(len=8) :: typmod(2)
!
!
! ----------------------------------------------------------------------
!    MODELE VISCOPLASTIQUE SANS SEUIL DE EDGAR
!    TRANSFORMATION DE LA MATRICE ANIC DANS LE REPERE PRINCIPAL
!  IN  NDIM  : DIMENSION DU PROBLEME
!  IN  COORD : COORDONNEES DU POINT DE GAUSS
!  IN  ANIC  : MATRICE D ANISOTROPIE DANS LE REPERE CYLINDRIQUE
!
!  OUT ANI  : MATRICE D ANISOTROPIE DANS LE REPERE PRINCIPAL
! ----------------------------------------------------------------------
!
    integer :: i, j, k, l
    integer :: ind(3, 3)
    real(kind=8) :: zero, norme, cost, sint
    real(kind=8) :: pas(3, 3), pasi(3, 3)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    data    ind/1,4,5,&
     &            4,2,6,&
     &            5,6,3/
!
    if (typmod(1)(1:4) .eq. 'AXIS') then
        do 5 i = 1, 6
            do 6 j = 1, 6
                ani(i,j)=anic(i,j)
 6          continue
 5      continue
        ani(1,2)=anic(1,3)
        ani(1,3)=anic(1,2)
        ani(2,1)=anic(3,1)
        ani(2,2)=anic(3,3)
        ani(3,1)=anic(2,1)
        ani(3,3)=anic(2,2)
        ani(4,4)=anic(5,5)
        ani(5,5)=anic(4,4)
    else
        zero=r8prem()
!
        norme=sqrt((coord(1)**2)+(coord(2)**2))
        if (norme .le. zero) then
            cost=0.d0
            sint=0.d0
        else
            cost=coord(1)/norme
            sint=coord(2)/norme
        endif
!
! MATRICE DE PASSAGE PAS ET INVERSE PASI
! DU REPERE X Y Z AU REPERE CYLINDRIQUE R T Z
!
        do 10 i = 1, 3
            do 20 j = 1, 3
                pas(i,j)=0.d0
                pasi(i,j)=0.d0
20          continue
10      continue
        pas(1,1)=cost
        pas(1,2)=-sint
        pas(2,1)=sint
        pas(2,2)=cost
        pas(3,3)=1.d0
!
        pasi(1,1)=cost
        pasi(1,2)=sint
        pasi(2,1)=-sint
        pasi(2,2)=cost
        pasi(3,3)=1.d0
!
        do 30 i = 1, 3
            do 40 j = 1, 3
                do 50 k = 1, 3
                    do 60 l = 1, 3
                        if ((j.ge.i) .and. (l.ge.k)) then
                            ani(ind(i,j),ind(k,l))= anic(1,1)*pas(i,1)&
                            *pasi(1,j)*pasi(1,k)*pas(l,1) +anic(2,2)*&
                            pas(i,2)*pasi(2,j)*pasi(2,k)*pas(l,2)&
                            +anic(3,3)*pas(i,3)*pasi(3,j)*pasi(3,k)*&
                            pas(l,3) +anic(4,4)*(pas(i,1)*pasi(2,j) +&
                            pas(i,2)*pasi(1,j)) *(pasi(1,k)*pas(l,2) +&
                            pasi(2,k)*pas(l,1)) +anic(5,5)*(pas(i,1)*&
                            pasi(3,j) + pas(i,3)*pasi(1,j)) *(pasi(1,&
                            k)*pas(l,3) + pasi(3,k)*pas(l,1)) +anic(6,&
                            6)*(pas(i,2)*pasi(3,j) + pas(i,3)*pasi(2,&
                            j)) *(pasi(2,k)*pas(l,3) + pasi(3,k)*pas(&
                            l,2)) +anic(1,2)*(pas(i,1)*pasi(1,j)*pasi(&
                            2,k)*pas(l,2)+ pas(i,2)*pasi(2,j)*pasi(1,&
                            k)*pas(l,1)) +anic(1,3)*(pas(i,1)*pasi(1,&
                            j)*pasi(3,k)*pas(l,3)+ pas(i,3)*pasi(3,j)*&
                            pasi(1,k)*pas(l,1)) +anic(2,3)*(pas(i,2)*&
                            pasi(2,j)*pasi(3,k)*pas(l,3)+ pas(i,3)*&
                            pasi(3,j)*pasi(2,k)*pas(l,2))
                        endif
60                  continue
50              continue
40          continue
30      continue
!
    endif
end subroutine
