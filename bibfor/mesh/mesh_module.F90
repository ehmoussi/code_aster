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
module mesh_module
! ==================================================================================================
implicit none
! ==================================================================================================
private :: getSignNormalSkinToSupport
public  :: getCellProperties, getSkinCellSupport,&
           checkNormalOnSkinCell

! ==================================================================================================
private
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/teattr.h"
#include "asterfort/jexatr.h"
#include "asterfort/utmavo.h"
#include "asterfort/utmasu.h"
#include "asterfort/jedetr.h"
#include "asterfort/normev.h"
#include "asterfort/provec.h"
#include "asterfort/utmess.h"
#include "blas/ddot.h"
! ==================================================================================================
contains
! ==================================================================================================
! --------------------------------------------------------------------------------------------------
!
! getCellProperties
!
! Get properties of cells
!
! In  mesh             : name of mesh
! In  nbCell           : number of skin cells
! In  listCell         : list of skin cells (number)
! IO  cellNbNode       : number of nodes for each cell
! IO  cellNodeIndx     : index of first node for each cell
! Out lCell2d          : 2D cells exist
! Out lCell1d          : 1D cells exist
!
! --------------------------------------------------------------------------------------------------
subroutine getCellProperties(meshz     ,&
                             nbCell    , listCell,&
                             cellNbNode, cellNodeIndx,&
                             lCell2d   , lCell1d)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: meshz
    integer, intent(in) :: nbCell, listCell(*)
    integer, intent(inout) :: cellNbNode(nbCell), cellNodeIndx(nbCell)
    aster_logical, intent(out) :: lCell2d, lCell1d
! - Local
    integer :: iCell, cellNume, cellTypeNume
    character(len=8) :: mesh, cellTypeName
    integer, pointer :: skinCellType(:) => null()
    integer, pointer :: meshConnexLen(:) => null()
!   ------------------------------------------------------------------------------------------------
    mesh = meshz
    lCell2d = ASTER_FALSE
    lCell1d = ASTER_FALSE
    call jeveuo(mesh//'.TYPMAIL', 'L', vi=skinCellType)
    call jeveuo(jexatr(mesh//'.CONNEX', 'LONCUM'), 'L', vi = meshConnexLen)
    do iCell = 1, nbCell
        cellNume            = listCell(iCell)
        cellNbNode(iCell)   = meshConnexLen(cellNume+1) - meshConnexLen(cellNume)
        cellNodeIndx(iCell) = meshConnexLen(cellNume)
        cellTypeNume        = skinCellType(cellNume)
        call jenuno(jexnum('&CATA.TM.NOMTM', cellTypeNume), cellTypeName)
        if (cellTypeName(1:4) .eq. 'QUAD') then
            lCell2d = ASTER_TRUE
        else if (cellTypeName(1:4) .eq. 'TRIA') then
            lCell2d = ASTER_TRUE
        else if (cellTypeName(1:3) .eq. 'SEG') then
            lCell1d = ASTER_TRUE
        else
! --------- Ignore
        endif
    end do
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getSkinCellSupport
!
! Get "volumic" cells support of skin cells
!
! In  mesh             : name of mesh
! In  nbSkinCell       : number of skin cells
! In  cellSkinNume     : list of skin cells (number)
! In  lCell2d          : flag if 2d cells exist
! In  lCell1d          : flag if 1D cells exist
! Ptr cellSuppNume  : volumic" cells support of skin cells
!
! --------------------------------------------------------------------------------------------------
subroutine getSkinCellSupport(meshz          ,&
                              nbSkinCell     , cellSkinNume,&
                              lCell2d        , lCell1d ,&
                              cellSuppNume,&
                              nbCellSupport_ , suppNume_)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: meshz
    integer, intent(in) :: nbSkinCell, cellSkinNume(nbSkinCell)
    aster_logical, intent(in) :: lCell2d, lCell1d
    integer, pointer :: cellSuppNume(:)
    integer, optional, intent(in) :: nbCellSupport_
    integer, optional, pointer :: suppNume_(:)
! - Local
    character(len=8) :: mesh
    character(len=2) :: kdim
    real(kind=8), pointer :: meshNodeCoor(:) => null()
    integer, parameter :: zero = 0
    aster_logical, parameter :: skinInsideVolume = ASTER_TRUE
    integer :: ibid(1), iSkinCell
    character(len=24), parameter :: jvCellVolume = '&&UTMASU'
    integer, pointer :: vCellVolume(:) => null()
!   ------------------------------------------------------------------------------------------------
    mesh = meshz
    kdim = '  '
    if (lCell1d) then
        kdim = '2D'
        ASSERT(.not. lCell2d)
    endif
    if (lCell2d) then
        kdim = '3D'
        ASSERT(.not. lCell1d)
    endif
!
    call jeveuo(mesh//'.COORDO    .VALE', 'L', vr=meshNodeCoor)
    if (present(nbCellSupport_)) then
        call utmasu(mesh, kdim, nbSkinCell, cellSkinNume, jvCellVolume,&
                    meshNodeCoor, nbCellSupport_, suppNume_, skinInsideVolume)
    else
        call utmasu(mesh, kdim, nbSkinCell, cellSkinNume, jvCellVolume,&
                    meshNodeCoor, zero, ibid, skinInsideVolume)
    endif
    call jeveuo(jvCellVolume, 'L', vi = vCellVolume)
    do iSkinCell = 1, nbSkinCell
        cellSuppNume(iSkinCell) = vCellVolume(iSkinCell)
    end do
    call jedetr(jvCellVolume)
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! checkNormalOnSkinCell
!
! Get "volumic" cells support of skin cells
!
! In  mesh             : name of mesh
! In  modelDime        : global dimension of model
! In  nbSkinCell       : number of skin cells
! In  cellSkinNume     : index for skin cells
! In  cellSkinNbNode   : number of nodes for skin cells
! In  cellSkinNodeIndx : index of first node for skin cells
! In  cellSuppNume     : index for "volumic" cells support of skin cells
!
! --------------------------------------------------------------------------------------------------
subroutine checkNormalOnSkinCell(meshz         , modelDime,&
                                 nbSkinCell    , cellSkinNume ,&
                                 cellSkinNbNode, cellSkinNodeIndx,&
                                 cellSuppNume, lMisoriented)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    character(len=*), intent(in) :: meshz
    integer, intent(in) :: modelDime
    integer, intent(in) :: nbSkinCell, cellSkinNume(nbSkinCell), cellSuppNume(nbSkinCell)
    integer, intent(in) :: cellSkinNbNode(nbSkinCell), cellSkinNodeIndx(nbSkinCell)
    aster_logical, intent(out) :: lMisoriented
! - Local
    character(len=8) :: mesh, skinCellType, suppCellType, cellName
    integer :: iSkinCell, suppNume, nodeFirst, iNode
    integer :: skinNume
    integer :: skinNbNode, skinNodeNume(27), suppNbNode, suppNodeNume(27)
    real(kind=8) :: signNorm
    real(kind=8), pointer :: meshNodeCoor(:) => null()
    integer, pointer :: meshConnexLen(:) => null()
    integer, pointer :: meshConnex(:) => null()
    integer, pointer :: meshCellType(:) => null()
!   ------------------------------------------------------------------------------------------------
    mesh = meshz
    call jeveuo(mesh//'.TYPMAIL        ', 'L', vi = meshCellType)
    call jeveuo(mesh//'.COORDO    .VALE', 'L', vr = meshNodeCoor)
    call jeveuo(jexatr(mesh//'.CONNEX', 'LONCUM'), 'L', vi = meshConnexLen)
    call jeveuo(mesh//'.CONNEX', 'E', vi = meshConnex)
    lMisoriented = ASTER_FALSE

    do iSkinCell = 1, nbSkinCell
! ----- Support cell of skin
        suppNume  = cellSuppNume(iSkinCell)
        if (suppNume .eq. 0) then
            call utmess('A', 'FLUID1_3')
        else
! --------- Parameters of skin cell
            skinNume     = cellSkinNume(iSkinCell)
            skinNbNode   = cellSkinNbNode(iSkinCell)
            ASSERT(skinNbNode .le. 27)
            nodeFirst    = cellSkinNodeIndx(iSKinCell)
            skinNodeNume = 0
            do iNode = 1, skinNbNode
                skinNodeNume(iNode) = meshConnex(nodeFirst+iNode-1)
            end do
            call jenuno(jexnum('&CATA.TM.NOMTM', meshCellType(skinNume)), skinCellType)
! --------- Parameters of support cell
            nodeFirst    = meshConnexLen(suppNume)
            suppNbNode   = meshConnexLen(suppNume+1) - nodeFirst
            ASSERT(suppNbNode .le. 27)
            suppNodeNume = 0
            do iNode = 1, suppNbNode
                suppNodeNume(iNode) = meshConnex(nodeFirst+iNode-1)
            end do
            call jenuno(jexnum('&CATA.TM.NOMTM', meshCellType(suppNume)), suppCellType)
            call jenuno(jexnum(mesh//'.NOMMAI', skinNume), cellName)

! --------- Get sign of normal from skin cell to its volumic support
            call getSignNormalSkinToSupport(modelDime   ,&
                                            skinNodeNume, suppNodeNume,&
                                            skinCellType, suppCellType,&
                                            meshNodeCoor, signNorm)
            if (signNorm .gt. 0.d0) then
                lMisoriented = ASTER_TRUE
            endif
        endif
!
    end do
!   ------------------------------------------------------------------------------------------------
end subroutine
! --------------------------------------------------------------------------------------------------
!
! getSignNormalSkinToSupport
!
! get sign of normal from skin cell to its volumic support
!
! In  modelDime        : global dimension of model
! In  skinNodeNume     : index of nodes in mesh for skin cell
! In  suppNodeNume     : index of nodes in mesh for support of skin cell
! In  skinCellType     : type of skin cell
! In  suppCellType     : type of support of skin cell
! In  meshNodeCoor     : coordinates of nodes
! Out signNorm         : sign of normal from skin to support
!                          >0 : normal if from skin to inside support cell
!
! --------------------------------------------------------------------------------------------------
subroutine getSignNormalSkinToSupport(modelDime   ,&
                                      skinNodeNume, suppNodeNume,&
                                      skinCellType, suppCellType,&
                                      meshNodeCoor, signNorm)
!   ------------------------------------------------------------------------------------------------
! - Parameters
    integer, intent(in) :: modelDime
    integer, intent(in) :: skinNodeNume(27), suppNodeNume(27)
    character(len=8), intent(in) :: skinCellType, suppCellType
    real(kind=8), intent(in) :: meshNodeCoor(*)
    real(kind=8), intent(out) :: signNorm
! - Local
    integer :: node1, node2, node3, iDime, iNode
    integer :: skinNbNode, suppNbNode
    real(kind=8) :: node1Coor(3), node2Coor(3), node3Coor(3)
    real(kind=8) :: n1n3(3), n1n2(3), normal(3), n1g(3), norm
    real(kind=8) :: xgm(3), xg3d(3)

!   ------------------------------------------------------------------------------------------------
    signNorm = 0.d0
    normal   = 0.d0
!
! - Compute normal to skin element
!
    node1 = skinNodeNume(1)
    node2 = skinNodeNume(2)
    if (modelDime .eq. 3) then
        node3 = skinNodeNume(3)
    endif
    node1Coor = 0.d0
    node2Coor = 0.d0
    do iDime = 1, modelDime
        node1Coor(iDime) = meshNodeCoor(3*(node1-1)+iDime)
        node2Coor(iDime) = meshNodeCoor(3*(node2-1)+iDime)
    end do
    n1n2 = node2Coor - node1Coor
    if (modelDime .eq. 2) then
        normal(1) = n1n2(2)
        normal(2) = -n1n2(1)
    else if (modelDime .eq. 3) then
        do iDime = 1, 3
            node3Coor(iDime) = meshNodeCoor(3*(node3-1)+iDime)
        end do
        n1n3 = node3Coor - node1Coor
        call provec(n1n2, n1n3, normal)
    else
        ASSERT(ASTER_FALSE)
    endif
    call normev(normal, norm)
! 
! - Compute barycentric for skin element
!
    if (skinCellType(1:4) .eq. 'QUAD') then
        skinNbNode = 4
    else if (skinCellType(1:4) .eq. 'TRIA') then
        skinNbNode = 3
    else if (skinCellType(1:3) .eq. 'SEG') then
        skinNbNode = 2
        ASSERT(modelDime .eq. 2)
    else
        ASSERT(ASTER_FALSE)
    endif
    xgm = 0.d0
    do iNode = 1, skinNbNode
        xgm(1) = xgm(1) + meshNodeCoor(3*(skinNodeNume(iNode)-1)+1)
        xgm(2) = xgm(2) + meshNodeCoor(3*(skinNodeNume(iNode)-1)+2)
        if (modelDime .eq. 3) then
            xgm(3) = xgm(3) + meshNodeCoor(3*(skinNodeNume(iNode)-1)+3)
        endif
    end do
    xgm(1) = xgm(1) / skinNbNode
    xgm(2) = xgm(2) / skinNbNode
    xgm(3) = xgm(3) / skinNbNode
! 
! - Compute barycentric for support element
!
    if (suppCellType(1:4) .eq. 'HEXA') then
        suppNbNode = 8
    else if (suppCellType(1:4) .eq. 'PENT') then
        suppNbNode = 6
    else if (suppCellType(1:4) .eq. 'PYRA') then
        suppNbNode = 5
    else if (suppCellType(1:4) .eq. 'TETR') then
        suppNbNode = 4
    else if (suppCellType(1:4) .eq. 'QUAD') then
        suppNbNode = 4
    else if (suppCellType(1:4) .eq. 'TRIA') then
        suppNbNode = 3
    else
        ASSERT(ASTER_FALSE)
    endif
    xg3d = 0.d0
    do iNode = 1, suppNbNode
        xg3d(1) = xg3d(1) + meshNodeCoor(3*(suppNodeNume(iNode)-1)+1)
        xg3d(2) = xg3d(2) + meshNodeCoor(3*(suppNodeNume(iNode)-1)+2)
        if (modelDime .eq. 3) then
            xg3d(3) = xg3d(3) + meshNodeCoor(3*(suppNodeNume(iNode)-1)+3)
        endif
    end do
    xg3d(1) = xg3d(1) / suppNbNode
    xg3d(2) = xg3d(2) / suppNbNode
    xg3d(3) = xg3d(3) / suppNbNode
!
! - Compute sign of normal from skin to support
!
    n1g = xg3d - xgm
    call normev(n1g, norm)
    signNorm = ddot(modelDime, n1g, 1, normal, 1)
!   ------------------------------------------------------------------------------------------------
end subroutine
!
end module mesh_module
