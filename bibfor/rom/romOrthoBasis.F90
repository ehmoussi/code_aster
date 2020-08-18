! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romOrthoBasis(ds_multipara, base, new_basis)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
#include "asterfort/romAlgoMGS.h"
#include "blas/zdotc.h"
#include "blas/ddot.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jedetr.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
type(ROM_DS_Empi), intent(in) :: base
character(len=19), intent(in) :: new_basis
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Orthonormalization the basis with algorithme << Iterative Modified Gram-Schmidt >>
! (version KAHAN-PARLETT) 
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara        : datastructure for multiparametric problems
! In  base                : base
! In  new_basis           : new basis to be orthogonalized 
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbMode, nbEqua
    complex(kind=8), pointer :: vc_new_mode(:) => null()
    real(kind=8), pointer :: vr_new_mode(:) => null()
    complex(kind=8), pointer :: vc_new_mode1(:) => null()
    real(kind=8), pointer :: vr_new_mode1(:) => null()
    complex(kind=8), pointer :: vc_new_mode2(:) => null()
    real(kind=8), pointer :: vr_new_mode2(:) => null()
    character(len=1) :: syst_type
    complex(kind=8) :: normc_new_mode, normc_new_mode1, normc_new_mode2
    real(kind=8) :: normr_new_mode, normr_new_mode1, normr_new_mode2
    character(len=8) :: resultName
    character(len=24) :: fieldIden
!
! --------------------------------------------------------------------------------------------------
!
    syst_type  = ds_multipara%syst_type
    nbMode     = base%nbMode
    fieldIden  = 'DEPL'
    resultName = base%resultName
    nbEqua     = base%mode%nbEqua
    ASSERT(base%mode%fieldSupp .eq. 'NOEU')
!
! - Orthogonalization the basis
!
    if (syst_type .eq. 'R') then 
        call jeveuo(new_basis(1:19)//'.VALE', 'E', vr = vr_new_mode)
        AS_ALLOCATE(vr = vr_new_mode1, size=nbEqua)
        call romAlgoMGS(nbMode, nbEqua, 'R', fieldIden, resultName,&
                        vr_mode_in  = vr_new_mode,&
                        vr_mode_out = vr_new_mode1)
        normr_new_mode  = sqrt(ddot(nbEqua, vr_new_mode, 1, vr_new_mode, 1))
        normr_new_mode1 = sqrt(ddot(nbEqua, vr_new_mode1, 1, vr_new_mode1, 1))
        if (normr_new_mode1 .gt. 0.717*normr_new_mode) then
            vr_new_mode(1:nbEqua) = vr_new_mode1(1:nbEqua)/normr_new_mode1
            AS_DEALLOCATE(vr = vr_new_mode1)
        else  
            AS_ALLOCATE(vr = vr_new_mode2, size=nbEqua)
            call romAlgoMGS(nbMode, nbEqua, 'R', fieldIden, resultName,&
                            vr_mode_in  = vr_new_mode1,&
                            vr_mode_out = vr_new_mode2)
            normr_new_mode2 = sqrt(ddot(nbEqua, vr_new_mode2, 1, vr_new_mode2, 1))
            if (normr_new_mode2 .gt. 0.717*normr_new_mode1) then
                vr_new_mode(1:nbEqua) = vr_new_mode2(1:nbEqua)/normr_new_mode2
                AS_DEALLOCATE(vr = vr_new_mode1)
                AS_DEALLOCATE(vr = vr_new_mode2)
            else 
                AS_DEALLOCATE(vr = vr_new_mode1)
                AS_DEALLOCATE(vr = vr_new_mode2)
                call utmess('F', 'ROM5_14')
            end if
        end if  
    else if (syst_type .eq. 'C') then  
        call jeveuo(new_basis(1:19)//'.VALE', 'E', vc = vc_new_mode)
        AS_ALLOCATE(vc = vc_new_mode1, size=nbEqua)
        call romAlgoMGS(nbMode, nbEqua, 'C', fieldIden, resultName,&
                        vc_mode_in  = vc_new_mode,&
                        vc_mode_out = vc_new_mode1)
        normc_new_mode  = sqrt(zdotc(nbEqua, vc_new_mode, 1,  vc_new_mode, 1))
        normc_new_mode1 = sqrt(zdotc(nbEqua, vc_new_mode1, 1, vc_new_mode1, 1))
        if (real(normc_new_mode1) .gt. 0.717*real(normc_new_mode)) then
            vc_new_mode(1:nbEqua) = vc_new_mode1(1:nbEqua)/normc_new_mode1
            AS_DEALLOCATE(vc = vc_new_mode1)
        else  
            AS_ALLOCATE(vc = vc_new_mode2, size=nbEqua)
            call romAlgoMGS(nbMode, nbEqua, 'C', fieldIden, resultName,&
                            vc_mode_in = vc_new_mode1,&
                            vc_mode_out = vc_new_mode2)
            normc_new_mode2 = sqrt(zdotc(nbEqua, vc_new_mode2, 1, vc_new_mode2, 1))
            if (real(normc_new_mode2) .gt. 0.717*real(normc_new_mode1)) then
                vc_new_mode(1:nbEqua) = vc_new_mode2(1:nbEqua)/normc_new_mode2
                AS_DEALLOCATE(vc = vc_new_mode1)
                AS_DEALLOCATE(vc = vc_new_mode2)
            else 
                call utmess('F', 'ROM5_14')
            end if
        end if
    else
        ASSERT(ASTER_FALSE)
    end if
end subroutine

