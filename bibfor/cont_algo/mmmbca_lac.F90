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
subroutine mmmbca_lac(mesh, disp_curr, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8nnem.h"
#include "asterc/r8prem.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexatr.h"
#include "asterfort/apcoor.h"
#include "asterfort/gapint.h"
#include "asterfort/jelira.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/jexnum.h"
#include "asterfort/detrsd.h"
#include "asterfort/mreacg.h"
#include "asterfort/mmbouc.h"
#include "asterfort/mminfi.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=8), intent(in) :: mesh
character(len=19), intent(in) :: disp_curr
type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC method - Management of contact loop
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  disp_curr        : current displacements
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_cont_zone, i_patch, nb_patch, nb_cont_zone
    integer :: j_patch
    integer :: indi_cont_curr, indi_cont_prev
    real(kind=8) :: tole_inter, gap
    integer :: loop_cont_vali
    aster_logical :: loop_cont_conv
    real(kind=8) :: lagc, coefint, loop_cont_vale
    integer :: jacobian_type
    integer :: loop_geom_count, iter_newt
    character(len=19) :: sdappa, newgeo
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdcont_lagc
    real(kind=8), pointer :: v_sdcont_lagc(:) => null()
    character(len=24) :: sdcont_ddlc
    integer, pointer :: v_sdcont_ddlc(:) => null()
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
    character(len=24) :: sdappa_ap2m
    real(kind=8), pointer :: v_sdappa_ap2m(:) => null()
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
    real(kind=8) :: inte_weight, pair_tole, poin_gaus_ma(72)
    aster_logical :: l_axis
    real(kind=8), pointer :: v_disp_curr(:)  => null()
    integer :: nume_equa
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> ... ACTIVATION/DESACTIVATION'
    endif
!
! - Initializations
!
    loop_cont_conv = ASTER_TRUE
    loop_cont_vali = 0
    tole_inter     = 1.d-5
    pair_tole      = 1.d-8
!
! - Get parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
    l_axis       = cfdisi(ds_contact%sdcont_defi,'AXISYMETRIQUE').eq.1
    nb_patch     = ds_contact%nt_patch
    nb_pair      = ds_contact%nb_cont_pair
!
! - Access to mesh (patches)
!
    call jeveuo(jexnum(mesh//'.PATCH',1), 'L', vi = v_mesh_lpatch)
    call jeveuo(mesh//'.TYPMAIL', 'L', vi = v_mesh_typmail)
    call jeveuo(mesh//'.COMAPA','L', vi = v_mesh_comapa)
    call jeveuo(mesh//'.CONNEX', 'L', vi = v_mesh_connex)
    call jeveuo(jexatr(mesh//'.CONNEX', 'LONCUM'), 'L', vi = v_connex_lcum)
!
! - Working vector
!
    AS_ALLOCATE(vr=patch_weight_c,size=nb_patch)
!
! - Update geometry
!
    call mreacg(mesh, ds_contact, disp_curr)
!
! - Access to geometry
!
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
    call jeveuo(newgeo(1:19)//'.VALE', 'L', jv_geom)
!
! - Acces to contact objects
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    sdcont_lagc = ds_contact%sdcont_solv(1:14)//'.LAGC'
    sdcont_ddlc = ds_contact%sdcont_solv(1:14)//'.DDLC'
    call jeveuo(sdcont_stat, 'E', vi = v_sdcont_stat)
    call jeveuo(sdcont_lagc, 'E', vr = v_sdcont_lagc)
    call jeveuo(sdcont_ddlc, 'L', vi = v_sdcont_ddlc)
!
! - Get pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_coef = sdappa(1:19)//'.COEF'
    sdappa_apli = sdappa(1:19)//'.APLI'
    sdappa_apnp = sdappa(1:19)//'.APNP'
    sdappa_apts = sdappa(1:19)//'.APTS'
    sdappa_ap2m = sdappa(1:19)//'.AP2M'
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
    call jeveuo(sdappa_ap2m, 'L', vr = v_sdappa_ap2m)
    call jeveuo(sdappa_apli, 'L', vi = v_sdappa_apli)
!
! - Access to displacement field to get contact Lagrangien multiplier
!
    call jeveuo(disp_curr(1:19)//'.VALE', 'E', vr = v_disp_curr)
!
! - Get status of loops
!
    call mmbouc(ds_contact, 'Geom', 'Read_Counter', loop_geom_count)
    iter_newt = ds_contact%iteration_newton
!
! - Compute integrated gap
!
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
        poin_gaus_ma(1:72) = v_sdappa_ap2m(72*(i_pair-1)+1:72*(i_pair-1)+72)
        !compute gap
        call gapint(elem_slav_dime, elem_slav_code  , elem_slav_nbnode, elem_slav_coor,&
                    elem_mast_code, elem_mast_nbnode, elem_mast_coor  , nb_poin_inte  ,&
                    poin_inte     , gap_moy         , inte_weight     , poin_gaus_ma  ,&
                    l_axis )
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
! ----- Access to patch
        nb_patch = v_mesh_lpatch((i_cont_zone-1)*2+2)
        j_patch  = v_mesh_lpatch((i_cont_zone-1)*2+1)
! ----- Get parameters on current zone
        jacobian_type = mminfi(ds_contact%sdcont_defi, 'TYPE_JACOBIEN', i_cont_zone)
!
! ----- Loop on patches
!
        do i_patch = 1, nb_patch
!
! --------- Get/Set LAGS_C
!
            nume_equa = v_sdcont_ddlc(i_patch)
            if (iter_newt .eq. 0 .and. loop_geom_count .gt. 1) then
                lagc      = v_sdcont_lagc(j_patch-2+i_patch)
                v_disp_curr(nume_equa) = lagc
            else
                lagc = v_disp_curr(nume_equa)
            endif
            v_sdcont_lagc(j_patch-2+i_patch) = lagc
!
! --------- Get previous parameters
!
            coefint        = v_sdappa_coef(j_patch-2+i_patch)
            gap            = v_sdappa_gapi(j_patch-2+i_patch)
            indi_cont_prev = v_sdcont_stat(j_patch-2+i_patch)
!
! --------- Compute new status
!
            if (isnan(gap)) then
                indi_cont_curr = -1
            else
                if ((lagc+gap) .le. r8prem() .and.&
                    v_sdappa_coef(j_patch-2+i_patch).ge.tole_inter) then
                    indi_cont_curr = 1
                else
                    indi_cont_curr = 0
                endif
                v_sdcont_stat(j_patch-2+i_patch) = indi_cont_curr
            endif
!
! --------- Save new status
!
            v_sdcont_stat(j_patch-2+i_patch) = indi_cont_curr
!
! --------- Change status ?
!
            if (indi_cont_curr .ne. indi_cont_prev) then
                loop_cont_vali = loop_cont_vali+1
            end if
        end do
    end do
!
! - Convergence ?
!
    loop_cont_conv = loop_cont_vali .eq. 0
!
! - Set loop values
!
    if (loop_cont_conv) then
        call mmbouc(ds_contact, 'Cont', 'Set_Convergence')
    else
        call mmbouc(ds_contact, 'Cont', 'Set_Divergence')
    endif
    loop_cont_vale = real(loop_cont_vali, kind=8)
    call mmbouc(ds_contact, 'Cont', 'Set_Vale' , loop_vale_ = loop_cont_vale)
!
! - Cleaning
!
    call jedetr(newgeo)
    AS_DEALLOCATE(vr=patch_weight_c)
!
    call jedema()
end subroutine
