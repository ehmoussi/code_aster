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

subroutine verstp(model     , lload_name , lload_info, mate     , time_curr,&
                  time      , compor_ther, temp_prev , temp_iter, varc_curr,&
                  vect_elem , base       , &
                  hydr_prev_, hydr_curr_ , dry_prev_ , dry_curr_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/gcnco2.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecara.h"
#include "asterfort/megeom.h"
#include "asterfort/reajre.h"
#include "asterfort/load_neut_prep.h"
#include "asterfort/load_neut_comp.h"
#include "asterfort/resi_ther.h"
#include "asterfort/inical.h"
#include "asterfort/load_list_info.h"
#include "asterfort/detrsd.h"
#include "asterfort/memare.h"
!
character(len=24), intent(in) :: model
character(len=24), intent(in) :: lload_name
character(len=24), intent(in) :: lload_info
character(len=24), intent(in) :: mate
real(kind=8), intent(in) :: time_curr
character(len=24), intent(in) :: time
character(len=24), intent(in) :: compor_ther
character(len=24), intent(in) :: temp_prev
character(len=24), intent(in) :: temp_iter
character(len=19), intent(in) :: varc_curr
character(len=24), intent(in) :: vect_elem
character(len=1), intent(in) :: base
character(len=24), optional, intent(in) :: hydr_prev_
character(len=24), optional, intent(in) :: hydr_curr_
character(len=24), optional, intent(in) :: dry_prev_  
character(len=24), optional, intent(in) :: dry_curr_
!
! --------------------------------------------------------------------------------------------------
!
! Thermic - Residuals
! 
! Neumann loads elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  lload_name       : name of object for list of loads name
! In  lload_info       : name of object for list of loads info
! In  mate             : name of material characteristics (field)
! In  time_curr        : current time
! In  time             : time (<CARTE>)
! In  compor_ther      : name of comportment definition (field)
! In  temp_prev        : previous temperature
! In  temp_iter        : temperature field at current Newton iteration
! In  varc_curr        : command variable for current time
! In  vect_elem        : name of vect_elem result
! In  base             : JEVEUX base for object
! In  hydr_prev        : previous hydratation
! In  hydr_curr        : current hydratation
! In  dry_prev         : previous drying
! In  dry_curr         : current drying
!
! --------------------------------------------------------------------------------------------------
!
    integer , parameter :: nb_in_maxi = 5 
    integer , parameter :: nbout = 2
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
    character(len=1) :: stop_calc
    character(len=8) :: load_name, newnom
    character(len=19) :: resu_elem
    integer :: load_nume
    aster_logical :: load_empty
    integer :: i_load, nb_load, nb_in_prep
    character(len=24), pointer :: v_load_name(:) => null()
    integer, pointer :: v_load_info(:) => null()
    character(len=24) :: hydr_prev, hydr_curr, dry_prev, dry_curr
!
! --------------------------------------------------------------------------------------------------
!
    resu_elem = vect_elem(1:8)//'.0000000'
    stop_calc = 'S'
!
! - Get fields
!
    hydr_prev = ' '
    if (present(hydr_prev_)) then
        hydr_prev = hydr_prev_
    endif
    hydr_curr = '&&VEHYDR'
    if (present(hydr_curr_)) then
        hydr_curr = hydr_curr_
    endif
    dry_prev = ' '
    if (present(dry_prev_)) then
        dry_prev = dry_prev_
    endif
    dry_curr = ' '
    if (present(dry_curr_)) then
        dry_curr = dry_curr_
    endif
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
! - Allocate result
!
    call detrsd('VECT_ELEM', vect_elem)
    call memare(base, vect_elem, model, ' ', ' ',&
                'CHAR_THER')
    call reajre(vect_elem, ' ', base)
!
! - Generate new RESU_ELEM name
!
    newnom = resu_elem(10:16)
    call gcnco2(newnom)
    lchout(1) (10:16) = newnom(2:8)
!
! - Residuals from non-linear laws 
!
    call resi_ther(model    , mate     , time     , compor_ther, temp_prev,&
                   temp_iter, hydr_prev, hydr_curr, dry_prev   , dry_curr ,&
                   varc_curr, resu_elem, vect_elem, base)
!
! - Preparing input fields
!
    call load_neut_prep(model, nb_in_maxi, nb_in_prep, lchin, lpain,&
                        temp_iter_ = temp_iter)
!
! - Computation
!
    do i_load = 1, nb_load
        load_name = v_load_name(i_load)(1:8)
        load_nume = v_load_info(nb_load+i_load+1)
        if (load_nume .gt. 0) then
            call load_neut_comp('RESI'   , stop_calc, model     , time_curr , time ,&
                                load_name, load_nume, nb_in_maxi, nb_in_prep, lpain,&
                                lchin    , base     , resu_elem , vect_elem )
        endif
    end do
!
end subroutine
