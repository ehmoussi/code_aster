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
subroutine irchor(keywf      , keywfIocc    ,&
                  dsName     , lResu        , lField,&
                  fieldListNb, fieldListType, fieldMedListType,&
                  storeListNb, storeListIndx,&
                  paraListNb , paraListName ,&
                  cmpListNb  , cmpListName  ,&
                  codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/irparb.h"
#include "asterfort/irvcmp.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/lxlgut.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsutnu.h"
#include "asterfort/utmess.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=16), intent(in) :: keywf
integer, intent(in) :: keywfIocc
aster_logical, intent(in) :: lField, lResu
character(len=8), intent(in) :: dsName
integer, intent(out) :: fieldListNb
character(len=16), pointer :: fieldListType(:)
character(len=80), pointer :: fieldMedListType(:)
integer, intent(out) :: storeListNb
integer, pointer :: storeListIndx(:)
integer, intent(out) :: paraListNb
character(len=16), pointer :: paraListName(:)
integer, intent(out) :: cmpListNb
character(len=8), pointer :: cmpListName(:)
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Print result or field in a file (IMPR_RESU)
!
! Get parameters from user: field types, components, parameters and storing index
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : keyword to read
! In  keywfIocc        : keyword index to read
! In  dsName           : name of datastructure (result or field)
! In  lResu            : flag if datastructure is a result
! Out fieldListNb      : length of list of field types to read
! Ptr fieldListType    : pointer to list of field types to read
! Ptr fieldMedListType : pointer to list of MED field types to read
! Out paraListNb       : length of list of parameter names to read
! Ptr paraListName     : pointer to the list of parameter names to read
! Out storeNb          : length of list of storing slots to read
! Ptr storeListIndx    : pointer to the list of storing slots to read
! Out cmpListNb        : length of the list of component names to read
! Ptr cmpListName      : pointer to the list of component names to read
! Out codret           : error return code (0: OK)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbFieldMedName, nbAllField
    integer :: nbFieldName, nbResuMedName
    integer :: iField, iStore, iCmp, iPara
    integer :: quantityIndx, cmpCataNb, storeIndx, iret, lenString
    integer :: nbOcc, nbParaCheck, nbCmpOut, nbStore, nbCmp
    integer :: nbAllPara, nbParaName
    real(kind=8) :: storePrec
    character(len=3) :: paraAll, fieldAll
    character(len=8) :: resultMedName, storeCrit, quantityName
    character(len=19) :: fieldName
    character(len=19), parameter :: storeJvName = '&&IRCHOR.STORE_LIST'
    character(len=19), parameter :: paraJvName = '&&IRCHOR.PARA_LIST'
    character(len=16) :: fieldType
    character(len=80) :: fieldMedType
    aster_logical :: lCheckCmp
    character(len=8), pointer :: cmpName(:) => null()
    character(len=8), pointer :: cmpCataName(:) => null()
    character(len=16), pointer :: paraCheckName(:) => null()
    character(len=16), pointer :: paraName(:) => null()
    integer, pointer :: storeList(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    fieldListNb = 0
    storeListNb = 0
    paraListNb  = 0
    cmpListNb   = 0
    codret      = 0
!
! - No parameters to read
!
    if (.not.lField .and. .not.lResu) then
        goto 999
    endif
!
! - Read parameters
!
    if (lField) then
! ----- For a field
        fieldType      = dsName
! ----- Type of field
        fieldListNb    = 1
        AS_ALLOCATE(vk16 = fieldListType, size = fieldListNb)
        fieldListType(1) = fieldType
! ----- Type of MED field
        call getvtx(keywf, 'NOM_CHAM_MED', iocc=keywfIocc, nbval=0, nbret=nbFieldMedName)
        if (nbFieldMedName .ne. 0) then
            nbFieldMedName = - nbFieldMedName
            ASSERT(nbFieldMedName .eq. 1)
            AS_ALLOCATE(vk80 = fieldMedListType, size = fieldListNb)
            call getvtx(keywf, 'NOM_CHAM_MED', iocc=keywfIocc, nbval=fieldListNb,&
                        vect=fieldMedListType, nbret=nbOcc)
        endif
! ----- List of parameters: void (only for results)
        nbParaCheck = 0
        paraListNb  = 0
! ----- List of storing index
        storeListNb = 1
! ----- List of components
        call getvtx(keywf, 'NOM_CMP', iocc=keywfIocc, nbval=0, nbret=nbCmp)
        if (nbCmp .lt. 0) then
            nbCmp = -nbCmp
            AS_ALLOCATE(vk8=cmpName, size=nbCmp)
            call getvtx(keywf, 'NOM_CMP', iocc=keywfIocc, nbval=nbCmp,&
                        vect=cmpName, nbret=nbOcc)
        endif
        cmpListNb = nbCmp
    elseif (lResu) then
! ----- For a complete result
        fieldAll = 'OUI'
        call getvtx(keywf, 'TOUT_CHAM', iocc=keywfIocc, scal=fieldAll, nbret=nbAllField)
        call getvtx(keywf, 'NOM_CHAM', iocc=keywfIocc, nbval=0, nbret=nbFieldName)
        call getvtx(keywf, 'NOM_CHAM_MED', iocc=keywfIocc, nbval=0, nbret=nbFieldMedName)
        call getvtx(keywf, 'NOM_RESU_MED', iocc=keywfIocc, nbval=0, nbret=nbResuMedName)
! ----- Check consistency
        if ((nbFieldName .eq. 0) .and. (nbFieldMedName .lt. 0)) then
            call utmess('F', 'MED3_1')
        endif
! ----- Default: all fields
        if (abs(nbAllField)+abs(nbFieldName) .eq. 0) then
            nbAllField = 1
        endif
        if (nbAllField .gt. 0 .and. fieldAll .eq. 'OUI' .and. nbResuMedName .eq. 0) then
! --------- Get all fields
            call jelira(dsName//'           .DESC', 'NOMUTI', fieldListNb)
            AS_ALLOCATE(vk16 = fieldListType, size = fieldListNb)
            do iField = 1, fieldListNb
                call jenuno(jexnum(dsName//'           .DESC', iField), fieldListType(iField))
            end do
        else if (nbAllField .gt. 0 .and. fieldAll.eq.'NON') then
! --------- No fields
            fieldListNb = 0
        else if (nbFieldName .lt. 0) then
! --------- Get type of fields from user
            fieldListNb = - nbFieldName
            AS_ALLOCATE(vk16 = fieldListType, size = fieldListNb)
            call getvtx(keywf, 'NOM_CHAM', iocc=keywfIocc, nbval=fieldListNb,&
                        vect=fieldListType, nbret=nbOcc)
! --------- Get type of fields for MED from user
            if (nbFieldMedName .ne. 0) then
                nbFieldMedName = - nbFieldMedName
                if (nbFieldMedName .ne. fieldListNb) then
                    call utmess('F', 'MED3_1')
                endif
                AS_ALLOCATE(vk80 = fieldMedListType, size = fieldListNb)
                call getvtx(keywf, 'NOM_CHAM_MED', iocc=keywfIocc,nbval=fieldListNb,&
                            vect=fieldMedListType, nbret=nbOcc)
            endif
        else if (nbResuMedName .lt. 0) then
! --------- Get type of fields from MED result
            call getvtx(keywf, 'NOM_RESU_MED', iocc=keywfIocc, scal=resultMedName, nbret=nbOcc)
            call jelira(dsName//'           .DESC', 'NOMUTI', fieldListNb)
            AS_ALLOCATE(vk16 = fieldListType, size = fieldListNb)
            AS_ALLOCATE(vk80 = fieldMedListType, size = fieldListNb)
            do iField = 1, fieldListNb
                call jenuno(jexnum(dsName//'           .DESC', iField), fieldListType(iField))
                fieldMedType = '________'
                lenString        = lxlgut(resultMedName)
                fieldMedType(1:lenString) = resultMedName(1:lenString)
                lenString        = lxlgut(fieldListType(iField))
                fieldMedType(9:8+lenString) = fieldListType(iField)(1:lenString)
                fieldMedListType(iField) = fieldMedType
            end do
        endif
! ----- Get name of components (to check with catalog)
        call getvtx(keywf, 'NOM_CMP', iocc=keywfIocc, nbval=0, nbret=nbCmp)
        lCheckCmp = ASTER_FALSE
        if (nbCmp .lt. 0) then
            if (nbResuMedName .lt. 0) then
                call utmess('F', 'MED3_6')
            endif
            nbCmp = -nbCmp
            AS_ALLOCATE(vk8=cmpName, size=nbCmp)
            call getvtx(keywf, 'NOM_CMP', iocc=keywfIocc, nbval=nbCmp,&
                        vect=cmpName, nbret=nbOcc)
            lCheckCmp = ASTER_TRUE
        endif
        cmpListNb = nbCmp
! ----- Get parameters to select real (INST, FREQ, etc.)
        call getvr8(keywf, 'PRECISION', iocc=keywfIocc, scal=storePrec, nbret=nbOcc)
        call getvtx(keywf, 'CRITERE', iocc=keywfIocc, scal=storeCrit, nbret=nbOcc)
! ----- Get list of storing index from user
        call rsutnu(dsName      ,&
                    keywf       , keywfIocc,&
                    storeJvName , nbStore  ,&
                    storePrec   , storeCrit,&
                    iret)
        storeListNb = nbStore
        if (iret .ne. 0 .and. nbStore .eq. 0) then
            codret = 1
            goto 999
        endif
        call jeveuo(storeJvName, 'L', vi=storeList)
! ----- Some checks
        if (nbFieldName .lt. 0) then
! --------- Check if field exists
            do iField = 1, fieldListNb
                fieldType = fieldListType(iField)
                do iStore = 1, nbStore
                    storeIndx = storeList(iStore)
                    call rsexch(' ', dsName, fieldType, storeIndx, fieldName, iret)
                    if (iret .ne. 0) then
                        call utmess('A', 'RESULT3_4', sk=fieldType, si=storeIndx)
                    endif
                end do
            end do
! --------- Check components (only on the first storing index)
            if (lCheckCmp) then
                storeIndx = storeList(1)
                nbCmpOut  = 0
                do iCmp = 1, nbCmp
                    do iField = 1, fieldListNb
                        fieldType = fieldListType(iField)
                        call rsexch(' ', dsName, fieldType, storeIndx, fieldName, iret)
                        if (iret .eq. 0) then
                            call dismoi('NUM_GD', fieldName, 'CHAMP', repi=quantityIndx)
                            call jenuno(jexnum('&CATA.GD.NOMGD', quantityIndx), quantityName)
                            if (quantityName .eq. 'VARI_R') then
                                ! TRAITEMENT PARTICULIER POUR LA GRANDEUR VARI_R
                                nbCmpOut = nbCmpOut + 1
                                goto 17
                            endif
                            call jelira(jexnum('&CATA.GD.NOMCMP', quantityIndx),&
                                               'LONMAX', cmpCataNb)
                            call jeveuo(jexnum('&CATA.GD.NOMCMP', quantityIndx),&
                                               'L', vk8 = cmpCataName)
                            call irvcmp(cmpCataNb, cmpCataName, cmpName(iCmp), nbCmpOut)
                        endif
 17                     continue
                    end do
                    if (nbCmpOut .eq. 0) then
                        call utmess('A', 'RESULT3_5', sk=cmpName(iCmp))
                    endif
                end do
            endif
        endif
! ----- Get list of parameters to print
        paraAll = 'NON'
        call getvtx(keywf, 'TOUT_PARA', iocc=keywfIocc, scal=paraAll, nbret=nbAllPara)
        call getvtx(keywf, 'NOM_PARA', iocc=keywfIocc, nbval=0, nbret=nbParaName)
! ----- Default: all parameters
        if (nbParaName .eq. 0) then
            nbAllPara = 1
        endif
! ----- Get list of parameters (to check)
        if (nbAllPara .ne. 0 .and. paraAll .eq. 'NON') then
            nbParaCheck = 0
        else if (nbAllPara .ne. 0 .and. paraAll .eq. 'OUI') then
            nbParaCheck = -1
        else if (nbParaName.ne.0) then
            nbParaCheck = -nbParaName
            AS_ALLOCATE(vk16=paraCheckName, size=nbParaCheck)
            call getvtx(keywf, 'NOM_PARA', iocc=keywfIocc, nbval=nbParaCheck, vect=paraCheckName)
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Check parameters
!
    call irparb(dsName, nbParaCheck, paraCheckName, paraJvName, paraListNb)
!
! - Copy storing index
!
    if (storeListNb .ne. 0) then
        AS_ALLOCATE(vi = storeListIndx, size = storeListNb)
        if (lField) then
            storeListIndx(1) = 1
        else
            call jeveuo(storeJvName, 'L', vi=storeList)
            do iStore = 1, storeListNb
                storeListIndx(iStore) = storeList(iStore)
            end do
        endif
    endif
    call jedetr(storeJvName)
!
! - Copy list of parameters
!
    if (paraListNb .ne. 0) then
        AS_ALLOCATE(vk16 = paraListName, size = paraListNb)
        call jeveuo(paraJvName, 'L', vk16 = paraName)
        do iPara = 1, paraListNb
            paraListName(iPara) = paraName(iPara)
        end do
    endif
    call jedetr(paraJvName)
!
! - Copy list of components
!
    if (cmpListNb .ne. 0) then
        AS_ALLOCATE(vk8 = cmpListName, size = cmpListNb)
        do iCmp = 1, cmpListNb
            cmpListName(iCmp) = cmpName(iCmp)
        end do
    endif
!
999 continue
!
! - Clean
!
    AS_DEALLOCATE(vk8=cmpName)
    AS_DEALLOCATE(vk16=paraCheckName)
!
    call jedema()
!
end subroutine
