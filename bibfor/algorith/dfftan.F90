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

subroutine dfftan(ndim, baslo, inoff, vtan)
!
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dffdir.h"
#include "asterfort/dffnor.h"
#include "asterfort/provec.h"
    real(kind=8) :: baslo(*), vtan(3)
    integer :: ndim, inoff
!
!
! FONCTION REALISEE (OPERATEURS DEFI_FOND_FISS, CALC_G) :
!
!      RETOURNE LE VECTEUR TANGENT AU FOND DE FISSURE (3EME VECTEUR DE
!      LA BASE LOCALE EN FOND DE FISSURE) EN UN NOEUD
!
! IN
!   NDIM   : DIMENSION DU MAILLAGE
!   BASLO  : VALEURS DE LA BASE LOCALE EN FOND DE FISSURE
!   INOFF  : INDICE LOCAL DU NOEUD DE LA BASE DEMANDE
!
! OUT
!   VTAN   : VALEURS DU TANGENT AU FOND DE FISSURE EN CE NOEUD
!
!-----------------------------------------------------------------------
!
    real(kind=8) :: vdir(3), vnor(3)
!
!-----------------------------------------------------------------------
!
    ASSERT((ndim.eq.2).or.(ndim.eq.3))
!
    if (ndim .eq. 3) then
!
        call dffdir(ndim, baslo, inoff, vdir)
!
        call dffnor(ndim, baslo, inoff, vnor)
!
        call provec(vdir, vnor, vtan)
!
    else if (ndim.eq.2) then
!
        vtan(1) = 0.d0
        vtan(2) = 0.d0
        vtan(3) = 1.d0
!
    endif
!
end subroutine
