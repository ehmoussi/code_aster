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
!
subroutine vethbt(model    , lload_name, lload_info, cara_elem, mate,&
                  temp_iter, vect_elem , base)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/gcnco2.h"
#include "asterfort/inical.h"
#include "asterfort/load_list_info.h"
#include "asterfort/jeveuo.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/detrsd.h"
!
character(len=24), intent(in) :: model
character(len=24), intent(in) :: lload_name
character(len=24), intent(in) :: lload_info
character(len=24), intent(in) :: cara_elem
character(len=24), intent(in) :: mate
character(len=24), intent(in) :: temp_iter
character(len=24), intent(in) :: vect_elem
character(len=1), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! Compute Dirichlet loads
!
! For Lagrange elements (AFFE_CHAR_THER) - BT . LAMBDA (reaction loads)
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  lload_name       : name of object for list of loads name
! In  lload_info       : name of object for list of loads info
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
! In  temp_iter        : temperature field at current Newton iteration
! In  vect_elem        : name of vect_elem result
! In  base             : JEVEUX base for object
!
! --------------------------------------------------------------------------------------------------
!
    integer , parameter :: nbin = 2 
    integer , parameter :: nbout = 1
    character(len=8) :: lpain(nbin), lpaout(nbout)
    character(len=19) :: lchin(nbin), lchout(nbout)
    character(len=16) :: option
    character(len=24) :: ligrch
    character(len=8) :: load_name, newnom
    character(len=19) :: resu_elem
    integer :: load_nume, ibid
    aster_logical :: load_empty
    integer :: i_load, nb_load
    character(len=24), pointer :: v_load_name(:) => null()
    integer, pointer :: v_load_info(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    newnom    = '.0000000'
    option    = 'THER_BTLA_R'
    resu_elem = vect_elem(1:8)//'.0000000'
!
! - Init fields
!
    call inical(nbin, lpain, lchin, nbout, lpaout, lchout)    
!
! - Loads
!
    call load_list_info(load_empty, nb_load   , v_load_name, v_load_info,&
                        lload_name, lload_info)
!
! - Allocate result
!
    call detrsd('VECT_ELEM', vect_elem)
    call memare(base, vect_elem, model, mate, cara_elem, 'CHAR_THER')
    call reajre(vect_elem, ' ', base)
!
! - Input fields
!
    lpain(1) = 'PLAGRAR'
    lchin(1) = temp_iter(1:19)
!
! - Output field
!
    lpaout(1) = 'PVECTTR'
!
! - Computation
!
    if (nb_load .gt. 0) then
        do i_load = 1, nb_load
            load_name = v_load_name(i_load)(1:8)
            load_nume = v_load_info(i_load+1)         
            if (load_nume .gt. 0) then
                ligrch   = load_name//'.CHTH.LIGRE'
! ------------- Input field
                lpain(2) = 'PDDLMUR'
                lchin(2) = load_name//'.CHTH.CMULT'
! ------------- Generate new RESU_ELEM name
                call gcnco2(newnom)
                resu_elem(10:16) = newnom(2:8)
                call corich('E', resu_elem, -1, ibid)
                lchout(1) = resu_elem
! ------------- Computation
                call calcul('S'  , option, ligrch, nbin  , lchin,&
                            lpain, nbout , lchout, lpaout, base ,&
                            'OUI')
! ------------- Copying output field
                call reajre(vect_elem, lchout(1), 'V')
            endif
        end do
    endif
!
end subroutine
