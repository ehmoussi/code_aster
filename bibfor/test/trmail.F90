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

subroutine trmail(ific, nocc)
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvid.h"
#include "asterfort/tresu_tole.h"
#include "asterfort/tresu_read_refe.h"
#include "asterfort/tresu_mail.h"
#include "asterfort/utmess.h"
    integer, intent(in) :: ific
    integer, intent(in) :: nocc
!     COMMANDE:  TEST_RESU
!                MOT CLE FACTEUR "MAILLAGE"
! ----------------------------------------------------------------------
    integer :: iocc, refi, refir, n1, n2, n2r, iret
    real(kind=8) :: epsi, epsir
    character(len=3) :: ssigne
    character(len=8) :: crit
    character(len=16) :: tbtxt(2), tbref(2)
    character(len=8) :: nommai
    aster_logical :: lref
!     ------------------------------------------------------------------
!
    do 100 iocc = 1, nocc
        call getvid('MAILLAGE', 'MAILLAGE', iocc=iocc, scal=nommai, nbret=n1)
        call getvtx('MAILLAGE', 'VALE_ABS', iocc=iocc, scal=ssigne, nbret=n1)
        call tresu_tole(epsi, mcf='MAILLAGE', iocc=iocc)
        call getvtx('MAILLAGE', 'CRITERE', iocc=iocc, scal=crit, nbret=n1)
!
        call tresu_read_refe('MAILLAGE', iocc, tbtxt)
        lref=.false.
        call getvr8('MAILLAGE', 'PRECISION', iocc=iocc, scal=epsir, nbret=iret)
        if (iret .ne. 0) then
            lref=.true.
            tbref(1)=tbtxt(1)
            tbref(2)=tbtxt(2)
            tbtxt(1)='NON_REGRESSION'
        endif
!
        write (ific,*) '---- MAILLAGE '
        write (ific,*) '     ',nommai
!
        call getvis('MAILLAGE', 'VALE_CALC_I', iocc=iocc, scal=refi, nbret=n2)
        if (n2 .eq. 1) then
            call tresu_mail(nommai, tbtxt, refi, iocc,&
                           epsi, crit, .true._1, ssigne)
            if (lref) then
                call getvis('MAILLAGE', 'VALE_REFE_I', iocc=iocc, scal=refir, nbret=n2r)
                ASSERT(n2.eq.n2r)
                call tresu_mail(nommai, tbref, refir, iocc,&
                               epsir, crit, .false._1, ssigne)
            endif
        endif
        write (ific,*)' '
100 end do
!
!
end subroutine
