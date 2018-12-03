! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine mmopti_lac(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/armin.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/infdbg.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jemarq.h"
#include "asterfort/jexnum.h"
#include "asterfort/jexatr.h"
#include "asterfort/jedema.h"
#include "asterfort/mminfi.h"
#include "asterfort/utmess.h"
#include "asterfort/apcoor.h"
#include "asterfort/gapint.h"
#include "asterfort/jelira.h"
#include "asterc/r8nnem.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/jenuno.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC method - Initial options (*_INIT)
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_cont_zone, i_patch, nb_patch, nb_cont_zone, nb_cont_init
    integer :: j_patch, cont_init
    integer :: indi_cont_curr, indi_cont_prev
    real(kind=8) :: tole_inter, gap, armini, epsint
    character(len=19) :: sdappa, newgeo
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdappa_gapi
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    character(len=24) :: sdappa_coef
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    character(len=24) :: sdappa_apli
    integer, pointer :: v_sdappa_apli(:) => null()
    character(len=24) :: sdappa_apnp
    integer, pointer :: v_sdappa_apnp(:) => null()
    character(len=24) :: sdappa_apts
    real(kind=8), pointer :: v_sdappa_apts(:) => null()
    character(len=24) :: sdappa_wpat
    real(kind=8), pointer :: v_sdappa_wpat(:) => null()
    character(len=24) :: sdappa_poid
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    character(len=24) :: sdappa_nmcp
    integer, pointer :: v_sdappa_nmcp(:) => null()
    integer, pointer :: v_mesh_lpatch(:) => null()
    integer :: nb_poin_inte, patch_indx, i_pair, nb_pair, jv_geom,elem_type_nume
    integer, pointer :: v_mesh_connex(:)  => null()
    integer, pointer :: v_connex_lcum(:)  => null()
    real(kind=8), pointer :: patch_weight_c(:) => null()
    integer, pointer :: v_mesh_comapa(:) => null()
    integer, pointer :: v_mesh_typmail(:) => null()
    integer :: elem_slav_nbnode, elem_slav_nume, elem_slav_dime
    integer :: elem_mast_nbnode, elem_mast_nume, elem_mast_dime
    character(len=8) :: elem_mast_code, elem_slav_code
    character(len=8) :: elem_slav_type, elem_mast_type
    real(kind=8) :: elem_mast_coor(27), elem_slav_coor(27), poin_inte(16), gap_moy
    real(kind=8) :: inte_weight, pair_tole
    aster_logical :: l_axis
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','CONTACT5_19')
    endif
!
! - Initializations
!
    tole_inter   = 1.d-5
    pair_tole      = 1.d-8
    nb_cont_init = 0
!
! - Tolerance for CONTACT_INIT
!
    armini = armin(mesh)
    epsint = 1.d-6*armini
    ds_contact%arete_min  = armini
    l_axis       = cfdisi(ds_contact%sdcont_defi,'AXISYMETRIQUE').eq.1
!
! - Get parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
!
! - Access to mesh (patch)
!
    call jeveuo(jexnum(mesh//'.PATCH',1), 'L', vi = v_mesh_lpatch)
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
    call jeveuo(newgeo(1:19)//'.VALE', 'L', jv_geom)
    call jeveuo(mesh//'.TYPMAIL', 'L', vi = v_mesh_typmail)
    call jeveuo(mesh//'.COMAPA','L', vi = v_mesh_comapa)
    call jeveuo(mesh//'.CONNEX', 'L', vi = v_mesh_connex)
    call jeveuo(jexatr(mesh//'.CONNEX', 'LONCUM'), 'L', vi = v_connex_lcum)
    nb_patch = ds_contact%nt_patch
    AS_ALLOCATE(vr=patch_weight_c,size=nb_patch)
!
! - Get pairing datastructure
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    call jeveuo(sdcont_stat, 'E', vi = v_sdcont_stat)
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_coef = sdappa(1:19)//'.COEF'
    sdappa_apli = sdappa(1:19)//'.APLI'
    sdappa_apnp = sdappa(1:19)//'.APNP'
    sdappa_apts = sdappa(1:19)//'.APTS'
    sdappa_wpat = sdappa(1:19)//'.WPAT'
    sdappa_poid = sdappa(1:19)//'.POID'
    sdappa_nmcp = sdappa(1:19)//'.NMCP'
    call jeveuo(sdappa_gapi, 'E', vr = v_sdappa_gapi)
    call jeveuo(sdappa_coef, 'E', vr = v_sdappa_coef)
    call jeveuo(sdappa_wpat, 'L', vr = v_sdappa_wpat)
    call jeveuo(sdappa_nmcp, 'E', vi = v_sdappa_nmcp)
    call jeveuo(sdappa_poid, 'E', vr = v_sdappa_poid)
    call jeveuo(sdappa_apli, 'L', vi = v_sdappa_apli)
    call jeveuo(sdappa_apnp, 'L', vi = v_sdappa_apnp)
    call jeveuo(sdappa_apts, 'L', vr = v_sdappa_apts)
    call jeveuo(sdappa_apli, 'L', vi = v_sdappa_apli)
    nb_pair = ds_contact%nb_cont_pair
    v_sdappa_gapi(:) = 0.d0
    v_sdappa_coef(:) = 0.d0
    v_sdappa_nmcp(:) = 0
    do i_pair=1,nb_pair
        !get master and slave element number
        elem_slav_nume = v_sdappa_apli(3*(i_pair-1)+1)
        elem_mast_nume = v_sdappa_apli(3*(i_pair-1)+2)
        !get slave coor
        elem_type_nume = v_mesh_typmail(elem_slav_nume)
        call jenuno(jexnum('&CATA.TM.NOMTM', elem_type_nume), elem_slav_type)
        call apcoor(jv_geom       , elem_slav_type  ,&
                    elem_slav_nume, elem_slav_coor, elem_slav_nbnode,&
                    elem_slav_code, elem_slav_dime, v_mesh_connex   ,&
                    v_connex_lcum)
        !get patch number
        patch_indx = v_mesh_comapa(elem_slav_nume)
        v_sdappa_nmcp(patch_indx) = v_sdappa_nmcp(patch_indx) + 1
        !get master coor
        elem_type_nume = v_mesh_typmail(elem_mast_nume)
        call jenuno(jexnum('&CATA.TM.NOMTM', elem_type_nume), elem_mast_type)
        call apcoor(jv_geom       , elem_mast_type  ,&
                    elem_mast_nume, elem_mast_coor, elem_mast_nbnode,&
                    elem_mast_code, elem_mast_dime, v_mesh_connex   ,&
                    v_connex_lcum)
        !get number of intersection nodes
        nb_poin_inte = v_sdappa_apnp(i_pair)
        !get intersection nodes
        poin_inte(1:16) = v_sdappa_apts(16*(i_pair-1)+1:16*(i_pair-1)+16)
        !compute gap
        call gapint(pair_tole    , elem_slav_dime,&
                    elem_slav_code, elem_slav_nbnode, elem_slav_coor,&
                    elem_mast_code, elem_mast_nbnode, elem_mast_coor,&
                    nb_poin_inte  , poin_inte                    , &
                    gap_moy       , inte_weight, l_axis)
        !save gap
        v_sdappa_gapi(patch_indx)  = v_sdappa_gapi(patch_indx)-gap_moy
        patch_weight_c(patch_indx) = patch_weight_c(patch_indx)+inte_weight
    end do
    do i_patch=1,nb_patch
        if (patch_weight_c(i_patch) .le. pair_tole) then
            v_sdappa_gapi(i_patch) = r8nnem()
        end if
        if (.not.isnan(v_sdappa_gapi(i_patch))) then
            v_sdappa_gapi(i_patch) = v_sdappa_gapi(i_patch)/patch_weight_c(i_patch)
            v_sdappa_coef(i_patch) = patch_weight_c(i_patch)/v_sdappa_wpat(i_patch)
            v_sdappa_poid(i_patch) = patch_weight_c(i_patch)
        end if
    end do
!
! - Loop on contact zones
!
    do i_cont_zone = 1, nb_cont_zone
!
! ----- Get access to patch
!
        nb_patch = v_mesh_lpatch((i_cont_zone-1)*2+2)
        j_patch  = v_mesh_lpatch((i_cont_zone-1)*2+1)
!
! ----- Get parameters
!
        cont_init = mminfi(ds_contact%sdcont_defi, 'CONTACT_INIT', i_cont_zone)
!
! ----- Loop on patches
!
        do i_patch = 1, nb_patch
!
            gap            = v_sdappa_gapi(j_patch-2+i_patch)
            indi_cont_prev = v_sdcont_stat(j_patch-2+i_patch)
!
! --------- Compute new status
!
            if (isnan(gap)) then
                indi_cont_curr = -1
            else
                indi_cont_curr = 0
                if (cont_init .eq. 2) then
! ----------------- Only interpenetrated points
                    if (gap .le. epsint.and.&
                        v_sdappa_coef(j_patch-2+i_patch) .ge. tole_inter) then
                        indi_cont_curr = 1
                        nb_cont_init = nb_cont_init + 1
                    endif
                else if (cont_init .eq. 1) then
! ----------------- All points
                    indi_cont_curr = 1
                    nb_cont_init = nb_cont_init + 1
                else if (cont_init .eq. 0) then
! ----------------- No initial contact
                    indi_cont_curr = 0
                else
                    ASSERT(.false.)
                endif
            endif
!
! --------- Save new status
!
            v_sdcont_stat(j_patch-2+i_patch) = indi_cont_curr
        end do
    end do
!
    call utmess('I', 'CONTACT3_6', si = nb_cont_init)
!
    AS_DEALLOCATE(vr=patch_weight_c)
    call jedema()
!
end subroutine
