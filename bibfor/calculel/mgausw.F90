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

subroutine mgausw(a, b, dim, nordre, nb,&
                  det, iret)
!
    implicit none
#include "asterf_types.h"
!
    integer :: dim, nb, nordre
    real(kind=8) :: a(dim, dim), b(dim, nb), det
    aster_logical :: iret
!
!
! ----------------------------------------------------------------------
!     RESOLUTION PAR LA METHODE DE GAUSS D'UN SYSTEME LINEAIRE
! ----------------------------------------------------------------------
!     VARIABLES D'ENTREE
!     REAL*8      A(DIM, DIM)     : MATRICE CARREE PLEINE
!     REAL*8      B(DIM, NB)      : SECONDS MEMBRES
!     INTEGER     DIM             : DIMENSION DE A
!     INTEGER     NORDRE          : RANG DE LA MATRICE
!     INTEGER     NB              : NOMBRE DE SECONDS MEMBRES
!     REAL*8      DET             : 0 = PAS DE CALCUL DU DETERMINANT
!
!     VARIABLES DE SORTIE
!     REAL*8      B(DIM, NB)      : A-1 * B
!     REAL*8      DET             : DETERMINANT DE A (SI DEMANDE)
!     LOGICAL     IRET            : .FALSE. SI A SINGULIERE
!
! ----------------------------------------------------------------------
!     ATTENTION : LA MATRICE A EST MODIFIEE
! ----------------------------------------------------------------------
!
!     PARAMETRE
    real(kind=8) :: condmx
    parameter (condmx = 1.d16)
!
    integer :: i, j, k
    real(kind=8) :: c, d, cmin, cmax
    aster_logical :: flag, ldet
!
    iret = .true.
!
    if (det .eq. 0.d0) then
        ldet = .false.
    else
        ldet = .true.
        det = 1.d0
    endif
!
    do 10 i = 1, nordre
!
! ----- RECHERCHE DU MEILLEUR PIVOT
!
        j = i
        c = a(i,i)
        flag = .false.
!
        do 20 k = i+1, nordre
            d = a(k,i)
            if (abs(c) .lt. abs(d)) then
                c = d
                j = k
                flag = .true.
            endif
 20     continue
!
! ----- DETERMINANT
!
        if (ldet) det = det * c
!
! ----- ESTIMATION GROSSIERE DU CONDITIONNEMENT
!
        if (i .eq. 1) then
            cmin = abs(c)
            cmax = cmin
        else
            if (abs(c) .lt. cmin) then
                cmin = abs(c)
                if (cmax .gt. condmx*cmin) then
                    iret = .false.
                    goto 100
                endif
                goto 30
            endif
            if (abs(c) .gt. cmax) then
                cmax = abs(c)
                if (cmax .gt. condmx*cmin) then
                    iret = .false.
                    goto 100
                endif
            endif
        endif
!
 30     continue
!
! ----- PERMUTATION
!
        if (flag) then
!
            do 40 k = i, nordre
                d = a(i,k)
                a(i,k) = a(j,k)
                a(j,k) = d
 40         continue
!
            do 50 k = 1, nb
                d = b(i,k)
                b(i,k) = b(j,k)
                b(j,k) = d
 50         continue
!
            det = (-1.d0)*det
!
        endif
!
! ----- ELIMINATION
!
        do 10 j = i+1, nordre
!
            if (a(j,i) .ne. 0.d0) then
!
                d = a(j,i)/c
!
                do 60 k = 1, nb
                    b(j,k) = b(j,k) - d*b(i,k)
 60             continue
!
                do 70 k = i+1, nordre
                    a(j,k) = a(j,k) - d*a(i,k)
 70             continue
!
            endif
!
 10     continue
!
! --- RESOLUTION
!
    do 80 k = 1, nb
        b(nordre,k) = b(nordre,k)/c
!
        do 80 i = nordre-1, 1, -1
            d = 0.d0
            do 90 j = i+1, nordre
                d = d + a(i,j) * b(j, k)
 90         continue
!
            b(i,k) = (b(i,k) - d) / a(i,i)
!
 80     continue
!
100 continue
!
end subroutine
