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

subroutine op0160()
    implicit none
!     OPERATEUR   IMPR_MACR_ELEM
!     ------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/iredmi.h"
#include "asterfort/iredsu.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ulexis.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
    integer :: versio, n1, ific, vali(2)
    character(len=8) :: format, macrel, basemo, k8b
    character(len=16) :: fichie
    integer ::  nbmodt, nbvect
    integer, pointer :: desm(:) => null()
    character(len=24), pointer :: mael_refe(:) => null()
!     ------------------------------------------------------------------
    call infmaj()
!
    ific = 0
    fichie = ' '
!
    call getvid(' ', 'MACR_ELEM_DYNA', scal=macrel, nbret=n1)
!
!     ----- VERIFICATION QUE LA BASE MODALE EST A JOUR -----
!
!     1. RECUPERATION DU NOMBRE DES MODES -----
    call jeveuo(macrel//'.MAEL_REFE', 'L', vk24=mael_refe)
    basemo = mael_refe(1)(1:8)
    call jelira(basemo//'           .ORDR', 'LONMAX', nbmodt, k8b)
!
!     2. RECUPERATION DU NOMBRE DE VECTEURS DE BASE -----
    call jeveuo(macrel//'.DESM', 'L', vi=desm)
    nbvect = desm(4)
!
!     3. VERIFICATION QUE LA BASE MODALE EST A JOUR -----
    if (nbvect .ne. nbmodt) then
        vali(1) = nbvect
        vali(2) = nbmodt
        call utmess('F', 'UTILITAI8_66', ni=2, vali=vali)
    endif
!     ------------------------------------------------------------------
!
    call getvtx(' ', 'FORMAT', scal=format, nbret=n1)
!
    if (format .eq. 'IDEAS') then
!
        call getvis(' ', 'VERSION', scal=versio, nbret=n1)
!
        call getvis(' ', 'UNITE', scal=ific, nbret=n1)
        if (.not. ulexis( ific )) then
            call ulopen(ific, ' ', fichie, 'NEW', 'O')
        endif
!
        call iredsu(macrel, format, ific, versio)
!
!     ------------------------------------------------------------------
    else if (format .eq. 'MISS_3D') then
        call iredmi(macrel)
!
!     ------------------------------------------------------------------
    else
        ASSERT(.false.)
    endif
!
end subroutine
