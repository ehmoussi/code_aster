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

subroutine vefpme(modelz, cara_elem, mate      , lload_namez , lload_infoz,&
                  inst  , varc_curr, vect_elemz, ligrel_calcz,&
                  disp_prevz  , disp_cumu_instz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/load_list_info.h"
#include "asterfort/load_neum_prep.h"
#include "asterfort/load_neum_comp.h"
#include "asterfort/detrsd.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
!
character(len=*), intent(in) :: modelz
character(len=*), intent(in) :: lload_namez
character(len=*), intent(in) :: lload_infoz
real(kind=8), intent(in) :: inst(3)
character(len=*), intent(in) :: cara_elem
character(len=*), intent(in) :: mate
character(len=*), intent(in) :: varc_curr
character(len=*), intent(in) :: ligrel_calcz
character(len=*), intent(inout) :: vect_elemz
character(len=*), intent(in) :: disp_prevz
character(len=*), intent(in) :: disp_cumu_instz
!
! --------------------------------------------------------------------------------------------------
!
! Compute Neumann loads
! 
! Dead and "driven" loads
!
! --------------------------------------------------------------------------------------------------
!
! In  stop           : COMPORTEMENT DE CALCUL
! In  model          : name of model
! In  mate           : name of material characteristics (field)
! In  cara_elem      : name of elementary characteristics (field)
! In  lload_name     : name of object for list of loads name
! In  lload_info     : name of object for list of loads info
! In  inst           : times informations
! In  ligrel_calc    : LIGREL to compute 
! In  varc_curr      : command variable for current time
! IO  vect_elem      : name of vect_elem result
! In  disp_prev      : displacement at beginning of current time
! In  disp_cumu_inst : displacement increment from beginning of current time
!
! ATTENTION :
!   LE VECT_ELEM (VECELZ) RESULTAT A 1 PARTICULARITE :
!   CERTAINS RESUELEM NE SONT PAS DES RESUELEM MAIS DES CHAM_NO (.VEASS)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_in_maxi, nbout
    parameter (nb_in_maxi = 42, nbout = 1)
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
!
    character(len=1) :: stop
    integer :: nb_load, i_load
    integer :: load_nume
    integer :: nb_in_prep
    real(kind=8) :: inst_prev, inst_curr, inst_theta
    character(len=19) :: disp_prev, disp_cumu_inst
    character(len=8) :: load_name
    character(len=24) :: ligrel_calc, model
    character(len=19) :: vect_elem, resu_elem
    character(len=24) :: lload_name
    character(len=24), pointer :: v_load_name(:) => null()
    character(len=24) :: lload_info
    integer, pointer :: v_load_info(:) => null()
    aster_logical :: load_empty
    character(len=1) :: base
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    stop        = 'S'
    resu_elem   = '&&VEFPME.0000000'
    model       = modelz
    lload_name  = lload_namez
    lload_info  = lload_infoz
    ligrel_calc = ligrel_calcz
    disp_prev      = disp_prevz
    disp_cumu_inst = disp_cumu_instz
    if (ligrel_calc .eq. ' ') then
        ligrel_calc = model(1:8)//'.MODELE'
    endif
    inst_prev   = inst(1)
    inst_curr   = inst(1)+inst(2)
    inst_theta  = inst(3)
    base        = 'V'
!
! - Init fields
!
    call inical(nb_in_maxi, lpain, lchin, nbout, lpaout,&
                lchout)
!
! - Result name for vect_elem
!
    vect_elem = vect_elemz
    if (vect_elem .eq. ' ') then
        vect_elem = '&&VEFPME'
    endif
!
! - Loads
!
    call load_list_info(load_empty, nb_load  , v_load_name, v_load_info,&
                        lload_name, lload_info)
!
! - Allocate result
!
    call detrsd('VECT_ELEM', vect_elem)
    call memare(base, vect_elem, model, mate, cara_elem,&
                'CHAR_MECA')
    call reajre(vect_elem, ' ', base)
    if (load_empty) then
        goto 99
    endif
!
! - Preparing input fields
!
    call load_neum_prep(model    , cara_elem , mate      , 'Pilo'      , inst_prev,&
                        inst_curr, inst_theta, nb_in_maxi, nb_in_prep  , lchin    ,&
                        lpain    , disp_prev = disp_prev, disp_cumu_inst = disp_cumu_inst,&
                        varc_curr = varc_curr)
!
! - Computation
!
    do i_load = 1, nb_load
        load_name = v_load_name(i_load)(1:8)
        load_nume = v_load_info(nb_load+i_load+1)
        if ((load_nume .eq. 5).or.(load_nume .eq. 8)) then
            call load_neum_comp(stop       , i_load    , load_name , load_nume, 'Pilo',&
                                ligrel_calc, nb_in_maxi, nb_in_prep, lpain    , lchin ,&
                                base       , resu_elem , vect_elem)
        endif
        if ((load_nume .eq. 9).or.(load_nume .eq. 11)) then
            call load_neum_comp(stop       , i_load    , load_name , load_nume, 'Suiv',&
                                ligrel_calc, nb_in_maxi, nb_in_prep, lpain    , lchin ,&
                                base       , resu_elem , vect_elem)
        endif
    end do
!
 99 continue
!
    vect_elemz = vect_elem//'.RELR'
!
    call jedema()
end subroutine
