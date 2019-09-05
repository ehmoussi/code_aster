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
#include "asterfort/assert.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexatr.h"
#include "asterfort/apcoor.h"
#include "asterfort/aptype.h"
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
#include "asterfort/mmfield_prep.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "asterfort/lac_gapi.h"
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
    integer :: indi_cont_curr, indi_cont_prev, node_nume
    real(kind=8) :: tole_inter, gap
    integer :: loop_cont_vali
    aster_logical :: loop_cont_conv
    real(kind=8) :: lagc, coefint, loop_cont_vale
    integer :: jacobian_type
    integer :: loop_geom_count, iter_newt
    character(len=19) :: sdappa, newgeo, cnscon
    integer, pointer :: v_pa_lcum(:) => null()
    integer, pointer :: v_mesh_patch(:) => null()
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdcont_lagc
    real(kind=8), pointer :: v_sdcont_lagc(:) => null()
    character(len=24) :: sdappa_gapi
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    character(len=24) :: sdappa_coef
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    integer :: jv_geom
    real(kind=8), pointer :: v_disp_curr(:)  => null()
    integer, pointer :: v_mesh_lpatch(:) => null()
    real(kind=8), pointer :: v_cnscon_cnsv(:) => null()
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
!
! - Get parameters
!
    tole_inter   = 1.d-5
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
!
! - Access to mesh (patches)
!
    call jeveuo(jexnum(mesh//'.PATCH',1), 'L', vi = v_mesh_lpatch)
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
    call jeveuo(sdcont_stat, 'E', vi = v_sdcont_stat)
    call jeveuo(sdcont_lagc, 'E', vr = v_sdcont_lagc)
!
! - Get pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_coef = sdappa(1:19)//'.COEF'
    call jeveuo(sdappa_gapi, 'E', vr = v_sdappa_gapi)
    call jeveuo(sdappa_coef, 'E', vr = v_sdappa_coef)
!
! - Access to displacement field to get contact Lagrangien multiplier
!
    call jeveuo(disp_curr(1:19)//'.VALE', 'E', vr = v_disp_curr)
!
! - Prepare displacement field to get contact Lagrangien multiplier
!
    cnscon = '&&MMMBCA.CNSCON'
    call mmfield_prep(disp_curr, cnscon,&
                      l_sort_ = .true._1, nb_cmp_ = 1, list_cmp_ = ['LAGS_C  '])
    call jeveuo(cnscon//'.CNSV', 'L', vr = v_cnscon_cnsv)
!
! - Get current patch

    call jeveuo(mesh//'.PATCH', 'L', vi = v_mesh_patch)
    call jeveuo(jexatr(mesh//'.PATCH', 'LONCUM'), 'L', vi = v_pa_lcum)
!
! - Get status of loops
!
    call mmbouc(ds_contact, 'Geom', 'Read_Counter', loop_geom_count)
    iter_newt = ds_contact%iteration_newton
!
! - Compute mean square gaps and weights of intersections
!
    call lac_gapi(mesh, ds_contact)
!
! - Evaluatio of status
!
    do i_cont_zone = 1, nb_cont_zone
! ----- Access to patch
        nb_patch = v_mesh_lpatch((i_cont_zone-1)*2+2)
        j_patch  = v_mesh_lpatch((i_cont_zone-1)*2+1)
! ----- Get parameters on current zone
        jacobian_type = mminfi(ds_contact%sdcont_defi, 'TYPE_JACOBIEN', i_cont_zone)
! ----- Loop on patches
        do i_patch = 1, nb_patch
! --------- Get/Set LAGS_C
            node_nume = v_mesh_patch(v_pa_lcum(j_patch+i_patch-1)+2-1)
            lagc      = v_cnscon_cnsv(node_nume)
            v_sdcont_lagc(j_patch-2+i_patch) = lagc
! --------- Get parameters
            coefint        = v_sdappa_coef(j_patch-2+i_patch)
            gap            = v_sdappa_gapi(j_patch-2+i_patch)
            indi_cont_prev = v_sdcont_stat(j_patch-2+i_patch)
! --------- Compute new status
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
! --------- Save new status
            v_sdcont_stat(j_patch-2+i_patch) = indi_cont_curr
! --------- Change status ?
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
    call detrsd('CHAM_NO_S', cnscon)
!
    call jedema()
end subroutine
