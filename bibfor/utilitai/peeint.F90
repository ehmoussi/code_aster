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
subroutine peeint(tableOut, model, nbocc)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismlg.h"
#include "asterfort/dismoi.h"
#include "asterfort/exlim1.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/peecal.h"
#include "asterfort/getelem.h"
#include "asterfort/rsexch.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/umalma.h"
#include "asterfort/utflmd.h"
#include "asterfort/utmess.h"
#include "asterfort/varinonu.h"
#include "asterfort/wkvect.h"
#include "asterfort/rsSelectStoringIndex.h"
#include "asterfort/rsGetOneBehaviourFromResult.h"
#include "asterfort/convertFieldNodeToNeutElem.h"
!
integer :: nbocc
character(len=8) :: model
character(len=19) :: tableOut
!
! --------------------------------------------------------------------------------------------------
!
!     OPERATEUR   POST_ELEM
!     TRAITEMENT DU MOT CLE-FACTEUR "INTEGRALE"
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbParaResult = 4, nbParaField = 2
    character(len=8), parameter :: paraTypeResult(nbParaResult) = (/'K16','I  ','R  ','R  '/)
    character(len=8), parameter :: paraTypeField(nbParaField) = (/'K16','R  '/)
    character(len=16), parameter :: paraNameResult(nbParaResult) = (/'NOM_CHAM  ','NUME_ORDRE',&
                                                                     'INST      ','VOL       '/)
    character(len=16), parameter :: paraNameField(nbParaField) = (/'CHAM_GD ','VOL     '/)
    integer :: iret, ibid, iocc, nbret
    integer :: cellNume,  cmpNume, numeStore
    integer :: iCmp, iCellCompute, iGroup, iStore
    integer :: nbCellMesh, nbCellUser, nbCell, nbCellFilter, nbCellCompute
    integer :: nbCmp, nbStore, nbCmpField, nbGroup, nbVari
    real(kind=8) :: inst
    character(len=8) :: mesh, resultIn, cellName, physName
    character(len=4) :: fieldSupp, lStructElem
    character(len=8), parameter :: locaNameAll ='TOUT', locaNameGroup = 'GROUP_MA'
    character(len=24), parameter :: locaNameUnion = 'UNION_GROUP_MA', locaNameCell = 'MAILLE'
    character(len=24), parameter :: keywFact = 'INTEGRALE'
    character(len=24), parameter :: listCellUser = '&&PEEINT.CELL_USER'
    character(len=24) :: listCellFilter
    character(len=24) :: numeStoreJv, timeStoreJv, compor
    character(len=19) :: field, fieldFromUser
    character(len=19), parameter :: ligrel = '&&PEEINT.LIGREL'
    character(len=19), parameter :: cespoi ='&&PEEINT.CESPOI'
    character(len=19) :: fieldInput
    character(len=24) :: fieldName, groupName
    aster_logical :: convToNeut, lFromField, lFromResult, lVariName
    integer :: filterTypeNume
    character(len=8) :: filterTypeName
    character(len=8), pointer :: cmpNameNode(:) => null(), cmpNameNeut(:) => null()
    character(len=8), pointer :: cmpNameInit(:) => null()
    integer, pointer :: cellCompute(:) => null()
    integer, pointer :: cellFilter(:) => null()
    integer, pointer :: listNumeStore(:) => null()
    real(kind=8), pointer :: listTimeStore(:) => null()
    character(len=16), pointer :: variName(:) => null()
    character(len=8), pointer :: cmpName(:) => null(), cellNames(:) => null()
    character(len=24), pointer :: groupCell(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Main parameters
!
    call dismoi('NOM_MAILLA', model, 'MODELE', repk = mesh)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi = nbCellMesh)
!
! - Origin of fields
!
    call getvid(' ', 'RESULTAT', scal = resultIn, nbret = nbret)
    lFromResult = nbret .ne. 0
    call getvid(' ', 'CHAM_GD' , scal = fieldFromUser, nbret = nbret)
    lFromField  = nbret .ne. 0
    if (lFromField) then
        ASSERT(.not. lFromResult)
        fieldInput = 'TMP_CHAMP_GD'
        call copisd('CHAMP', 'V', fieldFromUser, fieldInput)
    endif
!
! - Select storing index from user
!
    call rsSelectStoringIndex(resultIn, lFromField ,&
                              nbStore , numeStoreJv, timeStoreJv)
    call jeveuo(numeStoreJv, 'L', vi = listNumeStore)
    call jeveuo(timeStoreJv, 'L', vr = listTimeStore)
!
! - Create table
!
    call tbcrsd(tableOut, 'G')
    if (lFromResult) then
        call tbajpa(tableOut, nbParaResult, paraNameResult, paraTypeResult)
    else
        call tbajpa(tableOut, nbParaField, paraNameField, paraTypeField)
    endif
!
    do iocc = 1, nbocc

! ----- Get list of cells fro user to create reduced domain
        call getelem(mesh, keywFact, iocc, 'F', listCellUser, nbCellUser)

! ----- Sort with topological dimension of cells
        call getvtx(keywFact, 'TYPE_MAILLE', iocc = iocc, scal = filterTypeName, nbret = iret)
        if (iret .eq. 0) then
           listCellFilter = listCellUser
           nbCellFilter   = nbCellUser
        else
            if (filterTypeName .eq. '1D') then
                filterTypeNume = 1
            else if (filterTypeName .eq. '2D') then
                filterTypeNume = 2
            else if (filterTypeName .eq. '3D') then
                filterTypeNume = 3
            else
                ASSERT(ASTER_FALSE)
            endif
            listCellFilter = '&&PEEINT.MAILLES_FILTRE'
            call utflmd(mesh        , listCellUser  , nbCellUser, filterTypeNume, ' ',&
                        nbCellFilter, listCellFilter)
            if (nbCellFilter .eq. 0) then
                call utmess('F', 'PREPOST2_8')
            else
                call utmess('I','PREPOST2_7', si= (nbCellUser - nbCellFilter))
            endif
        endif

! ----- Create LIGREL
        call jeveuo(listCellFilter, 'L', vi = cellFilter)
        call exlim1(cellFilter, nbCellFilter, model, 'V', ligrel)

! ----- No structural elements !
        call dismlg('EXI_RDM', ligrel, ibid, lStructElem, iret)
        if (lStructElem .eq. 'OUI') then
            call utmess('F', 'UTILITAI8_60')
        endif

! ----- Get name of components
        call getvtx(keywFact, 'NOM_CMP', iocc = iocc, nbval = 0, nbret = nbCmp)
        nbCmp     = -nbCmp
        lVariName = ASTER_FALSE
        if (nbCmp .eq. 0) then
! --------- Get list for internal state variables
            lVariName = ASTER_TRUE
            call getvtx(keywFact, 'NOM_VARI', iocc = iocc, nbval = 0, nbret = nbVari)
            nbVari    = -nbVari
            ASSERT(nbVari .gt. 0)
            if (nbVari .gt. 0) then
                if (.not. lFromResult) then
                    call utmess('F', 'POSTELEM_6')
                endif
            endif
            AS_ALLOCATE(vk16 = variName, size = nbVari)
            call getvtx(keywFact, 'NOM_VARI', iocc = iocc, nbval = nbVari, vect = variName)

! --------- Get behaviour (only one !)
            if (lFromResult) then
                call rsGetOneBehaviourFromResult(resultIn, nbStore, listNumeStore, compor)
                if (compor .eq. '#SANS') then
                    call utmess('F', 'RESULT1_5')
                endif
                if (compor .eq. '#PLUSIEURS') then
                    call utmess('F', 'RESULT1_6')
                endif
            else
                call utmess('F', 'RESULT1_7')
            endif

! --------- Get name of internal state variables
            nbCmp = nbVari
            AS_ALLOCATE(vk8 = cmpName, size = nbCellFilter*nbCmp)
            call varinonu(model       , compor    ,&
                          nbCellFilter, cellFilter,&
                          nbVari      , variName  , cmpName)

        else
            AS_ALLOCATE(vk8 = cmpName, size = nbCmp)
            call getvtx(keywFact, 'NOM_CMP', iocc = iocc, nbval = nbCmp, vect=cmpName, nbret=iret)
        endif

! ----- Copy name of components
        AS_ALLOCATE(vk8 = cmpNameInit, size = nbCmp)
        do iCmp = 1, nbCmp
            if (lVariName) then
                cmpNameInit(iCmp) = variName(iCmp)(1:8)
            else
                cmpNameInit(iCmp) = cmpName(iCmp)
            endif
        end do

! ----- Loop on storing index
        do iStore = 1, nbStore
            if (lFromResult) then
                numeStore = listNumeStore(iStore)
                inst      = listTimeStore(iStore)
                call getvtx(keywFact, 'NOM_CHAM', iocc = iocc, scal = fieldName, nbret = iret)
                if (iret .eq. 0)  then
                    call utmess('F', 'POSTELEM_4')
                endif
                if (fieldName.eq.'FORC_NODA' .or. fieldName.eq.'REAC_NODA') then
                    call utmess('F', 'POSTELEM_5')
                endif
                call rsexch('F', resultIn, fieldName, numeStore, fieldInput, iret)
            else
                numeStore = nbStore
                fieldName = fieldFromUser
            endif
!
            call dismoi('TYPE_CHAMP', fieldInput, 'CHAMP', repk=fieldSupp, arret='C', ier=iret)
            call dismoi('NOM_GD'    , fieldInput, 'CHAMP', repk=physName , arret='C', ier=iret)
!
            if (physName(6:6) .eq. 'C') then
                exit
            endif
!
! --------- Prepare field
            convToNeut = ASTER_FALSE
            if (fieldSupp(1:2) .eq. 'EL') then
                field = fieldInput
            else
                convToNeut = ASTER_TRUE
                field      = '&&PEEINT.FIELD'
                call convertFieldNodeToNeutElem(ligrel    , fieldInput , field      ,&
                                                nbCmpField, cmpNameNode, cmpNameNeut)
            endif
!
            call dismoi('TYPE_CHAMP', field, 'CHAMP', repk=fieldSupp, arret='C', ier=iret)
            ASSERT(fieldSupp(1:2) .eq. 'EL')
!
            if (convToNeut) then
                do iCmp = 1, nbCmp
                    cmpNume = indik8(cmpNameNode, cmpNameInit(iCmp), 1, nbCmpField)
                    cmpName(iCmp) = cmpNameNeut(cmpNume)
                end do
                AS_DEALLOCATE(vk8 = cmpNameNode)
                AS_DEALLOCATE(vk8 = cmpNameNeut)
            endif
!
! --------- CALCUL ET STOCKAGE DES MOYENNES : MOT-CLE 'TOUT'
            call getvtx(keywFact, 'TOUT', iocc=iocc, nbval=0, nbret=iret)
            if (iret .ne. 0) then
                nbCellCompute = nbCellMesh
                AS_ALLOCATE(vi = cellCompute, size = nbCellCompute)
                do iCellCompute = 1, nbCellCompute
                    cellCompute(iCellCompute) = iCellCompute
                end do
                call peecal(fieldSupp  , tableOut     , fieldName  ,&
                            locaNameAll, locaNameAll  ,&
                            cellCompute, nbCellCompute,&
                            model      , lFromResult  , field      ,&
                            nbCmp      , cmpName      , cmpNameInit,&
                            numeStore  , inst         , iocc       ,&
                            ligrel     , cespoi)
                AS_DEALLOCATE(vi = cellCompute)
            endif
!
! --------- CALCUL ET STOCKAGE DES MOYENNES : MOT-CLE 'GROUP_MA'
            call getvtx(keywFact, 'GROUP_MA', iocc=iocc, nbval=0, nbret=nbret)
            if (nbret .ne. 0) then
                nbGroup = -nbret
                AS_ALLOCATE(vk24 = groupCell, size = nbGroup)
                call getvtx(keywFact, 'GROUP_MA', iocc=iocc, nbval=nbGroup, vect=groupCell)
                do iGroup = 1, nbGroup
                    groupName = groupCell(iGroup)
                    call jeexin(jexnom(mesh//'.GROUPEMA', groupName), iret)
                    if (iret .eq. 0) then
                        call utmess('A', 'UTILITAI3_46', sk=groupName)
                        cycle
                    endif
                    call jelira(jexnom(mesh//'.GROUPEMA', groupName), 'LONUTI', nbCellCompute)
                    if (nbCellCompute .eq. 0) then
                        call utmess('A', 'UTILITAI3_47', sk=groupName)
                        cycle
                    endif
                    call jeveuo(jexnom(mesh//'.GROUPEMA', groupName), 'L', vi=cellCompute)
                    call peecal(fieldSupp    , tableOut     , fieldName  ,&
                                locaNameGroup, groupName    ,&
                                cellCompute  , nbCellCompute,&
                                model        , lFromResult  , field      ,&
                                nbCmp        , cmpName      , cmpNameInit,&
                                numeStore    , inst         , iocc       ,&
                                ligrel       , cespoi)
                end do
! --- UNION
                if (nbGroup > 1) then
                    call umalma(mesh, groupCell, nbGroup, cellCompute, nbCellCompute)
                    ASSERT(nbCellCompute>0)
                    call peecal(fieldSupp  , tableOut    , fieldName,&
                                locaNameGroup, locaNameUnion,&
                                cellCompute, nbCellCompute,&
                                model, lFromResult, field, nbCmp, cmpName,&
                                cmpNameInit, numeStore, inst, iocc, ligrel, cespoi)
                    AS_DEALLOCATE(vi = cellCompute)
                end if
                AS_DEALLOCATE(vk24 = groupCell)

            endif
!
! --------- CALCUL ET STOCKAGE DES MOYENNES : MOT-CLE 'MAILLE'
            call getvtx(keywFact, 'MAILLE', iocc=iocc, nbval=0, nbret=nbret)
            if (nbret .ne. 0) then
                nbCell        = - nbret
                nbCellCompute = nbCell
                AS_ALLOCATE(vk8 = cellNames, size = nbCellCompute)
                call getvtx(keywFact, 'MAILLE', iocc=iocc, nbval=nbCellCompute, vect = cellNames)
                do iCellCompute = 1, nbCellCompute
                    cellName = cellNames(iCellCompute)
                    call jenonu(jexnom(mesh//'.NOMMAI', cellName), cellNume)
                    call peecal(fieldSupp, tableOut, fieldName,&
                                locaNameCell, cellName, &
                                [cellNume], 1,&
                                model, lFromResult, field, nbCmp, cmpName, &
                                cmpNameInit, numeStore, inst, iocc, ligrel, cespoi)
                end do
                AS_DEALLOCATE(vk8 = cellNames)
            endif
        end do
!
        call jedetr(listCellUser)
        call jedetr(listCellFilter)
        call detrsd('LIGREL', ligrel)
        call detrsd('CHAM_ELEM_S', cespoi)
        call jedetr(cespoi//'.PDSM')
        AS_DEALLOCATE(vk16 = variName)
        AS_DEALLOCATE(vk8  = cmpName)
        AS_DEALLOCATE(vk8  = cmpNameInit)
    end do
!
! - Clean
!
    call jedetr(numeStoreJv)
    call jedetr(timeStoreJv)
    if (lFromField) then
        call detrsd('CHAMP', fieldInput)
    endif
!
    call jedema()
!
end subroutine
