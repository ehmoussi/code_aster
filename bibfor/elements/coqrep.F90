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

subroutine coqrep(pgl, alpha, beta, t2iu, t2ui,&
                  c, s)
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"

    real(kind=8) :: pgl(3, 3), t2iu(*), t2ui(*), alpha, beta, c, s
! person_in_charge: nicolas.sellenet at edf.fr
!     ------------------------------------------------------------------
!
!         CALCUL DE LA MATRICE DE PASSAGE DU REPERE INTRINSEQUE (ELEMENT) A CELUI
!         DE L'UTILISATEUR (VARIETE) (LE REPERE DE LA VARIETE EST OBTENU PAR LA MATRICE
!         DE PASSAGE GLOBAL -> LOCAL) AINSI QUE SON INVERSE
!
!         POUR TOUTES LES OPTIONS DE POST TRAITEMENT COQUE
!
!     ==> ALPHA, BETA EN RADIAN
!
!     ------------------------------------------------------------------
    real(kind=8) :: dx, dy, dz, norm
    real(kind=8) :: ps, pjdx, pjdy, pjdz
!     LE VECTEUR EST NORME
    dx = cos(beta)*cos(alpha)
    dy = cos(beta)*sin(alpha)
    dz = -sin(beta)
!   On vérifie que n = pgl(3,1:3) n'est pas de norme nulle
    norm = sqrt(dot_product(pgl(3,1:3),pgl(3,1:3)))
    ASSERT( norm.gt.r8prem() )
!   
    ps = dx*pgl(3,1) + dy*pgl(3,2) + dz*pgl(3,3)
    pjdx = dx - ps*pgl(3,1)
    pjdy = dy - ps*pgl(3,2)
    pjdz = dz - ps*pgl(3,3)
    norm = sqrt (pjdx*pjdx + pjdy*pjdy + pjdz*pjdz)
    if (norm .le. r8prem()) then
        call utmess('F', 'ELEMENTS_40')
    endif
!
    pjdx = pjdx/norm
    pjdy = pjdy/norm
    pjdz = pjdz/norm
    c = pjdx*pgl(1,1) + pjdy*pgl(1,2) + pjdz*pgl(1,3)
    s = pjdx*pgl(2,1) + pjdy*pgl(2,2) + pjdz*pgl(2,3)
!
    c=c/sqrt(c**2+s**2)
    s=s/sqrt(c**2+s**2)
!
    t2iu(1) = c
    t2iu(2) = s
    t2iu(3) = - s
    t2iu(4) = c
!
    t2ui(1) = c
    t2ui(2) = - s
    t2ui(3) = s
    t2ui(4) = c
!
!
end subroutine
