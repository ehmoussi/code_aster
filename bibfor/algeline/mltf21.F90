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

subroutine mltf21(p, front, frn, n, t1,&
                  t2, eps, ier)
! person_in_charge: olivier.boiteau at edf.fr
!     VERSION MODIFIEE POUR L' APPEL A DGEMV (PRODUITS MATRICE-VECTEUR)
!     LE STOCKAGE DES COLONNES DE LA FACTORISEE EST MODIFIE
    implicit none
#include "asterfort/col11j.h"
#include "asterfort/col21j.h"
#include "asterfort/colni1.h"
#include "asterfort/colni2.h"
    integer :: p, n, ier
    real(kind=8) :: front(*), t1(*), t2(*), frn(*), eps
!                                          VARIABLES LOCALES
    integer :: dia1, dia2, j, l, m, r, dia21, n1, jj
    real(kind=8) :: coef1
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    m = p/2
    r = p - 2*m
    l = n
    dia2 = -n
    do 10 j = 1, m
        jj=j
!                    TRAVAIL SUR LE BLOC TRIANGULAIRE
!     MODIFS POUR STOCKAGE DGEMV
        dia1 = dia2 + n + 1
        dia2 = dia1 + n + 1
        dia21 = dia2 + 1
        l = l - 2
        coef1 = front(dia1+1)
        if (abs(front(dia1)) .le. eps) then
            ier = 1
            goto 30
        else
            front(dia1+1) = front(dia1+1)/front(dia1)
            front(dia2) = front(dia2) - front(dia1+1)*coef1
!                                            TRAVAIL SUR LES 2 COLONNES
            call colni2(front(dia1+2), front(dia21), l, front(dia1), front(dia2),&
                        coef1, t1, t2, eps, ier)
            if (ier .ne. 0) goto 30
!                                    MISE A JOUR DES COLONNES
            n1 = p - 2*j
!     MODIFS POUR STOCKAGE DGEMV
            call col21j(front(dia1), front(dia21+n), frn, j, l,&
                        n, n1, t1, t2)
        endif
10  end do
!                          TRAVAIL SUR LE RESTE DES COLONNES
!                                            DU SUPERNOEUD
    if (r .eq. 1) then
        jj = m + 1
!     MODIFS POUR STOCKAGE DGEMV
        dia1 = dia2 + n + 1
        dia2 = dia1 + l
        l = l - 1
        call colni1(front(dia1+1), l, front(dia1), t1, eps,&
                    ier)
        if (ier .ne. 0) goto 30
        call col11j(front(dia1), frn, l, t1)
    endif
30  continue
    if (ier .gt. 0) ier = ier + 2* (jj-1)
end subroutine
