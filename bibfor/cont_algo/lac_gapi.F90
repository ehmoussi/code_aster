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
subroutine lac_gapi(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/apcoor.h"
#include "asterfort/aptype.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/gapint.h"
#include "asterfort/cfdisi.h"
#include "asterfort/copisd.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/mmfield_prep.h"
#include "asterfort/nmdebg.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC method - Compute mean square gaps and weights of intersections
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_cont_pair, nb_cont_pair, i_patch, nt_patch
    character(len=19) :: sdappa
    character(len=24) :: sdappa_gapi, sdappa_coef, sdappa_nmcp, sdappa_apli
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    integer, pointer :: v_sdappa_nmcp(:) => null()
    integer, pointer :: v_sdappa_apli(:) => null()
    character(len=24) :: sdappa_apnp, sdappa_apts, sdappa_ap2m
    integer, pointer :: v_sdappa_apnp(:) => null()
    real(kind=8), pointer :: v_sdappa_apts(:) => null()
    real(kind=8), pointer :: v_sdappa_ap2m(:) => null()
    character(len=24) :: sdappa_wpat, sdappa_poid
    real(kind=8), pointer :: v_sdappa_wpat(:) => null()
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    integer :: elem_type_nume
    character(len=8) :: elem_slav_type, elem_mast_type
    integer :: elem_slav_nbnode, elem_slav_nume, elem_slav_dime
    integer :: elem_mast_nbnode, elem_mast_nume, elem_mast_dime
    character(len=8) :: elem_mast_code, elem_slav_code
    real(kind=8) :: elem_slav_coorO(27), elem_mast_coorN(27), elem_slav_coorN(27)
    character(len=19) :: newgeo
    integer :: jv_geomO, jv_geomN
    integer :: patch_indx
    integer, pointer :: v_mesh_typmail(:) => null()
    integer, pointer :: v_mesh_comapa(:) => null()
    integer, pointer :: v_mesh_connex(:)  => null()
    integer, pointer :: v_connex_lcum(:)  => null()
    integer :: nb_poin_inte
    real(kind=8) :: poin_inte(16), poin_gaus_ma(72)
    aster_logical :: l_axis
    real(kind=8) :: inte_weight, gap_moy, pair_tole
    real(kind=8), pointer :: patch_weight_c(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','CONTACT5_29')
    endif
!
! - Initializations
!
    pair_tole      = 1.d-8
!
! - Access to mesh (patches)
!
    call jeveuo(mesh//'.TYPMAIL', 'L', vi = v_mesh_typmail)
    call jeveuo(mesh//'.COMAPA' , 'L', vi = v_mesh_comapa)
    call jeveuo(mesh//'.CONNEX' , 'L', vi = v_mesh_connex)
    call jeveuo(jexatr(mesh//'.CONNEX', 'LONCUM'), 'L', vi = v_connex_lcum)
!
! - Get parameters
!
    l_axis       = cfdisi(ds_contact%sdcont_defi,'AXISYMETRIQUE').eq.1
    nt_patch     = ds_contact%nt_patch
    nb_cont_pair = ds_contact%nb_cont_pair
!
! - Working vector
!
    AS_ALLOCATE(vr=patch_weight_c, size = nt_patch)
!
! - Access to geometry
!
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
! - For Newton:
    call jeveuo(newgeo(1:19)//'.VALE', 'L', jv_geomO)
    call jeveuo(newgeo(1:19)//'.VALE', 'L', jv_geomN)
!
! - Access pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_coef = sdappa(1:19)//'.COEF'
    sdappa_nmcp = sdappa(1:19)//'.NMCP'
    sdappa_apli = sdappa(1:19)//'.APLI'
    sdappa_apnp = sdappa(1:19)//'.APNP'
    sdappa_apts = sdappa(1:19)//'.APTS'
    sdappa_ap2m = sdappa(1:19)//'.AP2M'
    sdappa_wpat = sdappa(1:19)//'.WPAT'
    sdappa_poid = sdappa(1:19)//'.POID'
    call jeveuo(sdappa_gapi, 'E', vr = v_sdappa_gapi)
    call jeveuo(sdappa_coef, 'E', vr = v_sdappa_coef)
    call jeveuo(sdappa_nmcp, 'E', vi = v_sdappa_nmcp)
    call jeveuo(sdappa_apli, 'L', vi = v_sdappa_apli)
    call jeveuo(sdappa_apnp, 'L', vi = v_sdappa_apnp)
    call jeveuo(sdappa_apts, 'L', vr = v_sdappa_apts)
    call jeveuo(sdappa_ap2m, 'L', vr = v_sdappa_ap2m)
    call jeveuo(sdappa_wpat, 'L', vr = v_sdappa_wpat)
    call jeveuo(sdappa_poid, 'E', vr = v_sdappa_poid)
!
! - Compute mean square gap and weight of intersection on contact pairs
!
    v_sdappa_gapi(:) = 0.d0
    v_sdappa_coef(:) = 0.d0
    v_sdappa_nmcp(:) = 0
    do i_cont_pair = 1, nb_cont_pair
! ----- Get master and slave element number
        elem_slav_nume = v_sdappa_apli(3*(i_cont_pair-1)+1)
        elem_mast_nume = v_sdappa_apli(3*(i_cont_pair-1)+2)
! ----- Get master and slave element type
        elem_type_nume = v_mesh_typmail(elem_slav_nume)
        call jenuno(jexnum('&CATA.TM.NOMTM', elem_type_nume), elem_slav_type)
        call aptype(elem_slav_type  ,&
                    elem_slav_nbnode, elem_slav_code, elem_slav_dime)
        elem_type_nume = v_mesh_typmail(elem_mast_nume)
        call jenuno(jexnum('&CATA.TM.NOMTM', elem_type_nume), elem_mast_type)
        call aptype(elem_mast_type  ,&
                    elem_mast_nbnode, elem_mast_code, elem_mast_dime)
        ASSERT(elem_slav_dime .eq. elem_mast_dime)
! ----- Get current patch
        patch_indx = v_mesh_comapa(elem_slav_nume)
! ----- Get coordinates of slave element (on old geometry)
        call apcoor(v_mesh_connex  , v_connex_lcum   , jv_geomO      ,&
                    elem_slav_nume , elem_slav_nbnode, elem_slav_dime,&
                    elem_slav_coorO)
! ----- Get coordinates of slave element (on new geometry)
        call apcoor(v_mesh_connex  , v_connex_lcum   , jv_geomN      ,&
                    elem_slav_nume , elem_slav_nbnode, elem_slav_dime,&
                    elem_slav_coorN)
! ----- Get coordinates of master element (on new geometry)
        call apcoor(v_mesh_connex  , v_connex_lcum   , jv_geomN      ,&
                    elem_mast_nume , elem_mast_nbnode, elem_mast_dime,&
                    elem_mast_coorN)
! ----- Get intersection nodes and Gauss points on master element
        nb_poin_inte       = v_sdappa_apnp(i_cont_pair)
        poin_inte(1:16)    = v_sdappa_apts(16*(i_cont_pair-1)+1:16*(i_cont_pair-1)+16)
        poin_gaus_ma(1:72) = v_sdappa_ap2m(72*(i_cont_pair-1)+1:72*(i_cont_pair-1)+72)
! ----- Compute mean square gap and weight of intersection
        call gapint(elem_slav_dime, l_axis          ,&
                    elem_slav_code, elem_slav_nbnode, elem_slav_coorO, elem_slav_coorN,&
                    elem_mast_code, elem_mast_nbnode, elem_mast_coorN,&
                    nb_poin_inte  , poin_inte       , poin_gaus_ma  ,&
                    gap_moy       , inte_weight)
! ----- Save gap and weight
        v_sdappa_gapi(patch_indx)  = v_sdappa_gapi(patch_indx)-gap_moy
        patch_weight_c(patch_indx) = patch_weight_c(patch_indx)+inte_weight
        v_sdappa_nmcp(patch_indx)  = v_sdappa_nmcp(patch_indx) + 1
    end do
!
! - Compute mean square gap and weight of intersection on patches
!
    do i_patch = 1, nt_patch
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
    AS_DEALLOCATE(vr=patch_weight_c)
    call jedema()
end subroutine

