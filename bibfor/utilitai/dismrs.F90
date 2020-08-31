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
subroutine dismrs(questionZ, objNameZ, repi, repkz, ierd)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismcp.h"
#include "asterfort/dismrc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsdocu.h"
#include "asterfort/rslipa.h"
#include "asterfort/rsexch.h"
#include "asterfort/rs_get_liststore.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: questionZ, objNameZ
character(len=*), intent(out)  :: repkz
integer, intent(out) :: repi, ierd
!
! --------------------------------------------------------------------------------------------------
!
!     IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN OBJET DE TYPE RESULTAT
!     OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: objdes
    character(len=4) :: docu
    character(len=24) :: valk(2)
    character(len=8) :: answer
    character(len=19) :: fieldResult
    integer :: ibid
    character(len=24), pointer :: tach(:) => null()
    character(len=32) :: repk
    character(len=19) :: result
    integer :: iStore, iField, iFieldName
    integer :: iret
    integer :: jvPara, jvStore
    integer :: nbField, nbFound, nbFieldName, nbModeDyna, nbModeStat, nbStore
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    result = objNameZ
    repi   = 0
    repk   = ' '
    ierd   = 0
!
    if (questionZ .eq. 'TYPE_RESU') then
!         ---------------------
        call jeexin(result//'.DESC', ibid)
        if (ibid .gt. 0) then
            objdes = result//'.DESC'
        else
            objdes = result//'.CELD'
        endif
!
        call jelira(objdes, 'GENR', cval=answer)
        if (answer(1:1) .eq. 'N') then
            call jelira(objdes, 'DOCU', cval=docu)
            call rsdocu(docu, repk, iret)
            if (iret .ne. 0) then
                valk(1) = docu
                valk(2) = result
                call utmess('F', 'UTILITAI_68', nk=2, valk=valk)
                ierd=1
                goto 999
            endif
        else
            repk = 'CHAMP'
        endif

    else if ((questionZ.eq.'NOM_MODELE').or. (questionZ.eq.'MODELE').or.&
             (questionZ.eq.'CHAM_MATER').or.&
             (questionZ.eq.'CARA_ELEM')) then
!     ------------------------------------------
        if ((questionZ.eq.'NOM_MODELE') .or. (questionZ(1:6).eq.'MODELE')) then
            call rslipa(result, 'MODELE'  , '&&DISMRS.LIPAR', jvStore, nbStore)
        else if (questionZ(1:9).eq.'CARA_ELEM') then
            call rslipa(result, 'CARAELEM', '&&DISMRS.LIPAR', jvStore, nbStore)
        else if (questionZ(1:10).eq.'CHAM_MATER') then
            call rslipa(result, 'CHAMPMAT', '&&DISMRS.LIPAR', jvStore, nbStore)
        endif
        ASSERT(nbStore.ge.1)
        repk    = ' '
        nbFound = 0
        do iStore = 1, nbStore
            if (zk8(jvStore-1+iStore) .ne. ' ') then
                if (zk8(jvStore-1+iStore) .ne. repk) then
                    nbFound = nbFound+1
                    repk    = zk8(jvStore-1+iStore)
                endif
            endif
        end do
        if (nbFound .eq. 0) then
            repk = '#AUCUN'
        endif
        if (nbFound .gt. 1) then
            repk ='#PLUSIEURS'
        endif
        call jedetr('&&DISMRS.LIPAR')

    else if (questionZ .eq. 'NOM_MAILLA') then
!     ------------------------------------------
        call jelira(jexnum(result//'.TACH', 1), 'LONMAX', nbField)
        call jeveuo(jexnum(result//'.TACH', 1), 'L', vk24 = tach)
        do iField = 1, nbField
            fieldResult = tach(iField)(1:19)
            if (fieldResult(1:1) .ne. ' ') then
                call dismcp(questionZ, fieldResult, repi, repk, ierd)
                goto 999
            endif
        end do
!
        call jelira(result//'.TACH', 'NMAXOC', nbFieldName)
        do iFieldName = 2, nbFieldName
            call jelira(jexnum(result//'.TACH', iFieldName), 'LONMAX', nbField)
            call jeveuo(jexnum(result//'.TACH', iFieldName), 'L', vk24 = tach)
            do iField = 1, nbField
                fieldResult = tach(iField)(1:19)
                if (fieldResult(1:1) .ne. ' ') then
                    call dismcp(questionZ, fieldResult, repi, repk, ierd)
                    goto 999
                endif
            end do
        end do
        ierd = 1
!
    else if ( (questionZ.eq.'NB_CHAMP_MAX') .or. (questionZ.eq.'NB_CHAMP_UTI')) then
!     ------------------------------------------
        call jelira(result//'.DESC', 'GENR', cval = answer)
        if (answer(1:1) .eq. 'N') then
            call dismrc(questionZ, result, repi, repk, ierd)
        else
            repi = 1
        endif
!
!
    else if (questionZ.eq.'NB_MODES_TOT') then
!     ------------------------------------------
        call rs_get_liststore(result, nbStore)
        repi = nbStore
        repk = 'NON'
!
    else if (questionZ.eq.'NB_MODES_STA') then
!     ------------------------------------------
        nbModeStat = 0
        call rs_get_liststore(result, nbStore)
!
        do iStore = 1, nbStore
            call rsadpa(result, 'L', 1, 'TYPE_MODE', iStore,&
                        0, sjv=jvPara, styp=answer)
            fieldResult = zk16(jvPara)(1:16)
            if (fieldResult(1:8) .eq. 'MODE_STA') then
                nbModeStat = nbModeStat + 1
            endif
        end do
        repi = nbModeStat
        repk = 'NON'
!
    else if (questionZ.eq.'NB_MODES_DYN') then
!     ------------------------------------------
        nbModeDyna = 0
        call rs_get_liststore(result, nbStore)
!
        do iStore =  1, nbStore
            call rsadpa(result, 'L', 1, 'TYPE_MODE', iStore,&
                        0, sjv=jvPara, styp=answer)
            fieldResult = zk16(jvPara)(1:16)
            if ((fieldResult(1:9) .eq. 'MODE_DYN')) then
                nbModeDyna = nbModeDyna + 1
            endif
        end do
        repi = nbModeDyna
        repk = 'NON'
!
    else
        ierd = 1
    endif
!
999 continue
!
    repkz = repk
!
    call jedema()
end subroutine
