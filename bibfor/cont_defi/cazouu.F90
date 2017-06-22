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

subroutine cazouu(keywf, nb_cont_zone, keyw_,keyw_type_)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getmjm.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: nb_cont_zone
    character(len=*), intent(in) :: keyw_
    character(len=*), intent(in) :: keyw_type_
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Check if keyword is the same for all contact zones
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : factor keyword to read
! In  nb_cont_zone     : number of zones of contact
! In  keyw             : keyword
!
! --------------------------------------------------------------------------------------------------
!
    
!
    character(len=16) :: keyw
    aster_logical :: l_error
    integer :: i_zone, noc
    real(kind=8) :: vale_r
    integer :: vale_i
    character(len=16) :: vale_k
    real(kind=8) :: vale_refe_r
    integer :: vale_refe_i
    character(len=16) :: vale_refe_k
    character(len=1) :: keyw_type
!
! --------------------------------------------------------------------------------------------------
!
    l_error = .false.
    i_zone  = 1
    keyw    = keyw_
    keyw_type=keyw_type_

!
! ----- Loop on contact zones
!

        do i_zone = 1, nb_cont_zone
!
! ----------------- Read value (depends on type)
!

                    vale_i         = 0
                    vale_r         = 0.d0
                    vale_k         = ' '
                    write (6,*)  keyw_type
                    if (keyw_type .eq. 'I') then
                        call getvis(keywf, keyw, iocc=i_zone, scal=vale_i, nbret=noc)
                    else if (keyw_type .eq.'T') then
                        call getvtx(keywf, keyw, iocc=i_zone, scal=vale_k, nbret=noc)
                    else if (keyw_type .eq.'R') then
                        call getvr8(keywf, keyw, iocc=i_zone, scal=vale_r, nbret=noc)
                    else
                        ASSERT(.false.)
                    endif
                    
                    if (noc .ne. 0) then
                     
                    
                        if (i_zone .eq. 1) then
                            vale_refe_i = vale_i
                            vale_refe_r = vale_r
                            vale_refe_k = vale_k
                        else
                            if (keyw_type .eq. 'I') then
                                if (vale_i .ne. vale_refe_i) then
                                    l_error = .true.
                                    goto 99
                                endif
                            else if (keyw_type.eq.'R') then
                                if (abs(vale_r - vale_refe_r).le.r8prem()) then
                                    l_error = .true.
                                    goto 99
                                endif
                            else if (keyw_type.eq.'T') then
                                if (vale_k .ne. vale_refe_k) then
                                    l_error = .true.
                                    goto 99
                                endif
                            else
                                ASSERT(.false.)
                            endif
                        endif
                    endif
        end do
!
 99 continue
!
    if (l_error) then
        call utmess('F', 'CONTACT3_4', sk=keyw)
    endif
!
end subroutine
