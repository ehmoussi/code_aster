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

subroutine tresu_read_refe(mclfac, iocc, tbref)
    implicit none
    character(len=*), intent(in) :: mclfac
    integer, intent(in) :: iocc
    character(len=16), intent(out) :: tbref(2)
!
! utilisé par TEST_RESU, TEST_TABLE
!
! in  : mclfac : mot cle facteur
! in  : iocc   : numero d'occurrence
! out : tbref  : (1) = reference
!                (2) = legende
!
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lxnoac.h"
!
    integer :: n0, n2
    character(len=16) :: legend, refer
!
    call jemarq()
!
    call getvtx(mclfac, 'LEGENDE', iocc=iocc, nbval=0, nbret=n0)
    call getvtx(mclfac, 'REFERENCE', iocc=iocc, nbval=0, nbret=n2)
!
    legend='XXXX'
    if (n0 .lt. 0) then
        call getvtx(mclfac, 'LEGENDE', iocc=iocc, scal=legend, nbret=n0)
        call lxnoac(legend, legend)
    endif
!
    refer='NON_REGRESSION'
    if (n2 .lt. 0) then
        call getvtx(mclfac, 'REFERENCE', iocc=iocc, scal=refer, nbret=n2)
    endif
!
    tbref(1)=refer
    tbref(2)=legend
!
    call jedema()
!
end subroutine
