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

subroutine cargri(lexc, densit, distn, dir11)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterc/r8vide.h"
#include "asterfort/jevech.h"
    aster_logical :: lexc
    real(kind=8) :: densit, distn, dir11(3)
!
!
!         LECTURE DES CARACTERISTIQUES DES GRILLES
!
!  IN  LEXC : TRUE  SI GRILLE_EXCENTREE
!             FALSE SI GRILLE_MEMBRANE
!  OUT DENSIT : DENSITE D'ARMATURE
!  OUT DISTN  : EXCENTREMENT ( R8VIDE() SI LEXC = .FALSE.)
!  OUT DIR11  : DIRECTION DES ARMATURE
!
!     ------------------------------------------------------------------
    real(kind=8) :: alpha, beta
    integer :: icacoq
!
    call jevech('PCACOQU', 'L', icacoq)
!
    densit = zr(icacoq)
    alpha = zr(icacoq+1) * r8dgrd()
    beta = zr(icacoq+2) * r8dgrd()
    dir11(1) = cos(beta)*cos(alpha)
    dir11(2) = cos(beta)*sin(alpha)
    dir11(3) = - sin(beta)
!
    if (lexc) then
        distn = zr(icacoq+3)
    else
        distn = r8vide()
    endif
!
end subroutine
