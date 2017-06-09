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

subroutine te0562(option, nomte)
!
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/massup.h"
#include "asterfort/teattr.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  OPTION MASS_MECA_* POUR GRAD_VARI
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    integer :: dlns
    integer :: nno, npg1, imatuu, ndim, nnos, jgano, iret, icodr1(1)
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: nnob, ivfb, idfdeb, jganob
!
    character(len=8) :: typmod(2)
    character(len=16) :: phenom
!
!
    call elrefv(nomte, 'MASS', ndim, nno, nnob,&
                nnos, npg1, ipoids, ivf, ivfb,&
                idfde, idfdeb, jgano, jganob)
!
!    TYPE DE MODELISATION
    call teattr('S', 'TYPMOD', typmod(1), iret)
    typmod(2) = 'GRADVARI'
!
!     PARAMETRES EN ENTREE
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PMATUUR', 'E', imatuu)
!
!    DEPLACEMENT + LAMBDA + VAR_REG
    ASSERT(ndim.eq.2 .or. ndim.eq.3)
    dlns = ndim + 2
!
    call massup(option, ndim, dlns, nno, nnob,&
                zi(imate), phenom, npg1, ipoids, idfde,&
                zr(igeom), zr(ivf), imatuu, icodr1, igeom,&
                ivf)
!
end subroutine
