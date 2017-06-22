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

subroutine nmdocv(keywordfact, iocc, algo_inte, keyword, value)
!
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    character(len=16), intent(in) :: algo_inte
    character(len=14), intent(in) :: keyword
    real(kind=8), intent(out) :: value
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get and check special keywords for convergence criterion
!
! --------------------------------------------------------------------------------------------------
!
! In  keywordfact     : factor keyword to read (COMPORTEMENT)
! In  iocc            : factor keyword index in COMPORTEMENT
! In  algo_inte       : integration algorithm
! In  keyword         : keyword
! Out value           : real value of keyword
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iarg, iret, vali, iter_cplan
    real(kind=8) :: inte_rela_anal
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(keyword(1:9).eq.'RESI_INTE'.or.keyword.eq.'ITER_INTE_MAXI')
!
! - Get Values
!
    if (keyword .eq. 'RESI_INTE_RELA') then
        call getvr8(keywordfact, keyword, iocc=iocc, scal=value, nbret=iret,&
                    isdefault=iarg)
    else if (keyword .eq. 'RESI_INTE_MAXI') then
        call getvr8(keywordfact, keyword, iocc=iocc, scal=value, nbret=iret,&
                    isdefault=iarg)
    else if (keyword.eq.'ITER_INTE_MAXI') then
        call getvis(keywordfact, keyword, iocc=iocc, scal=vali, nbret=iret,&
                    isdefault=iarg)
        value      = vali
        iter_cplan = vali
    endif
!
    ASSERT(iret.ne.0)
!
! - Number of iterations for plane stress
!
    inte_rela_anal = -iter_cplan
!
! - Checking
!
    if (iarg .eq. 0) then
        if (algo_inte .eq. 'ANALYTIQUE') then
            call utmess('A', 'COMPOR4_70', sk=keyword)
            value = inte_rela_anal
        endif
    else
        if (algo_inte .eq. 'ANALYTIQUE') then
            if (keyword .eq. 'ITER_INTE_MAXI') then
                value = inte_rela_anal
            endif
        endif
    endif
!
    if (keyword .eq. 'RESI_INTE_RELA') then
        if (value .gt. 1.0001d-6) then
            call utmess('A', 'COMPOR4_62')
        endif
    endif
!
end subroutine
