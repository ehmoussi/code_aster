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

subroutine excart(imodat, iparg)

use calcul_module, only : ca_iachii_, ca_iachlo_, ca_iamloc_, ca_iawlo2_,&
    ca_iel_, ca_igr_, ca_iichin_, ca_ilchlo_,&
    ca_ilmloc_, ca_nbelgr_, ca_nbgr_, ca_typegd_, ca_paral_, ca_lparal_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/excar2.h"
#include "asterfort/jacopo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"

    integer :: imodat, iparg
!----------------------------------------------------------------------
!     entrees:
!       imodat : indice dans la collection modeloc
!----------------------------------------------------------------------
    integer :: desc, modloc, dec1, dec2, lgcata
    integer :: ipt, ityplo
    integer :: nbpoin, ncmp, ngrmx, debugr
!-------------------------------------------------------------------

!   recuperation de la carte:
!   -------------------------
    desc=zi(ca_iachii_-1+11*(ca_iichin_-1)+4)
    ngrmx=zi(desc-1+2)
    modloc=ca_iamloc_-1+zi(ca_ilmloc_-1+imodat)
    ityplo=zi(modloc-1+1)
    nbpoin=zi(modloc-1+4)
    lgcata=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+2)
    debugr=zi(ca_iawlo2_-1+5*(ca_nbgr_*(iparg-1)+ca_igr_-1)+5)


!   1-  cas: cart -> elno (ou elga) : "expand"
!   -------------------------------------------
    if ((ityplo.eq.2) .or. (ityplo.eq.3)) then
        ASSERT((ityplo.ne.2) .or. (nbpoin.le.10000))
        ncmp=lgcata/nbpoin
        call excar2(ngrmx, desc, zi(modloc-1+5), ncmp, debugr)
!       on dupplique les valeurs en commencant par la fin pour ne pas
!       les ecraser :
        do ca_iel_ = ca_nbelgr_, 1, -1
            if (ca_lparal_) then
                if (.not.ca_paral_(ca_iel_)) cycle
            endif
            do ipt = nbpoin, 1, -1
                dec1=debugr-1+(ca_iel_-1)*ncmp
                dec2=debugr-1+(ca_iel_-1)*ncmp*nbpoin+ncmp*(ipt-1)
                call jacopo(ncmp, ca_typegd_, ca_iachlo_+dec1, ca_iachlo_+dec2)
                call jacopo(ncmp, 'L', ca_ilchlo_+dec1, ca_ilchlo_+dec2)
            enddo
        enddo


!   2-  cas: cart -> elem :
!   -----------------------
    else if (ityplo.eq.1) then
        ASSERT(nbpoin.eq.1)
        ncmp=lgcata
        call excar2(ngrmx, desc, zi(modloc-1+5), ncmp, debugr)

    else
        ASSERT(.false.)
    endif

end subroutine
