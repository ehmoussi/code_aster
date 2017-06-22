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

subroutine getnode(mesh, keywordfact, iocc, stop_void, list_node,&
                   nb_node, model, suffix, elem_excl)
!
    implicit none
!
#include "asterf_types.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    character(len=1), intent(in) :: stop_void
    integer, intent(out) :: nb_node
    character(len=24), intent(in) :: list_node
    character(len=8), intent(in), optional :: model
    character(len=*), intent(in), optional :: suffix
    aster_logical, intent(in), optional :: elem_excl
!
! --------------------------------------------------------------------------------------------------
!
! Read mesh affectation - Nodes
!
! --------------------------------------------------------------------------------------------------
!
! Create list of elements:
!  - read MAILLE/GROUP_MA/TOUT/NOEU_GROUP_NO keywords
!  - remove by SANS_MAILLE/SANS_GROUP_MA/SANS_NOEUD/SANS_GROUP_NO keywords
!  - can use <SUFFIX> to enhance keyword. For instance:
!           suffix = '_1': GROUP_MA -> GROUP_MA_1
!                          MAILLE -> MAILLE_1
!                          SANS_GROUP_MA -> SANS_GROUP_MA_1
!                          SANS_MAILLE -> SANS_MAILLE_1
!                          GROUP_NO -> GROUP_NO_1
!                          NOEUD -> NOEUD_1
!                          SANS_GROUP_NO -> SANS_GROUP_NO_1
!                          SANS_NOEUD -> SANS_NOEUD_1
!           WARNING ->     TOUT -> TOUT
!  - can stop or alarm if no elements in final list
!
! In  mesh         : name of mesh
! In  keywordfact  : factor keyword to read
! In  iocc         : factor keyword index
! In  stop_void    : if nb_node == 0
!                      'F' - Error
!                      'A' - Error
!                      ' ' - Nothing
! In  list_node    : list of nodes read
! Out nb_node      : number of nodes read
! In  model        : <optional> check nodes belongs to model
! In  suffix       : <optional> suffix for read
! In  elem_excl    : <optional> exlusion of elements keywords
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: moclm(5)
    character(len=16) :: typmcl(5)
    character(len=24) :: list_lect
    integer, pointer :: p_list_lect(:) => null()
    character(len=24) :: list_excl
    integer, pointer :: p_list_excl(:) => null()
    integer, pointer :: p_list_node(:) => null()
    character(len=24) :: keyword
    character(len=8) :: model_name, suffix_name
    integer :: nb_mocl
    integer :: nb_lect, nb_excl, nb_elim
    integer :: nume_lect, nume_excl
    integer :: i_lect, i_excl, i_node
    aster_logical :: l_read_elem
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    list_lect = '&&LIST_LECT'
    list_excl = '&&LIST_EXCL'
    nb_node = 0
    nb_lect = 0
    nb_excl = 0
    model_name = ' '
    suffix_name = ' '
    l_read_elem = .true.
    if (present(model)) then
        model_name = model
    endif
    if (present(suffix)) then
        suffix_name = suffix
    endif
    if (present(elem_excl)) then
        l_read_elem = .not.elem_excl
    endif
!
! - Read nodes
!
    nb_mocl = 0
    if (l_read_elem) then
        keyword = 'GROUP_MA'//suffix_name
        if (getexm(keywordfact,keyword) .eq. 1) then
            nb_mocl = nb_mocl + 1
            moclm(nb_mocl) = keyword
            typmcl(nb_mocl) = 'GROUP_MA'
        endif
        keyword = 'MAILLE'//suffix_name
        if (getexm(keywordfact,keyword) .eq. 1) then
            nb_mocl = nb_mocl + 1
            moclm(nb_mocl) = keyword
            typmcl(nb_mocl) = 'MAILLE'
        endif
    endif
    if (getexm(keywordfact,'TOUT') .eq. 1) then
        nb_mocl = nb_mocl + 1
        moclm(nb_mocl) = 'TOUT'
        typmcl(nb_mocl) = 'TOUT'
    endif
    keyword = 'GROUP_NO'//suffix_name
    if (getexm(keywordfact,keyword) .eq. 1) then
        nb_mocl = nb_mocl + 1
        moclm(nb_mocl) = keyword
        typmcl(nb_mocl) = 'GROUP_NO'
    endif
    keyword = 'NOEUD'//suffix_name
    if (getexm(keywordfact,keyword) .eq. 1) then
        nb_mocl = nb_mocl + 1
        moclm(nb_mocl) = keyword
        typmcl(nb_mocl) = 'NOEUD'
    endif
    if (nb_mocl .ne. 0) then
        call reliem(model_name, mesh, 'NU_NOEUD', keywordfact, iocc,&
                    nb_mocl, moclm, typmcl, list_lect, nb_lect)
    endif
!
! - Read nodes excludes
!
    nb_mocl = 0
    if (l_read_elem) then
        keyword = 'SANS_GROUP_MA'//suffix_name
        if (getexm(keywordfact,keyword) .eq. 1) then
            nb_mocl = nb_mocl + 1
            moclm(nb_mocl) = keyword
            typmcl(nb_mocl) = 'GROUP_MA'
        endif
        keyword = 'SANS_MAILLE'//suffix_name
        if (getexm(keywordfact,keyword) .eq. 1) then
            nb_mocl = nb_mocl + 1
            moclm(nb_mocl) = keyword
            typmcl(nb_mocl) = 'MAILLE'
        endif
    endif
    keyword = 'SANS_GROUP_NO'//suffix_name
    if (getexm(keywordfact,keyword) .eq. 1) then
        nb_mocl = nb_mocl + 1
        moclm(nb_mocl) = keyword
        typmcl(nb_mocl) = 'GROUP_NO'
    endif
    keyword = 'SANS_NOEUD'//suffix_name
    if (getexm(keywordfact,keyword) .eq. 1) then
        nb_mocl = nb_mocl + 1
        moclm(nb_mocl) = keyword
        typmcl(nb_mocl) = 'NOEUD'
    endif
    if (nb_mocl .ne. 0) then
        call reliem(' ', mesh, 'NU_NOEUD', keywordfact, iocc,&
                    nb_mocl, moclm, typmcl, list_excl, nb_excl)
    endif
!
! - Access to list of nodes 
!
    if (nb_lect .ne. 0) then
        call jeveuo(list_lect, 'E', vi = p_list_lect)
    endif
!
! - Exclusion of nodes in initial list
!
    nb_elim = 0
    if (nb_excl .ne. 0) then
        call jeveuo(list_excl, 'L', vi = p_list_excl)
        do i_excl = 1, nb_excl
            nume_excl = p_list_excl(i_excl)
            do i_lect = 1, nb_lect
                nume_lect = p_list_lect(i_lect)
                if (nume_excl .eq. nume_lect) then
                    nb_elim = nb_elim + 1
                    p_list_lect(i_lect) = 0
                endif
            end do
        end do
    endif
    nb_node = nb_lect - nb_elim
!
! - Final list of nodes
!
    i_node = 0
    if ((nb_node.ne.0) .and. (nb_lect.ne.0)) then
        call wkvect(list_node, 'V V I', nb_node, vi = p_list_node)
        do i_lect = 1, nb_lect
            nume_lect = p_list_lect(i_lect)
            if (nume_lect .ne. 0) then
                i_node = i_node + 1
                p_list_node(i_node) = nume_lect
            endif
        end do
        ASSERT(i_node.eq.nb_node)
    endif
!
! - If no nodes
!
    if (stop_void .ne. ' ' .and. nb_node .eq. 0) then
        call utmess(stop_void, 'UTILITY_4', sk=keywordfact)
    endif
!
    call jedetr(list_lect)
    call jedetr(list_excl)
    call jedema()
end subroutine
