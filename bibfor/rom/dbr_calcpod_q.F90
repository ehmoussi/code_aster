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
subroutine dbr_calcpod_q(base, ds_snap, m, n, q)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/rsexch.h"
#include "asterfort/jelibe.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/dbr_calcpod_ql.h"
!
type(ROM_DS_Empi), intent(in) :: base
type(ROM_DS_Snap), intent(in) :: ds_snap
integer, intent(in) :: m, n
real(kind=8), pointer :: q(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Create snapshots matrix [Q]
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : base
! In  ds_snap          : datastructure for snapshot selection
! In  m                : first dimension of snapshot matrix
! In  m                : second dimension of snapshot matrix
! Out q                : pointer to [Q] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iSnap, iEqua
    integer :: nbSnap, nbEqua
    integer :: numeInst, iret
    character(len=8)  :: baseType, resultName
    character(len=24) :: fieldName, list_snap
    integer, pointer :: v_list_snap(:) => null()
    real(kind=8), pointer :: v_resuFieldVale(:) => null()
    character(len=24) :: resuFieldVale
    character(len=4) :: fieldSupp
    type(ROM_DS_Field) :: mode
    type(ROM_DS_LineicNumb) :: lineicNume
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_1')
    endif
!
! - Initializations
!
    resuFieldVale = '&&ROM_FIELDRESU'
!
! - Get parameters for snapshots
!
    resultName = ds_snap%result
    nbSnap     = ds_snap%nb_snap
    list_snap  = ds_snap%list_snap
    ASSERT(nbSnap .gt. 0)
!
! - Get parameters for base
!
    baseType   = base%baseType
    lineicNume = base%lineicNume
!
! - Get parameters for mode
!
    mode      = base%mode
    nbEqua    = mode%nbEqua
    fieldName = mode%fieldName
    fieldSupp = mode%fieldSupp
    ASSERT(nbEqua .gt. 0)
!
! - Get list of snapshots to select
!
    call jeveuo(list_snap, 'L', vi = v_list_snap)
!
! - Prepare snapshots matrix
!
    AS_ALLOCATE(vr = q, size = m * n)
!
! - Save the [Q] matrix depend on which type of reduced base
!
    if (baseType .eq. 'LINEIQUE') then
        call dbr_calcpod_ql(lineicNume, &
                            resultName, fieldName  , nbEqua,&
                            nbSnap    , v_list_snap,&
                            q)
    else
        do iSnap = 1, nbSnap
            numeInst = v_list_snap(iSnap)
            call rsexch(' '  , resultName, fieldName, numeInst, resuFieldVale, iret)
            if (iret .ne. 0) then
                call utmess('F','ROM2_11',sk = resultName)
            endif
            if (fieldSupp == 'NOEU') then
                call jeveuo(resuFieldVale(1:19)//'.VALE', 'L', vr = v_resuFieldVale)
            else if (fieldSupp == 'ELGA') then
                call jeveuo(resuFieldVale(1:19)//'.CELV', 'L', vr = v_resuFieldVale)
            else
                ASSERT(ASTER_FALSE)
            endif
            do iEqua = 1, nbEqua
                q(iEqua + nbEqua*(iSnap - 1)) = v_resuFieldVale(iEqua)
            end do
            if (fieldSupp == 'NOEU') then
                call jelibe(resuFieldVale(1:19)//'.VALE')
            elseif (fieldSupp == 'ELGA') then
                call jelibe(resuFieldVale(1:19)//'.CELV')
            else
                ASSERT(ASTER_FALSE)
            endif
        enddo
    endif
!
end subroutine
