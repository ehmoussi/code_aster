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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmdovd(model         , l_affe_all  , l_auto_deborst,&
                  list_elem_affe, nb_elem_affe, full_elem_s   ,&
                  l_mfront      , exte_defo   ,&
                  defo_comp     , defo_comp_py,&
                  rela_comp     , rela_comp_py)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/lctest.h"
#include "asterfort/assert.h"
#include "asterfort/cesexi.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
character(len=8), intent(in) :: model
character(len=24), intent(in) :: list_elem_affe
aster_logical, intent(in) :: l_affe_all, l_auto_deborst, l_mfront
integer, intent(in) :: nb_elem_affe, exte_defo
character(len=19), intent(in) :: full_elem_s
character(len=16), intent(in) :: defo_comp, defo_comp_py
character(len=16), intent(in) :: rela_comp, rela_comp_py
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Check deformation with Comportement.py
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  full_elem_s      :  <CHELEM_S> of FULL_MECA option
! In  l_affe_all       : .true. if affect on all elements of model
! In  l_auto_deborst   : .true. if at least one element swap to Deborst algorithm
! In  nb_elem_affe     : number of elements where comportment affected
! In  list_elem_affe   : list of elements where comportment affected
! In  l_mfront         : .true. if MFront
! In  exte_defo        : strain model for external behaviour (MFront)
! In  defo_comp        : comportement DEFORMATION
! In  defo_comp_py     : comportement DEFORMATION - Python coding
! In  rela_comp        : comportment RELATION
! In  rela_comp_py     : comportement RELATION - Python coding
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: elem_type_name, texte(3), model_type, model_type2
    character(len=8) :: mesh, name_elem, grille
    character(len=19) :: ligrmo
    integer :: elem_type_nume
    integer :: j_cesd, j_cesl, j_cesv
    integer :: iret, irett, ielem, iad
    integer :: nb_elem_mesh, nb_elem, nb_elem_grel
    integer :: nume_elem, nume_grel
    integer, pointer :: v_repe(:) => null()
    integer, pointer :: v_elem_affe(:) => null()
    integer, pointer :: v_liel(:) => null()
    aster_logical :: l_coq3d, l_dkt, l_dktg, l_shell
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to model and mesh
!
    ligrmo = model//'.MODELE'
    call jeveuo(ligrmo(1:19)//'.REPE', 'L', vi=v_repe)
    call dismoi('NOM_MAILLA', model(1:8), 'MODELE', repk=mesh)
!
! - Access to <CHELEM_S> of FULL_MECA option
!
    call jeveuo(full_elem_s//'.CESD', 'L', j_cesd)
    call jeveuo(full_elem_s//'.CESL', 'L', j_cesl)
    call jeveuo(full_elem_s//'.CESV', 'L', j_cesv)
    nb_elem_mesh = zi(j_cesd-1+1)
!
! - Mesh affectation
!
    if (l_affe_all) then
        nb_elem = nb_elem_mesh
    else
        call jeveuo(list_elem_affe, 'L', vi = v_elem_affe)
        nb_elem = nb_elem_affe
    endif
!
! - No Deborst allowed with large strains models
!
    if (l_auto_deborst .and. defo_comp .eq. 'GDEF_LOG') then
        call utmess('F', 'COMPOR1_13')
    endif
    if (l_auto_deborst .and. defo_comp .eq. 'SIMO_MIEHE') then
        call utmess('F', 'COMPOR1_13')
    endif
!
! - Check consistency with catalog
!
    call lctest(rela_comp_py, 'DEFORMATION', defo_comp, iret)
    if (iret .eq. 0) then
        call utmess('F', 'COMPOR1_44', nk = 2, valk = [defo_comp, rela_comp])
    endif
!
! - Loop on elements
!
    do ielem = 1, nb_elem
! ----- Current element
        if (l_affe_all) then
            nume_elem = ielem
        else
            nume_elem = v_elem_affe(ielem)
        endif
        call jenuno(jexnum(mesh(1:8)//'.NOMMAI', nume_elem), name_elem)
! ----- Access to <CARTE>
        call cesexi('C', j_cesd, j_cesl, nume_elem, 1, 1, 1, iad)
        if (iad .gt. 0) then
! --------- Access to element type
            nume_grel = v_repe(2*(nume_elem-1)+1)
            call jeveuo(jexnum(ligrmo(1:19)//'.LIEL', nume_grel), 'L', vi = v_liel)
            call jelira(jexnum(ligrmo(1:19)//'.LIEL', nume_grel), 'LONMAX', nb_elem_grel)
            elem_type_nume = v_liel(nb_elem_grel)
            call jenuno(jexnum('&CATA.TE.NOMTE', elem_type_nume), elem_type_name)
! --------- Get modelisation
            call teattr('C', 'TYPMOD', model_type, iret, typel = elem_type_name)
            l_coq3d = lteatt('MODELI','CQ3', typel = elem_type_name)
            l_dkt   = lteatt('MODELI','DKT', typel = elem_type_name)
            l_dktg  = lteatt('MODELI','DTG', typel = elem_type_name)
            l_shell = lteatt('COQUE' ,'OUI', typel = elem_type_name)
! --------- Specific checks
            if (l_coq3d .and. (defo_comp .eq. 'GROT_GDEP') ) then
                call utmess('A', 'COMPOR1_47')
            endif
            if (l_dkt .and. .not. l_dktg ) then
                if ((defo_comp .eq. 'GROT_GDEP') .and. (rela_comp(1:4).ne.'ELAS')) then
                    call utmess('F', 'COMPOR1_48')
                endif
            endif
            if (l_mfront) then
                if (exte_defo .eq. MFRONT_STRAIN_SMALL) then
                    if (defo_comp .ne. 'PETIT' .and.&
                        defo_comp .ne. 'PETIT_REAC' .and.&
                        defo_comp .ne. 'GDEF_LOG' .and.&
                        defo_comp .ne. 'GROT_GDEP' ) then
                        call utmess('F', 'COMPOR4_35', sk = defo_comp)
                    endif
                endif
                if (exte_defo .eq. MFRONT_STRAIN_SIMOMIEHE) then
                    if (defo_comp .ne. 'SIMO_MIEHE' ) then
                        call utmess('F', 'COMPOR4_35', sk = defo_comp)
                    endif
                endif
                if (exte_defo .eq. MFRONT_STRAIN_GROTGDEP) then
                    if (defo_comp .ne. 'GROT_GDEP' .and.&
                        defo_comp .ne. 'PETIT' ) then
                        call utmess('F', 'COMPOR4_35', sk = defo_comp)
                    endif
                endif
            endif
! --------- Generic checks
            if (iret .eq. 0) then
                if (model_type .eq. 'C_PLAN') then
                    if (defo_comp .eq. 'GROT_GDEP' .and. rela_comp .eq. 'ELAS' .and.&
                        .not. l_shell) then
                        call utmess('F', 'COMPOR1_15')
                    endif
                elseif (model_type .eq. '3D') then
                    call lctest(defo_comp_py, 'MODELISATION', '3D', irett)
                    if (irett .eq. 0) then
                        texte(1) = elem_type_name
                        texte(2) = name_elem
                        texte(3) = defo_comp
                        call utmess('F', 'COMPOR5_23', nk=3, valk=texte)
                    endif
                else if (model_type .eq. '1D') then
                    call teattr('C', 'TYPMOD2', model_type2, iret, typel=elem_type_name)
                    if (model_type2 .eq. 'PMF') then
                        call lctest(defo_comp_py, 'MODELISATION', 'PMF', irett)
                        if (irett .eq. 0) then
                            texte(1) = elem_type_name
                            texte(2) = name_elem
                            texte(3) = defo_comp
                            call utmess('F', 'COMPOR5_23', nk=3, valk=texte)
                        endif
                    else
                        call teattr('C', 'GRILLE', grille, iret, typel=elem_type_name)
                        if (grille(1:3).eq.'OUI') then
                            call lctest(defo_comp_py, 'MODELISATION', 'GRILLE', irett)
                        else
                            call lctest(defo_comp_py, 'MODELISATION', '1D', irett)
                        endif
                        if (irett .eq. 0) then
                            texte(1) = elem_type_name
                            texte(2) = name_elem
                            texte(3) = defo_comp
                            call utmess('F', 'COMPOR5_23', nk=3, valk=texte)
                        endif
                    endif
                else
                    call lctest(defo_comp_py, 'MODELISATION', model_type, irett)
                    if (model_type .ne. '0D') then
                        if (irett .eq. 0) then
                            texte(1) = elem_type_name
                            texte(2) = name_elem
                            texte(3) = defo_comp
                            call utmess('F', 'COMPOR5_23', nk=3, valk=texte)
                        endif
                    endif
                endif
            endif
        endif
    end do
!
    call jedema()
!
end subroutine
