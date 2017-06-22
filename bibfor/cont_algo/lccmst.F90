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

subroutine lccmst(ds_contact, matr_asse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h" 
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mtdsc2.h"
#include "asterfort/assert.h"
!
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=19), intent(in) :: matr_asse
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC method - Modification of matrix for non-paired elements
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  matr_asse        : matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nt_patch
    integer :: i_patch, indi_cont, nume_equa
    integer :: jv_matr_sxdi, jv_matr_valm
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdcont_ddlc
    integer, pointer :: v_sdcont_ddlc(:) => null()
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
    call jeveuo(sdcont_stat, 'L', vi = v_sdcont_stat)
    call jeveuo(sdcont_ddlc, 'L', vi = v_sdcont_ddlc)
!
! - Acces to matrix
!
    call mtdsc2(matr_asse, 'SXDI', 'L', jv_matr_sxdi)
    call jeveuo(jexnum(matr_asse//'.VALM', 1), 'E', jv_matr_valm)
!
! - Loop on patches
!
    do i_patch = 1, nt_patch
        indi_cont = v_sdcont_stat(i_patch)
        nume_equa = v_sdcont_ddlc(i_patch)
        if (indi_cont .eq. -1) then
            zr(jv_matr_valm-1+zi(jv_matr_sxdi-1+nume_equa)) = 1.d0
        end if
    end do
!
    call jedema()
end subroutine 
