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

subroutine rc36sa(nommat, mati, matj, snpq, spij,&
                  typeke, spmeca, spther, saltij, sm)
    implicit   none
#include "asterfort/prccm3.h"
    real(kind=8) :: mati(*), matj(*), snpq, spij, saltij, sm
    real(kind=8) :: typeke, spmeca, spther
    character(len=8) :: nommat
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
!
!     CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE  SALT
!     CALCUL DU FACTEUR D'USAGE ET DE SON CUMUL
!
! IN  : NOMMAT : NOM MATERIAU
! IN  : MATI   : MATERIAU ASSOCIE A L'ETAT STABILISE I
! IN  : MATJ   : MATERIAU ASSOCIE A L'ETAT STABILISE J
! IN  : SNPQ   : AMPLITUDE DE VARIATION DES CONTRAINTES LINEARISEES
! IN  : SPIJ   : AMPLITUDE DE VARIATION DES CONTRAINTES TOTALES
! OUT : SALTIJ : AMPLITUDE DE CONTRAINTE ENTRE LES ETATS I ET J
!
!     ------------------------------------------------------------------
!
    real(kind=8) :: e, ec, para(3), m, n, ke, nadm, saltm, salth, kemeca, kether
    real(kind=8) :: kethe1
! DEB ------------------------------------------------------------------
!
! --- LE MATERIAU
!
    e = min ( mati(1) , matj(1) )
    ec = max ( mati(10) , matj(10) )
    sm = min ( mati(11) , matj(11) )
    m = max ( mati(12) , matj(12) )
    n = max ( mati(13) , matj(13) )
!
    para(1) = m
    para(2) = n
    para(3) = ec / e
!
! --- CALCUL DU COEFFICIENT DE CONCENTRATION ELASTO-PLASTIQUE KE
! --- CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE SALT
! --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE NADM
!
    if (typeke .lt. 0.d0) then
        call prccm3(nommat, para, sm, snpq, spij,&
                    ke, saltij, nadm)
    else
        call prccm3(nommat, para, sm, snpq, spmeca,&
                    kemeca, saltm, nadm)
!
!       CALCUL DE KE THER
!
        kethe1 = 1.86d0*(1.d0-(1.d0/(1.66d0+snpq/sm)))
        kether = max(1.d0,kethe1)
!
!        CALCUL DE SALTH
        salth= 0.5d0 * para(3) * kether * spther
!
        saltij = saltm + salth
    endif
!
end subroutine
