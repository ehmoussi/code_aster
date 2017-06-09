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

subroutine op0155()
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
!     COMMANDE :  POST_CHAMP
! ----------------------------------------------------------------------
    implicit none
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedup1.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/refdcp.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsnopa.h"
#include "asterfort/rsutnu.h"
#include "asterfort/w155ce.h"
#include "asterfort/w155ex.h"
#include "asterfort/w155mx.h"
    integer :: ifm, niv, n0, iret, jordr, nbordr, ie, nuordr
    integer :: i, j, jnompa, iadin, iadou, nbac, nbpa, nbpara
    character(len=16) :: crit, typesd, k16b, nopara
    character(len=8) :: resu, nomres
    character(len=3) :: type
    character(len=19) :: resu19, nomr19
    real(kind=8) :: prec
    character(len=24) :: nompar
!     ------------------------------------------------------------------
!
    call jemarq()
!
!
    call infmaj()
    call infniv(ifm, niv)
!
    call getres(nomres, typesd, k16b)
    call getvid(' ', 'RESULTAT', scal=resu, nbret=n0)
    resu19=resu
!
!     -- SELECTION DES NUMERO D'ORDRE :
!     ---------------------------------
    prec=-1.d0
    crit=' '
    call getvr8(' ', 'PRECISION', scal=prec, nbret=ie)
    call getvtx(' ', 'CRITERE', scal=crit, nbret=ie)
    call rsutnu(resu19, ' ', 0, '&&OP0155.NUME_ORDRE', nbordr,&
                prec, crit, iret)
    ASSERT(iret.eq.0)
    ASSERT(nbordr.gt.0)
    call jeveuo('&&OP0155.NUME_ORDRE', 'L', jordr)
!
!
!     -- 1. ON CREE LA SD_RESULTAT NOMRES :
!     ---------------------------------------------
    call rscrsd('G', nomres, typesd, nbordr)
!
!
!     -- 2. MOTS CLES EXTR_XXXX :
!     ----------------------------
    call w155ex(nomres, resu, nbordr, zi(jordr))
!
!
!     -- 3. MOT CLE MIN_MAX_SP :
!     ----------------------------
    call w155mx(nomres, resu, nbordr, zi(jordr))
!
!
!     -- 4. MOT CLE COQU_EXCENT :
!     ----------------------------
    call w155ce(nomres, resu, nbordr, zi(jordr))
!
!
!     -- 5. RECOPIE DES PARAMETRES DE RESU VERS NOMRES :
!     --------------------------------------------------
    nompar='&&OP0155'//'.NOMS_PARA'
    call rsnopa(resu, 2, nompar, nbac, nbpa)
    nbpara=nbac+nbpa
    call jeveuo(nompar, 'L', jnompa)
    nomr19 = nomres
    call jeveuo(nomr19//'.ORDR', 'L', jordr)
    call jelira(nomr19//'.ORDR', 'LONUTI', nbordr)
!
    do 20 i = 1, nbordr
        nuordr=zi(jordr-1+i)
        do 10 j = 1, nbpara
            nopara=zk16(jnompa-1+j)
            call rsadpa(resu, 'L', 1, nopara, nuordr,&
                        1, sjv=iadin, styp=type, istop=0)
            call rsadpa(nomres, 'E', 1, nopara, nuordr,&
                        1, sjv=iadou, styp=type)
            if (type(1:1) .eq. 'I') then
                zi(iadou)=zi(iadin)
            else if (type(1:1).eq.'R') then
                zr(iadou)=zr(iadin)
            else if (type(1:1).eq.'C') then
                zc(iadou)=zc(iadin)
            else if (type(1:3).eq.'K80') then
                zk80(iadou)=zk80(iadin)
            else if (type(1:3).eq.'K32') then
                zk32(iadou)=zk32(iadin)
            else if (type(1:3).eq.'K24') then
                zk24(iadou)=zk24(iadin)
                if (nopara(1:5) .eq. 'EXCIT' .and. zk24(iadin)(1:2) .ne. '  ') then
                    zk24(iadou)=nomres//zk24(iadin)(9:)
                    call copisd(' ', 'G', zk24(iadin)(1:19), zk24(iadou)( 1:19))
                endif
            else if (type(1:3).eq.'K16') then
                zk16(iadou)=zk16(iadin)
            else if (type(1:2).eq.'K8') then
                zk8(iadou)=zk8(iadin)
            endif
10      continue
20  continue
    call jedetr(nompar)
!
!
!     -- 6. RECOPIE DE L'OBJET .REFD (SI NECESSAIRE) :
!     --------------------------------------------------
    call refdcp(resu19, nomr19)
!
!
!
    call jedetr('&&OP0155.NUME_ORDRE')
    call jedema()
end subroutine
