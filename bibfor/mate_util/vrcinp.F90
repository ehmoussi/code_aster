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

subroutine vrcinp(ind, instam, instap)
!
use calcul_module, only : ca_iactif_, ca_jvcnom_, ca_nbcvrc_ , ca_jvcfon_, ca_jvcval_
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/fointe.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveut.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: ind
    real(kind=8), intent(in) :: instam
    real(kind=8), intent(in) :: instap
!
! --------------------------------------------------------------------------------------------------
!
! Material - External state variables (VARC)
!
! Preparation (for calcul_module) - SIMU_POINT_MAT
!
! --------------------------------------------------------------------------------------------------
!
! In  ind              : what to do
!                         0 => ca_iactif_=0 (end)
!                         1 => ca_iactif_=2 initializations (begin)
!                         2 => interpolation
! In  instam           : time at beginning of step time
! In  instap           : time at end of step time
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbocc, ier, n1, iocc
    character(len=16), parameter :: keywf = 'AFFE_VARC'
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    if (ind .eq. 1) then
!
        ca_iactif_ = 2
        call getfac(keywf, nbocc)
        ca_nbcvrc_ = nbocc
        ASSERT(ca_nbcvrc_.le.100)

        if (ca_nbcvrc_ .ne. 0) then
! --------- Create objects
            call wkvect('&&OP0033.TVCNOM', 'V V K8', ca_nbcvrc_, ca_jvcnom_)
            call wkvect('&&OP0033.TVCFON', 'V V K8', ca_nbcvrc_, ca_jvcfon_)
            call wkvect('&&OP0033.TVCVAL', 'V V R', 3*ca_nbcvrc_, ca_jvcval_)

! --------- Get address of objects
            call jeveut('&&OP0033.TVCNOM', 'E', ca_jvcnom_)
            call jeveut('&&OP0033.TVCFON', 'E', ca_jvcfon_)
            call jeveut('&&OP0033.TVCVAL', 'E', ca_jvcval_)

! --------- Fill objects
            do iocc = 1, nbocc
                call getvtx(keywf, 'NOM_VARC' , iocc=iocc, scal=zk8(ca_jvcnom_-1+iocc),&
                            nbret=n1)
                call getvid(keywf, 'VALE_FONC', iocc=iocc, scal=zk8(ca_jvcfon_-1+iocc),&
                            nbret=n1)
                call getvr8(keywf, 'VALE_REF' , iocc=iocc, scal=zr(ca_jvcval_-1+3*(iocc-1)+3),&
                            nbret=n1)
            end do
        endif

    else if (ind.eq.0) then
        ca_iactif_=0

    else if (ind.eq.2) then
        ca_iactif_=2
        do iocc = 1, ca_nbcvrc_
            call fointe('F', zk8(ca_jvcfon_-1+iocc), 1, ['INST'], [instam],&
                        zr( ca_jvcval_-1+3*(iocc-1)+1), ier)
            call fointe('F', zk8(ca_jvcfon_-1+iocc), 1, ['INST'], [instap],&
                        zr( ca_jvcval_-1+3*(iocc-1)+2), ier)
        end do
    endif
!
    call jedema()
end subroutine
