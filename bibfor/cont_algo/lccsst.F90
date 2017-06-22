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

subroutine lccsst(ds_contact, vect_asse_cont)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnum.h" 
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/assert.h"
!
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=19), intent(in) :: vect_asse_cont
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC method - Modification of second member for non-paired elements
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  vect_asse_cont   : second member for contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nt_patch, i_patch, indi_cont, nume_equa
    integer :: jv_vect_vale
    real(kind=8) :: lagc
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdcont_ddlc
    integer, pointer :: v_sdcont_ddlc(:) => null()
    character(len=24) :: sdcont_lagc
    real(kind=8), pointer :: v_sdcont_lagc(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Get parameters
!
    nt_patch = ds_contact%nt_patch
!
! - Acces to contact objects
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    sdcont_ddlc = ds_contact%sdcont_solv(1:14)//'.DDLC'
    sdcont_lagc = ds_contact%sdcont_solv(1:14)//'.LAGC'
    call jeveuo(sdcont_stat, 'L', vi = v_sdcont_stat)
    call jeveuo(sdcont_ddlc, 'L', vi = v_sdcont_ddlc)
    call jeveuo(sdcont_lagc, 'E', vr = v_sdcont_lagc)
!
! - Acces to vector
!
    call jeveuo(vect_asse_cont(1:19)//'.VALE', 'E', jv_vect_vale)
!
! - Loop on patches
!
    do i_patch = 1, nt_patch
        indi_cont = v_sdcont_stat(i_patch)
        nume_equa = v_sdcont_ddlc(i_patch)
        lagc      = v_sdcont_lagc(i_patch)
        if (indi_cont .eq. -1) then
            zr(jv_vect_vale-1+nume_equa) = lagc
        end if
    end do
!
    call jedema()
end subroutine
