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
subroutine irtopo(keywf     , keywfIocc   ,&
                  dsName    , lResu       , lField,&
                  cellListNb, cellListNume,&
                  nodeListNb, nodeListNume,&
                  fileFormat, fileUnit    ,&
                  codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/irmama.h"
#include "asterfort/irmano.h"
#include "asterfort/irnono.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lxlgut.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=16), intent(in) :: keywf
integer, intent(in) :: keywfIocc
aster_logical, intent(in) :: lField, lResu
character(len=8), intent(in) :: dsName
integer, intent(out) :: cellListNb
integer, pointer :: cellListNume(:)
integer, intent(out) :: nodeListNb
integer, pointer :: nodeListNume(:)
integer, intent(in) :: fileUnit
character(len=8), intent(in) :: fileFormat
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Print result or field in a file (IMPR_RESU)
!
! Get parameters from user: topological entities (nodes and elements)
!
! --------------------------------------------------------------------------------------------------
!
! In  keywf            : keyword to read
! In  keywfIocc        : keyword index to read
! In  dsName           : name of datastructure (result or field)
! In  lResu            : flag if datastructure is a result
! Out cellListNb       : number of cells require by user
! Ptr cellListNume     : list of index of cells require by user
! Out nodeListNb       : number of nodes require by user
! Ptr nodeListNume     : list of index of nodes require by user
! In  fileFormat       : format of file to print (MED, RESULTAT, etc.)
! In  fileUnit         : index of file (logical unit)
! Out codret           : error return code (0: OK)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: meshNbNode, meshNbCell
    integer :: nbNodePrev, nbCellSelect, nbNodeSelect
    integer :: iGrCell, iGrNode, iCell, iNode
    integer :: nbCell, nbGrCell, nbNode, nbGrNode
    integer :: nbOcc
    integer :: imxno, imxgn, imxma, imxgm, idebu, iutil
    character(len=8) :: meshName
    integer, pointer :: nodeFlag(:) => null()
    integer, pointer :: cellFlag(:) => null()
    character(len=24), pointer :: grNodeName(:) => null()
    character(len=8), pointer :: nodeName(:) => null()
    character(len=24), pointer :: grCellName(:) => null()
    character(len=8), pointer :: cellName(:) => null()
    character(len=80) :: texte
    character(len=80), pointer :: nodeFile(:) => null()
    character(len=80), pointer :: grNodeFile(:) => null()
    character(len=80), pointer :: cellFile(:) => null()
    character(len=80), pointer :: grCellFile(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    cellListNb = 0
    nodeListNb = 0
    codret     = 0
!
! - No parameters to read
!
    if (.not.lField .and. .not.lResu) then
        goto 999
    endif
!
! - Get entities from user
!
    call getvtx(keywf, 'NOEUD', iocc=keywfIocc, nbval=0, nbret=nbNode)
    call getvtx(keywf, 'GROUP_NO', iocc=keywfIocc, nbval=0, nbret=nbGrNode)
    call getvtx(keywf, 'MAILLE', iocc=keywfIocc, nbval=0, nbret=nbCell)
    call getvtx(keywf, 'GROUP_MA', iocc=keywfIocc, nbval=0, nbret=nbGrCell)
    if (nbGrNode .lt. 0) then
        nbGrNode = -nbGrNode
        AS_ALLOCATE(vk24=grNodeName, size=nbGrNode)
        call getvtx(keywf, 'GROUP_NO', iocc=keywfIocc, nbval=nbGrNode,&
                    vect=grNodeName, nbret=nbOcc)
    endif
    if (nbNode .lt. 0) then
        nbNode = -nbNode
        AS_ALLOCATE(vk8=nodeName, size=nbNode)
        call getvtx(keywf, 'NOEUD', iocc=keywfIocc, nbval=nbNode,&
                    vect=nodeName, nbret=nbOcc)
    endif
    if (nbGrCell .lt. 0) then
        nbGrCell = -nbGrCell
        AS_ALLOCATE(vk24=grCellName, size=nbGrCell)
        call getvtx(keywf, 'GROUP_MA', iocc=keywfIocc, nbval=nbGrCell,&
                    vect=grCellName, nbret=nbOcc)
    endif
    if (nbCell .lt. 0) then
        nbCell = -nbCell
        AS_ALLOCATE(vk8=cellName, size=nbCell)
        call getvtx(keywf, 'MAILLE', iocc=keywfIocc, nbval=nbCell,&
                    vect=cellName, nbret=nbOcc)
    endif
!
! - Prepare selectors
!
    if (nbNode .ne. 0 .or. nbGrNode .ne. 0 .or. nbCell .ne. 0 .or. nbGrCell .ne. 0) then
        if (lResu) then
            call dismoi('NOM_MAILLA', dsName, 'RESULTAT', repk=meshName)
        else
            call dismoi('NOM_MAILLA', dsName, 'CHAMP', repk=meshName)
        endif
        call dismoi('NB_NO_MAILLA', meshName, 'MAILLAGE', repi=meshNbNode)
        call dismoi('NB_MA_MAILLA', meshName, 'MAILLAGE', repi=meshNbCell)
        AS_ALLOCATE(vi = nodeFlag, size=meshNbNode)
        AS_ALLOCATE(vi = nodeListNume, size = meshNbNode)
        AS_ALLOCATE(vi = cellListNume, size = meshNbCell)
        AS_ALLOCATE(vi = cellFlag, size=meshNbCell)
    endif
!
! - Select nodes
!
    nbNodeSelect = 0
    if (nbNode .ne. 0 .or. nbGrNode .ne. 0) then
        call irnono(meshName    , meshNbNode  ,&
                    nbNode      , nodeName    ,&
                    nbGrNode    , grNodeName  ,&
                    nodeListNume, nbNodeSelect,&
                    nodeFlag)
        nodeListNb = nodeListNb + nbNodeSelect
    endif
!
! - Select cells and nodes from cells
!
    nbCellSelect = 0
    if (nbCell .ne. 0 .or. nbGrCell .ne. 0) then
! ----- Select cells
        call irmama(meshName    , meshNbCell  ,&
                    nbCell      , cellName    ,&
                    nbGrCell    , grCellName  ,&
                    cellListNume, nbCellSelect,&
                    cellFlag)
        cellListNb = cellListNb + nbCellSelect
! ----- Nodes from cells
        nbNodePrev = nbNodeSelect
        call irmano(meshName    , meshNbNode  ,&
                    nbCellSelect, cellListNume,&
                    nodeListNume, nbNodeSelect,&
                    nodeFlag)
        nodeListNb = nodeListNb + (nbNodeSelect - nbNodePrev)
        nbNodeSelect = nbNodePrev
    endif
    if (nbNode .ne. 0 .or. nbGrNode .ne. 0 .or. nbCell .ne. 0 .or. nbGrCell .ne. 0) then
        if (nbNodeSelect .eq. 0 .and. nbCellSelect .eq. 0) then
            codret =1 
            goto 999
        endif
    endif
!
! - Print for FORMAT='RESULTAT'
!
    if (fileFormat .eq. 'RESULTAT') then
        imxno = 0
        imxgn = 0
        imxma = 0
        imxgm = 0
        if (nbNode .ne. 0) then
            AS_ALLOCATE(vk80 = nodeFile, size = nbNode)
            idebu = 12
            imxno = imxno+1
            do iNode = 1, nbNodeSelect
                texte = nodeName(iNode)
                iutil = lxlgut(texte)
                if (iutil .ne. 0) then
                    if ((idebu+iutil) .gt. 80) then
                        imxno = imxno + 1
                        idebu = 1
                    endif
                    nodeFile(imxno)(idebu:idebu+iutil) = texte(1:iutil)
                    idebu = idebu+iutil+1
                endif
            end do
        endif
        if (nbGrNode .ne. 0) then
            AS_ALLOCATE(vk80 = grNodeFile, size = nbGrNode)
            idebu = 12
            imxgn = imxgn + 1
            do iGrNode = 1, nbGrNode
                texte = grNodeName(iGrNode)
                iutil = lxlgut(texte)
                if (iutil .ne. 0) then
                    if ((idebu+iutil) .gt. 80) then
                        imxgn = imxgn + 1
                        idebu = 1
                    endif
                    grNodeFile(imxgn)(idebu:idebu+iutil) = texte(1:iutil)
                    idebu = idebu+iutil+1
                endif
            end do
        endif
        if (nbGrCell .ne. 0) then
            AS_ALLOCATE(vk80 = grCellFile, size = nbGrCell)
            idebu = 12
            imxgm = imxgm + 1
            do iGrCell = 1, nbGrCell
                texte = grCellName(iGrCell)
                iutil = lxlgut(texte)
                if (iutil .ne. 0) then
                    if ((idebu+iutil) .gt. 80) then
                        idebu = 1
                    endif
                    grCellFile(imxgm)(idebu:idebu+iutil) = texte(1:iutil)
                    idebu=idebu+iutil+1
                endif
            end do
        endif
        if (nbCell .ne. 0) then
            AS_ALLOCATE(vk80 = cellFile, size = nbCell)
            idebu = 12
            imxma = imxma + 1
            do iCell = 1, nbCellSelect
                texte = cellName(iCell)
                iutil = lxlgut(texte)
                if (iutil .ne. 0) then
                    if ((idebu+iutil) .gt. 80) then
                        imxma = imxma + 1
                        idebu = 1
                    endif
                    cellFile(imxma)(idebu:idebu+iutil) = texte(1:iutil)
                    idebu=idebu+iutil+1
                endif
            end do
        endif
        if (imxno .ne. 0 .or. imxgn .ne. 0 .or. imxma .ne. 0 .or. imxgm .ne. 0) then
            write(fileUnit, '(/,20X,A)') 'ENTITES TOPOLOGIQUES SELECTIONNEES '
        endif
        if (imxno .ne. 0) then
            nodeFile(1)(1:11) = 'NOEUD    : '
            write(fileUnit,'(1X,A80)') (nodeFile(iNode),iNode=1,imxno)
        endif
        if (imxgn .ne. 0) then
            grNodeFile(1)(1:11) = 'GROUP_NO : '
            write(fileUnit,'(1X,A80)') (grNodeFile(iGrNode),iGrNode=1,imxgn)
        endif
        if (imxma .ne. 0) then
            cellFile(1)(1:11) = 'MAILLE   : '
            write(fileUnit,'(1X,A80)') (cellFile(iCell),iCell=1,imxma)
        endif
        if (imxgm .ne. 0) then
            grCellFile(1)(1:11) = 'GROUP_MA : '
            write(fileUnit,'(1X,A80)') (grCellFile(iGrCell),iGrCell=1,imxgm)
        endif
        write(fileUnit,'(A)')
    endif
!
999 continue
!
    AS_DEALLOCATE(vk24 = grNodeName)
    AS_DEALLOCATE(vk8  = nodeName)
    AS_DEALLOCATE(vk24 = grCellName)
    AS_DEALLOCATE(vk8  = cellName)
    AS_DEALLOCATE(vk80 = nodeFile)
    AS_DEALLOCATE(vk80 = grNodeFile)
    AS_DEALLOCATE(vk80 = grCellFile)
    AS_DEALLOCATE(vk80 = cellFile)
    AS_DEALLOCATE(vi   = nodeFlag)
    AS_DEALLOCATE(vi   = cellFlag)
!
    call jedema()
!
end subroutine
