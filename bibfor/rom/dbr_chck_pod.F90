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
subroutine dbr_chck_pod(operation, paraPod, l_reuse, base)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rs_paraonce.h"
#include "asterfort/dbr_chck_table.h"
!
character(len=16), intent(in) :: operation
type(ROM_DS_ParaDBR_POD), intent(in) :: paraPod
aster_logical, intent(in) :: l_reuse
type(ROM_DS_Empi), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  operation        : type of method
! In  paraPod          : datastructure for parameters (POD)
! In  l_reuse          : .true. if reuse
! In  base             : base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nbPara = 4
    character(len=16), parameter :: paraName(nbPara) = (/&
        'MODELE  ', 'CHAMPMAT',&
        'CARAELEM', 'EXCIT   '/)
    character(len=8) :: tablUserName
    character(len=24) :: tablName
    aster_logical :: lTablUser, lTablFromResu
    integer :: nbMode, nbSnap
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','ROM5_19')
    endif
!
! - General check
!
    if (l_reuse .and. operation .eq. 'POD') then
        call utmess('F', 'ROM2_13', sk = operation)
    endif
!
! - Check if parameters are the same on all storing index
!
    call rs_paraonce(paraPod%resultDom%resultName, nbPara, paraName)
!
! - Check if COOR_REDUIT is OK
!
    lTablFromResu = paraPod%resultDom%lTablFromResu
    tablUserName  = paraPod%tablReduCoor%tablUserName
    lTablUser     = paraPod%tablReduCoor%lTablUser
    tablName      = paraPod%tablReduCoor%tablResu%tablName
    if (operation .eq. 'POD_INCR' .and. l_reuse) then
! ----- Check if table is OK
        if (lTablFromResu) then
            if (lTablUser) then
                call utmess('F', 'ROM7_24')
            endif
        else
            if (.not. lTablUser) then
                call utmess('F', 'ROM7_23')
            endif
        endif
! ----- Check conformity of table
        if (lTablUser) then
            nbMode = base%nbMode
            nbSnap = paraPod%snap%nbSnap
            call dbr_chck_table(tablUserName, nbMode, nbSnap)
        endif
    endif
!
end subroutine
