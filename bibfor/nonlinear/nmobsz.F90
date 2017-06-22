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

subroutine nmobsz(sd_obsv  , tabl_name    , title         , field_type   , field_disc,&
                  type_extr, type_extr_cmp, type_extr_elem, type_sele_cmp, cmp_name  ,&
                  time     , valr,&
                  node_namez,&
                  elem_namez, poin_numez, spoi_numez)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/tbajli.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sd_obsv
    character(len=19), intent(in) :: tabl_name
    character(len=4), intent(in) :: field_disc
    character(len=24), intent(in) :: field_type
    character(len=16), intent(in) :: title
    character(len=8), intent(in) :: type_extr
    character(len=8), intent(in) :: type_extr_cmp
    character(len=8), intent(in) :: type_extr_elem
    character(len=8), intent(in) :: type_sele_cmp
    character(len=16), intent(in) :: cmp_name
    real(kind=8), intent(in) :: time
    real(kind=8), intent(in) :: valr
    character(len=8), optional, intent(in) :: node_namez
    character(len=8), optional, intent(in) :: elem_namez
    integer, optional, intent(in) :: poin_numez
    integer, optional, intent(in) :: spoi_numez
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear operators - Observation
!
! Save value in table
!
! --------------------------------------------------------------------------------------------------
!
! In  sd_obsv          : datastructure for observation parameters
! In  tabl_name        : name of observation table
! In  field_disc       : localization of field (discretization: NOEU or ELGA)
! In  field_type       : type of field (name in results datastructure)
! In  title            : title of observation
! In  type_extr        : type of extraction
! In  type_extr_elem   : type of extraction by element
! In  type_extr_cmp    : type of extraction for components
! In  type_sele_cmp    : type of selection for components NOM_CMP or NOM_VARI
! In  cmp_name         : name of components
! In  time             : current time
! In  valr             : value to save
! In  node_name        : name of node
! In  elem_name        : name of element
! In  poin_nume        : index of point
! In  spoi_nume        : index of subpoint
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para = 16
    character(len=16) :: para_name(nb_para)
    real(kind=8) :: tabl_vale_r(nb_para)
    integer :: tabl_vale_i(nb_para)
    character(len=24) :: tabl_vale_k(nb_para), para_name_add(nb_para)
!
    integer :: nb_para_add
    integer :: nume_reuse, nume_obsv
    complex(kind=8) :: c16bid
    character(len=16) :: obje_type
    integer :: i_para_add, nb_vale_k, nb_vale_i, nb_vale_r
    character(len=14) :: sdextr_obsv
    character(len=24) :: extr_info
    integer, pointer :: v_extr_info(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    data para_name /'NOM_OBSERVATION','TYPE_OBJET'  ,&
                    'NUME_REUSE'     ,'NUME_OBSE'   ,'INST'   ,&
                    'NOM_CHAM'       ,'EVAL_CHAM'   ,'NOM_CMP', 'NOM_VARI',&
                    'EVAL_CMP'       ,'NOEUD'       ,'MAILLE' ,&
                    'EVAL_ELGA'      ,'POINT'       ,'SOUS_POINT',&
                    'VALE'           /
!
! --------------------------------------------------------------------------------------------------
!
    c16bid=(0.d0,0.d0)
    i_para_add = 1
    nb_vale_k = 1
    nb_vale_i = 1
    nb_vale_r = 1
    obje_type = 'R'

!
! - Access to extraction datastructure
!
    sdextr_obsv = sd_obsv(1:14)
!
! - Get information vector
!
    extr_info    = sdextr_obsv(1:14)//'     .INFO'
    call jeveuo(extr_info, 'E', vi = v_extr_info)
    nume_obsv  = v_extr_info(3)
    nume_reuse = v_extr_info(4)
!
! - Common columns
!
    para_name_add(i_para_add) = para_name(1)
    i_para_add = i_para_add + 1
    tabl_vale_k(nb_vale_k) = title
    nb_vale_k = nb_vale_k + 1
!
    para_name_add(i_para_add) = para_name(2)
    i_para_add = i_para_add + 1
    tabl_vale_k(nb_vale_k) = obje_type
    nb_vale_k = nb_vale_k + 1
!
    para_name_add(i_para_add) = para_name(3)
    i_para_add = i_para_add + 1
    tabl_vale_i(nb_vale_i) = nume_reuse
    nb_vale_i = nb_vale_i + 1
!
    para_name_add(i_para_add) = para_name(4)
    i_para_add = i_para_add + 1
    tabl_vale_i(nb_vale_i) = nume_obsv
    nb_vale_i = nb_vale_i + 1
!
    para_name_add(i_para_add) = para_name(5)
    i_para_add = i_para_add + 1
    tabl_vale_r(nb_vale_r) = time
    nb_vale_r = nb_vale_r + 1
!
    para_name_add(i_para_add) = para_name(6)
    i_para_add = i_para_add + 1
    tabl_vale_k(nb_vale_k) = field_type
    nb_vale_k = nb_vale_k + 1
!
! - Type of extraction for field
!
    para_name_add(i_para_add) = para_name(7)
    i_para_add = i_para_add + 1
    tabl_vale_k(nb_vale_k) = type_extr
    nb_vale_k = nb_vale_k + 1
!
! - Type of extraction for components
!
    if (type_extr_cmp .eq. ' ') then
        if (type_sele_cmp .eq. 'NOM_CMP') then
            para_name_add(i_para_add) = para_name(8)
            i_para_add = i_para_add + 1
            tabl_vale_k(nb_vale_k) = cmp_name
            nb_vale_k = nb_vale_k + 1
        elseif (type_sele_cmp .eq. 'NOM_VARI') then
            para_name_add(i_para_add) = para_name(9)
            i_para_add = i_para_add + 1
            tabl_vale_k(nb_vale_k) = cmp_name
            nb_vale_k = nb_vale_k + 1
        else
            ASSERT(.false.)
        endif
    else
        para_name_add(i_para_add) = para_name(10)
        i_para_add = i_para_add + 1
        tabl_vale_k(nb_vale_k) = type_extr_cmp
        nb_vale_k = nb_vale_k + 1
    endif
!
! - Node or element
!
    if (field_disc .eq. 'NOEU') then
        if (type_extr .eq. 'VALE') then
            para_name_add(i_para_add) = para_name(11)
            i_para_add = i_para_add + 1
            tabl_vale_k(nb_vale_k) = node_namez
            nb_vale_k = nb_vale_k + 1
        else
            para_name_add(i_para_add) = para_name(7)
            i_para_add = i_para_add + 1
            tabl_vale_k(nb_vale_k) = type_extr
            nb_vale_k = nb_vale_k + 1
        endif
        para_name_add(i_para_add) = para_name(16)
        i_para_add = i_para_add + 1
        tabl_vale_r(nb_vale_r) = valr
        nb_vale_r = nb_vale_r + 1
    else if (field_disc .eq. 'ELGA' .or. field_disc .eq. 'ELEM') then
        if (type_extr .eq. 'VALE') then
            para_name_add(i_para_add) = para_name(12)
            i_para_add = i_para_add + 1
            tabl_vale_k(nb_vale_k) = elem_namez
            nb_vale_k = nb_vale_k + 1
        else
            para_name_add(i_para_add) = para_name(7)
            i_para_add = i_para_add + 1
            tabl_vale_k(nb_vale_k) = type_extr
            nb_vale_k = nb_vale_k + 1
        endif
        if (type_extr_elem .eq. 'VALE') then
            para_name_add(i_para_add) = para_name(14)
            i_para_add = i_para_add + 1
            tabl_vale_i(nb_vale_i) = poin_numez
            nb_vale_i = nb_vale_i + 1
            para_name_add(i_para_add) = para_name(15)
            i_para_add = i_para_add + 1
            tabl_vale_i(nb_vale_i) = spoi_numez
            nb_vale_i = nb_vale_i + 1
            para_name_add(i_para_add) = para_name(16)
            i_para_add = i_para_add + 1
            tabl_vale_r(nb_vale_r) = valr
            nb_vale_r = nb_vale_r + 1
        else
            para_name_add(i_para_add) = para_name(13)
            i_para_add = i_para_add + 1
            tabl_vale_k(nb_vale_k) = type_extr_elem
            nb_vale_k = nb_vale_k + 1
            para_name_add(i_para_add) = para_name(16)
            i_para_add = i_para_add + 1
            tabl_vale_r(nb_vale_r) = valr
            nb_vale_r = nb_vale_r + 1
        endif
    else
        ASSERT(.false.)
    endif
!
    nb_para_add = i_para_add -1
!
! - Add line in table
!
    call tbajli(tabl_name, nb_para_add, para_name_add, tabl_vale_i, tabl_vale_r,&
                [c16bid], tabl_vale_k, 0)
!
! - Next observation
!
    v_extr_info(3) = v_extr_info(3) + 1
!
end subroutine
