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
subroutine convertFieldNodeToNeutElem(ligrel    , fieldNode  , fieldElemNeut,&
                                      nbCmpField, cmpNameNode, cmpNameNeut)
!
implicit none
!
#include "asterfort/alchml.h"
#include "asterfort/as_allocate.h"
#include "asterfort/chpchd.h"
#include "asterfort/chsut1.h"
#include "asterfort/cnocns.h"
#include "asterfort/cnscno.h"
#include "asterfort/codent.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nopar2.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: ligrel, fieldNode, fieldElemNeut
integer, intent(out) :: nbCmpField
character(len=8), pointer :: cmpNameNode(:), cmpNameNeut(:)
!
! --------------------------------------------------------------------------------------------------
!
! Utility
!
! Convert nodal field to neutral elementary field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16), parameter :: option = 'TOU_INI_ELGA'
    character(len=19), parameter :: fieldElemRefe = '&&PEEINT.CELMOD'
    character(len=19), parameter :: fieldNodeNeut = '&&PEEINT.CHAM_3'
    character(len=19), parameter :: fieldNodeS ='&&PEEINT.CHS1'
    character(len=4) :: ki
    character(len=8) :: paraName, physName
    character(len=8), pointer :: cnsc(:) => null()
    integer :: iCmp, ibid, iret 
!
! --------------------------------------------------------------------------------------------------
!
    nbCmpField = 0
!
! - Convert nodal field to get name of components
!
    call cnocns(fieldNode, 'V', fieldNodeS)
    call jeveuo(fieldNodeS//'.CNSC', 'L', vk8 = cnsc)
    call jelira(fieldNodeS//'.CNSC', 'LONMAX', nbCmpField)
    AS_ALLOCATE(vk8 = cmpNameNode, size = nbCmpField)
    AS_ALLOCATE(vk8 = cmpNameNeut, size = nbCmpField)
    do iCmp = 1, nbCmpField
        call codent(iCmp, 'G', ki)
        cmpNameNeut(iCmp) = 'X'//ki(1:len(ki))
        cmpNameNode(iCmp) = cnsc(iCmp)
    end do
!
! - Change name of components
!
    call chsut1(fieldNodeS, 'NEUT_R', nbCmpField, cmpNameNode, cmpNameNeut, 'V', fieldNodeS)
    call cnscno(fieldNodeS, ' ', 'NON', 'V', fieldNodeNeut, 'F', ibid)
    call detrsd('CHAM_NO_S', fieldNodeS)
!
! - Create new field on cell
!
    call dismoi('NOM_GD', fieldNodeNeut, 'CHAMP', repk = physName, arret='C', ier=iret)
    paraName = nopar2(option, physName, 'OUT')
    call alchml(ligrel, option, paraName, 'V', fieldElemRefe, iret, ' ')
    if (iret .ne. 0) then
        call utmess('F', 'UTILITAI3_23', nk=3, valk=[ligrel, paraName, option])
    endif
!
! - Change support of field
!
    call chpchd(fieldNodeNeut, 'ELGA', fieldElemRefe, 'OUI', 'V', fieldElemNeut)
    call detrsd('CHAMP', fieldElemRefe)
    call detrsd('CHAMP', fieldNodeNeut)
!
end subroutine
