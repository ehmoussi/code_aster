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

subroutine elref2(nomte, dim, lielrf, ntrou)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
    character(len=16) :: nomte
    integer :: dim
    character(len=8) :: lielrf(dim)
! ---------------------------------------------------------------------
! BUT: RECUPERER LA LISTE DES ELREFE D'UN TYPE_ELEM
! ---------------------------------------------------------------------
!     ARGUMENTS:
! NOMTE  IN      K16    : NOM DU TYPE_ELEM
! DIM    IN      I      : DIMENSION DU VECTEUR LIELRF
! LIELRF OUT     L_K8   : LISTE DES ELREFE POUR NOMTE
!        OUT     NTROU  : NOMBRE D'ELREFE POUR NOMTE
!
! REMARQUE :
!   SI NOMTE A PLUS D'ELREFE QUE DIM => ERREUR <F>
!----------------------------------------------------------------------
!
    integer :: nute,   ntrou, iad, k
    character(len=8), pointer :: noelrefe(:) => null()
    integer, pointer :: nbelrefe(:) => null()
!
    call jenonu(jexnom('&CATA.TE.NOMTE', nomte), nute)
    ASSERT(nute.gt.0)
!
    call jeveuo('&CATA.TE.NBELREFE', 'L', vi=nbelrefe)
    call jeveuo('&CATA.TE.NOELREFE', 'L', vk8=noelrefe)
!
    ntrou = nbelrefe(2* (nute-1)+1)
    iad = nbelrefe(2* (nute-1)+2)
!
    ASSERT(ntrou.le.dim)
!
    do 10,k = 1,ntrou
    lielrf(k) = noelrefe(iad-1+k)
    10 end do
!
!
end subroutine
