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
subroutine comp_meca_chck(model, mesh, full_elem_s, l_etat_init, ds_compor_prep)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lccree.h"
#include "asterc/lctest.h"
#include "asterc/lcdiscard.h"
#include "asterfort/assert.h"
#include "asterfort/comp_meca_full.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/dismoi.h"
#include "asterfort/nmdovd.h"
#include "asterfort/nmdovm.h"
#include "asterfort/comp_read_mesh.h"
#include "asterfort/utmess.h"
!
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_info.h"
!
character(len=8), intent(in) :: model, mesh
character(len=19), intent(in) :: full_elem_s
aster_logical, intent(in) :: l_etat_init
type(Behaviour_PrepPara), intent(inout) :: ds_compor_prep
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of behaviour (mechanics)
!
! Check with Comportement.py
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  full_elem_s      : <CHELEM_S> of FULL_MECA option
! In  l_etat_init      : .true. if initial state is defined
! IO  ds_compor_prep   : datastructure to prepare comportement
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: list_elem_affe
    aster_logical :: l_affe_all
    integer :: nb_elem_affe
    character(len=16) :: defo_comp, rela_comp, rela_thmc, type_cpla
    character(len=16) :: rela_comp_py, defo_comp_py
    character(len=16) :: keywordfact
    integer :: i_comp, nb_comp, exte_defo
    aster_logical :: l_one_elem, l_elem_bound
    character(len=24) :: ligrmo
    character(len=8) :: partit
    mpi_int :: nb_proc, mpicou
    aster_logical :: l_auto_elas, l_auto_deborst, l_comp_erre, l_mfront
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact    = 'COMPORTEMENT'
    list_elem_affe = '&&COMPMECASAVE.LIST'
    nb_comp        = ds_compor_prep%nb_comp
    l_auto_elas    = ASTER_FALSE
    l_auto_deborst = ASTER_FALSE
    l_comp_erre    = ASTER_FALSE
!
! - MPI initialisation
!
    call asmpi_comm('GET', mpicou)
    call asmpi_info(mpicou, size=nb_proc)
!
! - Loop on occurrences of COMPORTEMENT
!
    do i_comp = 1, nb_comp
! ----- Get list of elements where comportment is defined
        call comp_read_mesh(mesh          , keywordfact, i_comp        ,&
                            list_elem_affe, l_affe_all , nb_elem_affe)
! ----- Get infos
        rela_comp = ds_compor_prep%v_para(i_comp)%rela_comp
        defo_comp = ds_compor_prep%v_para(i_comp)%defo_comp
        type_cpla = ds_compor_prep%v_para(i_comp)%type_cpla
        rela_thmc = ds_compor_prep%v_para(i_comp)%kit_comp(1)
        l_mfront  = ds_compor_prep%v_paraExte(i_comp)%l_mfront_offi .or.&
                    ds_compor_prep%v_paraExte(i_comp)%l_mfront_proto
        exte_defo = ds_compor_prep%v_paraExte(i_comp)%strain_model
! ----- Detection of specific cases
        if (rela_comp .eq. 'ENDO_HETEROGENE') then
            ligrmo = model//'.MODELE'
            call dismoi('PARTITION', ligrmo, 'LIGREL', repk=partit)
            if (partit .ne. ' ' .and. nb_proc .gt. 1) then
                call utmess('F', 'CALCULEL_25', sk=model)
            endif
         endif
! ----- Warning if ELASTIC comportment and initial state
        if (l_etat_init .and. rela_comp(1:10).eq.'ELAS_VMIS_') then
            call utmess('A', 'COMPOR1_61')
        endif
! ----- Coding comportment (Python)
        call lccree(1, rela_comp, rela_comp_py)
        call lccree(1, defo_comp, defo_comp_py)
! ----- Check comportment/model with Comportement.py
        call nmdovm(model       , l_affe_all  , list_elem_affe, nb_elem_affe  , full_elem_s,&
                    rela_comp_py, type_cpla   , l_auto_elas   , l_auto_deborst, l_comp_erre,&
                    l_one_elem  , l_elem_bound)
        if (.not. l_one_elem) then
            if (l_elem_bound) then
                call utmess('F', 'COMPOR1_60', si=i_comp)
            else
                call utmess('F', 'COMPOR1_59', si=i_comp)
            endif
        endif
        ds_compor_prep%v_para(i_comp)%type_cpla = type_cpla
! ----- Check strain model
        call nmdovd(model         , l_affe_all  , l_auto_deborst,&
                    list_elem_affe, nb_elem_affe, full_elem_s   ,&
                    l_mfront      , exte_defo   ,&
                    defo_comp     , defo_comp_py,&
                    rela_comp     , rela_comp_py)
!
        call lcdiscard(rela_comp_py)
        call lcdiscard(defo_comp_py)
    end do
!
! - Some informations
!   l_auto_elas      : .true. if at least one element use ELAS by default
!   l_auto_deborst   : .true. if at least one element swap to Deborst algorithm
!   l_comp_erre      : .true. if at least one element use comportment on element doesn't support it
!
    if (l_auto_deborst) then
        call utmess('I', 'COMPOR5_20')
    endif
    if (l_auto_elas) then
        call utmess('I', 'COMPOR5_21')
    endif
    if (l_comp_erre) then
        call utmess('I', 'COMPOR5_22')
    endif
!
end subroutine
