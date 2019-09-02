! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
function iden_nume(pchn1, pchn2)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jelira.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/dismoi.h"
!
aster_logical :: iden_nume
character(len=*), intent(in) :: pchn1, pchn2
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: lili1, lili2, ligr_name1, ligr_name2
    character(len=24) :: prno1
    integer :: nb_lili1, nb_lili2, prno_length
    integer :: i_lili1, i_lili2
    aster_logical :: l_same_ligr
!
! --------------------------------------------------------------------------------------------------
!
    iden_nume = ASTER_TRUE
    lili1 = pchn1(1:19)//'.LILI'
    lili2 = pchn2(1:19)//'.LILI'
    prno1 = pchn1(1:19)//'.PRNO'
    call jelira(lili1, 'NOMUTI', nb_lili1)
    call jelira(lili2, 'NOMUTI', nb_lili2)
!
    do i_lili1 = 2, nb_lili1
        call jenuno(jexnum(lili1, i_lili1), ligr_name1)
        l_same_ligr = ASTER_FALSE
        do i_lili2 = 2, nb_lili2
            call jenuno(jexnum(lili2, i_lili2), ligr_name2)
            if (ligr_name1 .eq. ligr_name2) then
                l_same_ligr = ASTER_TRUE
            endif
        end do
! ----- LIGREL Not found but no dof 
        if (.not. l_same_ligr) then
            call jelira(jexnum(prno1, i_lili1), 'LONMAX', prno_length)
            if (prno_length .eq. 0) then
                l_same_ligr = ASTER_TRUE
            endif
        endif
        if (.not. l_same_ligr) then
            exit
        endif
    end do
!
    iden_nume = l_same_ligr
!
end function
