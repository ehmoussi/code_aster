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
subroutine irmfac(keywfIocc, fileFormat, fileUnit, fileVersion, modelIn)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/gettco.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/irchor.h"
#include "asterfort/irecri.h"
#include "asterfort/iremed.h"
#include "asterfort/irmail.h"
#include "asterfort/irtitr.h"
#include "asterfort/irtopo.h"
#include "asterfort/irextv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/resuPrintIdeas.h"
#include "asterfort/irgmsh.h"
#include "asterfort/irdebg.h"
!
integer, intent(in) :: keywfIocc, fileUnit, fileVersion
character(len=8), intent(in) :: fileFormat, modelIn
!
! --------------------------------------------------------------------------------------------------
!
! Print result or field in a file (IMPR_RESU)
!
! Main subroutine for each occurrence, all formats
!
! --------------------------------------------------------------------------------------------------
!
! In  keywfIocc        : keyword index to read
! In  fileFormat       : format of file to print (MED, RESULTAT, etc.)
! In  fileUnit         : index of file (logical unit)
! In  fileVersion      : version of file (for IDEaS and GMSH)
! In  modelIn          : name of model
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16), parameter :: keywf = 'RESU'
    integer :: meshMEDInfo
    integer :: ier, iret, nbOcc
    real(kind=8) :: borsup, borinf
    character(len=1) :: paraFormat
    character(len=8) :: cplxFormat
    character(len=8) :: answer, modelMesh, model, caraElem
    character(len=8) :: dsName, resultName, fieldName, meshName
    character(len=8) :: fieldGsmh, fieldQuantity
    character(len=16) :: realFormat, resultType
    character(len=80) :: title
    integer :: fieldListNb, storeListNb, paraListNb, cmpListNb, nodeListNb, cellListNb
    character(len=16), pointer :: fieldListType(:) => null()
    character(len=80), pointer :: fieldMedListType(:) => null()
    integer, pointer :: storeListIndx(:) => null()
    character(len=16), pointer :: paraListName(:) => null()
    character(len=8), pointer :: cmpListName(:) => null()
    integer, pointer :: nodeListNume(:) => null()
    integer, pointer :: cellListNume(:) => null()
    aster_logical :: lResu, lMeshCoor, lmax, lmin, linf, lsup, lVariName
    aster_logical :: lModel, lField, lMesh, lFirstOcc
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    lResu = ASTER_FALSE
!
! - Has model ?
!
    model = ' '
    lModel = ASTER_FALSE
    if (modelIn .ne. ' ') then
        model  = modelIn
        lModel = ASTER_TRUE
    endif
!
! - Format of real numbers
!
    realFormat = ' '
    call getvtx(keywf, 'FORMAT_R', iocc=keywfIocc, scal=realFormat, nbret=nbOcc)
!
! - Format to print parameters (FORM_TABL keyword)
!
    answer = ' '
    call getvtx(keywf, 'FORM_TABL', iocc=keywfIocc, scal=answer, nbret=nbOcc)
    paraFormat = 'L'
    if (nbOcc .ne. 0) then
        if (answer .eq. 'OUI') then
            paraFormat = 'T'
        elseif (answer .eq. 'NON') then
            paraFormat = 'L'
        else if (answer .eq. 'EXCEL') then
            paraFormat = 'E'
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
! - Get elementary characteristics
!
    caraElem = ' '
    call getvid(keywf, 'CARA_ELEM', iocc=keywfIocc, scal=caraElem, nbret=nbOcc)
!
! - Get flag to print coordinates of nodes
!
    answer = ' '
    call getvtx(keywf, 'IMPR_COOR', iocc=keywfIocc, scal=answer, nbret=nbOcc)
    lMeshCoor = ASTER_FALSE
    if (nbOcc .ne. 0) then
        if (answer .eq. 'OUI') then
            lMeshCoor = ASTER_TRUE
        elseif (answer .eq. 'NON') then
            lMeshCoor = ASTER_FALSE
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
!
! - Print RESULTAT separation
!
    if (fileFormat .eq. 'RESULTAT') write(fileUnit,'(/,1X,80(''-''))')
!
! - Get results datastructure
!
    resultName = ' '
    call getvid(keywf, 'RESULTAT', iocc=keywfIocc, scal=answer, nbret=nbOcc)
    lResu = nbOcc .ne. 0
    if (lResu) then
        resultName = answer
    endif
!
! - Get model from result if necessary
!
    if (lResu.and.(.not. lModel) ) then
        call dismoi('MODELE', resultName, 'RESULTAT',repk=model)
        if (model(1:1) .eq. '#') then
            model = ' '
        endif
    endif
!
! - To print complex values
!
    cplxFormat = ' '
    call getvtx(keywf, 'PARTIE', iocc=keywfIocc, scal=cplxFormat, nbret=nbOcc)
    if (nbOcc .eq. 0) then
        cplxFormat = ' '
    endif
    if (lResu) then
        call gettco(resultName, resultType)
        if (resultType .eq. 'DYNA_HARMO' .or. resultType .eq. 'ACOU_HARMO') then
            if (fileFormat .eq. 'GMSH'.or. fileFormat .eq. 'MED') then
                if (nbOcc .eq. 0) then
                    call utmess('F', 'RESULT3_69')
                endif
            endif
        endif
    endif
!
! - Get name of field
!
    fieldName = ' '
    call getvid(keywf, 'CHAM_GD', iocc=keywfIocc, scal=answer, nbret=nbOcc)
    lField = nbOcc .ne. 0
    if (lField) then
        fieldName = answer
        call dismoi('NOM_GD', fieldName, 'CHAMP', repk=fieldQuantity, arret='C', ier=ier)
        if (fieldQuantity(6:6) .eq. 'C') then
            if (fileFormat .eq. 'GMSH') then
                if (cplxFormat .eq. ' ') then
                    call utmess('F', 'RESULT3_69')
                endif
            endif
        endif
    endif
!
! - Get parameter from INFO_MAILLAGE
!
    meshMEDInfo = 1
    call getvtx(keywf, 'INFO_MAILLAGE', iocc=keywfIocc, scal=answer, nbret=nbOcc)
    if (nbOcc .ne. 0) then
        if (answer .eq. 'OUI') then
            if (fileFormat .eq. 'MED') then
                meshMEDInfo = 2
            else
                call utmess('F', 'RESULT3_63')
            endif
        endif
    endif
!
! - Print mesh ?
!
    meshName = ' '
    call getvid(keywf, 'MAILLAGE', iocc=keywfIocc, scal=answer, nbret=nbOcc)
    lMesh = nbOcc .gt. 0
    if (lMesh) then
        meshName = answer
    endif
!
! - For fileFormat = 'ASTER' => only mesh !
!
    if (fileFormat .eq. 'ASTER') then
        if (.not. lMesh) then
            call utmess('F', 'RESULT3_70')
        endif
    endif
!
! - Check consistency of meshes
!
    if (lModel .and. lMesh) then
        call dismoi('NOM_MAILLA', model, 'MODELE', repk=modelMesh, arret='C', ier=iret)
        if (meshName .ne. modelMesh) then
            call utmess('F', 'RESULT3_66')
        endif
    endif
!
! - Generic name of datastructure
!
    dsName = ' '
    if (lResu) then
        dsName = resultName
    elseif (lField) then
        dsName = fieldName
    elseif (lMesh) then

    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Generate title and print it for RESULTAT and IDEAS
!
    call irtitr(lResu     , lField  ,&
                dsName    , meshName,&
                fileFormat, fileUnit,&
                title)
!
! - Print mesh
!
    if (lMesh) then
        call irmail(fileFormat , fileUnit  , fileVersion,&
                    meshName   , lModel    , model      ,&
                    meshMEDInfo, realFormat)
    endif
!
! - What to print ? Components, parameters and storing index
!
    call irchor(keywf      , keywfIocc    ,&
                dsName     , lResu        , lField,&
                fieldListNb, fieldListType, fieldMedListType,&
                storeListNb, storeListIndx,&
                paraListNb , paraListName ,&
                cmpListNb  , cmpListName  ,&
                iret)
    if (iret .ne. 0) goto 99
!
! - What to print ? Topological entities (nodes/cells)
!
    call irtopo(keywf     , keywfIocc   ,&
                dsName    , lResu       , lField,&
                cellListNb, cellListNume,&
                nodeListNb, nodeListNume,&
                fileFormat, fileUnit    ,&
                iret)
    if (iret .ne. 0) goto 99
! 
! - What to print ? Extremas values
!
    call irextv(fileFormat,&
                keywf     , keywfIocc,&
                lResu     , lField   ,&
                lmax      , lmin     ,&
                lsup      , borsup   ,&
                linf      , borinf)
!
! - Type of field for GMSH
!
    fieldGsmh = ' '
    if ((lField.or.lResu) .and. fileFormat .eq. 'GMSH' .and. fileVersion .ge. 2) then
        call getvtx(keywf, 'TYPE_CHAM', iocc=keywfIocc, scal=fieldGsmh, nbret=nbOcc)
    endif
!
! - Get IMPR_NOM_VARI
!
    answer = ' '
    call getvtx(keywf, 'IMPR_NOM_VARI', iocc=keywfIocc, scal=answer, nbret=nbOcc)
    lVariName = answer .eq. 'OUI'
!
! - Debug
!
    if (ASTER_FALSE) then
        call irdebg(dsName,&
                  fileFormat, fileUnit, fileVersion,&
                  lResu, lMesh, lField,&
                  lMeshCoor, paraFormat,realFormat,cplxFormat,&
                  lsup, linf, lmax, lmin,&
                  borsup, borinf,&
                  storeListNb, storeListIndx,&
                  fieldListNb, fieldListType, fieldMedListType,&
                  paraListNb, paraListName,&
                  cmpListNb, cmpListName,&
                  nodeListNb, nodeListNume,&
                  cellListNb, cellListNume)
    endif
!
! - Print fields
!
    if (lField .or. lResu) then
        if (fileFormat .eq. 'MED') then
            call iremed(fileUnit   , dsName       , lResu           ,&
                        fieldListNb, fieldListType, fieldMedListType,&
                        storeListNb, storeListIndx,&
                        paraListNb , paraListName ,&
                        cmpListNb  , cmpListName  ,&
                        cellListNb , cellListNume ,&
                        nodeListNb , nodeListNume ,&
                        cplxFormat , lVariName    ,&
                        caraElem)
        elseif (fileFormat .eq. 'GMSH') then
            lFirstOcc = keywfIocc .eq. 1 .and. .not. lMesh
            call irgmsh(dsName, cplxFormat, fileUnit, fieldListNb, fieldListType,&
                        lResu, storeListNb, storeListIndx, cmpListNb, cmpListName,&
                        cellListNb, cellListNume, fileVersion, lFirstOcc, fieldGsmh)
        elseif (fileFormat .eq. 'RESULTAT') then
            call irecri(fileUnit   , dsName       , lResu     ,&
                        keywf      , keywfIocc    ,&
                        storeListNb, storeListIndx,&
                        fieldListNb, fieldListType, realFormat,&
                        paraListNb , paraListName , paraFormat,&
                        cmpListNb  , cmpListName  ,&
                        cellListNb , cellListNume ,&
                        nodeListNb , nodeListNume ,&
                        lMeshCoor  , lmax         , lmin,&
                        lsup       , borsup       ,&
                        linf       , borinf)
        elseif (fileFormat .eq. 'IDEAS') then
            call resuPrintIdeas(fileUnit   , dsName       , lResu     ,&
                                storeListNb, storeListIndx,&
                                fieldListNb, fieldListType,&
                                title      , keywf        , keywfIocc , realFormat ,&
                                cmpListNb  , cmpListName  ,&
                                nodeListNb , nodeListNume ,&
                                cellListNb , cellListNume)
        elseif (fileFormat .eq. 'ASTER') then
! --------- No results !
        else
            ASSERT(ASTER_FALSE)
        endif
    endif
 99 continue
!
! - Clean
!
    AS_DEALLOCATE(vk16 = fieldListType)
    AS_DEALLOCATE(vk80 = fieldMedListType)
    AS_DEALLOCATE(vi = storeListIndx)
    AS_DEALLOCATE(vk16 = paraListName)
    AS_DEALLOCATE(vk8 = cmpListName)
    AS_DEALLOCATE(vi = nodeListNume)
    AS_DEALLOCATE(vi = cellListNume)
!
    call jedema()
end subroutine
