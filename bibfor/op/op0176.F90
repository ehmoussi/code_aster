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
subroutine op0176()
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/dyarc0.h"
#include "asterfort/extrs1.h"
#include "asterfort/extrs2.h"
#include "asterfort/getvid.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/irpara.h"
#include "asterfort/iunifi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/refdcp.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsinfo.h"
#include "asterfort/rsnopa.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
! --------------------------------------------------------------------------------------------------
!
!   EXTR_RESU
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: nompro
    parameter ( nompro = 'OP0176' )
    integer :: ibid, storeNb, nbexcl, jexcl, nbarch
    integer :: nbac, nbpa, iret, nbnosy, paraNb, nbrest
    integer :: mesgUnit, ifm, niv
    character(len=8) :: noma, nomo, nocara, nochmat
    character(len=16) :: typcon, nomcmd
    character(len=19) :: resultOutName, resultInName
    character(len=24) :: lisarc, lichex, paraJvName
    aster_logical :: lrest
    integer :: nmail, nmode, ncara, nchmat
    integer, pointer :: storeIndx(:) => null()
    integer, pointer :: archi(:) => null()
    character(len=16), pointer :: paraName(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
! - Initializations
!
    noma=' '
    nomo=' '
    nocara=' '
    nochmat=' '
    mesgUnit   = iunifi('MESSAGE')
    lisarc     = '&&'//nompro//'.LISTE.ARCH'
    lichex     = '&&'//nompro//'.LISTE.CHAM'
    paraJvName = '&&'//nompro//'.NOMS_PARA '
!
    call getres(resultOutName, typcon, nomcmd)
!
    call getvid(' ', 'RESULTAT', scal=resultInName, nbret=ibid)
!
!     --- CHAMPS ---
!
    call jelira(resultInName//'.DESC', 'NOMMAX', nbnosy)
    if (nbnosy .eq. 0) goto 999
!
! - Get list of storing index
!
    call rs_get_liststore(resultInName, storeNb)
    ASSERT(storeNb .gt. 0)
    AS_ALLOCATE(vi = storeIndx, size = storeNb)
    call rs_get_liststore(resultInName, storeNb, storeIndx)
!
! - Get list of parameters from input result
!
    call rsnopa(resultInName, 2, paraJvName, nbac, nbpa)
    paraNb = nbac + nbpa
    call jeveuo(paraJvName, 'L', vk16 = paraName)
!
!     --- CHAMPS EXCLUS ET PAS D'ARCHIVAGE ---
!
    call dyarc0(resultInName, nbnosy, nbarch, lisarc, nbexcl, lichex)
!
!     --- MOT-CLE RESTREINT
    call getfac('RESTREINT', nbrest)
    lrest = .false.
    if (nbrest .gt. 0) then
        lrest = .true.
        call getvid('RESTREINT', 'MAILLAGE', iocc=1, scal=noma, nbret=nmail)
        call getvid('RESTREINT', 'MODELE', iocc=1, scal=nomo, nbret=nmode)
        call getvid('RESTREINT', 'CARA_ELEM', iocc=1, scal=nocara, nbret=ncara)
        call getvid('RESTREINT', 'CHAM_MATER', iocc=1, scal=nochmat, nbret=nchmat)
    endif
    if ((nbarch.eq.0) .and. (nbrest.eq.0)) then
        goto 999
    else if ((nbarch.eq.0)) then
        archi => storeIndx
        nbarch = storeNb
    else
        call jeveuo(lisarc, 'L', vi = archi)
    endif
    call jeveuo(lichex, 'L', jexcl)
!
!     --- ALLOCATION DE LA STRUCTURE SORTIE SI ELLE N'EXISTE PAS ---
!
    call jeexin(resultOutName//'.DESC', iret)
    if (iret .eq. 0) then
        call rscrsd('G', resultOutName, typcon, nbarch)
    endif
!
    if (resultInName .eq. resultOutName) then
        if (lrest)  call utmess('F', 'PREPOST2_5')
        call extrs1(resultInName, storeNb, storeIndx, paraNb, paraName,&
                    nbarch, archi, nbexcl, zk16(jexcl), nbnosy)
    else
        call extrs2(resultInName, resultOutName, typcon, lrest, noma,&
                    nomo, nocara, nochmat, storeNb, storeIndx, paraNb, paraName,&
                    nbarch, archi, nbexcl, zk16(jexcl), nbnosy)
    endif
    AS_DEALLOCATE(vi = storeIndx)
!
    call titre()
!
! - Print informations about results
!
    call rsinfo(resultOutName, mesgUnit)
    if (niv .gt. 1) then
! ----- Get list of storing index
        call rs_get_liststore(resultOutName, storeNb)
        ASSERT(storeNb .gt. 0)
        AS_ALLOCATE(vi = storeIndx, size = storeNb)
        call rs_get_liststore(resultOutName, storeNb, storeIndx)
! ----- Print list of parameters
        call irpara(resultOutName, mesgUnit    ,&
                    storeNb      , storeIndx   ,&
                    paraNb       , paraName,&
                    'T')
        AS_DEALLOCATE(vi = storeIndx)
    endif
!
999 continue
!
!
!
!     -- CREATION DE L'OBJET .REFD SI NECESSAIRE:
!     -------------------------------------------
    call refdcp(resultInName, resultOutName)
!
!
    call jedema()
!
end subroutine
