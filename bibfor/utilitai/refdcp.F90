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

subroutine refdcp(resin, resout)
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedup1.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
!
    character(len=8) :: resin, resout
! person_in_charge: hassan.berro at edf.fr
! ----------------------------------------------------------------------
!
!   COPIER LE CONTENU DE REFERENCES DYNAMIQUE DE resin DANS resout
!
    integer :: ir1, ir2
    character(len=16) :: refd, indi
    character(len=1) :: jvb
!
    call jemarq()
!
    refd = '           .REFD'
    indi = '           .INDI'
    jvb = 'G'
!
    if (resin .ne. resout) then
        call jeexin(resin //refd, ir1)
        call jeexin(resout//refd, ir2)
!
        if (ir1 .gt. 0 .and. ir2 .gt. 0) then
            call jedetr(resout//refd)
            call jedetr(resout//indi)
        endif
!
        if (ir1 .gt. 0) then
            if (resout(1:2) .eq. '&&') jvb = 'V'
            call jedup1(resin//refd, jvb, resout//refd)
            call jedup1(resin//indi, jvb, resout//indi)
        endif
!
!       For debugging purposes only...
!       call utimsd(8, 1, .false._1, .true._1, resout//refd,1, 'G')
!       call utimsd(8, 1, .false._1, .true._1, resout//indi,1, 'G')
    endif
!
    call jedema()
end subroutine
