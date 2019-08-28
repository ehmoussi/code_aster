! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
subroutine te0562(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/massup.h"
#include "asterfort/teattr.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_GVNO
!           D_PLAN_GVNO
!
! Options: MASS_MECA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_DOF
    integer :: nnoQ, npg, imatuu, ndim, nnos, jv_ganoQ, icodr1(1)
    integer :: jv_poids, jv_vfQ, jv_dfdeQ, igeom, imate
    integer :: nnoL, jv_vfL, jv_dfdeL, jv_ganoL
    character(len=8) :: typmod(2)
    character(len=16) :: phenom
!
! --------------------------------------------------------------------------------------------------
!

!
! - Type of modelling
!
    call teattr('S', 'TYPMOD' , typmod(1))
    call teattr('S', 'TYPMOD2', typmod(2))
!
! - Get parameters of element
!
    call elrefv('MASS'  , ndim    ,&
                nnoL    , nnoQ    , nnos,&
                npg     , jv_poids,&
                jv_vfL  , jv_vfQ  ,&
                jv_dfdeL, jv_dfdeQ,&
                jv_ganoL, jv_ganoQ)
    ASSERT(ndim.eq.2 .or. ndim.eq.3)
!
! - Input fields
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PMATUUR', 'E', imatuu)
!
! - nb_DOF: displacements (2 or 3) + LAMBDA + VAR_REG
!
    nb_DOF = ndim + 2
!
    call massup(option, ndim, nb_DOF, nnoQ, nnoL,&
                zi(imate), phenom, npg, jv_poids, jv_dfdeQ,&
                zr(igeom), zr(jv_vfQ), imatuu, icodr1, igeom,&
                jv_vfQ)
!
end subroutine
