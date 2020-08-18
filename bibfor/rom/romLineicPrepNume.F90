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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romLineicPrepNume(base, nbNodeWithDof)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/romLineicIndexList.h"
#include "asterfort/romLineicIndexSurf.h"
#include "asterfort/romLineicNumberComponents.h"
#include "asterfort/utmess.h"
#include "asterfort/uttrir.h"
!
type(ROM_DS_Empi), intent(inout) :: base
integer, intent(in) ::  nbNodeWithDof
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Renumbering
!
! Create numbering of nodes for the lineic model
!
! --------------------------------------------------------------------------------------------------
!
! IO  base             : base
! In  nbNodeWithDof    : number of nodes with dof (model on mesh)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: niv, ifm
    type(ROM_DS_LineicNumb) :: lineicNume
    integer :: nbNode, nbSlice, iNode, nbNodeSlice, nbCmp, nbEqua
    real(kind=8) :: toleNode
    character(len=8) :: lineicAxis, mesh
    character(len=24) :: lineicSect
    integer          , pointer :: v_grno(:) => null()
    real(kind=8)     , pointer :: v_coor(:) => null()
    real(kind=8)     , pointer :: v_coor_x(:) => null()
    real(kind=8)     , pointer :: v_coor_y(:) => null()
    real(kind=8)     , pointer :: v_coor_z(:) => null()
    real(kind=8)     , pointer :: v_coor_w(:) => null()
    real(kind=8)     , pointer :: v_coor_p(:) => null()
    real(kind=8)     , pointer :: v_coor_1(:) => null()
    real(kind=8)     , pointer :: v_coor_2(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
       call utmess('I', 'ROM18_12')
    endif
!
! - Get parameters
!
    nbNode     = nbNodeWithDof
    mesh       = base%mode%mesh
    lineicAxis = base%lineicAxis
    lineicSect = base%lineicSect
    lineicNume = base%lineicNume
    nbEqua     = base%mode%nbEqua
    toleNode   = lineicNume%toleNode
    if (niv .ge. 2) then
        call utmess('I', 'ROM18_13', sr = toleNode)
    endif
!
! - Count number of components by node for lineic model
!
    call romLineicNumberComponents(nbNode, nbEqua, nbCmp)
!
! - Allocate pointers for lineic objects
!
    nbSlice = nbNode
    AS_ALLOCATE(vi = lineicNume%numeSlice, size = nbSlice)
    AS_ALLOCATE(vi = lineicNume%numeSection, size = nbSlice)
!
! - Get coordinates of nodes
!
    call jeveuo(mesh//'.COORDO    .VALE', 'L', vr = v_coor)
    AS_ALLOCATE(vr = v_coor_x, size = nbNode)
    AS_ALLOCATE(vr = v_coor_y, size = nbNode)
    AS_ALLOCATE(vr = v_coor_z, size = nbNode)
    AS_ALLOCATE(vr = v_coor_w, size = nbNode)
    do iNode = 1, nbNode
        v_coor_x(iNode) = v_coor(1+3*(iNode-1)+0)
        v_coor_y(iNode) = v_coor(1+3*(iNode-1)+1)
        v_coor_z(iNode) = v_coor(1+3*(iNode-1)+2)
    enddo
!
! - Get coordinates of nodes for one slice
!
    call jelira(jexnom(mesh//'.GROUPENO',lineicSect), 'LONUTI', nbNodeSlice)
    call jeveuo(jexnom(mesh//'.GROUPENO',lineicSect), 'L'     , vi = v_grno)
    AS_ALLOCATE(vr = v_coor_1, size = nbNodeSlice)
    AS_ALLOCATE(vr = v_coor_2, size = nbNodeSlice)
!
! - In case of lineic model, we must create a new numbering for the nodes on mesh
!
    if (lineicAxis .eq. 'OX') then
        v_coor_w(1:nbNode) = v_coor_x(1:nbNode)
        call uttrir(nbSlice, v_coor_w, toleNode)
        AS_ALLOCATE(vr = v_coor_p, size = nbSlice)
        v_coor_p(1:nbSlice) = v_coor_w(1:nbSlice)
        call romLineicIndexList(toleNode,&
                                nbNode      , v_coor_x,&
                                nbSlice     , v_coor_p,&
                                lineicNume%numeSlice)
        do iNode = 1, nbNodeSlice
            v_coor_1(iNode) = v_coor(1+3*(v_grno(iNode)-1)+1)
            v_coor_2(iNode) = v_coor(1+3*(v_grno(iNode)-1)+2)
        enddo
        call romLineicIndexSurf(toleNode  ,&
                                nbNode     , v_coor_y , v_coor_z,&
                                nbNodeSlice, v_coor_1 , v_coor_2,&
                                lineicNume%numeSection)
    elseif (lineicAxis .eq. 'OY') then
        v_coor_w(1:nbNode) = v_coor_y(1:nbNode)
        call uttrir(nbSlice, v_coor_w, toleNode)
        AS_ALLOCATE(vr=v_coor_p, size=nbSlice)
        v_coor_p(1:nbSlice) = v_coor_w(1:nbSlice)
        call romLineicIndexList(toleNode,&
                                nbNode      , v_coor_y,&
                                nbSlice     , v_coor_p,&
                                lineicNume%numeSlice)
        do iNode = 1, nbNodeSlice
            v_coor_1(iNode) = v_coor(1+3*(v_grno(iNode)-1)+2)
            v_coor_2(iNode) = v_coor(1+3*(v_grno(iNode)-1)+0)
        enddo
        call romLineicIndexSurf(toleNode  ,&
                                nbNode     , v_coor_z , v_coor_x,&
                                nbNodeSlice, v_coor_1 , v_coor_2,&
                                lineicNume%numeSection)
    elseif (lineicAxis .eq. 'OZ') then
        v_coor_w(1:nbNode) = v_coor_z(1:nbNode)
        call uttrir(nbSlice, v_coor_w, toleNode)
        AS_ALLOCATE(vr=v_coor_p, size=nbSlice)
        v_coor_p(1:nbSlice) = v_coor_w(1:nbSlice)
        call romLineicIndexList(toleNode,&
                                nbNode      , v_coor_z,&
                                nbSlice     , v_coor_p,&
                                lineicNume%numeSlice)
        do iNode = 1, nbNodeSlice
            v_coor_1(iNode) = v_coor(1+3*(v_grno(iNode)-1)+0)
            v_coor_2(iNode) = v_coor(1+3*(v_grno(iNode)-1)+1)
        enddo
        call romLineicIndexSurf(toleNode  ,&
                                nbNode     , v_coor_x , v_coor_y,&
                                nbNodeSlice, v_coor_1 , v_coor_2,&
                                lineicNume%numeSection)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Clean
!
    AS_DEALLOCATE(vr = v_coor_p)
    AS_DEALLOCATE(vr = v_coor_x)
    AS_DEALLOCATE(vr = v_coor_y)
    AS_DEALLOCATE(vr = v_coor_z)
    AS_DEALLOCATE(vr = v_coor_w)
    AS_DEALLOCATE(vr = v_coor_1)
    AS_DEALLOCATE(vr = v_coor_2)
!
! - Save
!
    lineicNume%nbSlice = nbSlice
    lineicNume%nbCmp   = nbCmp
    base%lineicNume    = lineicNume
!
end subroutine
