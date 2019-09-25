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
subroutine cm08ma(nb_elem_mesh, nb_list_elem, nb_node_add, nb_node_mesh,&
                  list_elem, &
                   mesh_in, mesh_out, nomima)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexnom.h"
#include "asterfort/jenonu.h"
!
integer, intent(in) :: nb_elem_mesh, nb_node_add, nb_list_elem, nb_node_mesh
integer, intent(in) :: list_elem(nb_list_elem)
integer, intent(in) :: nomima(nb_node_add, nb_list_elem)
character(len=8), intent(in) :: mesh_in, mesh_out
!           MISE A JOUR DES MAILLES (CREA_MAILLAGE
! ----------------------------------------------------------------------
! IN        nb_elem_mesh  NOMBRE TOTAL DE MAILLES DU MAILLAGE
! IN        nb_list_elem    NOMBRE DE MAILLES DE LA LISTE DES MAILLES A TRAITER
! IN        nb_node_mesh    NOMBRE DE NOEUDS DU MAILLAGE INITIAL
! IN        list_elem    LISTE DES MAILLES A TRAITER
! VAR       TYPEMA  LISTE DES TYPES DES MAILLES
! IN        NDINIT  NUMERO INITIAL DES NOEUDS CREES
! IN        CONNIZ  CONNECTIONS INITIALES (COLLECTION JEVEUX)
! IN/JXOUT  CONNOZ  NOUVELLES CONNECTIONS (COLLECTION JEVEUX)
! IN        nomima  LISTE DES NOEUDS CREES PAR MAILLE A TRAITER
! ----------------------------------------------------------------------
!
!
    integer :: i_elem, elem_nume, elem_type_in, elem_type_out, nbnoin, nbnoou, i_node
    aster_logical, pointer :: v_mamo(:) => null()
    integer, pointer :: v_posmai(:) => null()
    integer, pointer :: v_typema(:) => null()
    character(len=8) :: elem_te4_n, elem_te8_n, elem_tr4_n, elem_tr3_n, elem_se2_n
    integer :: elem_te4_i, elem_te8_i, elem_tr4_i, elem_tr3_i, elem_se2_i
    integer, pointer :: v_connexin(:) => null()
    integer, pointer :: v_connexout(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - Access
!
    call jeveuo(mesh_out// '.TYPMAIL', 'E', vi = v_typema)
    elem_te4_n = 'TETRA4'
    call jenonu(jexnom('&CATA.TM.NOMTM', elem_te4_n), elem_te4_i)
    elem_te8_n = 'TETRA8'
    call jenonu(jexnom('&CATA.TM.NOMTM', elem_te8_n), elem_te8_i)
    elem_tr4_n = 'TRIA4'
    call jenonu(jexnom('&CATA.TM.NOMTM', elem_tr4_n), elem_tr4_i)
    elem_tr3_n = 'TRIA3'
    call jenonu(jexnom('&CATA.TM.NOMTM', elem_tr3_n), elem_tr3_i)
    elem_se2_n = 'SEG2'
    call jenonu(jexnom('&CATA.TM.NOMTM', elem_se2_n), elem_se2_i)
!
! - Working vectors
!
    AS_ALLOCATE(vl = v_mamo, size = nb_elem_mesh)
    AS_ALLOCATE(vi = v_posmai, size = nb_elem_mesh)
    v_mamo(:) = ASTER_FALSE
!
! - Get cells to transform
!
    do i_elem = 1, nb_list_elem
        elem_nume    = list_elem(i_elem)
        elem_type_in = v_typema(elem_nume)
        if (elem_type_in .eq. elem_te4_i) then
            v_mamo(elem_nume)   = ASTER_TRUE
            v_posmai(elem_nume) = i_elem
        endif
        if (elem_type_in .eq. elem_tr3_i) then
            v_mamo(elem_nume)   = ASTER_TRUE
            v_posmai(elem_nume) = i_elem
        endif
    end do
!
! - Create connectivity
!
    do elem_nume = 1, nb_elem_mesh
! ----- Old connectivity
        call jelira(jexnum(mesh_in//'.CONNEX', elem_nume), 'LONMAX', nbnoin)
        call jeveuo(jexnum(mesh_in//'.CONNEX', elem_nume), 'L', vi = v_connexin)
! ----- Type of current element
        elem_type_in = v_typema(elem_nume)
        if (v_mamo(elem_nume)) then
            if (elem_type_in .eq. elem_tr3_i) then
                nbnoin = 3
                nbnoou = 4
                elem_type_out = elem_tr4_i
            elseif (elem_type_in .eq. elem_te4_i) then
                nbnoin = 4
                nbnoou = 8
                elem_type_out = elem_te8_i
            else
! ------------- Que des TETRA4/TRIA3 !
                ASSERT(ASTER_FALSE)
            endif
        else
            if (elem_type_in .eq. elem_tr3_i) then
                nbnoin = 3
                nbnoou = 3
                elem_type_out = elem_tr3_i
            elseif (elem_type_in .eq. elem_te4_i) then
                nbnoin = 4
                nbnoou = 4
                elem_type_out = elem_te4_i
            elseif (elem_type_in .eq. elem_se2_i) then
                nbnoin = 2
                nbnoou = 2
                elem_type_out = elem_se2_i
            else
! ------------- Que des TETRA4/TRIA3/SEG2 !
                write(6,*) elem_type_in,elem_se2_i
                ASSERT(ASTER_FALSE)
            endif
        endif
! ----- Create connectivity
        call jeecra(jexnum(mesh_out//'.CONNEX', elem_nume), 'LONMAX', nbnoou)
        call jeveuo(jexnum(mesh_out//'.CONNEX', elem_nume), 'E', vi = v_connexout)
! ----- Old connectivity
        v_connexout(1:nbnoin) = v_connexin(1:nbnoin)
! ----- New nodes
        if (v_mamo(elem_nume)) then
! --------- New connectivity
            do i_node = nbnoin+1, nbnoou
                v_connexout(i_node) = nomima(i_node-nbnoin,v_posmai(elem_nume)) + nb_node_mesh
            end do
! --------- New type
            v_typema(elem_nume) = elem_type_out
        endif
    end do
!
! - Debug
!
!     if (niv .ge. 1) then
! write(ifm,1000) 1
! do 30 i_elem = 1, nbtyma
! if (impmai(i_elem) .ne. 0) then
!   write(ifm,1002) impmai(i_elem), nomast(i_elem), nomast(reftyp(i_elem)&
!   )
! endif
! 30      continue
! endif
! !
! 1000 format('MOT CLE FACTEUR "PENTA15_18", OCCURRENCE ',i4)
! 1002 format('   TRANSFORMATION DE ',i6,' MAILLES ',a8,' EN ',a8)
!
    AS_DEALLOCATE(vl = v_mamo)
    AS_DEALLOCATE(vi = v_posmai)
    call jedema()
end subroutine
