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
subroutine nmnume(model     , mesh    , result, compor, list_load, &
                  ds_contact, nume_dof, sdnume)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmprof.h"
#include "asterfort/nuendo.h"
#include "asterfort/nunuco.h"
#include "asterfort/nunuco_l.h"
#include "asterfort/nurota.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: model
character(len=8), intent(in) :: result
character(len=24), intent(in) :: compor
character(len=19), intent(in) :: list_load
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=24), intent(out) :: nume_dof
character(len=19), intent(in) :: sdnume
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm - Initializations
!
! Create information about numbering
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model datastructure
! In  result           : name of result datastructure (EVOL_NOLI)
! In  compor           : name of <CARTE> COMPOR
! In  list_load        : list of loads
! In  ds_contact       : datastructure for contact management
! Out nume_dof         : name of numbering object (NUME_DDL)
! In  sdnume           : name of dof positions datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv, i_load, nb_load_init, iret
    character(len=8) :: lag12
    character(len=24) :: sdnuro, sdnuen, sdnuco
    character(len=24) :: lload_info, lload_list, load_n
    integer, pointer :: v_load_info(:) => null()
    character(len=8), pointer :: v_lgrf(:) => null()
    character(len=24), pointer :: v_load_list(:) => null()
    character(len=24), pointer :: v_tco(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_12')
    endif
!
! - Check if single Lagrange multiplier is not used
!
    lload_info = list_load(1:19)//'.INFC'
    call jeveuo(lload_info, 'L', vi = v_load_info)
    nb_load_init = v_load_info(1)
    lload_list = list_load(1:19)//'.LCHA'
    call jeveuo(lload_list, 'L', vk24 = v_load_list)
    do i_load = 1, nb_load_init
        load_n = v_load_list(i_load)
        call jeexin(load_n(1:19)//'._TCO', iret)
        if( iret.ne.0 ) then
            call jeveuo(load_n(1:19)//'._TCO', 'L', vk24 = v_tco)
            if( v_tco(1).eq.'CHAR_MECA' ) then
                call jeexin(load_n(1:8)//'.CHME.LIGRE.LGRF', iret)
                if( iret.ne.0 ) then
                    call jeveuo(load_n(1:8)//'.CHME.LIGRE.LGRF', 'L', vk8 = v_lgrf)
                    lag12 = v_lgrf(3)
                    if( lag12.eq.'LAG1' ) then
                        call utmess('F', 'MECANONLINE_5')
                    endif
                endif
            else if( v_tco(1).eq.'CHAR_THER' ) then
                call jeexin(load_n(1:8)//'.CHTH.LIGRE.LGRF', iret)
                if( iret.ne.0 ) then
                    call jeveuo(load_n(1:8)//'.CHTH.LIGRE.LGRF', 'L', vk8 = v_lgrf)
                    lag12 = v_lgrf(3)
                    if( lag12.eq.'LAG1' ) then
                        call utmess('F', 'MECANONLINE_5')
                    endif
                endif
            endif
        endif
    enddo
!
! - Create numbering
!
    call nmprof(model               , result, list_load, nume_dof,&
                ds_contact%iden_rela)
!
! - Get position of large rotation dof
!
    sdnuro = sdnume(1:19)//'.NDRO'
    call nurota(model, nume_dof, compor, sdnuro)
!
! - Get position of damaged dof
!
    sdnuen = sdnume(1:19)//'.ENDO'
    call nuendo(model, nume_dof, sdnuen)
!
! - Get position of contact dof
!
    sdnuco = sdnume(1:19)//'.NUCO'
    if (ds_contact%l_form_cont) then
        call nunuco(nume_dof, sdnuco)
    endif
    if (ds_contact%l_form_lac) then
        call nunuco(nume_dof, sdnuco)
        call nunuco_l(mesh, ds_contact, nume_dof, sdnume)
    endif
!
end subroutine
