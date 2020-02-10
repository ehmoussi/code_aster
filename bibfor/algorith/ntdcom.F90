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
!
subroutine ntdcom(result_dry, l_dry)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(out) :: result_dry
aster_logical, intent(out) :: l_dry
!
! --------------------------------------------------------------------------------------------------
!
! Thermics - Init
!
! Read parameters for drying
!
! --------------------------------------------------------------------------------------------------
!
! Out result_dry       : name of datastructure for results (drying)
! Out l_dry            : .true. if drying (concrete)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbocc, iocc, n1, nbcham
    character(len=16) :: comp_rela, tysd
    aster_logical :: lrela
    character(len=16), parameter :: keywfact = 'COMPORTEMENT'
!
! --------------------------------------------------------------------------------------------------
!
    result_dry = ' '
    l_dry      = ASTER_FALSE
!
! - Look for behaviour
!
    call getfac(keywfact, nbocc)
    lrela = ASTER_FALSE
    do iocc = 1, nbocc
        call getvtx(keywfact, 'RELATION', iocc=iocc, scal=comp_rela, nbret=n1)
        if (comp_rela(1:10) .eq. 'SECH_NAPPE') then
            l_dry = ASTER_TRUE
        endif
        if (comp_rela(1:12) .eq. 'SECH_GRANGER') then
            l_dry = ASTER_TRUE
        endif
        if (comp_rela(1:5) .ne. 'SECH_') then
            lrela = ASTER_TRUE
        endif
    end do
!
    if (l_dry .and. lrela) then
        call utmess('F', 'THERNONLINE4_96')
    endif
!
    if (l_dry) then
        call getvid(' ', 'EVOL_THER_SECH', nbval=0, nbret=n1)
        if (n1 .eq. 0) then
            call utmess('F', 'THERNONLINE4_97')
        else
            call getvid(' ', 'EVOL_THER_SECH', scal=result_dry, nbret=n1)
            call gettco(result_dry, tysd)
            if (tysd(1:9) .ne. 'EVOL_THER') then
                call utmess('F', 'THERNONLINE4_98', sk=result_dry)
            else
                call dismoi('NB_CHAMP_UTI', result_dry, 'RESULTAT', repi=nbcham)
                if (nbcham .le. 0) then
                    call utmess('F', 'THERNONLINE4_99', sk=result_dry)
                endif
            endif
        endif
    endif
!
end subroutine
