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
subroutine select_dof(listEqua_      , tablEqua_        , tablCmp_,&
                      numeDofZ_      , fieldNodeZ_      ,&
                      nbNodeToSelect_, listNodeToSelect_,&
                      nbCmpToSelect_ , listCmpToSelect_ )
!
implicit none
!
#include "asterc/indik8.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisdg.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/nbec.h"
#include "asterfort/select_dof_gene.h"
!
integer, pointer, optional :: listEqua_(:), tablEqua_(:, :), tablCmp_(:)
character(len=*), optional, intent(in) :: numeDofZ_, fieldNodeZ_
integer, optional, intent(in) :: nbNodeToSelect_
integer, pointer, optional :: listNodeToSelect_(:)
integer, optional, intent(in) :: nbCmpToSelect_
character(len=8), pointer, optional :: listCmpToSelect_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Utility for nodal field
!
! Select dof from list of nodes and components
!
! --------------------------------------------------------------------------------------------------
!
! Select output: listEqua/tablEqua/tablCmp
! Select input:
!    On numbering of nodal field (numeDof / fieldNode)
!    On which nodes (nbNodeToSelect / listNodeToSelect)
!                   if none => all nodes in mesh
!    On which components (nbCmpToSelect / listCmpToSelect)
!                   if none => all components
!
! Ptr listEqua_            : pointer to all equations [1:nbEqua] with
!                       for iEqua =  [1:nbEqua]
!                           listEqua[iEqua] = 0 if node+component not present
!                           listEqua[iEqua] = 1 if node+component is present
! Ptr tablEqua_            : pointer to all equations and all components 
!                            [1:nbEqua, 1:nbCmpToSelect] with
!                       for iEqua = [1:nbEqua]
!                           for iCmp = [1:nbCmpToSelect]
!                               tablEqua[iEqua,iCmp] = 0 if node+component not present
!                               tablEqua[iEqua,iCmp] = 1 if node+component is present
! Ptr tablCmp_             : pointer to all components [1:nbCmpToSelect]
!                       for iCmp = [1:nbCmpToSelect]
!                           tablCmp_[iCmp] = 0   if node+component not present
!                           tablCmp_[iCmp] = iEqua if node+component present
! In  numeDof              : name of numbering (NUME_DDL)
! In  fieldNode            : name of nodal field (CHAMNO)
! In  nbNodeToSelect       : number of nodes to select (if none => all nodes in mesh)
! Ptr listNodeToSelect     : pointer to the list of nodes (absolute index in mesh)
! In  nbCmpToSelect        : number of components (if none => all components)
! Ptr listCmpToSelect      : pointer to the list of components (name)
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: iLigrMesh = 1
    integer, parameter :: nbEcMax = 10
    integer :: physDesc(nbEcMax)

    character(len=24) :: liliName
    character(len=8) :: cmpName, mesh
    character(len=19) :: profChno, profGene, fieldNode
    character(len=14) :: numeDof
    integer :: iexi
    logical :: lProfGene
    integer :: numeNode, physNume, prnoLength
    integer :: numeEqua, iNode, iCmp, dofNume, numeCmp, iEc
    integer :: nbNodeToSelect, nb_ec, nbCmpToSelect, physNbCmp, nbNodeMesh, nbCmpNode
    integer, pointer :: cmpSelect(:) => null()
    integer, pointer :: nodeSelect(:) => null()
    integer, pointer :: prno(:) => null()
    integer, pointer :: nueq(:) => null()
    character(len=8), pointer :: physCataName(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    numeDof   = ' '
    fieldNode = ' '
!
! - Check output parameters
!
    ASSERT(EXCLUS2(tablEqua_, tablCmp_))
    ASSERT(EXCLUS2(tablEqua_, listEqua_))
    ASSERT(EXCLUS2(listEqua_, tablCmp_))
!
! - Check input parameters
!
    if (present(tablCmp_)) then
        ASSERT(present(nbNodeToSelect_))
        ASSERT(present(listNodeToSelect_))
        ASSERT(nbNodeToSelect_ .eq. 1)
    endif
!
! - Get PROF_CHNO
!
    profChno  = ' '
    if (present(numeDofZ_)) then
        numeDof = numeDofZ_
        ASSERT(.not.present(fieldNodeZ_))
        call dismoi('PROF_CHNO', numeDof, 'NUME_DDL', repk = profChno)
    elseif (present(fieldNodeZ_)) then
        fieldNode = fieldNodeZ_
        ASSERT(.not.present(numeDofZ_))
        call dismoi('PROF_CHNO', fieldNode, 'CHAM_NO', repk = profChno)
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Get informations about physical quantity
!
    physNume = 0
    nb_ec    = 0
    if (present(numeDofZ_)) then
        call dismoi('NUM_GD_SI', numeDof  , 'NUME_DDL', repi = physNume)
    elseif (present(fieldNodeZ_)) then
        call dismoi('NUM_GD'   , fieldNode, 'CHAM_NO' , repi = physNume)
    else
        ASSERT(ASTER_FALSE)
    endif
    ASSERT(physNume .ne. 0)
    nb_ec = nbec(physNume)
    ASSERT(nb_ec .le. nbEcMax)
!
! - Access to catalog
!
    call jelira(jexnum('&CATA.GD.NOMCMP', physNume), 'LONMAX', physNbCmp)
    call jeveuo(jexnum('&CATA.GD.NOMCMP', physNume), 'L', vk8 = physCataName)
!
! - Select number of components
!
    if (present(listCmpToSelect_)) then
        ASSERT(present(nbCmpToSelect_))
        nbCmpToSelect = nbCmpToSelect_
    else
        nbCmpToSelect = physNbCmp
    endif
!
! - Select components
!
    AS_ALLOCATE(vi = cmpSelect, size = physNbCmp)
    do iCmp = 1, nbCmpToSelect
        if (present(listCmpToSelect_)) then
            cmpName = listCmpToSelect_(iCmp)
        else
            cmpName = physCataName(iCmp)
        endif
        numeCmp = indik8(physCataName, cmpName, 1, physNbCmp)
        if (numeCmp .ne. 0) then
            cmpSelect(numeCmp) = iCmp
        endif
    end do
!
! - PROF_CHNO or PROF_GENE ?
!
    call jeexin(profChno//'.DESC', iexi)
    lProfGene = (iexi .gt. 0)
    if (lProfGene) then
        profGene = profChno
        call select_dof_gene(profGene, nbCmpToSelect, physCataName,&
                             listCmpToSelect_, listEqua_, tablEqua_)
        goto 99
    endif
!
! - Get mesh
!
    mesh = ' '
    if (present(numeDofZ_)) then
        call dismoi('NOM_MAILLA', numeDof, 'NUME_DDL', repk = mesh)
    elseif (present(fieldNodeZ_)) then
        call dismoi('NOM_MAILLA', fieldNode, 'CHAM_NO' , repk = mesh)
    else
        ASSERT(ASTER_FALSE)
    endif
    call dismoi('NB_NO_MAILLA', mesh, 'MAILLAGE', repi = nbNodeMesh)
!
! - Select number of nodes
!
    nbNodeToSelect = 0
    if (present(listNodeToSelect_)) then
        nbNodeToSelect = nbNodeToSelect_
    else
        nbNodeToSelect = nbNodeMesh
    endif
!
! - Select nodes
!
    AS_ALLOCATE(vi = nodeSelect, size = nbNodeToSelect)
    if (present(listNodeToSelect_)) then
        do iNode = 1, nbNodeToSelect
            numeNode          = listNodeToSelect_(iNode)
            nodeSelect(iNode) = numeNode
        end do
    else
        do iNode = 1, nbNodeToSelect
            numeNode          = iNode
            nodeSelect(iNode) = numeNode
        end do
    endif
!
! - Some checks
!
    call jenuno(jexnum(profChno(1:19)//'.LILI', iLigrMesh), liliName)
    ASSERT(liliName .eq. '&MAILLA')
    call jelira(jexnum(profChno(1:19)//'.PRNO', iLigrMesh), 'LONMAX', prnoLength)
    ASSERT(prnoLength/(nb_ec+2) .eq. nbNodeMesh)
!
! - Get objects
!
    call jeveuo(jexnum(profChno(1:19)//'.PRNO', iLigrMesh), 'L', vi = prno)
    call jeveuo(profChno(1:19)//'.NUEQ', 'L', vi = nueq)
!
! - Loop on nodes
!
    if (nbNodeToSelect.ne.0) then
        do iNode = 1, nbNodeToSelect
            numeNode  = nodeSelect(iNode)
            dofNume   = prno((nb_ec+2)*(numeNode-1)+1) - 1
            nbCmpNode = prno((nb_ec+2)*(numeNode-1)+2)
            physDesc  = 0
            if (nbCmpNode .ne. 0) then
                do iEc = 1, nb_ec
                    physDesc(iEc) = prno((nb_ec+2)*(numeNode-1)+2+iEc)
                end do
            endif
            do iCmp = 1, physNbCmp
                if (exisdg(physDesc, iCmp)) then
                    dofNume = dofNume + 1
                    numeCmp = cmpSelect(iCmp)
                    if (numeCmp .ne. 0) then
                        numeEqua = nueq(dofNume)
                        if (present(tablCmp_)) then
                            tablCmp_(numeCmp) = numeEqua
                        elseif (present(listEqua_)) then
                            listEqua_(numeEqua) = 1
                        elseif (present(tablEqua_)) then
                            tablEqua_(numeEqua, numeCmp) = 1
                        endif
                    endif
                endif
            end do
        end do
    endif
!
! - Clean
!
    AS_DEALLOCATE(vi = cmpSelect)
    AS_DEALLOCATE(vi = nodeSelect)
!
99  continue
end subroutine
