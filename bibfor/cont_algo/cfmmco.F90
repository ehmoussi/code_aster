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

subroutine cfmmco(ds_contact, i_zone, coef_type_, action, valr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=*), intent(in) :: coef_type_
    character(len=1), intent(in) :: action
    integer, intent(in) :: i_zone
    real(kind=8), intent(inout) :: valr
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete method - Get or set coefficients
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  coef_type        : type of coefficient (E_N or E_T)
! In  action           : read (L) or write (E) coefficient
! In  i_zone           : index of contact zone
! IO  valr             : coefficeint (to read or write)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ztaco
    character(len=24) :: sdcont_tabcof
    real(kind=8), pointer :: v_sdcont_tabcof(:) => null()
    character(len=24) :: coef_type
    integer :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Get parameters
!
    coef_type    = coef_type_
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
    ASSERT(i_zone .le. nb_cont_zone)
    ASSERT(i_zone .ge. 1)
!
! --- ACCES SD
!
    ztaco = cfmmvd('ZTACO')
    sdcont_tabcof = ds_contact%sdcont_solv(1:14)//'.TABL.COEF'
    call jeveuo(sdcont_tabcof, 'E', vr = v_sdcont_tabcof)
!
    if (action .eq. 'E') then
        if (coef_type .eq. 'E_N') then
            v_sdcont_tabcof(ztaco*(i_zone-1)+1) = valr
        else if (coef_type .eq.'E_T') then
            v_sdcont_tabcof(ztaco*(i_zone-1)+2) = valr
        else
            ASSERT(.false.)
        endif
    else if (action.eq.'L') then
        valr = 0.d0
        if (coef_type .eq. 'E_N') then
            valr = v_sdcont_tabcof(ztaco*(i_zone-1)+1)
        else if (coef_type .eq.'E_T') then
            valr = v_sdcont_tabcof(ztaco*(i_zone-1)+2)
        else
            ASSERT(.false.)
        endif
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
