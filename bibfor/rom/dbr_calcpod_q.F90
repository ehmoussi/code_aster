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
subroutine dbr_calcpod_q(paraPod, base, m, n, q)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/romFieldRead.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_ParaDBR_POD), intent(in) :: paraPod
type(ROM_DS_Empi), intent(in) :: base
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
! In  paraPod          : datastructure for parameters (POD)
! In  base             : base
! In  m                : first dimension of snapshot matrix
! In  m                : second dimension of snapshot matrix
! Ptr q                : pointer to [Q] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iSnap, iEqua
    integer :: nbSnap, nbEqua, nbSlice, nbCmp
    integer :: numeSnap
    integer :: nodeNume, cmpNume, iSlice, i_2d, n_2d
    character(len=8)  :: baseType, resultName
    real(kind=8), pointer :: fieldVale(:) => null()
    character(len=24) :: fieldObject
    character(len=16) :: resultType
    type(ROM_DS_Field) :: field
    type(ROM_DS_LineicNumb) :: lineicNume
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_1')
    endif
!
! - Get parameters for results datastructure
!
    resultName = paraPod%resultDom%resultName
    resultType = paraPod%resultDom%resultType
    ASSERT(resultType .eq. 'EVOL_THER' .or. resultType .eq. 'EVOL_NOLI')
    nbSnap     = paraPod%snap%nbSnap
    ASSERT(nbSnap .gt. 0)
!
! - Get properties of base
!
    baseType    = base%baseType
    lineicNume  = base%lineicNume
    nbSlice     = lineicNume%nbSlice
    nbCmp       = lineicNume%nbCmp
!
! - Get properties of field to read
!
    field       = paraPod%field
    nbEqua      = field%nbEqua
    ASSERT(nbEqua .gt. 0)
!
! - Prepare snapshots matrix
!
    AS_ALLOCATE(vr = q, size = m * n)
!
! - Cosntruct the [Q] matrix from high-fidelity results
!
    do iSnap = 1, nbSnap
        numeSnap = paraPod%snap%listSnap(iSnap)

! ----- Read field from results datastructure
        call romFieldRead('Read'   , field     , fieldObject,&
                          fieldVale, resultName, numeSnap)

! ----- Construct snapshots matrix [Q]
        if (baseType .eq. 'LINEIQUE') then
            ASSERT(nbCmp .gt. 0)
            do iEqua = 1, nbEqua
                nodeNume = (iEqua - 1)/nbCmp + 1
                cmpNume  = iEqua - (nodeNume - 1)*nbCmp
                iSlice   = lineicNume%numeSlice(nodeNume)
                n_2d     = lineicNume%numeSection(nodeNume)
                i_2d     = (n_2d - 1)*nbCmp + cmpNume
                q(i_2d + nbEqua*(iSlice - 1)/nbSlice + nbEqua*(iSnap - 1)) = fieldVale(iEqua)
            enddo
        elseif (baseType .eq. '3D') then
            do iEqua = 1, nbEqua
                q(iEqua + nbEqua*(iSnap - 1)) = fieldVale(iEqua)
            end do
        else
            ASSERT(ASTER_FALSE)
        endif

! ----- Free memory from field
        call romFieldRead('Free', field, fieldObject)
    enddo
!
end subroutine
