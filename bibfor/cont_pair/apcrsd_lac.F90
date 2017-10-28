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

subroutine apcrsd_lac(ds_contact  , sdappa      , mesh        ,&
                      nt_poin     , nb_cont_elem, nb_cont_node,&
                      nt_elem_node, nb_node_mesh)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/apcinv.h"
#include "asterfort/gtlima.h"
#include "asterfort/infdbg.h"
#include "asterfort/jecrec.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/crcnct.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfnben.h"
#include "asterfort/jecroc.h"
#include "asterfort/jemarq.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=19), intent(in) :: sdappa
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: nt_poin
    integer, intent(in) :: nb_cont_elem
    integer, intent(in) :: nb_cont_node
    integer, intent(in) :: nt_elem_node
    integer, intent(in) :: nb_node_mesh
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing
!
! Create datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
! In  sdappa           : name of pairing datastructure
! In  nt_poin          : total number of points (contact and non-contact)
! In  nb_cont_elem     : total number of contact elements
! In  nb_cont_node     : total number of contact nodes
! In  nt_elem_node     : total number of nodes at all contact elements
! In  nb_node_mesh     : number of nodes in mesh
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nt_patch, nb_cont_zone, nb_elem, nb_elem_patch
    integer :: i_elem, i_zone, i_cont_elem
    character(len=16) :: sdcont_defi
    character(len=24) :: pair_method
    integer :: longt, elem_indx, longc, elem_nbnode, patch_indx, elem_nume
    integer, pointer :: v_mesh_comapa(:) => null()
    character(len=24) :: sdappa_poin
    real(kind=8), pointer :: v_sdappa_poin(:) => null()
    character(len=24) :: sdappa_info
    integer, pointer :: v_sdappa_info(:) => null()
    character(len=24) :: sdappa_infp
    integer, pointer :: v_sdappa_infp(:) => null()
    character(len=24) :: sdappa_noms
    character(len=16), pointer :: v_sdappa_noms(:) => null()
    character(len=24) :: sdappa_appa
    integer, pointer :: v_sdappa_appa(:) => null()
    character(len=24) :: sdappa_dist
    real(kind=8), pointer :: v_sdappa_dist(:) => null()
    character(len=24) :: sdappa_tau1
    real(kind=8), pointer :: v_sdappa_tau1(:) => null()
    character(len=24) :: sdappa_tau2
    real(kind=8), pointer :: v_sdappa_tau2(:) => null()
    character(len=24) :: sdappa_proj
    real(kind=8), pointer :: v_sdappa_proj(:) => null()
    character(len=24) :: sdappa_tgno, sdappa_tgel
    real(kind=8), pointer :: v_sdappa_tgno(:) => null()
    character(len=24) :: sdappa_verk
    character(len=8), pointer :: v_sdappa_verk(:) => null()
    character(len=24) :: sdappa_vera
    real(kind=8), pointer :: v_sdappa_vera(:) => null()
    character(len=24) :: sdappa_gapi
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    character(len=24) :: sdappa_coef
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    character(len=24) :: sdappa_gpre
    real(kind=8), pointer :: v_sdappa_gpre(:) => null()
    character(len=24) :: sdappa_poid
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    character(len=24) :: sdappa_psno
    character(len=24) :: sdappa_norl
    real(kind=8), pointer :: v_sdappa_norl(:) => null()
    character(len=24) :: sdappa_dcl
    integer, pointer :: v_sdappa_dcl(:) => null()
    integer, pointer :: vi_ptrdclac(:) => null()
    character(len=24) :: sdcont_stat_prev
    integer, pointer :: v_sdcont_stat_prev(:) => null()
    character(len=24) :: sdcont_cyclac_etat
    integer, pointer :: v_sdcont_cyclac_etat(:) => null()
    character(len=24) :: sdcont_cyclac_hist
    real(kind=8), pointer :: v_sdcont_cyclac_hist(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('APPARIEMENT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<PAIRING> Create datastructure'
    endif
!
! - Get parameters
!
    nt_patch     = ds_contact%nt_patch
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi, 'NZOCO')
    pair_method  = 'PANG_ROBUSTE'
!
! - Access to mesh
!
    call jeveuo(mesh//'.COMAPA', 'L' , vi = v_mesh_comapa)
    call jelira(mesh//'.COMAPA', 'LONMAX', nb_elem)
!
! - Datastructure for pairing results
!
    sdappa_appa = sdappa(1:19)//'.APPA'
    call wkvect(sdappa_appa, 'V V I', 4*nt_poin, vi = v_sdappa_appa)
!
! - Datastructure for distances and local basis
!
    sdappa_dist = sdappa(1:19)//'.DIST'
    sdappa_tau1 = sdappa(1:19)//'.TAU1'
    sdappa_tau2 = sdappa(1:19)//'.TAU2'
    call wkvect(sdappa_dist, 'V V R', 4*nt_poin, vr = v_sdappa_dist)
    call wkvect(sdappa_tau1, 'V V R', 3*nt_poin, vr = v_sdappa_tau1)
    call wkvect(sdappa_tau2, 'V V R', 3*nt_poin, vr = v_sdappa_tau2)
!
! - Datastructure for projection points
!
    sdappa_proj = sdappa(1:19)//'.PROJ'
    call wkvect(sdappa_proj, 'V V R', 2*nt_poin, vr = v_sdappa_proj)
!
! - Datastructure for coordinates of points
!
    sdappa_poin = sdappa(1:19)//'.POIN'
    call wkvect(sdappa_poin, 'V V R', 3*nt_poin, vr = v_sdappa_poin)
!
! - Datastructure for informations about points
!
    sdappa_infp = sdappa(1:19)//'.INFP'
    call wkvect(sdappa_infp, 'V V I', nt_poin, vi = v_sdappa_infp)
!
! - Datastructure for name of contact points
!
    sdappa_noms = sdappa(1:19)//'.NOMS'
    call wkvect(sdappa_noms, 'V V K16', nt_poin, vk16 = v_sdappa_noms)
!
! - Datastructure for tangents at each node
!
    sdappa_tgno = sdappa(1:19)//'.TGNO'
    call wkvect(sdappa_tgno, 'V V R', 6*nb_cont_node, vr = v_sdappa_tgno)
!
! - Datastructure for tangents at each node by element
!
    sdappa_tgel = sdappa(1:19)//'.TGEL'
    call jecrec(sdappa_tgel, 'V V R', 'NU', 'CONTIG', 'VARIABLE',&
                nb_cont_elem)
    call jeecra(sdappa_tgel, 'LONT', 6*nt_elem_node)
    longt = 0
    do i_cont_elem = 1, nb_cont_elem
        elem_indx = i_cont_elem
        call cfnben(ds_contact%sdcont_defi, elem_indx, 'CONNEX', elem_nbnode)
        longc = 6*elem_nbnode
        call jeecra(jexnum(sdappa_tgel, i_cont_elem), 'LONMAX', ival=longc)
        call jecroc(jexnum(sdappa_tgel, i_cont_elem))
        longt = longt + longc
    end do
    ASSERT(longt.eq.6*nt_elem_node)
!
! - Datastructure for check normals discontinuity
!
    sdappa_verk = sdappa(1:19)//'.VERK'
    sdappa_vera = sdappa(1:19)//'.VERA'
    call wkvect(sdappa_verk, 'V V K8', nb_node_mesh, vk8 = v_sdappa_verk)
    call wkvect(sdappa_vera, 'V V R' , nb_node_mesh, vr  = v_sdappa_vera)
    call jeecra(sdappa_verk, 'LONUTI', 0)
!
! - Datastructure for gap
!
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    call wkvect(sdappa_gapi, 'V V R', nt_patch, vr = v_sdappa_gapi)
!
! - Datastructures for intersection parameters
!
    sdappa_coef = sdappa(1:19)//'.COEF'
    sdappa_poid = sdappa(1:19)//'.POID'
    call wkvect(sdappa_poid, 'V V R', nt_patch, vr = v_sdappa_coef)
    call wkvect(sdappa_coef, 'V V R', nt_patch, vr = v_sdappa_poid)
    


! - Datastructures for adaptation rho_n
 
    sdappa_gpre = sdappa(1:19)//'.GPRE'
    call wkvect(sdappa_gpre, 'V V R', nt_patch, vr = v_sdappa_gpre)


!
! - Loop on contact zones
!
    do i_zone = 1, nb_cont_zone
!
! ----- Create list of elements for current contact zone
!
        call gtlima(sdappa, ds_contact%sdcont_defi, i_zone)
!
! ----- Create objects for inverse connectivity
!
        if (pair_method(1:4).eq.'PANG') then
            call apcinv(mesh, sdappa, i_zone)
        endif
    end do
!
! - Datastructure for Smoothed NOrmals: CHAM_NO on complete mesh
!
    sdappa_psno = sdappa(1:14)//'.PSNO'
    call crcnct('V', sdappa_psno, mesh, 'GEOM_R', 3,&
                ['X','Y','Z'], [0.d0,0.d0,0.d0])
!
! - Datastructure for normals: only on contact zone (not a CHAM_NO ! )
!
    sdappa_norl = sdappa(1:19)//'.NORL'
    call wkvect(sdappa_norl, 'V V R', 3*nb_cont_node, vr = v_sdappa_norl)
!
! - Status saving (At Iteration k-2) ! statut a n-1
!
    sdcont_stat_prev = ds_contact%sdcont_solv(1:14)//'.CYCL'
    sdcont_cyclac_etat = ds_contact%sdcont_solv(1:14)//'.CYCE'
    sdcont_cyclac_hist = ds_contact%sdcont_solv(1:14)//'.CYCH'
!
! - Creating cycling objects
!
    call wkvect(sdcont_stat_prev, 'V V I', nt_patch, vi = v_sdcont_stat_prev)
    call wkvect(sdcont_cyclac_etat, 'V V I', nt_patch, vi = v_sdcont_cyclac_etat)
    call wkvect(sdcont_cyclac_hist, 'V V R', 22*nt_patch, vr = v_sdcont_cyclac_hist)
!
! - Datastructures for informations (from mesh to patch)
!
    sdappa_info = sdappa(1:19)//'.INFO'
    call wkvect(sdappa_info, 'V V I', 6*nt_patch, vi = v_sdappa_info)
    do i_elem = 1, nb_elem
        elem_nume  = i_elem
        patch_indx = v_mesh_comapa(elem_nume)
        ASSERT(patch_indx .le. nt_patch)
        if (patch_indx .ne. 0) then
            nb_elem_patch = v_sdappa_info(6*(patch_indx-1)+1)
            ASSERT(nb_elem_patch .le. 4)
            nb_elem_patch = nb_elem_patch + 1
            ASSERT(v_sdappa_info(6*(patch_indx-1)+1+nb_elem_patch) .eq. 0)
            v_sdappa_info(6*(patch_indx-1)+1+nb_elem_patch) = elem_nume
            v_sdappa_info(6*(patch_indx-1)+1) = nb_elem_patch
            v_sdcont_stat_prev((patch_indx-1)+1) = -2
            v_sdcont_cyclac_etat((patch_indx-1)+1) = -2
            v_sdcont_cyclac_hist(22*(patch_indx-1)+1) = -2
            v_sdcont_cyclac_hist(22*(patch_indx-1)+11) = elem_nume
        endif
    end do
!
! - Datastructure for pointer index DECOUPE_LAC<=>DEFI_CONTACT
!
    sdappa_dcl = sdappa(1:19)//'.DCL '
    sdcont_defi = ds_contact%sdcont_defi(1:16)
    call wkvect(sdappa_dcl, 'V V I', nb_cont_zone, vi = v_sdappa_dcl)
    call jeveuo(sdcont_defi(1:16)//'.PTRDCLC','L',vi = vi_ptrdclac)
    v_sdappa_dcl(:)=vi_ptrdclac(:)
!
    call jedema()
!
end subroutine
