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
subroutine merxth(model    , lload_name, lload_info, cara_elem  , mate     ,&
                  time_curr, time      , temp_iter , compor_ther, varc_curr,&
                  matr_elem, base      ,&
                  dry_prev_, dry_curr_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/ther_mtan.h"
#include "asterfort/gcnco2.h"
#include "asterfort/inical.h"
#include "asterfort/jeexin.h"
#include "asterfort/jedetr.h"
#include "asterfort/memare.h"
#include "asterfort/load_list_info.h"
#include "asterfort/load_neut_comp.h"
#include "asterfort/load_neut_prep.h"
!
character(len=24), intent(in) :: model
character(len=24), intent(in) :: lload_name
character(len=24), intent(in) :: lload_info
character(len=24), intent(in) :: cara_elem
character(len=24), intent(in) :: mate
real(kind=8), intent(in) :: time_curr
character(len=24), intent(in) :: time
character(len=24), intent(in) :: temp_iter
character(len=24), intent(in) :: compor_ther
character(len=19), intent(in) :: varc_curr
character(len=24), intent(in) :: matr_elem
character(len=1), intent(in) :: base
character(len=24), optional, intent(in) :: dry_prev_
character(len=24), optional, intent(in) :: dry_curr_
!
! --------------------------------------------------------------------------------------------------
!
! Thermic
! 
! Tangent matrix (non-linear) - Volumic and surfacic terms
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  lload_name       : name of object for list of loads name
! In  lload_info       : name of object for list of loads info
! In  cara_elem        : name of elementary characteristics (field)
! In  mate             : name of material characteristics (field)
! In  time_curr        : current time
! In  time             : time (<CARTE>)
! In  temp_iter        : temperature field at current Newton iteration
! In  compor_ther      : name of comportment definition (field)
! In  varc_curr        : command variable for current time
! In  matr_elem        : name of matr_elem result
! In  base             : JEVEUX base for object
! In  dry_prev         : previous drying
! In  dry_curr         : current drying
!
! --------------------------------------------------------------------------------------------------
!
    integer , parameter :: nb_in_maxi = 10 
    integer , parameter :: nbout = 1
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
    integer :: iret
    character(len=1) :: stop_calc
    character(len=8) :: load_name, newnom
    character(len=19) :: resu_elem
    integer :: load_nume
    aster_logical :: load_empty
    integer :: i_load, nb_load, nb_in_prep
    character(len=24), pointer :: v_load_name(:) => null()
    integer, pointer :: v_load_info(:) => null()
    character(len=24) :: dry_prev, dry_curr
!
! --------------------------------------------------------------------------------------------------
!
    resu_elem = matr_elem(1:8)//'.0000000'
    stop_calc = 'S'
!
! - Get fields
!
    dry_prev = ' '
    if (present(dry_prev_)) then
        dry_prev = dry_prev_
    endif
    dry_curr = ' '
    if (present(dry_curr_)) then
        dry_curr = dry_curr_
    endif
!
! - Prepare MATR_ELEM
!
    call jeexin(matr_elem(1:19)//'.RELR', iret)
    if (iret .eq. 0) then
        call memare(base, matr_elem, model, mate, cara_elem, 'MTAN_THER')
    else
        call jedetr(matr_elem(1:19)//'.RELR')
    endif
!
! - Generate new RESU_ELEM name
!
    newnom = resu_elem(10:16)
    call gcnco2(newnom)
    resu_elem(10:16) = newnom(2:8)
!
! - Tangent matrix - Volumic terms
!
    call ther_mtan(model    , mate    , time    , varc_curr, compor_ther,&
                   temp_iter, dry_prev, dry_curr, resu_elem, matr_elem  ,&
                   base)
!
! - Init fields
!
    call inical(nb_in_maxi, lpain, lchin, nbout, lpaout, lchout)
!
! - Loads
!
    call load_list_info(load_empty, nb_load   , v_load_name, v_load_info,&
                        lload_name, lload_info)

!
! - Preparing input fields
!
    call load_neut_prep(model, nb_in_maxi, nb_in_prep, lchin, lpain, &
                        varc_curr_ = varc_curr, temp_iter_ = temp_iter)
!
! - Computation
!
    do i_load = 1, nb_load
        load_name = v_load_name(i_load)(1:8)
        load_nume = v_load_info(nb_load+i_load+1)
        if (load_nume .gt. 0) then
            call load_neut_comp('MTAN'   , stop_calc, model     , time_curr , time ,&
                                load_name, load_nume, nb_in_maxi, nb_in_prep, lpain,&
                                lchin    , base     , resu_elem , matr_elem )
        endif
    end do
!
end subroutine
