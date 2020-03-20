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
! aslint: disable=W1501,W1504,W0413
!
subroutine ircecl(fileUnit    ,&
                  fieldSupport, celd        , realFormat  , cplxFormat,&
                  nodeListNb  , nodeListNume,&
                  cellListNb  , cellListNume,&
                  meshCellNb  , meshCellName, meshNodeName,&
                  lMeshCoor   , meshDimeIn  , meshCoor    ,&
                  connex      , connexLen   ,&
                  cmpCataNb   , cmpCataName ,&
                  cmpListNb   , cmpListIndx ,&
                  cmpVariNb   , cmpVariIndx ,&
                  grelNb      , liel        ,&
                  lielLen     , liliName    ,&
                  lmax        , lmin        ,&
                  lsup        , borsup      ,&
                  linf        , borinf      ,&
                  vale)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8pi.h"
#include "asterc/r8vide.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/dgmode.h"
#include "asterfort/digdel.h"
#include "asterfort/exisdg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/lxlgut.h"
#include "asterfort/nbec.h"
#include "asterfort/utmess.h"
!
integer, intent(in) :: fileUnit
character(len=4), intent(in) :: fieldSupport
integer, pointer :: celd(:)
character(len=8), intent(in) :: realFormat, cplxFormat
integer, intent(in) :: nodeListNb
integer, pointer :: nodeListNume(:)
integer, intent(in) :: cellListNb
integer, pointer :: cellListNume(:)
integer, intent(in) :: meshCellNb
character(len=8), pointer :: meshCellName(:), meshNodeName(:)
aster_logical, intent(in) :: lMeshCoor
integer, intent(in) :: meshDimeIn
real(kind=8), pointer :: meshCoor(:)
integer, intent(in) :: cmpCataNb
character(len=8), pointer :: cmpCataName(:)
integer, intent(in) :: cmpListNb
integer, pointer :: cmpListIndx(:)
integer, intent(in) :: cmpVariNb
integer, pointer :: cmpVariIndx(:)
integer, intent(in) :: grelNb
integer, pointer :: liel(:), lielLen(:)
character(len=19), intent(in) :: liliName
integer, pointer :: connex(:), connexLen(:) 
aster_logical, intent(in) :: lsup, linf, lmax, lmin
real(kind=8),  intent(in) :: borsup, borinf
complex(kind=8), pointer  :: vale(:)
!
! --------------------------------------------------------------------------------------------------
!
! Print results - RESULTAT
!
! Field on cells - Complex
!
! --------------------------------------------------------------------------------------------------
!
! In  fileUnit         : index of file (logical unit)
! In  realFormat       : format of real numbers
! In  cplxFormat       : format of complex numbers (IMAG, REAL, PHASE, MODULE or ' ')
! In  fieldSupport     : cell support of field (NOEU, ELNO, ELEM, ...)
! In  cmpUserNb        : number of components to select
! Ptr cmpUserName      : list of name of components to select
! In  nodeUserNb       : number of nodes require by user
! Ptr nodeUserNume     : list of index of nodes require by user
! In  cellUserNb       : number of cells require by user
! In  cellUserNume     : list of index of cells require by user
! In  nodeListNb       : number of nodes
! Ptr nodeListNume     : pointer to the list of index of nodes
! Ptr nodeListNume     : pointer to the list of name of nodes
! In  lMeshCoor        : flag to print coordinates of nodes
! In  meshDime         : dimension of mesh (2 or 3)
! In  meshCoor         : coordinates of nodes of mesh
! In  cmpCataNb        : maximum number of components in catalog
! Ptr cmpCataName      : pointer to the list of components in catalog
! In  cmpListNb        : number of components
! Ptr cmpUserName      : pointer to the list of name of components
! Ptr cmpUserName      : pointer to the list of index of components
! In  lmax             : flag to print maximum value on nodes
! In  lmin             : flag to print minimum value on nodes
! In  lsup             : flag if supremum exists
! In  borsup           : value of supremum
! In  linf             : flag if infinum exists
! In  borinf           : value of infinum
! Ptr vale             : pointer to the (complex) values
!
! --------------------------------------------------------------------------------------------------
!
    character(len=1), parameter :: meshCmpName(3) = (/'X', 'Y', 'Z'/)
    integer :: ilong, imodel, meshDime
    real(kind=8) :: rundf, value, valmax, valmin, c1
    character(len=3) :: text3
    character(len=8) :: nodeName, variName, blank
    character(len=8) :: fmtText
    character(len=50) :: fmtHead, fmtVal1, fmt1, fmt2, fmt3, fmtVal2, form1
    aster_logical :: limpr
    integer :: iGrel, iVari, iCell, iForm, iNode, iLayer, iNodeList
    integer :: iCmpList, iCmpVari, iCmpCata, iCmpActi, iCmp
    integer :: i2, iachml, iad, iadr
    integer :: icomp2, iBegin, iel, grelElem, iEnd
    integer :: ilign, irest
    integer :: cmpNume, cellNume, grelNume, cmpListNume, nodeNume, cmpCataNume
    integer :: ipca, ipoin, ipoin1
    integer :: j, fmtLen, mode, modsau
    integer :: nbcpt, nbNode, nbCmpActi, nbCmpVale, nbLayer, nec, nbCmp
    integer :: npcalc, nbScal, modeNbScal
    integer :: nbVariMaxi, nbCell, nbVariActi, nbVariCell
    integer, pointer :: inec(:) => null()
    integer, pointer :: repe(:) => null()
    integer, pointer :: locatedCmp(:) => null()
    real(kind=8), pointer :: valeReal(:) => null()
    real(kind=8), pointer :: valeImag(:) => null()
    real(kind=8), pointer :: valeComp(:) => null()
    integer, pointer :: valeIndx(:) => null()
    real(kind=8), pointer :: valeMaxReal(:) => null()
    real(kind=8), pointer :: valeMaxImag(:) => null()
    character(len=8), pointer :: valeMaxElem(:) => null()
    integer, pointer :: valeMaxNb(:) => null()
    real(kind=8), pointer :: valeMinReal(:) => null()
    real(kind=8), pointer :: valeMinImag(:) => null()
    character(len=8), pointer :: valeMinElem(:) => null()
    integer, pointer :: valeMinNb(:) => null()
    character(len=16), pointer :: cmpNameMinMax(:) => null()
    character(len=16), pointer :: cmpName(:) => null()
    integer, pointer :: cmpInPhys(:) => null()
    integer, pointer :: cmpInVale(:) => null()
    integer, pointer :: valeSupIndx(:) => null()
    character(len=16), pointer :: valeSupName(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    c1     = 180.d0/r8pi()
    blank  = '        '
    rundf  = r8vide()
    fmtLen = lxlgut(realFormat)
!
! - Get length of text format from description of real format (to align !)
! - Ex realFormat = '1PE12.3' => fmtText = 'A12'. By default => 'A12'
!
    iBegin = 0
    iEnd   = 0
    do iForm = 1, fmtLen - 1
        if (realFormat(iForm:iForm) .eq. 'D' .or. realFormat(iForm:iForm) .eq. 'E' .or.&
            realFormat(iForm:iForm) .eq. 'F' .or. realFormat(iForm:iForm) .eq. 'G') then
            iBegin = iForm + 1
            cycle
        endif
        if (realFormat(iForm:iForm) .eq. '.') then
            iEnd = iForm - 1
            cycle
        endif
    end do
    if (iBegin .ne. 0 .and. iEnd .ge. iBegin) then
        fmtText = 'A'//realFormat(iBegin:iEnd)
    else
        fmtText = 'A12'
    endif

    meshDime = meshDimeIn
    if (fieldSupport .eq. 'ELGA' .or. fieldSupport .eq. 'ELEM' .or. .not.lMeshCoor) then
        meshDime = 0
    endif
    nbCell = meshCellNb
    if (cellListNb .ne. 0) then
        nbCell = cellListNb
    endif
!
! - Maximum of components for internal state variable (dynamic)
!
    nbVariMaxi = 0
    do iGrel = 1, grelNb
        nbVariCell = max(1, celd(4))
        if (nbVariCell .gt. nbVariMaxi) then
            nbVariMaxi = nbVariCell
        endif
    end do
    ASSERT(nbVariMaxi .gt. 0)
!
! - Effective number of components for internal state variable (dynamic)
!
    nbVariActi = cmpVariNb
    if (cmpVariNb .gt. 0) then
        nbVariActi = 0
        do iCmpVari = 1, cmpVariNb
            if (cmpVariIndx(iCmpVari) .le. nbVariMaxi) then
                nbVariActi = nbVariActi + 1
            else
                call codent(cmpVariIndx(iCmpVari), 'G', text3)
                variName = 'V'//text3
                call utmess('A', 'RESULT3_13', sk=variName)
            endif
        end do
        if (nbVariActi .eq. 0) then
            call utmess('A', 'PREPOST_75')
            goto 999
        endif
        nbVariMaxi = nbVariActi
    endif
!
! - Name of components for MAX and MIN
!
    if (lmax .or. lmin) then
        AS_ALLOCATE(vk16 = cmpNameMinMax, size = cmpCataNb*nbVariMaxi)
        do iCmpCata = 1, cmpCataNb
            if (nbVariMaxi .gt. 1 .or. nbVariActi .ge. 1) then
                do iVari = 1, nbVariMaxi
                    if (nbVariActi .gt. 0) then
                        call codent(cmpVariIndx(iVari), 'G', text3)
                    else
                        call codent(iVari, 'G', text3)
                    endif
                    cmpNameMinMax((iCmpCata-1)*nbVariMaxi+iVari) = 'V'//text3
                end do
            else
                cmpNameMinMax(iCmpCata) = cmpCataName(iCmpCata)
            endif
        end do
    endif
!
! - Allocate objects for MINMAX
!
    if (lmax) then
        AS_ALLOCATE(vr = valeMaxReal, size = cmpCataNb*nbVariMaxi)
        AS_ALLOCATE(vr = valeMaxImag, size = cmpCataNb*nbVariMaxi)
        AS_ALLOCATE(vk8 = valeMaxElem, size = cmpCataNb*nbVariMaxi)
        AS_ALLOCATE(vi = valeMaxNb, size = cmpCataNb*nbVariMaxi)
        valeMaxReal = rundf
    endif
    if (lmin) then
        AS_ALLOCATE(vr = valeMinReal, size = cmpCataNb*nbVariMaxi)
        AS_ALLOCATE(vr = valeMinImag, size = cmpCataNb*nbVariMaxi)
        AS_ALLOCATE(vk8 = valeMinElem, size = cmpCataNb*nbVariMaxi)
        AS_ALLOCATE(vi = valeMinNb, size = cmpCataNb*nbVariMaxi)
        valeMinReal = rundf
    endif
!
! - Access to physical quantity
!
    call jeveuo('&CATA.TE.MODELOC', 'L', imodel)
    call jeveuo(jexatr('&CATA.TE.MODELOC', 'LONCUM'), 'L', ilong)
    call jeveuo(liliName//'.REPE', 'L', vi = repe)
!
! - Main loop on elements
!
    modsau = 0
    do iCell = 1, nbCell
! ----- Current cell
        if (cellListNb .eq. 0) then
            cellNume = iCell
        else
            cellNume = cellListNume(iCell)
        endif
! ----- Get position in the GREL
        grelNume = repe(2*(cellNume-1)+1)
        if (grelNume .eq. 0) cycle
        grelElem = repe(2*(cellNume-1)+2)
! ----- Get located components scheme
        mode = celd(celd(4+grelNume)+2)
        if (mode .eq. 0) cycle
        if (mode .ne. modsau) then
! --------- Access to properties of physical quantity
            call jeveuo(jexnum('&CATA.TE.MODELOC', mode), 'L', vi = locatedCmp)
            nec = nbec(locatedCmp(2))
            AS_ALLOCATE(vi = inec, size = nec)
            call dgmode(mode, imodel, ilong, nec, inec)
            modeNbScal = digdel(mode)
! --------- Access to properties of cell
            iad        = celd(celd(4+grelNume)+8)
            nbVariCell = max(1,celd(4))
            nbScal     = modeNbScal*nbVariCell
            nbCmp      = nbVariCell
            if (nbVariActi .gt. 0) then
                nbCmp = nbVariActi
            endif
            nbCmpActi = 0
            ipoin1 = lielLen(grelNume)
! --------- Allocate working objects
            AS_ALLOCATE(vi = cmpInPhys, size = cmpCataNb*nbCmp)
            AS_ALLOCATE(vi = cmpInVale, size = cmpCataNb*nbCmp)
            AS_ALLOCATE(vk16 = cmpName, size = cmpCataNb*nbCmp)
            AS_ALLOCATE(vr = valeComp, size = cmpCataNb*nbCmp)
            AS_ALLOCATE(vr = valeReal, size = cmpCataNb*nbCmp)
            AS_ALLOCATE(vr = valeImag, size = cmpCataNb*nbCmp)
            AS_ALLOCATE(vi = valeIndx, size = cmpCataNb*nbCmp)
            if (lsup .or. linf) then
                AS_ALLOCATE(vk16 = valeSupName, size = cmpCataNb*nbCmp)
                AS_ALLOCATE(vi = valeSupIndx, size = cmpCataNb*nbCmp)
            endif
! --------- Select components
            nbCmpVale = 0
            do iCmpCata = 1, cmpCataNb
                cmpCataNume = iCmpCata
                if (exisdg(inec, cmpCataNume)) then
                    nbCmpVale = nbCmpVale + 1
                    if (cmpListNb .ne. 0) then
! --------------------- Select components from user
                        do iCmpList = 1, cmpListNb
                            cmpListNume = cmpListIndx(iCmpList)
                            if (cmpCataNume .eq. cmpListNume) then
                                nbCmpActi = nbCmpActi+1
                                do iCmp = 1, nbCmp
                                    cmpInPhys((iCmpList-1)*nbCmp+iCmp) = cmpCataNume
                                end do
                                cmpInVale(iCmpList) = nbCmpVale
                            endif
                        end do
                    else
! --------------------- Select all components
                        do iCmp = 1, nbCmp
                            cmpInPhys((nbCmpVale-1)*nbCmp+iCmp) = cmpCataNume
                        end do
                    endif
                endif
            end do
            if (cmpListNb .eq. 0) then
                nbCmpActi = nbCmpVale
            endif
            npcalc = modeNbScal/nbCmpVale
! --------- Retassage
            if (cmpListNb .ne. 0) then
                i2 = 0
                do iCmp = 1, cmpListNb*nbCmp
                    if (cmpInPhys(iCmp) .ne. 0) then
                        i2=i2+1
                        cmpInPhys(i2)= cmpInPhys(iCmp)
                    endif
                end do
            endif
! --------- Save names of components
            do iCmpActi = 1, nbCmpActi
                if (nbCmp .gt. 1 .or. nbVariActi .ge. 1) then
                    do iCmp = 1, nbCmp
                        if (nbVariActi .gt. 0) then
                            call codent(cmpVariIndx(iCmp), 'G', text3)
                        else
                            call codent(iCmp, 'G', text3)
                        endif
                        cmpName((iCmpActi-1)*nbCmp+iCmp) = 'V'//text3
                    end do
                else
                    cmpName(iCmpActi) = cmpCataName(cmpInPhys(iCmpActi))
                endif
            end do
! --------- Prepare Fortran FORMAT
            if (.not.lmax .and. .not.lmin) then
                ilign = (nbCmpActi*nbCmp+meshDime)/6
                irest = (nbCmpActi*nbCmp+meshDime)-ilign*6
                fmtHead = ' '
                fmtVal1 = ' '
                fmtVal2 = ' '
                if (irest .ne. 0) then
! ----------------- Incomplete line
                    fmtHead = '(1X,A8,6(1X,'//fmtText//'),30(/,9X,6(1X,'//fmtText//')))'
                    if (fieldSupport .eq. 'ELNO') then
                        fmtVal1 = '(1X,A8,6(1X, '//realFormat//&
                                  '),30(/, 9X, 6(1X,'//realFormat//')))'
                    else if (fieldSupport.eq.'ELGA') then
                        fmtVal1 = '(2X,I7,6(1X, '//realFormat//&
                                  '), 30(/, 9X, 6(1X,'//realFormat//')))'
                        fmtVal2 = '(9X,6(1X, '//realFormat//&
                                  '), 30(/, 9X, 6(1X,'//realFormat//')))'
                    else if (fieldSupport.eq.'ELEM') then
                        fmtVal1 = '(9X,6(1X,'//realFormat//&
                                  '), 30(/, 9X, 6(1X,'//realFormat//')))'
                        fmtVal2 = '(9X,6(1X, '//realFormat//&
                                  '), 30(/, 9X, 6(1X,'//realFormat//')))'
                    endif
                else if (irest .eq. 0 .and. ilign .eq. 1) then
! ----------------- Complete first line
                    fmtHead = '(1X,A8,6(1X,'//fmtText//'))'
                    if (fieldSupport .eq. 'ELNO') then
                        fmtVal1 = '(1X,A8,6(1X,'//realFormat//'))'
                    else if (fieldSupport .eq. 'ELGA') then
                        fmtVal1 = '(2X,I7,6(1X,'//realFormat//'))'
                        fmtVal2 = '(9X,6(1X,'//realFormat//'))'
                    else if (fieldSupport .eq. 'ELEM') then
                        fmtVal1 = '(9X,6(1X,'//realFormat//'))'
                        fmtVal2 = '(9X,6(1X,'//realFormat//'))'
                    endif
                else
                    write(fmtHead,'(A,A8,A,I2,A,A8,A)') '(1X,A8,6(1X,',fmtText, '),',&
                                                        (ilign-1),'(/,9X,6(1X,',fmtText,')))'
                    if (fieldSupport .eq. 'ELNO') then
                        write(fmtVal1,'(A,A10,A,I2,A,A10,A)') '(1X,A8,6(1X,',realFormat,'),',&
                                                              (ilign-1),&
                                                              '(/,9X,6(1X,',realFormat,')))'
                    else if (fieldSupport .eq. 'ELGA') then
                        write(fmtVal1,'(A,A10,A,I2,A,A10,A)') '(2X,I7,6(1X,',realFormat,'),',&
                                                              (ilign-1),&
                                                              '(/,9X,6(1X,',realFormat,')))'
                        write(fmtVal2,'(A,A10,A,I2,A,A10,A)') '(9X,6(1X,',realFormat,'),',&
                                                              (ilign-1),&
                                                              '(/,9X,6(1X,',realFormat,')))'
                    else if (fieldSupport .eq. 'ELEM') then
                        write(fmtVal1,'(A,A10,A,I2,A,A10,A)') '(9X,6(1X,',realFormat,'),',&
                                                               (ilign-1),&
                                                               '(/,9X,6(1X,',realFormat,')))'
                        write(fmtVal2,'(A,A10,A,I2,A,A10,A)') '(9X,6(1X,',realFormat,'),',&
                                                               (ilign-1),&
                                                              '(/,9X,6(1X,',realFormat,')))'
                    endif
                endif
            endif
        endif
! ----- Loop on elements
        iel   = liel(ipoin1+grelElem-1)
        limpr = .true.
! ----- Print head
        if (.not.lsup .and. .not.linf .and. .not.lmax .and. .not.lmin) then
            if (meshDime .eq. 0) then
                write(fileUnit,fmtHead) meshCellName(iel),&
                                        (cmpName(iCmp)(1:11), iCmp=1,nbCmp*nbCmpActi)
            else
                write(fileUnit,fmtHead) meshCellName(iel),&
                                        (meshCmpName(iCmp),iCmp=1,meshDime),&
                                        (cmpName(iCmp)(1:11),iCmp=1,nbCmp*nbCmpActi)
            endif
        endif
        iachml = iad + nbScal * (grelElem-1)
! ----- Field support: ELGA/ELEM
        if (fieldSupport .eq. 'ELGA' .or. fieldSupport .eq. 'ELEM') then
            do ipca = 1, npcalc
                j = iachml-1+nbCmpVale*nbVariCell*(ipca-1)
                if (cmpListNb .eq. 0) then
                    do iCmpActi = 1, nbCmpActi
                        if (nbVariActi .gt. 0) then
                            do iCmp = 1, nbCmp
                                valeReal((iCmpActi-1)*nbCmp+iCmp) = &
                                    dble(vale(j+iCmpActi+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                valeImag((iCmpActi-1)*nbCmp+iCmp) = &
                                    dimag(vale(j+iCmpActi+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                valeIndx((iCmpActi-1)*nbCmp+iCmp) = &
                                    iCmp
                                if (cplxFormat .eq. 'MODULE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = &
                                        abs(vale(j+iCmpActi+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                elseif (cplxFormat .eq. 'PHASE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = atan2(&
                                        dble(vale(j+iCmpActi+(cmpVariIndx(iCmp)-1)*nbCmpVale)),&
                                        dimag(vale(j+iCmpActi+(cmpVariIndx(iCmp)-1)*nbCmpVale)))*c1
                                endif
                            end do
                        else
                            do iCmp = 1, nbCmp
                                valeReal((iCmpActi-1)*nbCmp+iCmp) = &
                                    dble(vale(j+iCmpActi+(iCmp-1)*nbCmpVale))
                                valeImag((iCmpActi-1)*nbCmp+iCmp) = &
                                    dimag(vale(j+iCmpActi+(iCmp-1)*nbCmpVale))
                                valeIndx((iCmpActi-1)*nbCmp+iCmp) = &
                                    iCmp
                                if (cplxFormat .eq. 'MODULE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = &
                                        abs(vale(j+iCmpActi+(iCmp-1)*nbCmpVale))
                                elseif (cplxFormat .eq. 'PHASE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = atan2(&
                                        dble(vale(j+iCmpActi+(iCmp-1)*nbCmpVale)),&
                                        dimag(vale(j+iCmpActi+(iCmp-1)*nbCmpVale)))*c1
                                endif
                            end do
                        endif
                    end do
                else
                    do iCmpActi = 1, nbCmpActi
                        cmpNume=cmpInVale(iCmp)
                        if (nbVariActi .gt. 0) then
                            do iCmp = 1, nbCmp
                                valeReal((iCmpActi-1)*nbCmp+iCmp) = &
                                    dble(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                valeImag((iCmpActi-1)*nbCmp+iCmp) = &
                                    dimag(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                valeIndx((iCmpActi-1)*nbCmp+iCmp) = &
                                    iCmp
                                if (cplxFormat .eq. 'MODULE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = &
                                        abs(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                elseif (cplxFormat .eq. 'PHASE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = atan2(&
                                        dble(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale)),&
                                        dimag(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale)))*c1
                                endif
                            end do
                        else
                            do iCmp = 1, nbCmp
                                valeReal((iCmpActi-1)*nbCmp+iCmp) = &
                                    dble(vale(j+cmpNume+(iCmp-1)*nbCmpVale))
                                valeImag((iCmpActi-1)*nbCmp+iCmp) = &
                                    dimag(vale(j+cmpNume+(iCmp-1)*nbCmpVale))
                                valeIndx((iCmpActi-1)*nbCmp+iCmp) = &
                                    iCmp
                                if (cplxFormat .eq. 'MODULE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = &
                                        abs(vale(j+cmpNume+(iCmp-1)*nbCmpVale))
                                elseif (cplxFormat .eq. 'PHASE') then
                                    valeComp((iCmpActi-1)*nbCmp+iCmp) = atan2(&
                                        dble(vale(j+cmpNume+(iCmp-1)*nbCmpVale)),&
                                        dimag(vale(j+cmpNume+(iCmp-1)*nbCmpVale)))*c1
                                endif
                            end do
                        endif
                    end do
                endif
! ------------- Select values between given boundaries
                if (lsup .or. linf) then
! ----------------- Désactivation des composantes en dehors des bornes
                    do iCmpActi = 1, nbCmp*nbCmpActi
                        value = sqrt(valeReal(iCmpActi)**2+valeImag(iCmpActi)**2)
                        if (lsup) then
                            if ((value-borsup) .gt. 0.d0) valeIndx(iCmpActi)= 0
                        endif
                        if (linf) then
                            if ((value-borinf) .lt. 0.d0) valeIndx(iCmpActi)= 0
                        endif
                    end do
! ----------------- Tassage
                    icomp2 = 0
                    do iCmpActi = 1, nbCmp*nbCmpActi
                        if (valeIndx(iCmpActi) .ne. 0) then
                            icomp2=icomp2+1
                            valeIndx(icomp2)    = valeIndx(iCmpActi)
                            valeSupIndx(icomp2) = cmpInPhys(iCmpActi)
                            valeReal(icomp2)    = valeReal(iCmpActi)
                            valeImag(icomp2)    = valeImag(iCmpActi)
                            valeSupName(icomp2) = cmpName(iCmpActi)
                            valeComp(icomp2)    = valeComp(iCmpActi)
                        endif
                    end do
                    if (icomp2 .eq. 0) goto 16
! ----------------- Print in file
                    if (.not.lmax .and. .not.lmin) then
                        ilign = (icomp2)/6
                        irest = (icomp2)-ilign*6
                        fmt1  = ' '
                        fmt2  = ' '
                        fmt3  = ' '
                        if (fieldSupport .eq. 'ELGA') then
                            if (irest .ne. 0) then
                                fmt1 = '(9X,6(1X,'//fmtText//'),30(/,9X,6(1X,'//fmtText//')))'
                                fmt2 = '(2X,I7,6(1X,'//realFormat&
                                        //'),30(/,9X,6(1X,'//realFormat//')))'
                                fmt3 = '(9X,6(1X,'//realFormat//'),30(/,9X,6(1X,'//realFormat//')))'
                            else if (irest.eq.0.and.ilign.eq.1) then
                                fmt1 = '(9X,6(1X,'//fmtText//'))'
                                fmt2 = '(2X,I7,6(1X,'//realFormat//'))'
                                fmt3 = '(9X,6(1X,'//realFormat//'))'
                            else
                                write(fmt1,'(A,A8,A,I2,A,A8,A)')   '(1X,A8,6(1X,',fmtText,'),',&
                                                                   (ilign-1),&
                                                                   '(/,9X,6(1X,',fmtText,')))'
                                write(fmt2,'(A,A10,A,I2,A,A10,A)') '(2X,I7,6(1X,',realFormat,'),',&
                                                                   (ilign-1),&
                                                                   '(/,9X,6(1X,',realFormat,')))'
                                write(fmt3,'(A,A10,A,I2,A,A10,A)') '(9X,6(1X,',realFormat,'),',&
                                                                   (ilign-1),&
                                                                   '(/,9X,6(1X,',realFormat,')))'
                            endif
                        else
                            if (irest .ne. 0) then
                                fmt1 = '(9X,6(1X,'//fmtText//'),30(/,9X,6(1X,'//fmtText//')))'
                                fmt2 = '(9X,6(1X,'//realFormat//'),30(/,9X,6(1X,'//realFormat//')))'
                                fmt3 = '(9X,6(1X,'//realFormat//'),30(/,9X,6(1X,'//realFormat//')))'
                            else if (irest.eq.0.and.ilign.eq.1) then
                                fmt1 = '(9X,6(1X,'//fmtText//'))'
                                fmt2 = '(9X,6(1X,'//realFormat//'))'
                                fmt3 = '(9X,6(1X,'//realFormat//'))'
                            else
                                write(fmt1,'(A,A8,A,I2,A,A8,A)')   '(1X,A8,6(1X,',fmtText,'),',&
                                                                   (ilign-1),&
                                                                   '(/,9X,6(1X,',fmtText,')))'
                                write(fmt2,'(A,A10,A,I2,A,A10,A)') '(9X,6(1X,',realFormat,'),',&
                                                                   (ilign-1),&
                                                                   '(/,9X,6(1X,',realFormat,')))'
                                write(fmt3,'(A,A10,A,I2,A,A10,A)') '(9X,6(1X,',realFormat,'),',&
                                                                   (ilign-1),&
                                                                   '(/,9X,6(1X,',realFormat,')))'
                            endif
                        endif
                        if (limpr) then
                            write(fileUnit,'(A,I2,A)') meshCellName(iel)
                            limpr = ASTER_FALSE
                        endif
                        write(fileUnit,fmt1) (valeSupName(iCmp)(1:11),iCmp=1,icomp2)
                        if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                            write(fileUnit,fmt2) ipca,(valeReal(icmp),icmp=1,icomp2)
                        endif
                        if (cplxFormat .eq. ' ') then
                            write(fileUnit,fmt3) (valeImag(icmp),icmp=1,icomp2)
                        endif
                        if (cplxFormat .eq. 'IMAG') then
                            write(fileUnit,fmt2) ipca,(valeImag(icmp),icmp=1,icomp2)
                        endif
                        if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                            write(fileUnit,fmt2) ipca,(valeComp(icmp),icmp=1,icomp2)
                        endif
                    endif
                    nbcpt = icomp2
                else
                    if (.not.lmax .and. .not.lmin) then
                        if (fieldSupport .eq. 'ELGA') then
                            if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                                write(fileUnit,fmtVal1) ipca,(valeReal(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                            if (cplxFormat .eq. ' ') then
                                write(fileUnit,fmtVal2) (valeImag(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                            if (cplxFormat .eq. 'IMAG') then
                                write(fileUnit,fmtVal1) ipca,(valeImag(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                            if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                                write(fileUnit,fmtVal1) ipca,(valeComp(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                        else
                            if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                                write(fileUnit,fmtVal1) (valeReal(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                            if (cplxFormat .eq. ' ') then
                                write(fileUnit,fmtVal1) (valeImag(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                            if (cplxFormat .eq. 'IMAG') then
                                write(fileUnit,fmtVal1) (valeImag(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                            if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                                write(fileUnit,fmtVal1) (valeComp(icmp),icmp=1,nbCmp*nbCmpActi)
                            endif
                        endif
                    endif
                    nbcpt = nbCmp*nbCmpActi
                endif
! ------------- Look for maximal value
                if (lmax) then
                    do iCmpList = 1, nbcpt
                        if (lsup .or. linf) then
                            iadr=(valeSupIndx(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                        else
                            iadr=(cmpInPhys(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                        endif
                        if (valeMaxReal(iadr) .eq. rundf) then
                            valeMaxReal(iadr) = valeReal(iCmpList)
                            valeMaxImag(iadr) = valeImag(iCmpList)
                            valeMaxElem(iadr) = meshCellName(iel)
                            valeMaxNb(iadr)   = 1
                        else
                            valmax = sqrt( valeMaxReal(iadr)**2 + valeMaxImag(iadr)**2)
                            value  = sqrt(valeReal(iCmpList)**2 + valeImag(iCmpList)**2)
                            if (value .gt. valmax) then
                                valeMaxReal(iadr) = valeReal(iCmpList)
                                valeMaxImag(iadr) = valeImag(iCmpList)
                                valeMaxElem(iadr) = meshCellName(iel)
                                valeMaxNb(iadr)   = 1
                            else if (value .eq. valmax) then
                                valeMaxNb(iadr)   = valeMaxNb(iadr)+1
                            endif
                        endif
                    end do
                endif
! ------------- Look for minimal value
                if (lmin) then
                    do iCmpList = 1, nbcpt
                        if (lsup .or. linf) then
                            iadr=(valeSupIndx(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                        else
                            iadr=(cmpInPhys(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                        endif
                        if (valeMaxReal(iadr) .eq. rundf) then
                            valeMaxReal(iadr) = valeReal(iCmpList)
                            valeMaxImag(iadr) = valeImag(iCmpList)
                            valeMinElem(iadr) = meshCellName(iel)
                            valeMinNb(iadr)   = 1
                        else
                            valmin = sqrt( valeMaxReal(iadr)**2 + valeMaxImag(iadr)**2)
                            value = sqrt(valeReal(iCmpList)**2 + valeImag(iCmpList)**2)
                            if (value .lt. valmin) then
                                valeMaxReal(iadr) = valeReal(iCmpList)
                                valeMaxImag(iadr) = valeImag(iCmpList)
                                valeMinElem(iadr) = meshCellName(iel)
                                valeMinNb(iadr)   = 1
                            else if (value .eq. valmin) then
                                valeMinNb(iadr)   = valeMinNb(iadr)+1
                            endif
                        endif
                    end do
                endif
 16             continue
            end do
! ----- Field support: ELNO
        else if (fieldSupport.eq.'ELNO') then
            ipoin   = connexLen(iel)
            nbNode  = connexLen(iel+1)-ipoin
            nbLayer = npcalc/nbNode
            do iLayer = 1, nbLayer
                if (nbLayer .gt. 1) then
                    if (.not.lmax .and. .not.lmin) then
                        if (nbLayer .eq. 2) then
                            if (iLayer .eq. 1) write(fileUnit,'(A)') ' PEAU INTERNE'
                            if (iLayer .eq. 2) write(fileUnit,'(A)') ' PEAU EXTERNE'
                        else
                            write(fileUnit,'(A,I3)') ' COUCHE NUMERO:',iLayer
                        endif
                    endif
                endif
                do iNode = 1, nbNode
                    nodeNume = connex(ipoin-1+iNode)
                    if (nodeListNb .ne. 0) then
                        do iNodeList = 1, nodeListNb
                            if (nodeNume .eq. nodeListNume(iNodeList)) exit
                        end do
                        cycle
                    endif
                    nodeName = meshNodeName(nodeNume)
                    j        = iachml-1+nbCmpVale*nbVariCell*(iNode-1)+&
                               (iLayer-1)*nbCmpVale*nbVariCell*nbNode
                    if (cmpListNb .eq. 0) then
                        do iCmpList = 1, nbCmpActi
                            if (nbVariActi .gt. 0) then
                                do iCmp = 1, nbCmp
                                    valeReal((iCmpList-1)*nbCmp+iCmp) = &
                                        dble(vale(j+iCmpList+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                    valeImag((iCmpList-1)*nbCmp+iCmp) = &
                                        dimag(vale(j+iCmpList+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                    valeIndx((iCmpList-1)*nbCmp+iCmp) = &
                                        iCmp
                                    if (cplxFormat .eq. 'MODULE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = &
                                            abs(vale(j+iCmpList+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                    elseif (cplxFormat .eq. 'PHASE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = atan2(&
                                            dble(vale(j+iCmpList+(cmpVariIndx(iCmp)-1)*nbCmpVale)),&
                                        dimag(vale(j+iCmpList+(cmpVariIndx(iCmp)-1)*nbCmpVale)))*c1
                                    endif
                                end do
                            else
                                do iCmp = 1, nbCmp
                                    valeReal((iCmpList-1)*nbCmp+iCmp) = &
                                        dble(vale(j+iCmpList+(iCmp-1)*nbCmpVale))
                                    valeImag((iCmpList-1)*nbCmp+iCmp) = &
                                        dimag(vale(j+iCmpList+(iCmp-1)*nbCmpVale))
                                    valeIndx((iCmpList-1)*nbCmp+iCmp) = &
                                        iCmp
                                    if (cplxFormat .eq. 'MODULE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = &
                                            abs(vale(j+iCmpList+(iCmp-1)*nbCmpVale))
                                    elseif (cplxFormat .eq. 'PHASE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = atan2(&
                                            dble(vale(j+iCmpList+(iCmp-1)*nbCmpVale)),&
                                            dimag(vale(j+iCmpList+(iCmp-1)*nbCmpVale)))*c1
                                    endif
                                end do
                            endif
                        end do
                    else
                        do iCmpList = 1, nbCmpActi
                            cmpNume = cmpInVale(iCmpList)
                            if (nbVariActi .gt. 0) then
                                do iCmp = 1, nbCmp
                                    valeReal((iCmpList-1)*nbCmp+iCmp) = &
                                        dble(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                    valeImag((iCmpList-1)*nbCmp+iCmp) = &
                                        dimag(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                    valeIndx((iCmpList-1)*nbCmp+iCmp) = &
                                        iCmp
                                    if (cplxFormat .eq. 'MODULE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = &
                                            abs(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale))
                                    elseif (cplxFormat .eq. 'PHASE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = atan2(&
                                            dble(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale)),&
                                        dimag(vale(j+cmpNume+(cmpVariIndx(iCmp)-1)*nbCmpVale)))*c1
                                    endif
                                end do
                            else
                                do iCmp = 1, nbCmp
                                    valeReal((iCmpList-1)*nbCmp+iCmp) = &
                                        dble(vale(j+cmpNume+(iCmp-1)*nbCmpVale))
                                    valeImag((iCmpList-1)*nbCmp+iCmp) = &
                                        dimag(vale(j+cmpNume+(iCmp-1)*nbCmpVale))
                                    valeIndx((iCmpList-1)*nbCmp+iCmp) = &
                                        iCmp
                                    if (cplxFormat .eq. 'MODULE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = &
                                            abs(vale(j+cmpNume+(iCmp-1)*nbCmpVale))
                                    elseif (cplxFormat .eq. 'PHASE') then
                                        valeComp((iCmpList-1)*nbCmp+iCmp) = atan2(&
                                            dble(vale(j+cmpNume+(iCmp-1)*nbCmpVale)),&
                                            dimag(vale(j+cmpNume+(iCmp-1)*nbCmpVale)))*c1
                                    endif
                                end do
                            endif
                        end do
                    endif
! ----------------- Print values between given boundaries
                    if (lsup .or. linf) then
! --------------------- Désactivation des composantes en dehors des bornes
                        do iCmpActi = 1, nbCmp*nbCmpActi
                            value= sqrt(valeReal(iCmpActi)**2+valeImag(iCmpActi)**2)
                            if (lsup) then
                                if ((value-borsup) .gt. 0.d0) valeIndx(iCmpActi)=0
                            endif
                            if (linf) then
                                if ((value-borinf) .lt. 0.d0) valeIndx(iCmpActi)=0
                            endif
                        end do
! --------------------- Tassage
                        icomp2 = 0
                        do iCmpList = 1, nbCmp*nbCmpActi
                            if (valeIndx(iCmpList) .ne. 0) then
                                icomp2 = icomp2+1
                                valeIndx(icomp2)    = valeIndx(iCmpList)
                                valeSupIndx(icomp2) = cmpInPhys(iCmpList)
                                valeReal(icomp2)    = valeReal(iCmpList)
                                valeImag(icomp2)    = valeImag(iCmpList)
                                valeSupName(icomp2) = cmpName(iCmpList)
                                valeComp(icomp2)    = valeComp(iCmpList)
                            endif
                        end do
                        if (icomp2 .eq. 0) goto 18
! --------------------- ELNO field - Print in file
                        if (.not.lmax .and. .not.lmin) then
                            ilign=(icomp2+meshDime)/6
                            irest=(icomp2+meshDime)-ilign*6
                            fmt1 = ' '
                            fmt2 = ' '
                            if (irest .ne. 0) then
                                fmt1 = '(9X,6(1X,'//fmtText//'),30(/,9X,6(1X,'//fmtText//')))'
                                fmt2 = '(1X,A8,6(1X,'//realFormat// '),30(/, 9X, 6(1X,'//&
                                       realFormat//')))'
                            else if (irest .eq. 0 .and. ilign .eq. 1) then
                                fmt1 = '(9X,6(1X,'//fmtText//'))'
                                fmt2 = '(1X,A8,6(1X,'//realFormat//'))'
                            else
                                write(fmt1,'(A,A8,A,I2,A,A8,A)')   '(9X,6(1X,',fmtText,'),',&
                                                                   (ilign-1),&
                                                                   '(/,9X,6(1X,',fmtText,')))'
                                write(fmt2,'(A,A10,A,I2,A,A10,A)') '(1X,A8,6(1X,',realFormat,'),',&
                                                                   (ilign-1),&
                                                                  '(/,9X,6(1X,',realFormat,')))'
                            endif
                            if (lsup .or. linf) then
                                if (limpr) then
                                    write(fileUnit,'(A,I2,A)') meshCellName(iel)
                                    limpr = ASTER_FALSE
                                endif
                            endif
                            if (meshDime .eq. 0) then
                                write(fileUnit,fmt1) &
                                    (valeSupName(iCmpList)(1:11),iCmpList=1,icomp2)
                                if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                                    write(fileUnit,fmt2) &
                                        nodeName,(valeReal(icmp),icmp=1,icomp2)
                                endif
                                if (cplxFormat .eq. ' ') then
                                    write(fileUnit,fmt2) &
                                        blank,(valeImag(icmp),icmp=1,icomp2)
                                endif
                                if (cplxFormat .eq. 'IMAG') then
                                    write(fileUnit,fmt2) &
                                        nodeName,(valeImag(icmp),icmp=1,icomp2)
                                endif
                                if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                                    write(fileUnit,fmt2) &
                                        nodeName,(valeComp(icmp),icmp=1,icomp2)
                                endif
                            else
                                write(fileUnit,fmt1) &
                                    (meshCmpName(iCmpList),iCmpList=1,meshDime),&
                                    (valeSupName(iCmpList)(1:11),iCmpList=1,icomp2)
                                if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                                    write(fileUnit,fmt2) &
                                        nodeName,&
                                        (meshCoor((nodeNume-1)*3+iCmpList),iCmpList=1,meshDime),&
                                        (valeReal(icmp),icmp=1,icomp2)
                                endif
                                if (cplxFormat .eq. ' ') then
                                    write(fileUnit,fmt2) &
                                        blank,&
                                        (meshCoor((nodeNume-1)*3+iCmpList),iCmpList=1,meshDime),&
                                        (valeImag(icmp),icmp=1,icomp2)
                                endif
                                if (cplxFormat .eq. 'IMAG') then
                                    write(fileUnit,fmt2) &
                                        nodeName,&
                                        (meshCoor((nodeNume-1)*3+iCmpList),iCmpList=1,meshDime),&
                                        (valeImag(icmp),icmp=1,icomp2)
                                endif
                                if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                                    write(fileUnit,fmt2) &
                                        nodeName,&
                                        (meshCoor((nodeNume-1)*3+iCmpList),iCmpList=1,meshDime),&
                                        (valeComp(icmp),icmp=1,icomp2)
                                endif
                            endif
                        endif
                        nbcpt = icomp2
                    else
! --------------------- Print all values
                        if (.not.lmax .and. .not.lmin) then
                            if (meshDime .eq. 0) then
                                if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                                    write(fileUnit,fmtVal1) &
                                        nodeName,&
                                        (valeReal(icmp), icmp=1,nbCmp*nbCmpActi)
                                endif
                                if (cplxFormat .eq. ' ') then
                                    write(fileUnit,fmtVal1) &
                                        blank,&
                                        (valeImag(icmp), icmp=1,nbCmp*nbCmpActi)
                                endif
                                if (cplxFormat .eq. 'IMAG') then
                                    write(fileUnit,fmtVal1) &
                                        nodeName,&
                                        (valeImag(icmp), icmp=1,nbCmp*nbCmpActi)
                                endif
                                if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                                    write(fileUnit,fmtVal1) &
                                        nodeName,&
                                        (valeComp(icmp), icmp=1,nbCmp*nbCmpActi)
                                endif
                            else
                                if (cplxFormat .eq. ' ' .or. cplxFormat .eq. 'REEL') then
                                    write(fileUnit,fmtVal1) &
                                        nodeName,&
                                        (meshCoor((nodeNume-1)*3+iCmpList), iCmpList=1,meshDime),&
                                        (valeReal(icmp),icmp=1,nbCmp*nbCmpActi)
                                endif
                                if (cplxFormat .eq. ' ') then
                                    write(fileUnit,fmtVal1) &
                                        blank,&
                                        (meshCoor((nodeNume-1)*3+iCmpList), iCmpList=1,meshDime),&
                                        (valeImag(icmp),icmp=1,nbCmp*nbCmpActi)
                                endif
                                if (cplxFormat .eq. 'IMAG') then
                                    write(fileUnit,fmtVal1) &
                                        nodeName,&
                                        (meshCoor((nodeNume-1)*3+iCmpList), iCmpList=1,meshDime),&
                                        (valeImag(icmp),icmp=1,nbCmp*nbCmpActi)
                                endif
                                if (cplxFormat .eq. 'MODULE' .or. cplxFormat .eq. 'PHASE') then
                                    write(fileUnit,fmtVal1) &
                                        nodeName,&
                                        (meshCoor((nodeNume-1)*3+iCmpList), iCmpList=1,meshDime),&
                                        (valeComp(icmp),icmp=1,nbCmp*nbCmpActi)
                                endif
                            endif
                        endif
                        nbcpt=nbCmp*nbCmpActi
                    endif
! ----------------- Look for maximal value
                    if (lmax) then
                        do iCmpList = 1, nbcpt
                            if (lsup .or. linf) then
                                iadr = (valeSupIndx(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                            else
                                iadr = (cmpInPhys(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                            endif
                            if (valeMaxReal(iadr) .eq. rundf) then
                                valeMaxReal(iadr) = valeReal(iCmpList)
                                valeMaxImag(iadr) = valeImag(iCmpList)
                                valeMaxElem(iadr) = meshCellName(iel)
                                valeMaxNb(iadr)   = 1
                            else
                                valmax = sqrt(valeMaxReal(iadr)**2+valeMaxImag(iadr)**2)
                                value  = sqrt(valeReal(iCmpList)**2+valeImag(iCmpList)**2)
                                if (value .gt. valmax) then
                                    valeMaxReal(iadr) = valeReal(iCmpList)
                                    valeMaxImag(iadr) = valeImag(iCmpList)
                                    valeMaxElem(iadr) = meshCellName(iel)
                                    valeMaxNb(iadr)   = 1
                                else if (value .eq. valmax) then
                                    valeMaxNb(iadr)   = valeMaxNb(iadr)+1
                                endif
                            endif
                        end do
                    endif
! ----------------- Look for minimal value
                    if (lmin) then
                        do iCmpList = 1, nbcpt
                            if (lsup .or. linf) then
                                iadr = (valeSupIndx(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                            else
                                iadr = (cmpInPhys(iCmpList)-1)*nbCmp+valeIndx(iCmpList)
                            endif
                            if (valeMaxReal(iadr) .eq. rundf) then
                                valeMaxReal(iadr) = valeReal(iCmpList)
                                valeMaxImag(iadr) = valeImag(iCmpList)
                                valeMinElem(iadr) = meshCellName(iel)
                                valeMinNb(iadr)   = 1
                            else
                                valmin = sqrt(valeMaxReal(iadr)**2+valeMaxImag(iadr)**2)
                                value  = sqrt(valeReal(iCmpList)**2+valeImag(iCmpList)**2)
                                if (value .lt. valmin) then
                                    valeMaxReal(iadr) = valeReal(iCmpList)
                                    valeMaxImag(iadr) = valeImag(iCmpList)
                                    valeMinElem(iadr) = meshCellName(iel)
                                    valeMinNb(iadr)   = 1
                                else if (value.eq.valmin) then
                                    valeMinNb(iadr)   = valeMinNb(iadr)+1
                                endif
                            endif
                        end do
                    endif
18                  continue
                end do
            end do
            AS_DEALLOCATE(vi = inec)
        endif
        AS_DEALLOCATE(vi = cmpInPhys)
        AS_DEALLOCATE(vi = cmpInVale)
        AS_DEALLOCATE(vk16 = cmpName)
        AS_DEALLOCATE(vr = valeReal)
        AS_DEALLOCATE(vr = valeImag)
        AS_DEALLOCATE(vr = valeComp)
        AS_DEALLOCATE(vi = valeIndx)
        AS_DEALLOCATE(vk16 = valeSupName)
        AS_DEALLOCATE(vi = valeSupIndx)
    end do
    write (fileUnit,*) ' '
!
! - Print maximum value
!
    if (lmax) then
        do iCmpList = 1, cmpCataNb*nbCmp
            if (valeMaxReal(iCmpList) .ne. rundf) then
                form1 = '(1X,3A,'//realFormat//',1X,'//realFormat//',A,I4,2A)'
                write(fileUnit,form1)'LA VALEUR MAXIMALE DE ',cmpNameMinMax(iCmpList),&
               ' EST ',valeMaxReal(iCmpList),valeMaxImag(iCmpList), ' EN ',&
                valeMaxNb(iCmpList),' MAILLE(S) : ',valeMaxElem(iCmpList)
            endif
        end do
    endif
!
! - Print minimum value
!
    if (lmin) then
        do iCmpList = 1, cmpCataNb*nbCmp
            if (valeMaxReal(iCmpList) .ne. rundf) then
                form1 = '(1X,3A,'//realFormat//',1X,'//realFormat//',A,I4,2A)'
                write(fileUnit,form1)'LA VALEUR MINIMALE DE ',cmpNameMinMax(iCmpList),&
                ' EST ',valeMinReal(iCmpList),valeMinImag(iCmpList), ' EN ',&
                valeMinNb(iCmpList),' MAILLE(S) : ',valeMinElem(iCmpList)
            endif
        end do
    endif
!
    AS_DEALLOCATE(vk16 = cmpNameMinMax)
    AS_DEALLOCATE(vr = valeMaxReal)
    AS_DEALLOCATE(vr = valeMaxImag)
    AS_DEALLOCATE(vk8 = valeMaxElem)
    AS_DEALLOCATE(vi = valeMaxNb)
    AS_DEALLOCATE(vr = valeMinReal)
    AS_DEALLOCATE(vr = valeMinImag)
    AS_DEALLOCATE(vk8 = valeMinElem)
    AS_DEALLOCATE(vi = valeMinNb)
    AS_DEALLOCATE(vi = inec)
!
999 continue
    call jedema()
end subroutine
