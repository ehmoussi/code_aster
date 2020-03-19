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
subroutine op0150()
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lect58.h"
#include "asterfort/lrcomm.h"
#include "asterfort/lridea.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsexpa.h"
#include "asterfort/rsmode.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
#include "asterfort/resuReadCheckFields.h"
#include "asterfort/resuReadMed.h"
#include "asterfort/resuReadStorageAccess.h"
#include "asterfort/resuReadDebug.h"
#include "asterfort/resuReadCreateREFD.h"
#include "asterfort/resuReadGetParameters.h"
#include "asterfort/resuSaveParameters.h"
#include "asterfort/resuGetLoads.h"
#include "asterfort/resuGetEmpiricParameters.h"
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: storeIndxNb, storeCreaNb, storeTimeNb
    character(len=19) :: storeTime, storeIndx
    character(len=8) :: storeCrit
    real(kind=8) :: storeEpsi
    character(len=4) :: storePara
    character(len=10) :: storeAccess
    integer :: empiNumePlan, empiSnapNb
    character(len=24) :: empiFieldType
    integer :: fieldStoreNb(100)
    character(len=16) :: fieldList(100)
    integer :: nbOcc, iret, iField, fieldNb
    character(len=8) :: resultName, meshAst, model, caraElem, fieldMate
    character(len=8) :: matrRigi, matrMass
    character(len=16) :: nomcmd, resultType2, resultType
    integer :: fileUnit
    character(len=16) :: fileFormat
    character(len=19) :: listLoad
    aster_logical:: lReuse, lLireResu
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call infniv(ifm, niv)
!
! - Initializations
!
    lReuse    = ASTER_FALSE
    lLireResu = ASTER_TRUE
!
! - Get results datastructure
!
    call getres(resultName, resultType2, nomcmd)
    call getvtx(' ', 'TYPE_RESU', scal=resultType, nbret=nbOcc)
    ASSERT(resultType .eq. resultType2)
!
! - Output format
!
    call getvtx(' ', 'FORMAT', scal=fileFormat, nbret=nbOcc)
    ASSERT(nbOcc .eq. 1)
    call getvis(' ', 'UNITE', scal=fileUnit, nbret=nbOcc)
    ASSERT(nbOcc .eq. 1)
!
! - Get list of fields to read
!
    call getfac('FORMAT_MED', nbOcc)
    if (nbOcc .gt. 0) then
        fieldNb = nbOcc
        if (fieldNb .gt. 100) then
            call utmess('F', 'UTILITAI2_86')
        else
            do iField = 1, fieldNb
                call getvtx('FORMAT_MED', 'NOM_CHAM', iocc=iField, scal=fieldList(iField),&
                            nbret=nbOcc)
                ASSERT(nbOcc .eq. 1)
            end do
        endif
    else
        call getvtx(' ', 'NOM_CHAM', nbval=100, vect=fieldList, nbret=fieldNb)
        if (fieldNb .lt. 0) then
            call utmess('F', 'UTILITAI2_86')
        endif
    endif
!
! - Get standard parameters
!
    call resuReadGetParameters(meshAst, model, caraElem, fieldMate)
!
! - Get loads
!
    call resuGetLoads(resultType, listLoad)
!
! - Get parameters for MODE_EMPI
!
    call resuGetEmpiricParameters(resultType  , fieldNb   , fieldList    ,&
                                  empiNumePlan, empiSnapNb, empiFieldType)
!
! - Get storage access from command file
!
    call resuReadStorageAccess(storeAccess, storeCreaNb,&
                               storeIndxNb, storeIndx  ,&
                               storeTimeNb, storeTime  ,&
                               storeEpsi  , storeCrit)
!
! - Create results datastructures
!
    call rscrsd('G', resultName, resultType, storeCreaNb)
!
! - Name of parameter for storage
!
    storePara = 'INST'
    call rsexpa(resultName, 0, 'FREQ', iret)
    if (iret .gt. 0) then
        storePara = 'FREQ'
    endif
!
! - Create .REFD object and save matrices (dynamic results)
!
    matrRigi = ' '
    matrMass = ' '
    if (resultType(1:9) .eq. 'MODE_MECA') then
        call getvid(' ', 'MATR_RIGI', scal=matrRigi, nbret=nbOcc)
        if (nbOcc .eq. 0) then
            matrRigi = ' '
        endif
        call getvid(' ', 'MATR_MASS', scal=matrMass, nbret=nbOcc)
        if (nbOcc .eq. 0) then
            matrMass = ' '
        endif
    endif
    call resuReadCreateREFD(resultName, resultType, matrRigi, matrMass)
!
! - Check if fields are allowed for the result
!
    call resuReadCheckFields(resultName, resultType, fieldNb, fieldList)
!
! - Read 
!
    if (fileFormat .eq. 'IDEAS') then
        call lridea(fileUnit   ,&
                    resultName , resultType ,&
                    model      , meshAst    ,&
                    fieldNb    , fieldList  ,&
                    storeAccess,&
                    storeIndxNb, storeTimeNb,&
                    storeIndx  , storeTime  ,&
                    storeCrit  , storeEpsi  ,&
                    storePara)
        fieldStoreNb = storeCreaNb
    else if (fileFormat .eq. 'IDEAS_DS58') then
        call lect58(fileUnit   ,&
                    resultName , resultType , meshAst,&
                    fieldNb    , fieldList  ,&
                    storeAccess,&
                    storeIndxNb, storeTimeNb,&
                    storeIndx  , storeTime  ,&
                    storeCrit  , storeEpsi)
        fieldStoreNb = storeCreaNb
    else if (fileFormat .eq. 'MED') then
        call resuReadMed(fileUnit    ,&
                         resultName  ,&
                         model       , meshAst     ,&
                         fieldNb     , fieldList   ,&
                         storeAccess , storeCreaNb ,&
                         storeIndxNb , storeIndx   ,&
                         storeTimeNb , storeTime   ,&
                         storeEpsi   , storeCrit   ,&
                         storePara   , fieldStoreNb)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Save standard parameters in results datastructure
!
    call resuSaveParameters(resultName  , resultType,&
                            model       , caraElem  , fieldMate    , listLoad,&
                            empiNumePlan, empiSnapNb, empiFieldType)
!
! - Non-linear behaviour management
!
    if (resultType .eq. 'EVOL_NOLI') then
        call lrcomm(lReuse, resultName, model, caraElem, fieldMate, lLireResu)
    endif
! 
! - Debug
!
    if (niv .ge. 2) then
        call resuReadDebug(resultName,&
                           fieldNb   , fieldList, fieldStoreNb,&
                           storePara , storeEpsi, storeCrit)
    endif
!
! - Save title
!
    call titre()
!
! - Set same numbering for matrices and nodal field
!
    call rsmode(resultName)
!
    call jedema()
end subroutine
