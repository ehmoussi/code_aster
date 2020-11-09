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
subroutine select_dof_2(listEqua_     , tablEqua_       ,&
                        numeDofZ_     , fieldNodeZ_     ,&
                        nbCmpToSelect_, listCmpToSelect_)
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
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/nbec.h"
#include "asterfort/select_dof_gene.h"
!
integer, pointer, optional :: listEqua_(:), tablEqua_(:, :)
character(len=*), optional, intent(in) :: numeDofZ_, fieldNodeZ_
integer, optional, intent(in) :: nbCmpToSelect_
character(len=8), pointer, optional :: listCmpToSelect_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Utility for nodal field
!
! Select dof from list of components - On all LIGREL
!
! --------------------------------------------------------------------------------------------------
!
! Select output: listEqua/tablEqua/tablCmp
! Select input:
!    On numbering of nodal field (numeDof / fieldNode)
!    On which components (nbCmpToSelect / listCmpToSelect)
!                   if none => all components
!
! Ptr listEqua             : pointer to all equations [1:nbEqua] with
!                       for iEqua =  [1:nbEqua]
!                           listEqua[iEqua] = 0 if node+component not present
!                           listEqua[iEqua] = 1 if node+component is present
! Ptr tablEqua             : pointer to all equations and all components 
!                            [1:nbEqua, 1:nbCmpToSelect] with
!                       for iEqua = [1:nbEqua]
!                           for iCmp = [1:nbCmpToSelect]
!                               tablEqua[iEqua,iCmp] = 0 if node+component not present
!                               tablEqua[iEqua,iCmp] = 1 if node+component is present
! In  numeDof              : name of numbering (NUME_DDL)
! In  fieldNode            : name of nodal field (CHAMNO)
! In  nbCmpToSelect        : number of components (if none => all components)
! Ptr listCmpToSelect      : pointer to the list of components (name)
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbEcMax = 10
    integer :: physDesc(nbEcMax)
    character(len=8) :: cmpName, mesh
    character(len=19) :: profChno, profGene, fieldNode, numeEqul
    character(len=14) :: numeDof
    integer :: iexi
    aster_logical :: lProfGene
    aster_logical :: lMatrDist
    integer :: nodeNume, physNume, prnoLength
    integer :: iLigr, nbLigr, nbNode
    integer :: numeEqua, iNode, iCmp, dofNume, numeEquaL, numeCmp, iEc
    integer :: nb_ec, nbCmpToSelect, physNbCmp, nbCmpNode
    integer, pointer :: cmpSelect(:) => null()
    integer, pointer :: prno(:) => null()
    integer, pointer :: nueq(:) => null()
    integer, pointer :: nugl(:) => null()
    character(len=8), pointer :: physCataName(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    numeDof   = ' '
    fieldNode = ' '
    lMatrDist = ASTER_FALSE
!
! - Check output parameters
!
    ASSERT(EXCLUS2(tablEqua_, listEqua_))
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
! - Check if nume_ddl is correct (Distributed matrix)
!
    if (present(numeDofZ_)) then
        numeEqul = numeDof//'.NUML'
        call jeexin(numeEqul(1:19)//'.NUGL', iexi)
        lMatrDist = iexi.ne.0
        if (lMatrDist) then
            call jeveuo(numeEqul(1:19)//'.NUGL', 'L', vi = nugl)
        endif
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
        call select_dof_gene(profGene        , nbCmpToSelect, physCataName,&
                             listCmpToSelect_, listEqua_    , tablEqua_)
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
!
! - Get objects
!
    call jeveuo(profChno(1:19)//'.NUEQ', 'L', vi = nueq)
!
! - Loop on LIGRELs
!
    call jelira(profChno(1:19)//'.PRNO', 'NMAXOC', nbLigr)
    do iLigr = 1, nbLigr

! ----- Get number of nodes
        call jelira(jexnum(profChno(1:19)//'.PRNO', iLigr), 'LONMAX', prnoLength)
        nbNode = prnoLength/(nb_ec+2)

! ----- Loop on nodes
        if (nbNode.ne.0) then
            call jeveuo(jexnum(profChno(1:19)//'.PRNO', iLigr), 'L', vi = prno)
            do iNode = 1, nbNode
                nodeNume  = iNode

! ------------- Parameters of current node
                dofNume   = prno((nb_ec+2)*(nodeNume-1)+1) - 1
                nbCmpNode = prno((nb_ec+2)*(nodeNume-1)+2)

! ------------- Vector containing active components on current node
                physDesc  = 0
                if (nbCmpNode .ne. 0) then
                    do iEc = 1, nb_ec
                        physDesc(iEc) = prno((nb_ec+2)*(nodeNume-1)+2+iEc)
                    end do
                endif

! ------------- Loop on components to seek
                do iCmp = 1, physNbCmp
                    if (exisdg(physDesc, iCmp)) then
                        dofNume = dofNume + 1
                        numeCmp = cmpSelect(iCmp)
                        if (numeCmp .ne. 0) then
                            numeEqua = nueq(dofNume)
                            if (lMatrDist) then
                                numeEquaL = nugl(numeEqua)
                            else
                                numeEquaL = numeEqua
                            endif
                            if (present(listEqua_)) then
                                listEqua_(numeEquaL) = 1
                            elseif (present(tablEqua_)) then
                                tablEqua_(numeEquaL, numeCmp) = 1
                            endif
                        endif
                    endif
                end do
            end do
        endif
    end do
!
99  continue
!
! - Clean
!
    AS_DEALLOCATE(vi = cmpSelect)
!
end subroutine
