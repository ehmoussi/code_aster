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
subroutine te0561(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/nmfogn.h"
#include "asterfort/nmforn.h"
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
! Options: FORC_NODA, REFE_FORC_NODA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: typmod(2)
    integer :: nnoQ, nnoL, npg
    integer :: jv_poids, jv_vfQ, jv_dfdeQ, igeom, imate
    integer :: jv_vfL, jv_dfdeL, nnos, jv_ganoQ, jv_ganoL
    integer :: icontm, idplgm, ivectu
    integer :: ndim
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
    call elrefv('RIGI'  , ndim    ,&
                nnoL    , nnoQ    , nnos,&
                npg     , jv_poids,&
                jv_vfL  , jv_vfQ  ,&
                jv_dfdeL, jv_dfdeQ,&
                jv_ganoL, jv_ganoQ)
!
! - Compute option
!
    if (option .eq. 'FORC_NODA') then
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PMATERC', 'L', imate)
        call jevech('PDEPLMR', 'L', idplgm)
        call jevech('PVECTUR', 'E', ivectu)
        call nmfogn(ndim, nnoQ, nnoL, npg, jv_poids,&
                    zr(jv_vfQ), zr(jv_vfL), jv_dfdeQ, jv_dfdeL, zr(igeom),&
                    typmod, zi(imate), zr(idplgm), zr(icontm), zr(ivectu))
    elseif (option .eq. 'REFE_FORC_NODA') then
        call jevech('PMATERC', 'L', imate)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PVECTUR', 'E', ivectu)
        call nmforn(ndim, nnoQ, nnoL, npg, jv_poids,&
                    zr(jv_vfQ), zr(jv_vfL), jv_dfdeQ, zr( igeom), zr(ivectu))
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
