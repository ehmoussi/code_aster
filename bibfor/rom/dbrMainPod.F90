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
subroutine dbrMainPod(paraPod, baseOut)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dbr_calcpod_q.h"
#include "asterfort/dbr_calcpod_redu.h"
#include "asterfort/dbr_calcpod_save.h"
#include "asterfort/dbr_calcpod_sele.h"
#include "asterfort/dbr_calcpod_size.h"
#include "asterfort/dbr_calcpod_svd.h"
#include "asterfort/infniv.h"
#include "asterfort/romTableSave.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_POD), intent(in) :: paraPod
type(ROM_DS_Empi), intent(in) :: baseOut
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE
!
! Main subroutine to compute base - For standard POD
!
! --------------------------------------------------------------------------------------------------
!
! In  paraPod          : datastructure for parameters (POD)
! In  baseOut          : output base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbSing, nbMode, nbSnap, iSnap, nbModeMaxi, m, n
    real(kind=8), pointer :: q(:) => null()
    real(kind=8), pointer :: v(:) => null()
    real(kind=8), pointer :: s(:) => null() 
    real(kind=8), pointer :: v_gamma(:) => null()
    real(kind=8) :: toleSVD
    character(len=8) :: resultDomName
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_58')
    endif
!
! - Get parameters
!
    toleSVD       = paraPod%toleSVD
    nbSnap        = paraPod%snap%nbSnap
    nbModeMaxi    = paraPod%nbModeMaxi
    resultDomName = paraPod%resultDom%resultName
!
! - Get size of snapshots matrix
!
    call dbr_calcpod_size(baseOut, paraPod%snap,&
                          m      , n)
!
! - Create snapshots matrix Q
!    
    call dbr_calcpod_q(baseOut, resultDomName, paraPod%snap, m, n, q)
!
! - Compute modes by SVD
!
    call dbr_calcpod_svd(m, n, q, s, v, nbSing)
!
! - Select modes
!
    call dbr_calcpod_sele(nbModeMaxi, toleSVD, s, nbSing, nbMode)
!
! - Save base
! 
    call dbr_calcpod_save(baseOut, nbMode, nbSnap, s, v)
!
! - Compute reduced coordinates
!
    call dbr_calcpod_redu(nbSnap, m, q, v, nbMode, v_gamma)
!
! - Save the reduced coordinates in a table
!
    do iSnap = 1, nbSnap
        call romTableSave(paraPod%tablReduCoor%tablResu, nbMode, v_gamma,&
                          numeSnap_ = iSnap)
    end do
!
! - Clean
!
    AS_DEALLOCATE(vr = q)
    AS_DEALLOCATE(vr = v)
    AS_DEALLOCATE(vr = s)
    AS_DEALLOCATE(vr = v_gamma)
!
end subroutine
