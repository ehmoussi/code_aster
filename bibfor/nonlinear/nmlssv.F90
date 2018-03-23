! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine nmlssv(list_load)
!
implicit none
!
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/wkvect.h"
!
character(len=19), intent(in) :: list_load
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - SOUS-STRUCTURATION)
!
! LECTURE ET PREPARATION POUR SOUS_STRUCT
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load        : name of datastructure for list of loads
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: lload_fcss
    integer :: i, iret, nbsst
    character(len=24), pointer :: v_lload_fcss(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nbsst      = 0
    lload_fcss = list_load(1:19)//'.FCSS'
    call getfac('SOUS_STRUC', nbsst)
    if (nbsst .gt. 0) then
        call wkvect(lload_fcss, 'V V K24', nbsst, vk24 = v_lload_fcss)
        do i = 1, nbsst
            call getvid('SOUS_STRUC', 'FONC_MULT', iocc=i, scal=v_lload_fcss(i), nbret=iret)
            if (iret .eq. 0) then
                v_lload_fcss(i) = '&&CONSTA'
            endif
        end do
    endif
!
end subroutine
