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

subroutine rc32sn(ze200, lieu, iocc1, iocc2, ns, sn, instsn, snet,&
                  sigmoypres, snther, sp3, spmeca3)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/getvtx.h"
#include "asterfort/rc32sna.h"
#include "asterfort/rc32snb.h"

    character(len=4) :: lieu
    integer :: iocc1, iocc2, ns
    real(kind=8) :: sn, instsn(4), snet, sigmoypres, snther, sp3, spmeca3
    aster_logical :: ze200
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_ZE200
!     CALCUL DU SN
!
!     ------------------------------------------------------------------
! IN  : LIEU   : ='ORIG' : ORIGINE DU SEGEMNT, ='EXTR' : EXTREMITE
! OUT : SN     : PARTIE B3200 du SN
!
    integer :: n1
    character(len=8) :: methode

!
! DEB ------------------------------------------------------------------
    call jemarq()
!
!
    call getvtx(' ', 'METHODE', scal=methode, nbret=n1)
    if (methode .eq. 'TRESCA') then
        call rc32sna(ze200, lieu, iocc1, iocc2, ns, sn, instsn, snet,&
                     sigmoypres, snther, sp3, spmeca3)
    else
        call rc32snb(ze200, lieu, iocc1, iocc2, ns, sn, instsn, snet,&
                     sigmoypres, snther, sp3, spmeca3)
    endif
!
    call jedema()
!
end subroutine
