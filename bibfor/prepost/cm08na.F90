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
!
subroutine cm08na(mesh_in     ,&
                  nb_node_mesh, nb_list_elem, list_elem,&
                  nb_node_face, nfmax, nb_node_add,&
                  nbno_fac, nbfac_modi,&
                  milieu, nomima, nomipe,&
                  add_node_total)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/uttrii.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
!
character(len=8), intent(in) :: mesh_in
integer, intent(in) :: nb_list_elem, list_elem(nb_list_elem)
integer, intent(in) :: nb_node_mesh, nb_node_face, nfmax, nb_node_add, nbno_fac, nbfac_modi
integer, intent(inout) :: milieu(nb_node_face, nfmax, nb_node_mesh)
integer, intent(inout) :: nomima(nb_node_add, nb_list_elem)
integer, intent(inout) :: nomipe(nbno_fac, nbfac_modi*nb_list_elem)
integer, intent(out) :: add_node_total
!
! ----------------------------------------------------------------------
!                   DETERMINATION DES NOEUDS DES FACES
! ----------------------------------------------------------------------
!
! ----------------------------------------------------------------------
!
    integer :: i_elem, elem_nume, elem_type, i_face, nb_face, i, nomi
    integer, pointer :: v_typmail(:) => null()
    integer, pointer :: v_connex(:) => null()
    character(len=8) :: elem_te4_n, elem_tr3_n, node_name
    integer :: elem_te4_i, elem_tr3_i, noeud(3), nb_sort

! ----------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    call jeveuo(mesh_in//'.TYPMAIL', 'L', vi=v_typmail)
    milieu = 0
    add_node_total = 0
    nomima = 0
    nomipe = 0
    elem_te4_n = 'TETRA4'
    call jenonu(jexnom('&CATA.TM.NOMTM', elem_te4_n), elem_te4_i)
    elem_tr3_n = 'TRIA3'
    call jenonu(jexnom('&CATA.TM.NOMTM', elem_tr3_n), elem_tr3_i)
!
    do i_elem = 1, nb_list_elem
        elem_nume = list_elem(i_elem)
        elem_type = v_typmail(elem_nume)
        if (elem_type .ne. elem_te4_i .and. (elem_type .ne. elem_tr3_i)) cycle
        call jeveuo(jexnum(mesh_in//'.CONNEX', elem_nume), 'L',  vi = v_connex)
        if (elem_type .eq. elem_te4_i) then
! --------- Loop on faces
            nb_face = 4
            do i_face = 1, nb_face
! ------------- Get nodes and sort them
                if (i_face .eq. 1) then
                    noeud(1:3) = v_connex(1:3)
                elseif (i_face .eq. 2) then
                    noeud(1) = v_connex(1)
                    noeud(2) = v_connex(2)
                    noeud(3) = v_connex(4)
                elseif (i_face .eq. 3) then
                    noeud(1) = v_connex(1)
                    noeud(2) = v_connex(3)
                    noeud(3) = v_connex(4)
                elseif (i_face .eq. 4) then
                    noeud(1) = v_connex(2)
                    noeud(2) = v_connex(3)
                    noeud(3) = v_connex(4)
                else
                    ASSERT(ASTER_FALSE)
                endif
                nb_sort = 3
                call uttrii(noeud, nb_sort)
                ASSERT(nb_sort.eq.3)
! ------------- Face already found ?
                do i = 1, nfmax
                    if ((milieu(1,i,noeud(1)) .eq. noeud(2)) .and.&
                        (milieu(2,i,noeud(1)) .eq. noeud(3))) then
                        nomi = milieu(3,i,noeud(1))
                        goto 31
                    else if (milieu(1,i,noeud(1)) .eq.0) then
                        add_node_total = add_node_total + 1
                        milieu(1,i,noeud(1)) = noeud(2)
                        milieu(2,i,noeud(1)) = noeud(3)
                        milieu(3,i,noeud(1)) = add_node_total
                        nomi = add_node_total
                        goto 31
                    endif
                end do
! ------------- Maximum connectivity
                call jenuno(jexnum(mesh_in//'.NOMNOE', noeud(1)), node_name)
                call utmess('F', 'MAIL0_11', sk=node_name, si=nfmax)
    31          continue
                nomima(i_face, i_elem) = nomi
                nomipe(1:3,nomi) = noeud(1:3)
            end do
        elseif (elem_type .eq. elem_tr3_i) then
            i_face = 1
            noeud(1:3) = v_connex(1:3)
            nb_sort = 3
            call uttrii(noeud, nb_sort)
            ASSERT(nb_sort.eq.3)
! --------- Face already found ?
            do i = 1, nfmax
                if ((milieu(1,i,noeud(1)) .eq. noeud(2)) .and.&
                    (milieu(2,i,noeud(1)) .eq. noeud(3))) then
                    nomi = milieu(3,i,noeud(1))
                    goto 32
                else if (milieu(1,i,noeud(1)) .eq.0) then
                    add_node_total = add_node_total + 1
                    milieu(1,i,noeud(1)) = noeud(2)
                    milieu(2,i,noeud(1)) = noeud(3)
                    milieu(3,i,noeud(1)) = add_node_total
                    nomi = add_node_total
                    goto 32
                endif
            end do
! --------- Maximum connectivity
            call jenuno(jexnum(mesh_in//'.NOMNOE', noeud(1)), node_name)
            call utmess('F', 'MAIL0_11', sk=node_name, si=nfmax)
32          continue
            nomima(i_face, i_elem) = nomi
            nomipe(1:3,nomi) = noeud(1:3)
        endif
    end do
!
call jedema()
end subroutine
