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
subroutine varinonu(modelZ, comporZ     ,&
                    nbCell, listCell    ,&
                    nbVari, listVariName, listVariNume)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/etenca.h"
#include "asterfort/jeexin.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/indk16.h"
#include "asterfort/comp_meca_pvar.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: modelZ, comporZ
integer, intent(in) :: nbCell, listCell(nbCell)
integer, intent(in) :: nbVari
character(len=16), intent(in) :: listVariName(nbVari)
character(len=8), intent(out) ::  listVariNume(nbCell, nbVari)
!
! --------------------------------------------------------------------------------------------------
!
! But : Etablir la correspondance entre les noms "mecaniques" de variables internes
! et leurs "numeros"  : 'V1', 'V7', ...
!
!  entrees:
!    comporZ  : nom de la carte de comportement
!    nbCell   : longueur de la liste listCell
!    listCell : liste des numeros de mailles concernees
!    nbVari : longueur des listes listVariName et listVariNume
!    listVariName : liste des noms "mecaniques" des variables internes
! sorties:
!    listVariNume : liste des "numeros" des variables internes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iVari, variNume
    integer :: iret, iCell, zoneField, jv_vari
    integer :: cellNume, nbVariZone
    character(len=19) :: compor, ligrmo
    character(len=19), parameter :: comporInfo = '&&NMDOCC.INFO'
    integer, pointer :: comporPtma(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Prepare COMPOR field
!
    compor = comporZ
    ligrmo = modelZ(1:8)//'.MODELE'
    call etenca(compor, ligrmo, iret)
    call jeveuo(compor//'.PTMA', 'L', vi = comporPtma)
!
! - Prepare informations about internal variables
!
    call jeexin(comporInfo(1:19)//'.ZONE', iret)
    if (iret .eq. 0) then
        call comp_meca_pvar(model_ = modelZ, compor_cart_ = compor, compor_info = comporInfo)
    endif
!
! - Access to informations
!
    do iCell = 1, nbCell
        cellNume  = listCell(iCell)
        zoneField = comporPtma(cellNume)
        call jelira(jexnum(comporInfo(1:19)//'.VARI', zoneField), 'LONMAX', nbVariZone)
        call jeveuo(jexnum(comporInfo(1:19)//'.VARI', zoneField), 'L', jv_vari)
        do iVari = 1, nbVari
            variNume = indk16(zk16(jv_vari), listVariName(iVari), 1, nbVariZone)
            if (variNume .eq. 0) then
                call utmess('F','EXTRACTION_22', sk = listVariName(iVari))
            endif
            listVariNume(iCell, iVari) = 'V'
            call codent(variNume, 'G', listVariNume(iCell, iVari)(2:8))
        enddo
    end do
!
    call jedema()
end subroutine
