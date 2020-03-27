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
subroutine irdebg(dsName,&
                  fileFormat, fileUnit, fileVersion,&
                  lResu, lMesh, lField,&
                  lMeshCoor, paraFormat,realFormat,cplxFormat,&
                  lsup, linf, lmax, lmin,&
                  borsup, borinf,&
                  storeListNb, storeListIndx,&
                  fieldListNb, fieldListType, fieldMedListType,&
                  paraListNb, paraListName,&
                  cmpListNb, cmpListName,&
                  nodeListNb, nodeListNume,&
                  cellListNb, cellListNume)
!
implicit none
!
#include "asterf_types.h"
!
character(len=8), intent(in) :: dsName
character(len=8), intent(in) :: fileFormat
integer, intent(in) ::  fileUnit, fileVersion
aster_logical, intent(in) :: lResu, lMesh, lField
aster_logical, intent(in) :: lMeshCoor
character(len=1), intent(in) :: paraFormat
character(len=16), intent(in) :: realFormat
character(len=4), intent(in) :: cplxFormat
aster_logical, intent(in) :: lsup, linf, lmax, lmin
real(kind=8), intent(in) :: borsup, borinf
integer, intent(in) :: storeListNb
integer , pointer :: storeListIndx(:)
integer, intent(in) :: fieldListNb
character(len=16), pointer :: fieldListType(:)
character(len=80), pointer :: fieldMedListType(:)
integer, intent(in) :: paraListNb
character(len=16), pointer :: paraListName(:)
integer, intent(in) :: cmpListNb
character(len=8), pointer :: cmpListName(:)
integer, intent(in) :: nodeListNb
integer , pointer :: nodeListNume(:)
integer, intent(in) :: cellListNb
integer , pointer :: cellListNume(:)
!
! --------------------------------------------------------------------------------------------------
!
! Print result or field in a file (IMPR_RESU)
!
! Debug
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iField, iCmp, iNode, iCell, iPara, iStore
!
! --------------------------------------------------------------------------------------------------
!
    WRITE(6,*) '*** IMPR_RESU'
    WRITE(6,*) '    Format       : ', fileFormat
    WRITE(6,*) '    Unité logique: ', fileUnit
    if (lMesh) then
        WRITE(6,*) '    Le maillage est imprimé'
    else
        WRITE(6,*) '    Le maillage n''est pas imprimé'
    endif
    if (lResu) then
        WRITE(6,*) '    On imprime une SD RESULTAT de nom  : ', dsName
    elseif (lField) then
        WRITE(6,*) '    On imprime une SD CHAM_GD de nom   : ', dsName
    endif
    if (fileFormat .eq. 'ASTER') then
        WRITE(6,*) '**  Spécifique à ASTER (maillage uniquement)'
        WRITE(6,*) '    Format des réels                   : ', realFormat
    endif
    if (fileFormat .eq. 'GMSH') then
        WRITE(6,*) '**  Spécifique à GMSH'
        WRITE(6,*) '    Version du fichier                 : ', fileVersion
        WRITE(6,*) '    Cas des nombres complexes          : ', cplxFormat
    endif
    if (fileFormat .eq. 'MED') then
        WRITE(6,*) '**  Spécifique à MED'
        WRITE(6,*) '    Cas des nombres complexes          : ', cplxFormat

    endif
    if (fileFormat .eq. 'IDEAS') then
        WRITE(6,*) '**  Spécifique à IDEAS'
        WRITE(6,*) '    Version du fichier                 : ', fileVersion
        WRITE(6,*) '    Format des réels                   : ', realFormat
    endif
    if (fileFormat .eq. 'RESULTAT') then
        WRITE(6,*) '**  Spécifique à RESULTAT'
        if (lMeshCoor) then
            WRITE(6,*) '    On imprime les coordonnées des noeuds du maillage'
        endif
        WRITE(6,*) '    Forme d''impression des paramètres : ', paraFormat
        WRITE(6,*) '    Format des réels                   : ', realFormat
        WRITE(6,*) '    Valeurs extrémales - LINF          : ', linf, ' - Borne :', borinf
        WRITE(6,*) '    Valeurs extrémales - LSUP          : ', lsup, ' - Borne :', borsup
        WRITE(6,*) '    Valeurs extrémales - LMIN          : ', lmin
        WRITE(6,*) '    Valeurs extrémales - LMAX          : ', lmax
    endif

    WRITE(6,*) '**  Liste des champs: ', fieldListNb
    do iField = 1, fieldListNb
        WRITE(6,*) '    Type du champ          - ', iField,': ',fieldListType(iField)
        if (associated(fieldMedListType)) then
            WRITE(6,*) '    Champ MED: ', fieldMedListType(iField)
        endif
    end do

    WRITE(6,*) '**  Liste des index de sauvegarde: ', storeListNb
    do iStore = 1, storeListNb
        WRITE(6,*) '    Index de sauvegarde    - ', iStore,': ',storeListIndx(iStore)
    end do

    WRITE(6,*) '**  Liste des paramètres: ', paraListNb
    do iPara = 1, paraListNb
        WRITE(6,*) '    Nom du paramètre       - ', iPara,': ',paraListName(iPara)(1:16)
    end do

    WRITE(6,*) '**  Liste des composantes: ', cmpListNb
    do iCmp = 1, cmpListNb
        WRITE(6,*) '    Nom de la composante   - ', iCmp,': ',cmpListName(iCmp)(1:8)
    end do

    WRITE(6,*) '**  Liste des éléments: ', cellListNb
    do iCell = 1, cellListNb
        WRITE(6,*) '    Index de l''élément    - ', iCell,': ',cellListNume(iCell)
    end do

    WRITE(6,*) '**  Liste des noeuds: ', nodeListNb
    do iNode = 1, nodeListNb
        WRITE(6,*) '    Index du noeud         - ', iNode,': ',nodeListNume(iNode)
    end do

end subroutine
