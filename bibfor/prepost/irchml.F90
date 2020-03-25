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
subroutine irchml(fileUnit  ,&
                  fieldTypeZ, fieldNameZ  , fieldSupport,&
                  cmpUserNb , cmpUserName ,&
                  cellUserNb, cellUserNume,&
                  nodeUserNb, nodeUserNume,&
                  lMeshCoor_ , lmax_       , lmin_,&
                  lsup_      , borsup_     ,&
                  linf_      , borinf_     ,&
                  realFormat_)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexatr.h"
#include "asterfort/celver.h"
#include "asterfort/celcel.h"
#include "asterfort/resuSelectCmp.h"
#include "asterfort/utmess.h"
#include "asterfort/utcmp3.h"
#include "asterfort/celces.h"
#include "asterfort/cesimp.h"
#include "asterfort/cncinv.h"
#include "asterfort/detrsd.h"
#include "asterfort/i2trgi.h"
#include "asterfort/ircecl.h"
#include "asterfort/ircerl.h"
#include "asterfort/irsspt.h"
!
integer, intent(in) :: fileUnit
character(len=*), intent(in) :: fieldNameZ, fieldTypeZ
character(len=4), intent(in) :: fieldSupport
integer, intent(in) :: cmpUserNb
character(len=8), pointer :: cmpUserName(:)
integer, intent(in) :: nodeUserNb
integer, pointer :: nodeUserNume(:)
integer, intent(in) :: cellUserNb
integer, pointer :: cellUserNume(:)
aster_logical, optional, intent(in) :: lMeshCoor_
aster_logical, optional, intent(in) :: lsup_, linf_, lmax_, lmin_
real(kind=8),  optional, intent(in) :: borsup_, borinf_
character(len=*),  optional, intent(in) :: realFormat_
!
! --------------------------------------------------------------------------------------------------
!
! Print results - RESULTAT
!
! Field on cells
!
! --------------------------------------------------------------------------------------------------
!
! In  fileUnit         : index of file (logical unit)
! In  fieldType        : type of field (DEPL, SIEF, EPSI, ...)
! In  fieldName        : name of field datastructure
! In  fieldSupport     : cell support of field (NOEU, ELNO, ELEM, ...)
! In  cmpUserNb        : number of components to select
! Ptr cmpUserName      : list of name of components to select
! In  nodeUserNb       : number of nodes require by user
! Ptr nodeUserNume     : list of index of nodes require by user
! In  cellUserNb       : number of cells require by user
! Ptr cellUserNume     : list of index of cells require by user
! In  lMeshCoor        : flag to print coordinates of node
! In  lmax             : flag to print maximum value on nodes
! In  lmin             : flag to print minimum value on nodes
! In  lsup             : flag if supremum exists
! In  borsup           : value of supremum
! In  linf             : flag if infinum exists
! In  borinf           : value of infinum
! In  realFormat       : format of real numbers
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=8) :: meshName, quantityName
    character(len=19) :: fieldName
    character(len=19), parameter :: fieldNameS = '&&IRCHML_CES'
    character(len=16) :: fieldType
    integer, pointer :: celd(:) => null()
    character(len=24), pointer :: celk(:) => null()
    character(len=19) :: liliName
    integer, pointer :: liel(:) => null()
    integer, pointer :: lielLen(:) => null()
    character(len=8), pointer :: lgrf(:) => null()
    character(len=1) :: type
    integer :: fieldScalar, quantityIndx, grelNb, iCell
    character(len=24), parameter :: ncncin = '&&IRCHML.CONNECINVERSE'
    integer :: jdrvlc, jcncin, nbtma, iadr
    integer :: iNode , nodeNume, nodeNbElem, cellNumeFirst
    integer :: meshNodeNb, meshCellNb, meshDime
    integer :: cmpCataNb, cmpListNb, cmpVariNb
    integer, pointer :: cmpListIndx(:) => null()
    character(len=8), pointer :: cmpCataName(:) => null()
    integer, pointer :: cmpVariIndx(:) => null()
    character(len=8), pointer :: meshCellName(:) => null()
    character(len=8), pointer :: meshNodeName(:) => null()
    real(kind=8), pointer :: meshCoor(:) => null()
    integer, pointer :: cellSelectNume(:) => null()
    integer :: cellSelectNb
    integer, pointer :: connex(:) => null()
    integer, pointer :: connexLen(:) => null()
    aster_logical :: lMeshCoor
    aster_logical :: lsup, linf, lmax, lmin
    real(kind=8) :: borsup, borinf
    character(len=8) :: realFormat
    complex(kind=8), pointer  :: valeC(:) => null()
    real(kind=8), pointer  :: valeR(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    fieldName = fieldNameZ
    fieldType = fieldTypeZ
    lMeshCoor = ASTER_FALSE
    if (present(lMeshCoor_)) then
        lMeshCoor = lMeshCoor_
    endif
    lsup = ASTER_FALSE
    if (present(lsup_)) then
        lsup = lsup_
    endif
    linf = ASTER_FALSE
    if (present(linf_)) then
        linf = linf_
    endif
    lmax = ASTER_FALSE
    if (present(lmax_)) then
        lmax = lmax_
    endif
    lmin = ASTER_FALSE
    if (present(lmin_)) then
        lmin = lmin_
    endif
    borsup = 0.d0
    if (present(borsup_)) then
        borsup = borsup_
    endif
    borinf = 0.d0
    if (present(borinf_)) then
        borinf = borinf_
    endif
    realFormat = '1PE12.5'
    if (present(realFormat_)) then
        realFormat = realFormat_
    endif
!
! - Check field "not too dynamic"
!
    call celver(fieldName, 'NBVARI_CST', 'COOL', iret)
    if (iret .eq. 1) then
        call celcel('NBVARI_CST', fieldName, 'V', '&&IRCHML.CHAMEL1')
        fieldName = '&&IRCHML.CHAMEL1'
    endif
!
! - For sub-points: special
!
    call celver(fieldName, 'NBSPT_1', 'COOL', iret)
    if (iret .eq. 1) then
        call celces(fieldName, 'V', fieldNameS)
        if (lmax .or. lmin) then
            call irsspt(fieldNameS, fileUnit    ,&
                        cellUserNb, cellUserNume,&
                        cmpUserNb , cmpUserName ,&
                        lsup      , linf        ,&
                        lmax      , lmin        ,&
                        borinf    , borsup)
        else
            call utmess('I', 'RESULT3_98', sk=fieldType)
            call cesimp(fieldNameS, fileUnit, cellUserNb, cellUserNume)
        endif
        call detrsd('CHAM_ELEM_S', fieldNameS)
        goto 999
    endif
!
! - Access to field
!
    call jeveuo(fieldName//'.CELK', 'L', vk24 = celk)
    call jeveuo(fieldName//'.CELD', 'L', vi = celd)
!
! - Physical quantity on field
!
    call jelira(fieldName//'.CELV', 'TYPE', cval=type)
    if (type(1:1) .eq. 'R') then
        fieldScalar = 1
    else if (type(1:1).eq.'C') then
        fieldScalar = 2
    else if (type(1:1).eq.'I') then
        fieldScalar = 3
    else if (type(1:1).eq.'K') then
        fieldScalar = 4
    else
        ASSERT(ASTER_FALSE)
    endif
    quantityIndx = celd(1)
    call jenuno(jexnum('&CATA.GD.NOMGD', quantityIndx), quantityName)
!
! - Access to mesh
!
    liliName = celk(1)(1:19)
    call jeveuo(liliName//'.LGRF', 'L', vk8 = lgrf)
    meshName = lgrf(1)
    call dismoi('DIM_GEOM_B', meshName, 'MAILLAGE', repi = meshDime)
    call dismoi('NB_NO_MAILLA', meshName, 'MAILLAGE', repi = meshNodeNb)
    call dismoi('NB_MA_MAILLA', meshName, 'MAILLAGE', repi = meshCellNb)
    call jeveuo(meshName//'.COORDO    .VALE', 'L', vr = meshCoor)
    call jeveuo(meshName//'.CONNEX', 'L', vi = connex)
    call jeveuo(jexatr(meshName//'.CONNEX', 'LONCUM'), 'L', vi = connexLen)
!
! - Select list of components
!
    call resuSelectCmp(quantityIndx,&
                       cmpUserNb   , cmpUserName,&
                       cmpCataNb   , cmpCataName,&
                       cmpListNb   , cmpListIndx)
!
! - Select list of components (for VARI_R)
!
    cmpVariNb = 0
    if (cmpListNb .ne. 0) then
        if ((quantityName .eq. 'VARI_R') .and. (fieldSupport(1:2) .eq. 'EL')) then
            cmpVariNb = cmpListNb
            call utcmp3(cmpListNb, cmpUserName, cmpVariIndx)
        endif
    endif
    if (cmpListNb .eq. 0 .and. cmpUserNb .ne. 0 .and. cmpVariNb .eq. 0) then
        goto 997
    endif
!
! - Access to LIGREL
!
    call jeveuo(liliName//'.LIEL', 'L', vi = liel)
    call jelira(liliName//'.LIEL', 'NUTIOC', grelNb)
    call jeveuo(jexatr(liliName//'.LIEL', 'LONCUM'), 'L', vi = lielLen)
    ASSERT(grelNb .eq. celd(2))
!
! - Get parameters of all elements in mesh
!
    AS_ALLOCATE(vk8 = meshCellName, size = meshCellNb)
    do iCell = 1, meshCellNb
        call jenuno(jexnum(meshName//'.NOMMAI', iCell), meshCellName(iCell))
    end do
    AS_ALLOCATE(vk8 = meshNodeName, size = meshNodeNb)
    do iNode = 1, meshNodeNb
        call jenuno(jexnum(meshName//'.NOMNOE', iNode), meshNodeName(iNode))
    end do
!
! - Get list of elements
!
    if (cellUserNb .eq. 0 .and. nodeUserNb .ne. 0) then
! ----- Get list of cells from list of nodes (inverse connectivity)
        call jelira(meshName//'.CONNEX', 'NMAXOC', nbtma)
        AS_ALLOCATE(vi = cellSelectNume, size = nbtma)
        call jeexin(ncncin, iret)
        if (iret .eq. 0) then
            call cncinv(meshName, [0], 0, 'V', ncncin)
        endif
        cellNumeFirst = 1
        call jeveuo(jexatr(ncncin, 'LONCUM'), 'L', jdrvlc)
        call jeveuo(jexnum(ncncin, 1), 'L', jcncin)
        do iNode = 1, nodeUserNb, 1
            nodeNume   = nodeUserNume(iNode)
            nodeNbElem = zi(jdrvlc + nodeNume+1-1) - zi(jdrvlc + nodeNume-1)
            iadr       = zi(jdrvlc + nodeNume-1)
            call i2trgi(cellSelectNume, zi(jcncin+iadr-1), nodeNbElem, cellNumeFirst)
        end do
        cellSelectNb = cellNumeFirst - 1
    else
! ----- Get list of cells from user (trivial)
        cellSelectNb = cellUserNb
        if (cellUserNb .ne. 0) then
            AS_ALLOCATE(vi = cellSelectNume, size = cellUserNb)
            do iCell = 1, cellUserNb
                cellSelectNume(iCell) = cellUserNume(iCell)
            end do
        endif
    endif
!
! - Print elementary field
!
    if (fieldScalar .eq. 1) then
        call jeveuo(fieldName//'.CELV', 'L', vr = valeR)
        call ircerl(fileUnit, meshCellNb, liel, grelNb, lielLen,&
                    cmpCataNb, valeR, cmpCataName, meshCellName, fieldSupport,&
                    celd, connex, connexLen, meshNodeName, cmpListNb,&
                    cmpListIndx, nodeUserNb, nodeUserNume, cellSelectNb, cellSelectNume,&
                    lsup, borsup, linf, borinf, lmax,&
                    lmin, lMeshCoor, meshDime, meshCoor, liliName,&
                    realFormat, cmpVariNb, cmpVariIndx)
    else if (fieldScalar .eq. 2) then
        call jeveuo(fieldName//'.CELV', 'L', vc = valeC)
        call ircecl(fileUnit, meshCellNb, liel, grelNb, lielLen,&
                    cmpCataNb, valeC, cmpCataName, meshCellName, fieldSupport,&
                    celd, connex, connexLen, meshNodeName, cmpListNb,&
                    cmpListIndx, nodeUserNb, nodeUserNume, cellSelectNb, cellSelectNume,&
                    lsup, borsup, linf, borinf, lmax,&
                    lmin, lMeshCoor, meshDime, meshCoor, liliName,&
                    realFormat, cmpVariNb, cmpVariIndx)
    else if ((fieldScalar.eq.3) .or. (fieldScalar.eq.4)) then
        call utmess('I', 'RESULT3_99', sk=fieldType)
        call celces(fieldName, 'V', fieldNameS)
        call cesimp(fieldNameS, fileUnit, cellSelectNb, cellSelectNume)
        call detrsd('CHAM_ELEM_S', fieldNameS)
    endif
    goto 999
!
997 continue
!
    call utmess('A', 'RESULT3_40', sk = fieldType)
!
999 continue
!
! - Clean
!
    call detrsd('CHAM_ELEM', '&&IRCHML.CHAMEL1')
    call detrsd('CHAM_ELEM', '&&IRCHML.CHAMEL2')
    AS_DEALLOCATE(vi = cellSelectNume)
    AS_DEALLOCATE(vi = cmpListIndx)
    AS_DEALLOCATE(vk8 = meshCellName)
    AS_DEALLOCATE(vk8 = meshNodeName)
!
    call jedema()
end subroutine
