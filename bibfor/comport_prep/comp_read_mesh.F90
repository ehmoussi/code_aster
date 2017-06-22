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

subroutine comp_read_mesh(mesh          , keywordfact, iocc        ,&
                          list_elem_affe, l_affe_all , nb_elem_affe)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
#include "asterfort/reliem.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    character(len=24), intent(in) :: list_elem_affe
    aster_logical, intent(out) :: l_affe_all
    integer, intent(out):: nb_elem_affe
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get list of elements where comportment is defined
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  keywordfact      : factor keyword to read (COMPORTEMENT)
! In  iocc             : factor keyword index
! In  list_elem_affe   : name of JEVEUX object for list of elements where comportment is defined
! Out l_affe_all       : .true. if all elements were affected
! Out nb_elem_affe     : number of elements where comportment is defined
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8), parameter :: keyw_type(2) = (/'GROUP_MA', 'MAILLE  '/)
    character(len=16), parameter :: keyw_name(2) = (/'GROUP_MA', 'MAILLE  '/)
    integer :: nt
!
! --------------------------------------------------------------------------------------------------
!
    l_affe_all   = .false._1
    nb_elem_affe = 0
!
! - Get list of elements
!
    call getvtx(keywordfact, 'TOUT', iocc = iocc, nbret = nt)
    if (nt .ne. 0) then
        l_affe_all = .true.
    else
        l_affe_all = .false.
        call reliem(' ', mesh     , 'NU_MAILLE', keywordfact   , iocc,&
                    2  , keyw_name, keyw_type  , list_elem_affe, nb_elem_affe)
        if (nb_elem_affe .eq. 0) then
            l_affe_all = .true.
        endif
    endif
!
end subroutine
