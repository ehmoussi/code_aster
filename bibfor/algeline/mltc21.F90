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

subroutine mltc21(p, front, frn, n, t1,&
                  t2, eps, ier)
! person_in_charge: olivier.boiteau at edf.fr
!     VERSION COMPLEXE DE MLTF21
!     VERSION MODIFIEE POUR L' APPEL A CGEMV (PRODUITS MATRICE-VECTEUR)
!     LE STOCKAGE DES COLONNES DE LA FACTORISEE EST MODIFIE
    implicit none
#include "asterfort/ccl11j.h"
#include "asterfort/ccl21j.h"
#include "asterfort/cclni1.h"
#include "asterfort/cclni2.h"
    integer :: p, n, ier
    complex(kind=8) :: front(*), t1(*), t2(*), frn(*)
    real(kind=8) :: eps
!                                          VARIABLES LOCALES
    integer :: dia1, dia2, j, l, m, r, dia21, n1
    complex(kind=8) :: coef1
    m = p/2
    r = p - 2*m
    l = n
    dia2 = -n
    do 110 j = 1, m
!                                            TRAVAIL SUR LE BLOC TRIANGU
        dia1 = dia2 + n + 1
        dia2 = dia1 + n + 1
        dia21 = dia2 + 1
        l = l - 2
        coef1 = front(dia1+1)
        if (abs(front(dia1)) .lt. eps) then
            ier = 1
            goto 120
        else
            front(dia1+1) = front(dia1+1)/front(dia1)
            front(dia2) = front(dia2) - front(dia1+1)*coef1
!                                            TRAVAIL SUR LES 2 COLONNES
            call cclni2(front(dia1+2), front(dia21), l, front(dia1), front(dia2),&
                        coef1, t1, t2, eps, ier)
!                                            MISE A JOUR DES COLONNES SU
            n1 = p - 2*j
!     MODIFS POUR STOCKAGE CGEMV
            call ccl21j(front(dia1), front(dia21+n), frn, j, l,&
                        n, n1, t1, t2)
        endif
110  end do
!                                            TRAVAIL SUR LE RESTE DES CO
!                                            DU SUPERNOEUD
    if (r .eq. 1) then
!     MODIFS POUR STOCKAGE CGEMV
        dia1 = dia2 + n + 1
        dia2 = dia1 + l
        l = l - 1
        call cclni1(front(dia1+1), l, front(dia1), t1, eps,&
                    ier)
        call ccl11j(front(dia1), frn, l, t1)
    endif
120  continue
    goto 9999
9999  continue
end subroutine
