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
#include "asterfort/jedema.h"
#include "asterfort/mminfi.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
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
    character(len=19) :: sdappa
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdappa_gapi
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    character(len=24) :: sdappa_coef
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    integer, pointer :: v_mesh_lpatch(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> . Initial options'
    endif
!
! - Initializations
!
    tole_inter   = 1.d-5
    nb_cont_init = 0
!
! - Tolerance for CONTACT_INIT
!
    armini = armin(mesh)
    epsint = 1.d-6*armini
    ds_contact%arete_min  = armini
!
! - Get parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO')
!
! - Access to mesh (patch)
!
    call jeveuo(jexnum(mesh//'.PATCH',1), 'L', vi = v_mesh_lpatch)
!
! - Get pairing datastructure
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    call jeveuo(sdcont_stat, 'E', vi = v_sdcont_stat)
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_coef = sdappa(1:19)//'.COEF' 
    call jeveuo(sdappa_gapi, 'L', vr = v_sdappa_gapi)
    call jeveuo(sdappa_coef, 'L', vr = v_sdappa_coef)
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
    call jedema()
!
end subroutine
