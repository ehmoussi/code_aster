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
subroutine w155mx(resultOut, resultIn, nbStore, listStore)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alchml.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/exlima.h"
#include "asterfort/getelem.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsGetOneModelFromResult.h"
#include "asterfort/rsGetOneBehaviourFromResult.h"
#include "asterfort/rslesd.h"
#include "asterfort/rsnoch.h"
#include "asterfort/utmess.h"
#include "asterfort/varinonu.h"
#include "asterfort/w155m2.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: resultOut, resultIn
integer, intent(in) :: nbStore, listStore(nbStore)
!
! --------------------------------------------------------------------------------------------------
!
!     COMMANDE :  POST_CHAMP / MIN_MAX_SP
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv, ico, n1, nbCell
    integer :: iret, iStore, numeStore, ibid, nocc, iocc, nchout, jcmp, nbVari
    character(len=8) :: model, caraElem, mesh
    character(len=8) :: modelPrev, cmpName, tymaxi
    character(len=4) :: fieldSupp
    character(len=16), parameter :: keywFact = 'MIN_MAX_SP'
    character(len=16) :: fieldName, nomsy2, variName
    character(len=19) :: chin, chextr, ligrel
    character(len=24) :: nompar, compor
    character(len=24), parameter :: listCell = '&&W155MX.LISMAI'
    character(len=24), parameter :: listVariNume = '&&W155MX.CMP'
    integer, pointer :: cellNume(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    call infmaj()
    call infniv(ifm, niv)
    call getfac(keywFact, nocc)
    if (nocc .eq. 0) goto 30
    ASSERT(nocc .lt. 10)
!
    do iocc = 1, nocc
!
!     -- 2.  : NOMSYM, NOCMP, TYMAXI, TYCH :
!     --------------------------------------------------
        call getvtx(keywFact, 'NOM_CHAM', iocc=iocc, scal=fieldName, nbret=ibid)
        call getvtx(keywFact, 'TYPE_MAXI', iocc=iocc, scal=tymaxi, nbret=ibid)
        fieldSupp = fieldName(6:9)
        ASSERT(fieldSupp.eq.'ELNO' .or. fieldSupp.eq.'ELGA')
        call getvtx(keywFact, 'NOM_CMP', iocc=iocc, scal=cmpName, nbret=n1)
        if (n1 .eq. 0) then
            ASSERT(fieldName(1:7).eq.'VARI_EL')
            call getvtx(keywFact, 'NOM_VARI', iocc=iocc, scal=variName, nbret=nbVari)
            ASSERT(nbVari .eq. 1)

! --------- Get list of cells
            call dismoi('NOM_MAILLA', resultIn, 'RESULTAT', repk = mesh)
            call getelem(mesh  , keywFact, iocc, 'F', listCell,&
                         nbCell)
            call jeveuo(listCell, 'L', vi = cellNume)
            call wkvect(listVariNume, 'V V K8', nbCell*nbVari, jcmp)

! --------- Get behaviour (only one !)
            call rsGetOneBehaviourFromResult(resultIn, nbStore, listStore, compor)
            if (compor .eq. '#SANS') then
                call utmess('F', 'RESULT1_5')
            endif
            if (compor .eq. '#PLUSIEURS') then
                call utmess('F', 'RESULT1_6')
            endif

! --------- Get model (only one !)
            call rsGetOneModelFromResult(resultIn, nbStore, listStore, model)
            if (model .eq. '#PLUSIEURS') then
                call utmess('F', 'RESULT1_4')
            endif

! --------- Get name of internal state variables
            call varinonu(model , compor  ,&
                          nbCell, cellNume,&
                          nbVari, variName, zk8(jcmp))

            cmpName = zk8(jcmp)

            call jedetr(listVariNume)
            call jedetr(listCell)
        endif
!
!
!     -- 3. : BOUCLE SUR LES NUME_ORDRE
!     --------------------------------------------------
        modelPrev = ' '
        ico    = 0
        do iStore = 1 , nbStore
            numeStore = listStore(iStore)
            call rsexch(' ', resultIn, fieldName, numeStore, chin, iret)
            if (iret .eq. 0) then
!
!         -- 3.1 : MODELE, CARELE, LIGREL :
                call rslesd(resultIn, numeStore, model_ = model, cara_elem_ = caraElem)
                if (model .ne. modelPrev) then
                    call exlima(' ', 1, 'G', model, ligrel)
                    modelPrev = model
                endif
!
                nomsy2='UTXX_'//fieldSupp
                call getvis(keywFact, 'NUME_CHAM_RESU', iocc=iocc, scal=nchout, nbret=ibid)
                ASSERT(nchout.ge.1 .and. nchout.le.20)
                call codent(nchout, 'D0', nomsy2(3:4))
                if (fieldSupp .eq. 'ELGA') then
                    nompar='PGAMIMA'
                else if (fieldSupp.eq.'ELNO') then
                    nompar='PNOMIMA'
                else
                    ASSERT(ASTER_FALSE)
                endif
!
                call rsexch(' ', resultOut, nomsy2, numeStore, chextr, iret)
                ASSERT(iret .eq. 100)
                call alchml(ligrel, 'MINMAX_SP', nompar, 'G', chextr, iret, ' ')
                ASSERT(iret .eq. 0)
                call w155m2(chin, caraElem, ligrel, chextr, fieldName,&
                            cmpName, tymaxi)
                ico=ico+1
                call rsnoch(resultOut, nomsy2, numeStore)
            endif
        end do
        if (ico .eq. 0) then
            call utmess('F', 'CALCULEL2_62', sk=fieldName)
        endif
    end do
!
30  continue
    call jedema()
end subroutine
