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

subroutine lceibt(ndimsi, eps, epsf, dep, invn,&
                  cn, dsidep)
    implicit none
#include "asterfort/r8inir.h"
    real(kind=8) :: eps(6), epsf(6), dep(6, 12), dsidep(6, 6), invn(6, 6)
    real(kind=8) :: cn(6, 6)
    integer :: ndimsi
! ----------------------------------------------------------------------
!     LOI DE COMPORTEMENT ENDO_ISOT_BETON - TERME COMPLEMENTAIRE DE
!                                           LA MATRICE TANGENTE POUR
!                                           LES LOIS COUPLES
! ----------------------------------------------------------------------
    integer :: i, j, k, l
    real(kind=8) :: sigel(6), sigme(6), temp1(6, 6)
!
    call r8inir(ndimsi, 0.d0, sigel, 1)
    call r8inir(ndimsi, 0.d0, sigme, 1)
    call r8inir(36, 0.d0, temp1, 1)
!
    do 30 i = 1, ndimsi
        temp1(i,i)=temp1(i,i)+1.d0
        do 30 j = 1, ndimsi
            do 30 k = 1, ndimsi
                do 30 l = 1, ndimsi
                    temp1(i,j)=temp1(i,j)-dep(i,k)*invn(k,l)*cn(l,j)
30              continue
!
    do 10 i = 1, ndimsi
        do 10 j = 1, ndimsi
            sigel(i) = sigel(i) + dep(i,j+6)*eps(j)
            sigme(i) = sigme(i) + dep(i,j+6)*(eps(j)-epsf(j))
10      continue
!
    do 20 i = 1, ndimsi
        do 20 j = 1, ndimsi
            do 20 k = 1, ndimsi
                dsidep(i,j)=dsidep(i,j)-temp1(i,k)*sigme(k)*sigel(j)
20          continue
!
end subroutine
