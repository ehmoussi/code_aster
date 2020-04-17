! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine mminit_lac(mesh     , ds_contact, hat_valinc, ds_measure, sdnume,&
                      nume_inst)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/cfdisl.h"
#include "asterfort/mmbouc.h"
#include "asterfort/mmapin.h"
#include "asterfort/misazl.h"
#include "asterfort/copisd.h"
#include "asterfort/nmchex.h"
#include "asterfort/mmopti_lac.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
type(NL_DS_Contact), intent(inout) :: ds_contact
character(len=19), intent(in) :: hat_valinc(*)
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: sdnume
integer, intent(in) :: nume_inst
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! LAC method - Initializations
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
! In  hat_valinc       : hat variable for algorithm fields
! IO  ds_measure       : datastructure for measure and statistics management
! In  sdnume           : name of dof positions datastructure
! In  nume_inst        : index of current step time
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_cont_allv, l_step_first
    character(len=19) :: sdcont_depgeo, disp_prev, sdcont_depini, sdappa
    character(len=19) :: sdcont_stat, sdcont_zeta, sdcont_zgpi
    character(len=19) :: sdcont_zpoi, sdcont_znmc,  sdcont_zcoe
    character(len=24) :: sdappa_gapi, sdappa_poid, sdappa_nmcp, sdappa_coef
    integer, pointer :: v_sdcont_stat(:) => null()
    integer, pointer :: v_sdcont_zeta(:) => null()
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    real(kind=8), pointer :: v_sdcont_zgpi(:) => null()
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    real(kind=8), pointer :: v_sdcont_zpoi(:) => null()
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    real(kind=8), pointer :: v_sdcont_zcoe(:) => null()
    integer, pointer :: v_sdappa_nmcp(:) => null()
    integer, pointer :: v_sdcont_znmc(:) => null()
!
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'CONTACT5_14')
    endif
!
! - Initializations
!
    l_cont_allv  = cfdisl(ds_contact%sdcont_defi,'ALL_VERIF')
    ASSERT(.not.l_cont_allv)
!
! - Using *_INIT options (like SEUIL_INIT)
!
    l_step_first = nume_inst .eq. 1
!
! - Get field names in hat-variables
!
    call nmchex(hat_valinc, 'VALINC', 'DEPMOI', disp_prev)
!
! - Lagrangians initialized (LAMBDA TOTAUX)
!
    sdcont_depini = ds_contact%sdcont_solv(1:14)//'.INIT'
    call copisd('CHAMP_GD', 'V', disp_prev, sdcont_depini)
    call misazl(ds_contact, sdnume, disp_prev)
!
! - Save displacements for geometric loop
!
    sdcont_depgeo = ds_contact%sdcont_solv(1:14)//'.DEPG'
    call copisd('CHAMP_GD', 'V', disp_prev, sdcont_depgeo)
!
! - Geometric loop counter initialization
!
    call mmbouc(ds_contact, 'Geom', 'Init_Counter')
!
! - First geometric loop counter
!
    call mmbouc(ds_contact, 'Geom', 'Incr_Counter')
!
! - Initial pairing
!
    call mmapin(mesh, ds_contact, ds_measure)
!
! - Management of status for time cut
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    sdcont_zeta = ds_contact%sdcont_solv(1:14)//'.ZETA'
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_poid = sdappa(1:19)//'.POID'
    sdappa_nmcp = sdappa(1:19)//'.NMCP'
    sdappa_coef = sdappa(1:19)//'.COEF'
    sdcont_zgpi = ds_contact%sdcont_solv(1:14)//'.ZGPI'
    sdcont_zpoi = ds_contact%sdcont_solv(1:14)//'.ZPOI'
    sdcont_znmc = ds_contact%sdcont_solv(1:14)//'.ZNMC'
    sdcont_zcoe = ds_contact%sdcont_solv(1:14)//'.ZCOE'
    call jeveuo(sdcont_stat, 'E', vi = v_sdcont_stat)
    call jeveuo(sdappa_gapi, 'E', vr = v_sdappa_gapi)
    call jeveuo(sdappa_nmcp, 'E', vi = v_sdappa_nmcp)
    call jeveuo(sdappa_poid, 'E', vr = v_sdappa_poid)
    call jeveuo(sdappa_coef, 'E', vr = v_sdappa_coef)
    call jeveuo(sdcont_zeta, 'L', vi = v_sdcont_zeta)
    call jeveuo(sdcont_zpoi, 'L', vr = v_sdcont_zpoi)
    call jeveuo(sdcont_znmc, 'L', vi = v_sdcont_znmc)
    call jeveuo(sdcont_zcoe, 'L', vr = v_sdcont_zcoe)
    call jeveuo(sdcont_zgpi, 'L', vr = v_sdcont_zgpi)
    v_sdcont_stat(:)=v_sdcont_zeta(:)
    v_sdappa_gapi(:)=v_sdcont_zgpi(:)
    v_sdappa_poid(:)=v_sdcont_zpoi(:)
    v_sdappa_nmcp(:)=v_sdcont_znmc(:)
    v_sdappa_coef(:)=v_sdcont_zcoe(:)
!
! - Initial options
!
    if (.not.l_cont_allv .and. l_step_first) then
       call mmopti_lac(mesh, ds_contact)
    endif
!
end subroutine
