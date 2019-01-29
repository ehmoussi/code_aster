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
subroutine mmopti_lac(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterc/r8nnem.h"
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
#include "asterfort/aptype.h"
#include "asterfort/gapint.h"
#include "asterfort/jelira.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/jenuno.h"
#include "asterfort/lac_gapi.h"
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
    integer :: i_cont_zone, i_patch, nb_patch, nb_cont_zone
    integer :: j_patch
    integer :: indi_cont_curr, indi_cont_prev
    real(kind=8) :: tole_inter, gap
    integer :: nb_cont_init, cont_init
    real(kind=8) :: epsint
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
    character(len=24) :: sdappa_ap2m
    real(kind=8), pointer :: v_sdappa_ap2m(:) => null()
    character(len=24) :: sdappa_wpat
    real(kind=8), pointer :: v_sdappa_wpat(:) => null()
    character(len=24) :: sdappa_poid
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    character(len=24) :: sdappa_nmcp
    integer, pointer :: v_sdappa_nmcp(:) => null()
    integer, pointer :: v_mesh_lpatch(:) => null()
    integer :: nb_pair, jv_geom
    integer, pointer :: v_mesh_connex(:)  => null()
    integer, pointer :: v_connex_lcum(:)  => null()
    real(kind=8), pointer :: patch_weight_c(:) => null()
    integer, pointer :: v_mesh_comapa(:) => null()
    integer, pointer :: v_mesh_typmail(:) => null()
    real(kind=8) ::  pair_tole
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
    pair_tole    = 1.d-8
    nb_cont_init = 0
!
! - Get parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
    l_axis       = cfdisi(ds_contact%sdcont_defi,'AXISYMETRIQUE').eq.1
    nb_patch     = ds_contact%nt_patch
    nb_pair      = ds_contact%nb_cont_pair
    epsint       = 1.d-6*ds_contact%arete_min
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
! - Access to geometry
!
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
    call jeveuo(newgeo(1:19)//'.VALE', 'L', jv_geom)
!
! - Acces to contact objects
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    call jeveuo(sdcont_stat, 'E', vi = v_sdcont_stat)
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
! - Compute mean square gaps and weights of intersections
!
    call lac_gapi(mesh, ds_contact)
!
! - Loop on contact zones
!
    do i_cont_zone = 1, nb_cont_zone
! ----- Access to patch
        nb_patch = v_mesh_lpatch((i_cont_zone-1)*2+2)
        j_patch  = v_mesh_lpatch((i_cont_zone-1)*2+1)
! ----- Get parameters on current zone
        cont_init = mminfi(ds_contact%sdcont_defi, 'CONTACT_INIT', i_cont_zone)
! ----- Loop on patches
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
