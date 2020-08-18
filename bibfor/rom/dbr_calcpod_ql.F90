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
subroutine dbr_calcpod_ql(lineicNume, &
                          resultName, modeSymbName, nbEqua,&
                          nbSnap    , listSnap    ,&
                          q)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rsexch.h"
#include "asterfort/jelibe.h"
#include "asterfort/jeveuo.h"
!
type(ROM_DS_LineicNumb) , intent(in):: lineicNume
character(len=8), intent(in) :: resultName
character(len=24), intent(in) :: modeSymbName
integer, intent(in) :: nbEqua, nbSnap
integer, pointer :: listSnap(:)
real(kind=8), intent(inout) :: q(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute
!
! Create snapshots matrix [Q] for lineic model
!
! --------------------------------------------------------------------------------------------------
!
! In  lineicNume       : lineic numbering
! In  resultName       : results datastructure for selection (EVOL_*)
! In  modeSymbName     : name of field where empiric modes have been constructed (NOM_CHAM)
! In  nbEqua           : number of equations (length of mode)
! In  nbSnap           : number of snapshots used to construct base
! Ptr listSnap         : pointer to snap selected to construct base
! IO  q                : pointer to [Q] matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iSnap, iEqua, nodeNume, cmpNume, iSlice, i_2d
    integer :: nbSlice, n_2d, nbCmp
    integer :: numeSnap, iret
    real(kind=8), pointer :: resuFieldVale(:) => null()
    character(len=24) :: resultField
!
! --------------------------------------------------------------------------------------------------
!
    nbSlice     = lineicNume%nbSlice
    nbCmp       = lineicNume%nbCmp
    ASSERT(nbSnap .gt. 0)
    ASSERT(nbEqua .gt. 0)
    ASSERT(nbCmp .gt. 0)
!
    do iSnap = 1, nbSnap
        numeSnap = listSnap(iSnap)
        call rsexch(' '  , resultName, modeSymbName, numeSnap, resultField, iret)
        ASSERT(iret .eq. 0)
        call jeveuo(resultField(1:19)//'.VALE', 'L', vr = resuFieldVale)
        do iEqua = 1, nbEqua
            nodeNume = (iEqua - 1)/nbCmp + 1
            cmpNume  = iEqua - (nodeNume - 1)*nbCmp
            iSlice   = lineicNume%numeSlice(nodeNume)
            n_2d   = lineicNume%numeSection(nodeNume)
            i_2d   = (n_2d - 1)*nbCmp + cmpNume
            q(i_2d + nbEqua*(iSlice - 1)/nbSlice + nbEqua*(iSnap - 1)) = resuFieldVale(iEqua)
        enddo
        call jelibe(resultField(1:19)//'.VALE')
    enddo
!
end subroutine
