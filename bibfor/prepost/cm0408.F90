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
subroutine cm0408(mesh_in, mesh_out, nb_list_elem, list_elem, prefix,&
                  ndinit)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jeveuo.h"
#include "asterfort/cm08na.h"
#include "asterfort/cm08nd.h"
#include "asterfort/cm08ma.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/cpclma.h"
#include "asterfort/jedupo.h"
#include "asterfort/jenuno.h"
#include "asterfort/juveca.h"
#include "asterfort/jeecra.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/copisd.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexnom.h"
#include "asterfort/jeccta.h"
#include "asterfort/jecrec.h"
#include "asterfort/dismoi.h"
!
integer, intent(in) :: ndinit, nb_list_elem, list_elem(nb_list_elem)
character(len=8), intent(in) :: mesh_in, mesh_out
character(len=8), intent(in) :: prefix
!
! ----------------------------------------------------------------------
!         TRANSFORMATION DES MAILLES TETRA4 en TETRA8
! ----------------------------------------------------------------------
! IN        mesh_in   K8  NOM DU MAILLAGE INITIAL
! IN/JXOUT  mesh_out  K8  NOM DU MAILLAGE TRANSFORME
! IN        NBMA    I  NOMBRE DE MAILLES A TRAITER
! IN        LIMA    I  NUMERO ET TYPE DES MAILLES A TRAITER
! IN        PREFIX K8  PREFIXE DU NOM DES NOEUDS CREES (EX: N, NO, ...)
! IN        NDINIT  I  NUMERO INITIAL DES NOEUDS CREES
! ----------------------------------------------------------------------
!
    integer, pointer :: v_mesh_dime(:) => null()
    integer :: nb_node_mesh, nb_elem_mesh, add_node_total, nb_node_new, i_node, nbnomx
! nb_node_add: nombre de noeuds ajoutés à l'élément
    integer, parameter :: nb_node_add = 4
! nb_node_face: nombre de noeuds définissant une face (ici triangle)
    integer, parameter :: nb_node_face = 3
! nfmax: nombre maximum de face connectées à un noeud (indicateur de complexité du maillage)
    integer, parameter :: nfmax = 75
! nbfac_modi: nombre de faces modifiées dans l'élément
    integer, parameter :: nbfac_modi = 4
! nbno_fac: nombre de noeuds initial des faces à modifier
    integer, parameter :: nbno_fac = 3
    integer, pointer :: nomima(:) => null()
    integer, pointer :: milieu(:) => null()
    integer, pointer :: nomipe(:) => null()
    character(len=8) :: node_name
    character(len=24), pointer :: v_refe(:) => null()
    real(kind=8), pointer :: v_coor(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Get size of mesh
!
    call jeveuo(mesh_in//'.DIME', 'L', vi = v_mesh_dime)
    nb_node_mesh = v_mesh_dime(1)
    nb_elem_mesh = v_mesh_dime(3)
!
! - Create working vectors
!
    AS_ALLOCATE(vi=nomima, size = nb_node_add*nb_list_elem)
    AS_ALLOCATE(vi=milieu, size = nb_node_face*nfmax*nb_node_mesh)
    AS_ALLOCATE(vi=nomipe, size = nbno_fac*nbfac_modi*nb_list_elem)
!
! - Create nodes
!
    call cm08na(mesh_in     ,&
                nb_node_mesh, nb_list_elem, list_elem,&
                nb_node_face, nfmax, nb_node_add,&
                nbno_fac, nbfac_modi,&
                milieu, nomima, nomipe,&
                add_node_total)
!
! - Duplicate groups
!
    call cpclma(mesh_in, mesh_out, 'GROUPENO', 'G')
    call jedupo(mesh_in//'.NOMMAI', 'G', mesh_out//'.NOMMAI', ASTER_FALSE)
    call cpclma(mesh_in, mesh_out, 'GROUPEMA', 'G')
!
! - Total number of nodes
!
    nb_node_new = nb_node_mesh + add_node_total
    call jedupo(mesh_in//'.DIME', 'G', mesh_out//'.DIME', ASTER_FALSE)
    call jeveuo(mesh_out//'.DIME', 'E', vi = v_mesh_dime)
    v_mesh_dime(1) = nb_node_new
!
! - Name of groups (only "old" nodes)
!
    call jecreo(mesh_out//'.NOMNOE', 'G N K8')
    call jeecra(mesh_out//'.NOMNOE', 'NOMMAX', nb_node_new)
    do i_node = 1, nb_node_mesh
        call jenuno(jexnum(mesh_in//'.NOMNOE', i_node), node_name)
        call jecroc(jexnom(mesh_out//'.NOMNOE',node_name))
    end do
!
! - Coordinates of nodes  (only "old" nodes)
!
    call copisd('CHAMP_GD', 'G', mesh_in//'.COORDO', mesh_out//'.COORDO')
    call jeveuo(mesh_out//'.COORDO    .REFE', 'E', vk24=v_refe)
    v_refe(1) = mesh_out
    call juveca(mesh_out//'.COORDO    .VALE', nb_node_new*3)
!
! - Add new nodes
!
    call jeveuo(mesh_out// '.COORDO    .VALE', 'E', vr = v_coor)
    call cm08nd(nb_node_mesh, add_node_total, prefix, ndinit, &
                nb_list_elem, nbno_fac, nbfac_modi, nomipe,&
                mesh_out, v_coor)
!
! - Updates cells (types)
!
    call jedupo(mesh_in//'.TYPMAIL', 'G', mesh_out // '.TYPMAIL', ASTER_FALSE)
!
! - Updates connectivity (oversize, see jeecta)
!
    call dismoi('NB_NO_MAX', '&CATA', 'CATALOGUE', repi=nbnomx)
    call jecrec(mesh_out//'.CONNEX', 'G V I', 'NU', 'CONTIG', 'VARIABLE', nb_elem_mesh)
    call jeecra(mesh_out//'.CONNEX', 'LONT', nbnomx*nb_elem_mesh)
!
! - Updates cells
!
    call cm08ma(nb_elem_mesh, nb_list_elem, nb_node_add, nb_node_mesh,&
                list_elem, &
                mesh_in, mesh_out, nomima)
!
! - Resize connectivity
!
    call jeccta(mesh_out//'.CONNEX')
!
! - Cleaning
!
    AS_DEALLOCATE(vi=nomima)
    AS_DEALLOCATE(vi=milieu)
    AS_DEALLOCATE(vi=nomipe)
!
    call jedema()
end subroutine
