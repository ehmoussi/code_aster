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

subroutine vecnuv(ipre, ider, gamma, phinit, dphi,&
                  n, k, dim, vectn, vectu,&
                  vectv)
! person_in_charge: van-xuan.tran at edf.fr
    implicit   none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: ipre, ider, n, k, dim
    real(kind=8) :: gamma, phinit, dphi, vectn(dim), vectu(dim)
    real(kind=8) :: vectv(dim)
! ----------------------------------------------------------------------
! BUT: DETERMINER LES COORDONNEES (X,Y,Z) DES VECTEURS NORMAUX.
! ----------------------------------------------------------------------
! ARGUMENTS :
!  IPRE     IN   I  : PREMIERE VALEUR DU POINTEUR.
!  IDER     IN   I  : DERNIERE VALEUR DU POINTEUR.
!  GAMMA    IN   R  : VALEUR DE GAMMA.
!  PHINIT   IN   R  : VALEUR INITIALE DE L'ANGLE PHI.
!  DPHI     IN   R  : INCREMENT DE PHI.
!  N        IN   I  : COMPTEUR.
!  K        IN   I  : VALEUR DU DECALAGE.
!  DIM      IN   I  : DIMENSION DES VECTEUR.
!  VECTN    OUT  R  : COORDONNEES DES VECTEURS NORMAUX.
!  VECTU    OUT  R  : COORDONNEES DES VECTEURS TANGENTS, COMPOSANTES U.
!  VECTV    OUT  R  : COORDONNEES DES VECTEURS TANGENTS, COMPOSANTES V.
! ----------------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: i
    real(kind=8) :: phi
!     ------------------------------------------------------------------
!
!234567                                                              012
!
    call jemarq()
!
    do 10 i = ipre, ider
        n = n + 1
        phi = phinit + (i-k)*dphi
!
        vectn((n-1)*3 + 1) = sin(gamma)*cos(phi)
        vectn((n-1)*3 + 2) = sin(gamma)*sin(phi)
        vectn((n-1)*3 + 3) = cos(gamma)
!
        vectu((n-1)*3 + 1) = -sin(phi)
        vectu((n-1)*3 + 2) = cos(phi)
        vectu((n-1)*3 + 3) = 0.0d0
!
        vectv((n-1)*3 + 1) = -cos(gamma)*cos(phi)
        vectv((n-1)*3 + 2) = -cos(gamma)*sin(phi)
        vectv((n-1)*3 + 3) = sin(gamma)
!
10  end do
!
    call jedema()
!
end subroutine
