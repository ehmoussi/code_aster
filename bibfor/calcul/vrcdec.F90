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

subroutine vrcdec()

use calcul_module, only : ca_decala_, ca_iredec_, ca_jfpgl_, ca_jnolfp_,&
     ca_jpnlfp_, ca_km_, ca_kp_, ca_kr_,&
     ca_nblfpg_, ca_nfpg_, ca_nomte_, ca_nfpgmx_

implicit none
! person_in_charge: jacques.pellet at edf.fr
!-----------------------------------------------------------------------
! But: calculer le decalage des differentes familles de PG utilisees
!      dans la famille "liste" mater.
!      ceci permet de gagner du temps dans rcvarc
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/indk32.h"
#include "asterfort/jelira.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"

    integer ::  kfpgl, kpgmat, nbpg
    integer :: nuflpg, nufgpg, k
    character(len=8) :: fapg, elrefe
    character(len=32) :: noflpg
    integer, pointer :: tmfpg(:) => null()
! ---------------------------------------------------------------
    ca_iredec_=0
    call jenonu(jexnom('&CATA.TE.NOFPG_LISTE', ca_nomte_//'MATER'), kfpgl)
    if (kfpgl .eq. 0) then
        ca_nfpg_=0
        ca_jfpgl_=0
        goto 999
    endif

    call jeveuo('&CATA.TM.TMFPG', 'L', vi=tmfpg)
    call jeveuo(jexnum('&CATA.TE.FPG_LISTE', kfpgl), 'L', ca_jfpgl_)
    call jelira(jexnum('&CATA.TE.FPG_LISTE', kfpgl), 'LONMAX', ca_nfpg_)
    ca_nfpg_=ca_nfpg_-1
    ASSERT(ca_nfpg_.le.ca_nfpgmx_)
    kpgmat=0
    elrefe= zk8(ca_jfpgl_-1+ca_nfpg_+1)

    do k=1,ca_nfpg_
        ca_decala_(k)=kpgmat
        fapg=zk8(ca_jfpgl_-1+k)
        noflpg = ca_nomte_//elrefe//fapg
        nuflpg = indk32(zk32(ca_jpnlfp_),noflpg,1,ca_nblfpg_)
!       -- on s'assure que la famille nomte//elrefe//fapg a
!          bien ete trouvee dans l'objet '&CATA.TE.PNLOCFPG'
        ASSERT(nuflpg.gt.0)

        nufgpg = zi(ca_jnolfp_-1+nuflpg)
        ASSERT(nufgpg.gt.0)
        nbpg=tmfpg(nufgpg)
        kpgmat=kpgmat+nbpg
    enddo

!   -- remise a zero de km,kp,kr pour que rcvarc n'utilise pas le
!      resultat d'un tecach inapproprie
    ca_km_=0
    ca_kp_=0
    ca_kr_=0


999 continue
end subroutine
