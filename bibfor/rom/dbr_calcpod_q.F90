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
subroutine dbr_calcpod_q(base, resultName, snap, m, n, q)
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
character(len=8), intent(in) :: resultName
type(ROM_DS_Snap), intent(in) :: snap
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
! In  snap             : snapshot selection
! In  resultName       : name of results datastructure
! In  m                : first dimension of snapshot matrix
! In  m                : second dimension of snapshot matrix
! Ptr q                : pointer to [Q] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iSnap, iEqua
    integer :: nbSnap, nbEqua
    integer :: numeSnap, iret
    character(len=8)  :: baseType
    character(len=24) :: fieldName
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
! - Get parameters
!
    nbSnap     = snap%nbSnap
    baseType   = base%baseType
    lineicNume = base%lineicNume
    ASSERT(nbSnap .gt. 0)
!
! - Get mode
!
    mode      = base%mode
    nbEqua    = mode%nbEqua
    fieldName = mode%fieldName
    fieldSupp = mode%fieldSupp
    ASSERT(nbEqua .gt. 0)
!
! - Prepare snapshots matrix
!
    AS_ALLOCATE(vr = q, size = m * n)
!
! - Save the [Q] matrix depend on which type of reduced base
!
    if (baseType .eq. 'LINEIQUE') then
        call dbr_calcpod_ql(lineicNume, &
                            resultName, fieldName, nbEqua,&
                            nbSnap    , snap%listSnap,&
                            q)
    else
        do iSnap = 1, nbSnap
            numeSnap = snap%listSnap(iSnap)
            call rsexch(' '  , resultName, fieldName, numeSnap, resuFieldVale, iret)
            if (iret .ne. 0) then
                call utmess('F','ROM2_11', sk = fieldName, si = numeSnap)
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
