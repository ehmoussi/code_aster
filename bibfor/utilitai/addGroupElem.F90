! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine addGroupElem(mesh, nb_add)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/cpclma.h"
#include "asterfort/jeexin.h"
#include "asterfort/jedetr.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jeecra.h"
#include "asterfort/jecrec.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
!
!
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: nb_add
!
! --------------------------------------------------------------------------------------------------
!
! Mesh management
!
! Add group in list of GROUP_MA
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh         : name of mesh
! In  nb_add       : number of groups to add
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: grpmai, gpptnm, grpmav
    character(len=24) :: group_name
    integer :: iret, nb_group, nb_group_new, nb_enti, i_enti, i_group
    integer, pointer :: v_list_old(:) => null()
    integer, pointer :: v_list_new(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    grpmai = mesh//'.GROUPEMA'
    gpptnm = mesh//'.PTRNOMMAI'
    grpmav = '&&ADDGRE.GROUPEMA'
!
    call jeexin(grpmai, iret)
    if (iret .eq. 0) then
        call jedetr(gpptnm)
        call jecreo(gpptnm, 'G N K24')
        call jeecra(gpptnm, 'NOMMAX', nb_add, ' ')
        call jecrec(grpmai, 'G V I', 'NO '//gpptnm, 'DISPERSE', 'VARIABLE', nb_add)
    else
        call jelira(grpmai, 'NOMUTI', nb_group)
        nb_group_new = nb_group + nb_add
        call cpclma(mesh, '&&ADDGRE', 'GROUPEMA', 'V')
        call jedetr(grpmai)
        call jedetr(gpptnm)
        call jecreo(gpptnm, 'G N K24')
        call jeecra(gpptnm, 'NOMMAX', nb_group_new, ' ')
        call jecrec(grpmai, 'G V I', 'NO '//gpptnm, 'DISPERSE', 'VARIABLE', nb_group_new)
        do i_group = 1, nb_group
            call jenuno(jexnum(grpmav, i_group), group_name)
            call jecroc(jexnom(grpmai, group_name))
            call jeveuo(jexnum(grpmav, i_group), 'L', vi = v_list_old)
            call jelira(jexnum(grpmav, i_group), 'LONUTI', nb_enti)
            call jeecra(jexnom(grpmai, group_name), 'LONMAX', max(nb_enti, 1))
            call jeecra(jexnom(grpmai, group_name), 'LONUTI', nb_enti)
            call jeveuo(jexnom(grpmai, group_name), 'E', vi = v_list_new)
            do i_enti = 1, nb_enti
                v_list_new(i_enti) = v_list_old(i_enti)
            enddo
        enddo
    endif
!
    call jedetr(grpmav)
!
end subroutine
