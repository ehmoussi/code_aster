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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine comp_meca_read(l_etat_init, ds_compor_prep, model)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getexm.h"
#include "asterc/mfront_get_nbvari.h"
#include "asterfort/deprecated_behavior.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/comp_meca_incr.h"
#include "asterfort/getExternalBehaviourPara.h"
#include "asterfort/comp_meca_rkit.h"
#include "asterfort/comp_meca_l.h"
!
aster_logical, intent(in) :: l_etat_init
type(NL_DS_ComporPrep), intent(inout) :: ds_compor_prep
character(len=8), intent(in), optional :: model
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Read informations from command file
!
! --------------------------------------------------------------------------------------------------
!
! In  l_etat_init      : .true. if initial state is defined
! IO  ds_compor_prep   : datastructure to prepare comportement
! In  model            : name of model
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: mesh = ' '
    character(len=16) :: keywordfact
    integer :: i_comp, nb_comp, model_dim, iret
    character(len=16) :: defo_comp, rela_comp, type_cpla, mult_comp, type_comp
    character(len=16) :: post_iter, model_mfront, type_model2
    character(len=16) :: kit_comp(4)
    character(len=255) :: libr_name, subr_name
    integer :: unit_comp, nb_vari_umat
    aster_logical :: l_cristal, l_kit
    aster_logical :: l_comp_external
    integer, pointer :: v_model_elem(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact = 'COMPORTEMENT'
    nb_comp     = ds_compor_prep%nb_comp
    mesh        = ' '
!
! - Pointer to list of elements in model
!
    if ( present(model) ) then
        call jeveuo(model//'.MAILLE', 'L', vi = v_model_elem)
        call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
    endif
!
! - Read informations
!
    do i_comp = 1, nb_comp
!
        libr_name      = ' '
        subr_name      = ' '
        model_mfront   = ' '
        model_dim      = 0
        nb_vari_umat   = 0
        unit_comp      = 0
        rela_comp      = 'VIDE'
        defo_comp      = 'VIDE'
        mult_comp      = ' '
        type_cpla      = 'VIDE'
        libr_name      = ' '
        post_iter      = ' '
        kit_comp(1:4)  = 'VIDE'
        type_model2    = 'VIDE'
!
! ----- Get RELATION from command file
!
        call getvtx(keywordfact, 'RELATION', iocc = i_comp, scal = rela_comp)
        call deprecated_behavior(rela_comp)
!
! ----- Detection of specific cases
!
        call comp_meca_l(rela_comp, 'KIT'    , l_kit)
        call comp_meca_l(rela_comp, 'CRISTAL', l_cristal)
!
! ----- Get DEFORMATION from command file
!
        call getvtx(keywordfact, 'DEFORMATION', iocc = i_comp, scal = defo_comp)
!
! ----- Damage post-treatment
!
        if (getexm(keywordfact,'POST_ITER') .eq. 1) then
            call getvtx(keywordfact, 'POST_ITER', iocc = i_comp, scal=post_iter, nbret=iret)
            if (iret .eq. 0) then
                post_iter = ' '
            endif
        endif
!
! ----- For KIT
!
        if (l_kit) then
            call comp_meca_rkit(keywordfact, i_comp, rela_comp, kit_comp, l_etat_init)
        endif
!
! ----- Get multi-comportment *CRISTAL
!
        if (l_cristal) then
            call getvid(keywordfact, 'COMPOR', iocc = i_comp, scal = mult_comp)
        endif
!
! ----- Get parameters for external programs (MFRONT/UMAT)
!
        call getExternalBehaviourPara(mesh           , v_model_elem, rela_comp, kit_comp,&
                                      l_comp_external, ds_compor_prep%v_exte(i_comp),&
                                      keywordfact    , i_comp,&
                                      type_cpla_out_ = type_cpla)
!
! ----- Select type of comportment (incremental or total)
!
        call comp_meca_incr(rela_comp, defo_comp, type_comp, l_etat_init)
!
! ----- Save parameters
!
        ds_compor_prep%v_comp(i_comp)%rela_comp      = rela_comp
        ds_compor_prep%v_comp(i_comp)%defo_comp      = defo_comp
        ds_compor_prep%v_comp(i_comp)%type_comp      = type_comp
        ds_compor_prep%v_comp(i_comp)%type_cpla      = type_cpla
        ds_compor_prep%v_comp(i_comp)%kit_comp(:)    = kit_comp(:)
        ds_compor_prep%v_comp(i_comp)%mult_comp      = mult_comp
        ds_compor_prep%v_comp(i_comp)%post_iter      = post_iter
        ds_compor_prep%v_comp(i_comp)%type_model2    = type_model2
    end do
!
end subroutine
