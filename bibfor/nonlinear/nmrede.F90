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
subroutine nmrede(list_func_acti, sddyna     ,&
                  sdnume        , nb_equa    , matass,&
                  ds_material   , ds_contact ,&
                  cnfext        , cnfint     , cndiri, cnsstr,&
                  hval_measse   , hval_incr  ,&
                  r_char_vale   , r_char_indx)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndiner.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddyna, sdnume
integer, intent(in) :: nb_equa
character(len=19), intent(in) :: matass
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: cnfext, cnfint, cndiri, cnsstr
character(len=19), intent(in) :: hval_measse(*)
character(len=19), intent(in) :: hval_incr(*)
real(kind=8), intent(out) :: r_char_vale
integer, intent(out) :: r_char_indx
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute force for denominator of RESI_GLOB_RELA
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  sddyna           : datastructure for dynamic
! In  sdnume           : datastructure for dof positions
! In  nb_equa          : total number of equations
! In  matass           : matrix
! In  ds_material      : datastructure for material parameters
! In  ds_contact       : datastructure for contact management
! In  cnfext           : nodal field for external force
! In  cnfint           : nodal field for internal force
! In  cndiri           : nodal field for support reaction
! In  cnsstr           : nodal field for sub-structuring force
! In  hval_measse      : hat-variable for matrix
! In  hval_incr        : hat-variable for incremental values fields
! Out r_char_vale      : norm for denominator of RESI_GLOB_RELA
! Out r_char_indx      : index of value for denominator of RESI_GLOB_RELA
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_dyna, l_load_cine, l_cont_cont, l_cont_lac, l_macr
    character(len=19) :: cniner
    integer :: i_equa
    real(kind=8) :: val2, appui, fext
    character(len=24) :: sdnuco
    integer, pointer :: v_ccid(:) => null()
    integer, pointer :: v_sdnuco(:) => null()
    real(kind=8), pointer :: v_cnctdf(:) => null()
    real(kind=8), pointer :: v_cndiri(:) => null()
    real(kind=8), pointer :: v_cnfext(:) => null()
    real(kind=8), pointer :: v_cnfint(:) => null()
    real(kind=8), pointer :: v_cniner(:) => null()
    real(kind=8), pointer :: v_cnsstr(:) => null()
    real(kind=8), pointer :: v_fvarc_curr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! - Initializations
!
    r_char_vale = 0.d0
    r_char_indx = 0
!
! - Active functionnalities
!
    l_dyna      = ndynlo(sddyna,'DYNAMIQUE')
    l_load_cine = isfonc(list_func_acti,'DIRI_CINE')
    l_cont_cont = isfonc(list_func_acti,'CONT_CONTINU')
    l_cont_lac  = isfonc(list_func_acti,'CONT_LAC')
    l_macr      = isfonc(list_func_acti, 'MACR_ELEM_STAT')
!
! - Compute inertial force
!
    if (l_dyna) then
        cniner = '&&CNPART.CHP1'
        call ndiner(nb_equa, sddyna, hval_incr, hval_measse, cniner)
    endif
!
! - For kinematic loads
!
    if (l_load_cine) then
        call jeveuo(matass(1:19)//'.CCID', 'L', vi = v_ccid)
    endif
!
! - For contact dof
!
    if (l_cont_cont .or. l_cont_lac) then
        sdnuco = sdnume(1:19)//'.NUCO'
        call jeveuo(sdnuco, 'L', vi = v_sdnuco)
    endif
!
! - Access
!
    call jeveuo(cnfint(1:19)//'.VALE', 'L', vr=v_cnfint)
    call jeveuo(cndiri(1:19)//'.VALE', 'L', vr=v_cndiri)
    call jeveuo(cnfext(1:19)//'.VALE', 'L', vr=v_cnfext)
    call jeveuo(ds_material%fvarc_curr(1:19)//'.VALE', 'L', vr=v_fvarc_curr)
    if (l_dyna) then
        call jeveuo(cniner(1:19)//'.VALE', 'L', vr=v_cniner)
    endif
    if (ds_contact%l_cnctdf) then
        call jeveuo(ds_contact%cnctdf(1:19)//'.VALE', 'L', vr=v_cnctdf)
    endif
    if (l_macr) then
        call jeveuo(cnsstr(1:19)//'.VALE', 'L', vr=v_cnsstr)
    endif
!
! - Compute
!
    do i_equa = 1, nb_equa
! ----- Select support force
        appui = 0.d0
        fext  = 0.d0
        if (l_load_cine) then
            if (v_ccid(i_equa) .eq. 1) then
                appui = - v_cnfint(i_equa)
                fext  = 0.d0
                if (l_macr) then
                    appui = - v_cnfint(i_equa) - v_cnsstr(i_equa)
                endif
            else
                if (ds_contact%l_cnctdf) then
                    appui = v_cndiri(i_equa) + v_cnctdf(i_equa)
                else
                    appui = v_cndiri(i_equa)
                endif
                fext = v_cnfext(i_equa)
            endif
        else
            if (ds_contact%l_cnctdf) then
                appui = v_cndiri(i_equa) + v_cnctdf(i_equa)
            else
                appui = v_cndiri(i_equa)
            endif
            fext = v_cnfext(i_equa)
        endif
! ----- Compute value
        val2 = abs(appui-fext)+abs(v_fvarc_curr(i_equa))
! ----- Exclude contact dof
        if (l_cont_cont .or. l_cont_lac) then
            if (v_sdnuco(i_equa) .eq. 1) then
                cycle
            endif
        endif
! ----- Get maximum value (static)
        if (r_char_vale .le. val2) then
            r_char_vale = val2
            r_char_indx = i_equa
        endif
! ----- Get maximum value (dynamic)
        if (l_dyna) then
            if (r_char_vale .le. abs(v_cniner(i_equa))) then
                r_char_vale = abs(v_cniner(i_equa))
                r_char_indx = i_equa
            endif
        endif
    end do
!
    call jedema()
end subroutine
