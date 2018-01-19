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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine selectListRead(keywfactz, iocc, selectList)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/as_allocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/getvis.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
#include "asterfort/nmcrpm.h"
!
character(len=*), intent(in) :: keywfactz
integer, intent(in) :: iocc
type(NL_DS_SelectList), intent(out) :: selectList
!
! --------------------------------------------------------------------------------------------------
!
! Select list management
!
! Read parameters for select list management
!
! --------------------------------------------------------------------------------------------------
!
! In  keywfact         : factor keyword to read parameters
! In  iocc             : index of factor keyword
! Out selectList       : datastructure for select list
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywfact
    character(len=8) :: criterion = 'RELATIF'
    real(kind=8) :: precision = 0.d0 , prec_default = 1.d-6, incr_mini = 0.d0
    integer :: n1, n2, n3, iret
    integer :: nb_value = 0, freq_step = 0
    aster_logical :: l_abso = ASTER_FALSE
    character(len=19) :: list
    real(kind=8), pointer :: v_vale(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    keywfact     = keywfactz
!
! - Get parameters to select real value
!
    call getvr8(keywfact, 'PRECISION', iocc=iocc, scal=precision, nbret=n1)
    call getvtx(keywfact, 'CRITERE'  , iocc=iocc, scal=criterion, nbret=n2)
    if (criterion .eq. 'ABSOLU') then
        if (n1 .eq. 0) then
            call utmess('F', 'LISTINST_1')
        endif
        l_abso = ASTER_TRUE
    else if (criterion .eq. 'RELATIF') then
        if (n1 .eq. 0) then
            precision = prec_default
            call utmess('A', 'LISTINST_2', sr=prec_default)
        endif
        l_abso = ASTER_FALSE
    else
        ASSERT(ASTER_FALSE)
    endif
    if (precision .le. r8prem()) then
        call utmess('F', 'LISTINST_3')
    endif
!
! - Get parameters to get list of values
!
    call getvid(keywfact, 'LIST_INST', iocc=iocc, scal=list, nbret=n2)
    call getvr8(keywfact, 'INST'     , iocc=iocc, nbval=0, nbret=n3)
    n3 = -n3
    if ((n2.ge.1) .and. (n3.ge.1)) then
        ASSERT(ASTER_FALSE)
    endif
    if (n3 .ge. 1) then
        nb_value = n3
    else if (n2 .ge. 1) then
        call jelira(list//'.VALE', 'LONMAX', ival=nb_value)
    else
        nb_value = 0
    endif
!
! - Get list
!
    if (nb_value .ne. 0) then
        AS_ALLOCATE(vr = selectList%list_value, size = nb_value)
        if (n3 .ge. 1) then
            call getvr8(keywfact, 'INST', iocc=iocc, nbval=nb_value, vect=selectList%list_value,&
                        nbret=iret)
        else
            call jeveuo(list//'.VALE', 'L', vr = v_vale)
            selectList%list_value(1:nb_value) = v_vale(1:nb_value)
        endif
        call nmcrpm(selectList%list_value, nb_value, incr_mini)
    endif
!
! - Read frequency
!
    n1 = 0
    if (nb_value .eq. 0) then
        call getvis(keywfact, 'PAS_CALC', iocc=iocc, scal=freq_step, nbret=n1)
        if (n1 .ne. 0) then
            ASSERT(freq_step .ge. 0)
        endif
    endif
    if (n1+nb_value .eq. 0) then
        freq_step = 1
    endif
!
! - Save values
!
    selectList%nb_value   = nb_value
    selectList%precision  = precision
    selectList%l_abso     = l_abso
    selectList%incr_mini  = incr_mini
    selectList%freq_step  = freq_step
    selectList%l_by_freq  = freq_step .gt. 0
!
end subroutine
