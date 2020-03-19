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
subroutine resuReadMed(fileUnit    ,&
                       resultName  ,&
                       model       , meshAst     ,&
                       fieldNb     , fieldList   ,&
                       storeAccess , storeCreaNb ,&
                       storeIndxNb , storeIndx   ,&
                       storeTimeNb , storeTime   ,&
                       storeEpsi   , storeCrit   ,&
                       storePara   , fieldStoreNb)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/carcha.h"
#include "asterfort/getvtx.h"
#include "asterfort/lrvema.h"
#include "asterfort/lrvemo.h"
#include "asterfort/lxlgut.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/lrfmed.h"
!
integer, intent(in) :: fileUnit
character(len=8), intent(in) :: resultName
character(len=8), intent(in) :: model, meshAst
integer, intent(in) :: fieldNb
character(len=16), intent(in) :: fieldList(100)
integer, intent(in) :: storeIndxNb, storeTimeNb
character(len=10), intent(in) :: storeAccess
integer, intent(in) :: storeCreaNb
character(len=19), intent(in) :: storeIndx, storeTime
real(kind=8), intent(in) :: storeEpsi
character(len=8), intent(in) :: storeCrit
character(len=4), intent(in) :: storePara
integer, intent(out) :: fieldStoreNb(100)
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! MED format
!
! --------------------------------------------------------------------------------------------------
!
! In  fileUnit         : index of file (logical unit)
! In  resultName       : name of results datastructure
! In  model            : name of model
! In  meshAst          : name of (aster) mesh
! In  fieldNb          : number of fields to read
! In  fieldList        : list of fields to read
! In  storeAccess      : how to access to the storage
! In  storeCreaNb      : number of storage slots to create
! In  storeIndxNb      : number of storage slots given by index (integer)
! In  storeIndx        : name of JEVEUX object to access storage slots given by index (integer)
! In  storeTimeNb      : number of storage slots given by time/freq (real)
! In  storeTime        : name of JEVEUX object to access storage slots given by time/freq (real)
! In  storeEpsi        : tolerance to find time/freq (real)
! In  storeCrit        : type of tolerance to find time/freq (real)
! In  storePara        : name of paremeter to access results (INST or FREQ)
! In  prolz            : flag to have zero everywhere in field
! Out fieldStoreNb     : effective number of fields has been saved
!
! --------------------------------------------------------------------------------------------------
!
    character(len=3) :: prolz
    integer :: iField, nchar, nbOcc, n1, cmpNb
    character(len=16) :: fieldType
    character(len=16), parameter :: keywfact = 'FORMAT_MED'
    character(len=64) :: fieldNameMed
    character(len=8) :: param, resultNameMed, fieldQuantity
    character(len=24) :: option
    character(len=4) :: fieldsupport
    character(len=24) :: cmpAstName, cmpMedName, valk(2)
    character(len=8), pointer :: vCmpAstName(:) => null()
    character(len=16), pointer :: vCmpMedName(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    fieldStoreNb = 0
!
! - Check model
!
    if (model .ne. ' ') then
        call lrvemo(model)
    endif
!
! - To have zero on all field
!
    call getvtx(' ', 'PROL_ZERO', scal=prolz, nbret=nbOcc)
    ASSERT(nbOcc .eq. 1)
!
! - Loop on fields to read
!
    do iField = 1, fieldNb
        fieldType = fieldList(iField)
! ----- Get properties of field
        call carcha(fieldType, fieldQuantity, fieldSupport, option, param)
! ----- Get name of field (MED)
        call getvtx(keywfact, 'NOM_CHAM_MED', iocc=iField, scal=fieldNameMed, nbret=nbOcc)
        if (nbOcc .eq. 0) then
            fieldNameMed = '________________________________________________________________'
            call getvtx(keywfact, 'NOM_RESU', iocc=iField, scal=resultNameMed, nbret=n1)
            nchar = lxlgut(resultNameMed)
            fieldNameMed(1:nchar)    = resultNameMed(1:nchar)
            nchar = lxlgut(fieldType)
            fieldNameMed(9:8+nchar)  = fieldType(1:nchar)
            fieldNameMed(9+nchar:64) = ' '
        endif
! ----- Check mesh (only at first)
        if (iField .eq. 1) then
            call lrvema(meshAst, fileUnit, fieldNameMed)
        endif
! ----- Get list of components
        cmpAstName = '&&OP0192.NOM_CMP'
        cmpMedName = '&&OP0192.NOM_CMP_MED'
        cmpNb      = 0
        call getvtx(keywfact, 'NOM_CMP', iocc=iField, nbval=0, nbret=nbOcc)
        if (nbOcc .lt. 0) then
            cmpNb = -nbOcc
        endif
        call getvtx(keywfact, 'NOM_CMP_MED', iocc=iField, nbval=0, nbret=nbOcc)
        if (-nbOcc .ne. cmpNb) then
            valk(1) = 'NOM_CMP'
            valk(2) = 'NOM_CMP_MED'
            call utmess('F', 'UTILITAI2_95', nk=2, valk=valk)
        endif
        if (cmpNb .gt. 0) then
            call wkvect(cmpAstName, 'V V K8', cmpNb, vk8 = vCmpAstName)
            call getvtx(keywfact, 'NOM_CMP', iocc=iField, nbval=cmpNb,&
                        vect=vCmpAstName, nbret=nbOcc)
            call wkvect(cmpMedName, 'V V K16', cmpNb, vk16 = vCmpMedName)
            call getvtx('FORMAT_MED', 'NOM_CMP_MED', iocc=iField, nbval=cmpNb,&
                        vect=vCmpMedName, nbret=nbOcc)
        endif
! ----- Read field
        call lrfmed(fileUnit            , resultName   , meshAst, &
                    fieldType           , fieldQuantity, fieldSupport, fieldNameMed,&
                    option              , param        , prolz       ,&
                    storeAccess         , storeCreaNb  ,&
                    storeIndxNb         , storeTimeNb  ,&
                    storeIndx           , storeTime    ,&
                    storeCrit           , storeEpsi    , storePara   ,&
                    cmpNb               , cmpAstName   , cmpMedName  ,&
                    fieldStoreNb(iField))
    end do
!
end subroutine
