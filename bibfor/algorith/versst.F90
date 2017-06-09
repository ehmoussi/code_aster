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

subroutine versst(nomres)
!    P. RICHARD     DATE 13/10/92
!-----------------------------------------------------------------------
!  BUT:      < VERIFICATION DES SOUS-STRUCTURES >
    implicit none
!
!  VERIFIER LA COHERENCE DES MACRO_ELEMENTS MIS EN JEU ET
!  NOTAMMENT LA GRANDEUR SOUS-JACENTE ET
!  CREATION DU .DESC STOCKANT CES INFORMATIONS
!
!-----------------------------------------------------------------------
!
! NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mgutdm.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    integer :: vali(2)
!
!
!
    character(len=24) :: valk(4)
    character(len=8) :: nomres, nmsstr, nmsst, nmmclr, nmmcl, blanc
    aster_logical :: pblog
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, ibid, lddesc, lldesc, nbcmpr, nbecr, nbsst
    integer :: numgd, numgdr
!-----------------------------------------------------------------------
    data blanc /'        '/
!-----------------------------------------------------------------------
!
    call jemarq()
    pblog=.false.
!
!------------RECUPERATION DU NOMBRE DE MACR_ELEM MIS EN JEU-------------
!
    call jelira(nomres//'      .MODG.SSME', 'LONMAX', nbsst)
!
!------RECUPERATION VALEURS DE REFERENCE GRANDEUR SOUS-JACENTE----------
!      (ON PREND CELLES DU PREMIER MACR_ELEM)
!
    nmsstr=blanc
    call mgutdm(nomres, nmsstr, 1, 'NOM_MACR_ELEM', ibid,&
                nmmclr)
    call jeveuo(nmmclr//'.MAEL_DESC', 'L', lldesc)
    nbecr=zi(lldesc)
    nbcmpr=zi(lldesc+1)
    numgdr=zi(lldesc+2)
!
!----------------BOUCLE SUR TOUS LES MACR_ELEM MIS EN JEU---------------
!
    do 10 i = 1, nbsst
        nmsst=blanc
        call mgutdm(nomres, nmsst, i, 'NOM_MACR_ELEM', ibid,&
                    nmmcl)
        call jeveuo(nmmcl//'.MAEL_DESC', 'L', lldesc)
        numgd=zi(lldesc+2)
        if (numgdr .ne. numgd) then
            pblog=.true.
            call jenuno(jexnum(nomres//'      .MODG.SSNO', i), nmsst)
            valk (1) = nmsstr
            valk (2) = nmmclr
            valk (3) = nmsst
            valk (4) = nmmcl
            vali (1) = numgdr
            vali (2) = numgd
            call utmess('E', 'ALGORITH14_73', nk=4, valk=valk, ni=2,&
                        vali=vali)
        endif
 10 end do
!
    if (pblog) then
        call utmess('F', 'ALGORITH14_74')
    endif
!
    call wkvect(nomres//'      .MODG.DESC', 'G V I', 3, lddesc)
    zi(lddesc)=nbecr
    zi(lddesc+1)=nbcmpr
    zi(lddesc+2)=numgdr
!
    call jedema()
end subroutine
