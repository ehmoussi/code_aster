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

subroutine dfdm2b(nno, poids, dfrdk, coor, jacp, normal)
! ======================================================================
! person_in_charge: daniele.colombo at ifpen.fr
    implicit none
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/provec.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "asterfort/vecini.h"
#include "asterfort/xnormv.h"
    integer :: nno
    real(kind=8) :: dfrdk(1), coor(*)
    real(kind=8) :: jacp, poids, normal(3)
! ......................................................................
!    - BUTS:  CALCULER LA VALEUR DU POIDS D'INTEGRATION EN 1 POINT DE
!             GAUSS POUR UNE FACE PLONGEE DANS UN ELEMENT VOLUMIQUE 
!
!    - ARGUMENTS:
!        DONNEES:     NNO           -->  NOMBRE DE NOEUDS DE LA FACE
!                     POIDS         -->  POIDS DE GAUSS
!                     DFRDK         -->  DERIVEES FONCTIONS DE FORME DE LA FACE
!                     COOR          -->  COORDONNEES DES NOEUDS DE LA FACE
!
!        RESULTATS:   JACP          <--  PRODUIT DU JACOBIEN ET DU POIDS
!                     NORMAL        <--  NORMALE A LA FACETTE AU POINT DE GAUSS

!
!  REMARQUE :
!    - LA FACE N'EST PAS NECESSAIREMENT PLANE
!
    character(len=8) :: nomail
    integer :: i, j
    integer :: iadzi, iazk24
    real(kind=8) :: da(3), db(3), jac
!-----------------------------------------------------------------------
    call vecini(3, 0.d0, da)
    call vecini(3, 0.d0, db)
    do i = 1, nno
       do j = 1, 3
          da(j) = da(j) + coor(3*(i-1)+j) * dfrdk(2*i-1)
          db(j) = db(j) + coor(3*(i-1)+j) * dfrdk(2*i)
       end do
    end do
    call provec(da, db, normal)
    call xnormv(3, normal, jac)
!
    if (abs(jac) .le. 1.d0/r8gaem()) then
        call tecael(iadzi, iazk24)
        nomail= zk24(iazk24-1+3)(1:8)
        call utmess('F', 'ALGORITH2_59', sk=nomail)
    endif
!
    jacp = jac * poids
end subroutine
