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
! aslint: disable=W1504
!
subroutine irecri(fileUnit   , dsName        , lResu         ,&
                  titleKeywf , titleKeywfIocc,&
                  storeNb    , storeListIndx ,&
                  fieldListNb, fieldListType ,&
                  paraNb     , paraName      , paraFormat,&
                  cmpUserNb  , cmpUserName   ,&
                  cellUserNb , cellUserNume  ,&
                  nodeUserNb , nodeUserNume  ,&
                  lMeshCoor  , lmax          , lmin,&
                  lsup       , borsup        ,&
                  linf       , borinf        ,&
                  realFormat , cplxFormat)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/dismoi.h"
#include "asterfort/irdepl.h"
#include "asterfort/irchml.h"
#include "asterfort/irpara.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jerecu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsutrg.h"
#include "asterfort/titre2.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
integer, intent(in) :: fileUnit
character(len=*), intent(in) :: dsName, titleKeywf
integer, intent(in) :: titleKeywfIocc
aster_logical, intent(in) :: lResu
integer, intent(in) :: storeNb
integer , pointer :: storeListIndx(:)
integer, intent(in) :: fieldListNb
character(len=*), pointer :: fieldListType(:)
integer, intent(in) :: paraNb
character(len=*), pointer :: paraName(:)
character(len=1), intent(in) :: paraFormat
integer, intent(in) :: cmpUserNb
character(len=8), pointer :: cmpUserName(:)
integer, intent(in) :: nodeUserNb
integer , pointer :: nodeUserNume(:)
integer, intent(in) :: cellUserNb
integer , pointer :: cellUserNume(:)
aster_logical, intent(in) :: lMeshCoor
aster_logical, intent(in) :: lsup, linf, lmax, lmin
real(kind=8), intent(in) :: borsup, borinf
character(len=*), intent(in) :: realFormat, cplxFormat
!
! --------------------------------------------------------------------------------------------------
!
! Print result or field in a file (IMPR_RESU)
!
! Print field or result for 'RESULTAT'
!
! --------------------------------------------------------------------------------------------------
!
! In  fileUnit         : index of file (logical unit)
! In  dsName           : name of datastructure (result or field)
! In  lResu            : flag if datastructure is a result
! In  titleKeywf       : keyword for sub-title
! In  titleKeywfIocc   : index of keyword for sub-title
! In  storeNb          : number of storing slots
! Ptr storeListIndx    : index of storing slots
! In  fieldListNb      : length of list of fields to save
! Ptr fieldListType    : list of fields type to save
! In  paraNb           : number of parameters
! Ptr paraName         : name of parameters
! In  paraFormat       : format to print parameters (FORM_TABL keyword)
!                         'L' => list
!                         'T' => table
!                         'E' => excel
! In  cmpUserNb        : number of components to select
! Ptr cmpUserName      : list of name of components to select
! In  cellUserNb       : number of cells require by user
! Ptr cellUserNume     : list of index of cells require by user
! In  nodeUserNb       : number of nodes require by user
! Ptr nodeUserNume     : list of index of nodes require by user
! In  lMeshCoor        : flag to print coordinates of nodes
! In  lmax             : flag to print maximum value on nodes
! In  lmin             : flag to print minimum value on nodes
! In  lsup             : flag if supremum exists
! In  borsup           : value of supremum
! In  linf             : flag if infinum exists
! In  borinf           : value of infinum
! In  realFormat       : format of real numbers
! In  cplxFormat       : format of complex numbers (IMAG, REAL, PHASE, MODULE or ' ')
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: fieldType
    character(len=19) :: fieldName
    character(len=16) :: resultType
    character(len=4) :: fieldSupport
    character(len=24) :: subtitleJvName
    character(len=8) :: resultName
    integer :: storeIndx, iret, ibid
    integer :: iStore, iField, iLine
    aster_logical :: lordr
    character(len=80), pointer :: titleLine(:) => null()
    integer :: titleLineNb
!
! --------------------------------------------------------------------------------------------------
!
    subtitleJvName = '&&IRECRI.SOUS_TITRE.TITR'
!
! - If result is a result and not a field name
!
    if (lResu) then
        resultName = dsName
    else
        resultName = ' '
    endif
!
! - Print list of parameters for all storing index
!
    call irpara(resultName, fileUnit     ,&
                storeNb   , storeListIndx,&
                paraNb    , paraName     ,&
                paraFormat)
!
! - Loop on storing slots
!
    do iStore = 1, storeNb
        call jemarq()
        call jerecu('V')
        storeIndx = storeListIndx(iStore)
! ----- Order of storing index
        lordr = ASTER_FALSE
        if (lResu) then
            call rsutrg(dsName, storeIndx, iret, ibid)
            if (iret .eq. 0) then
                call utmess('A', 'RESULT3_46', si = storeIndx)
                cycle
            endif
            lordr = ASTER_TRUE
        endif
! ----- Loop on fields
        if (fieldListNb .ne. 0) then
            do iField = 1, fieldListNb
                fieldType = fieldListType(iField)
! ------------- Extract field from results if necessary
                fieldName = ' '
                if (lResu) then
                    call rsexch(' ', resultName, fieldType, storeIndx, fieldName, iret)
                    if (iret .ne. 0) then
                        cycle
                    endif
                    call dismoi('TYPE_RESU', resultName, 'RESULTAT', repk=resultType)
                else
                    fieldName  = dsName
                endif
! ------------- Check support
                call dismoi('TYPE_CHAMP', fieldName, 'CHAMP', repk=fieldSupport)
                if ((fieldSupport .eq. 'NOEU') .or. (fieldSupport(1:2) .eq. 'EL')) then
                else if (fieldSupport .eq. 'CART') then
                    if (.not. lResu) then
                        call utmess('A', 'RESULT3_3')
                        cycle
                    endif
                else
                    if (resultType .eq. 'MODE_GENE' .or. resultType .eq. 'HARM_GENE') then
                        call utmess('A', 'RESULT3_2', sk = fieldType)
                    else
                        call utmess('A', 'RESULT3_1', sk = fieldType)
                    endif
                endif
! ------------- Print list of parameters for this storing index
                if (lordr) then
                    write(fileUnit,'(/,1X,A)') '======>'
                    call irpara(resultName, fileUnit   ,&
                                1         , [storeIndx],&
                                paraNb    , paraName   ,&
                                paraFormat)
                    lordr = ASTER_FALSE
                endif
! ------------- Create subtitle
                if (lResu) then
                    call titre2(dsName    , fieldName, subtitleJvName, titleKeywf, titleKeywfIocc,&
                                realFormat, fieldType, storeIndx)
                else
                    call titre2(dsName    , fieldName, subtitleJvName, titleKeywf, titleKeywfIocc,&
                                realFormat)
                endif
! ------------- Print subtitle
                write(fileUnit,'(/,1X,A)') '------>'
                call jeveuo(subtitleJvName, 'L', vk80 = titleLine)
                call jelira(subtitleJvName, 'LONMAX', titleLineNb)
                write(fileUnit,'(1X,A)') (titleLine(iLine),iLine=1,titleLineNb)
! ------------- Print field
                if (fieldSupport .eq. 'NOEU' .and. nodeUserNb .ge. 0) then
                    call irdepl(fileUnit  ,&
                                fieldType , fieldName   ,&
                                cmpUserNb , cmpUserName ,&
                                nodeUserNb, nodeUserNume,&
                                lMeshCoor , lmax        , lmin,&
                                lsup      , borsup      ,&
                                linf      , borinf      ,&
                                realFormat, cplxFormat)
                else if (fieldSupport(1:2) .eq. 'EL' .and. cellUserNb .ge. 0) then
                    call irchml(fileUnit  ,&
                                fieldType , fieldName   , fieldSupport,&
                                cmpUserNb , cmpUserName ,&
                                cellUserNb, cellUserNume,&
                                nodeUserNb, nodeUserNume,&
                                lMeshCoor , lmax        , lmin,&
                                lsup      , borsup      ,&
                                linf      , borinf      ,&
                                realFormat, cplxFormat)
                endif
            end do
        endif
        call jedema()
    end do
!
! - Clean
!
    call jedetr(subtitleJvName)
!
end subroutine
