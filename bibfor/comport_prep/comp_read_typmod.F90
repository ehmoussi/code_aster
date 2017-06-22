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

subroutine comp_read_typmod(mesh       , v_model_elem,&
                            keywordfact, i_comp      , rela_comp ,&
                            model_dim  , model_mfront, type_cpla_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/comp_read_mesh.h"
#include "asterfort/comp_mfront_modelem.h"
#include "asterfort/utmess.h"
#include "asterc/lccree.h"
#include "asterc/lcdiscard.h"
#include "asterc/lctest.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    integer, intent(in), pointer :: v_model_elem(:)
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: i_comp
    character(len=16), intent(in) :: rela_comp
    character(len=16), intent(out) :: model_mfront
    integer, intent(out) :: model_dim
    character(len=16), optional, intent(out) :: type_cpla_
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Find dimension and type of modelisation for MFront
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  v_model_elem     : pointer to list of elements in model
! In  keywordfact      : factor keyword to read (COMPORTEMENT)
! In  i_comp           : factor keyword index
! In  rela_comp        : RELATION comportment
! Out model_dim        : dimension of modelisation (2D or 3D)
! Out model_mfront     : type of modelisation MFront
! Out type_cpla        : stress plane hypothesis (for Deborst)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_elem_affe, nb_elem, i_elem, elem_nume
    integer :: elem_type_nume, iret, codret
    aster_logical :: l_affe_all, l_mfront_cp
    character(len=24) :: list_elem_affe
    character(len=16) :: elem_type_name, model_save, rela_comp_py, type_cpla, answer
    integer, pointer :: v_elem_affe(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    model_mfront   = ' '
    model_save     = ' '
    model_dim      = 0
    list_elem_affe = '&&COMPMECASAVE.LIST'
    type_cpla      = 'VIDE'
!
! - For CALC_POINT_MAT case
!
    if ( .not.associated(v_model_elem) ) then
        model_dim    = 3
        model_save   = '_Tridimensional'
        model_mfront = '_Tridimensional'
        goto 99
    endif
!
! - Get list of elements where comportment is defined
!
    call comp_read_mesh(mesh          , keywordfact, i_comp        ,&
                        list_elem_affe, l_affe_all , nb_elem_affe)
    if (l_affe_all) then
        call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nb_elem)
    else
        call jeveuo(list_elem_affe, 'L', vi = v_elem_affe)
        nb_elem = nb_elem_affe
    endif
!
! - For plane stress hypothesis
!
    if (rela_comp .eq. 'MFRONT') then
        call getvtx(keywordfact, 'ALGO_CPLAN', iocc = i_comp, scal = answer)
        l_mfront_cp = answer .eq. 'ANALYTIQUE'  
    else
        call lccree(1, rela_comp, rela_comp_py)
        call lctest(rela_comp_py, 'MODELISATION', 'C_PLAN', iret)
        l_mfront_cp = iret .ne. 0
        call lcdiscard(rela_comp_py)
    endif
!
! - Loop on elements
!
    
    do i_elem = 1, nb_elem
!
! ----- Current element
!
        if (l_affe_all) then
            elem_nume = i_elem
        else
            elem_nume = v_elem_affe(i_elem)
        endif
!
! ----- Select type of modelisation for MFront
!
        elem_type_nume = v_model_elem(elem_nume)
        if (elem_type_nume .ne. 0) then
            call jenuno(jexnum('&CATA.TE.NOMTE', elem_type_nume), elem_type_name)
            call comp_mfront_modelem(elem_type_name, l_mfront_cp ,&
                                     model_dim     , model_mfront,&
                                     codret        , type_cpla)
            if (model_mfront .ne. ' ') then
                if (model_save .eq. ' ') then
                    model_save = model_mfront
                else
                    if ((model_save .ne. model_mfront) ) then
                        codret = 1
                    endif
                endif
            endif
            if (codret .eq. 1) then
                call utmess('F','COMPOR4_13', nk=2, &
                            valk=[model_save, model_mfront])
            endif
            if (codret .eq. 2) then
                call utmess('F','COMPOR4_14', sk = model_mfront)
            endif
        endif
    end do
!
 99 continue
!
    model_mfront = model_save
    if (present(type_cpla_)) then
        type_cpla_ = type_cpla
    endif
!
end subroutine
