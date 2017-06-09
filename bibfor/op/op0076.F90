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

subroutine op0076()
    implicit none
!     RECUPERE LES CHAMPS GENERALISES (DEPL, VITE, ACCE) D'UN CONCEPT
!     TRAN_GENE.
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/dismoi.h"
#include "asterfort/extrac.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/zxtrac.h"
!
    real(kind=8) :: temps, prec, freq
    character(len=8) :: nomres, trange, basemo, nomcha, interp, crit
    character(len=16) :: concep, nomcmd
    character(len=24) :: nddlge
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer ::  idcham, iddesc,  idrefe, idvecg
    integer :: ierd, n1, nbinst, nbmode, nt, nf, ni
    integer, pointer :: desc(:) => null()
    real(kind=8), pointer :: disc(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    call infmaj()
!
    call getres(nomres, concep, nomcmd)
!
!     --- RECUPERATION DES ARGUMENTS DE LA COMMANDE ---
!
    call getvid(' ', 'RESU_GENE', scal=trange, nbret=n1)
    call getvtx(' ', 'NOM_CHAM', scal=nomcha, nbret=n1)
    call getvr8(' ', 'INST', scal=temps, nbret=nt)
    call getvr8(' ', 'FREQ', scal=freq, nbret=nf)
    call getvtx(' ', 'INTERPOL', scal=interp, nbret=ni)
    call getvtx(' ', 'CRITERE', scal=crit, nbret=n1)
    call getvr8(' ', 'PRECISION', scal=prec, nbret=n1)
!
    if (ni .eq. 0) interp(1:3) = 'NON'
!
!     --- RECUPERATION DES INFORMATIONS MODALES ---
!
    call jeveuo(trange//'           .DESC', 'L', vi=desc)
    call jeveuo(trange//'           .DISC', 'L', vr=disc)
    call jelira(trange//'           .DISC', 'LONMAX', nbinst)
    call jeveuo(trange//'           .'//nomcha(1:4), 'L', idcham)
!
!     --- RECUPERATION DE LA NUMEROTATION GENERALISEE NUME_DDL_GENE
    call dismoi('NUME_DDL', trange, 'RESU_DYNA', repk=nddlge)
!     --- RECUPERATION DE LA BASE MODALE ET LE NOMBRE DE MODES
    call dismoi('BASE_MODALE', trange, 'RESU_DYNA', repk=basemo)
    nbmode = desc(2)
!
    call wkvect(nomres//'           .REFE', 'G V K24', 2, idrefe)
    call wkvect(nomres//'           .DESC', 'G V I', 2, iddesc)
    call jeecra(nomres//'           .DESC', 'DOCU', cval='VGEN')
!
    zi(iddesc) = 1
    zi(iddesc+1) = nbmode
!
    zk24(idrefe) = basemo
    zk24(idrefe+1) = nddlge
!
!     --- CAS DU TRAN_GENE
    if (desc(1) .ne. 4) then
!
!       ---  ON PLANTE SI LE MOT CLE DEMANDE EST FREQ POUR UN TRAN_GENE
        if (nf .ne. 0) then
            call utmess('E', 'ALGORITH9_51')
        endif
!
!       --- CREATION DU VECT_ASSE_GENE RESULTAT ---
        call wkvect(nomres//'           .VALE', 'G V R', nbmode, idvecg)
!
!       --- RECUPERATION DU CHAMP ---
        call extrac(interp, prec, crit, nbinst, disc,&
                    temps, zr( idcham), nbmode, zr(idvecg), ierd)
!
        if (ierd .ne. 0) then
            call utmess('E', 'ALGORITH9_49')
        endif
!
! --- CAS DU HARM_GENE
!
    else
!       ---  ON PLANTE SI LE MOT CLE DEMANDE EST INST POUR UN HARM_GENE
        if (nt .ne. 0) then
            call utmess('E', 'ALGORITH9_52')
        endif
!
!       --- CREATION DU VECT_ASSE_GENE RESULTAT ---
        call wkvect(nomres//'           .VALE', 'G V C', nbmode, idvecg)
!
!       --- RECUPERATION DU CHAMP ---
        call zxtrac('NON', 0.d0, 'RELATIF', nbinst, disc,&
                    freq, zc(idcham), nbmode, zc(idvecg), ierd)
!
        if (ierd .ne. 0) then
            call utmess('E', 'ALGORITH9_50')
        endif
!
    endif
!
    call jedema()
end subroutine
