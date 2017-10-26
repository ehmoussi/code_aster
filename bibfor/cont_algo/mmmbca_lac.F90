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

subroutine mmmbca_lac(mesh, disp_curr, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/jexatr.h"
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
#include "asterfort/mmfield_prep.h"
#include "asterfort/mminfi.h"
#include "asterfort/search_opt_coef.h"
!
! person_in_charge: mickael.abbas at edf.fr
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
    integer :: ifm, niv, hist_index
    integer :: i_cont_zone, i_patch, nb_patch, nb_cont_zone
    integer :: j_patch, node_nume
    integer :: indi_cont_curr, indi_cont_prev, loop_cont_vali, indi_cont_prev2
    aster_logical :: loop_cont_conv
    character(len=19) :: oldgeo, newgeo, cnscon
    real(kind=8) :: tole_inter, gap,gap_prev, lagc,lagc_prev, coefint, loop_cont_vale
    character(len=24) :: sdcont_stat
    integer, pointer :: v_sdcont_stat(:) => null()
    character(len=24) :: sdcont_lagc
    real(kind=8), pointer :: v_sdcont_lagc(:) => null()
    character(len=19) :: sdappa
    character(len=24) :: sdappa_gapi
    real(kind=8), pointer :: v_sdappa_gapi(:) => null()
    character(len=24) :: sdappa_coef
    real(kind=8), pointer :: v_sdappa_coef(:) => null()
    integer, pointer :: v_mesh_patch(:) => null()
    integer, pointer :: v_mesh_lpatch(:) => null()
    integer, pointer :: v_pa_lcum(:) => null()
    real(kind=8), pointer :: v_cnscon_cnsv(:) => null()
    character(len=24) :: sdappa_gpre
    real(kind=8), pointer :: v_sdappa_gpre(:) => null()
    character(len=24) :: sdappa_poid
    real(kind=8), pointer :: v_sdappa_poid(:) => null()
    character(len=24) :: sdcont_stat_prev
    integer, pointer :: v_sdcont_stat_prev(:) => null()
    integer :: etatcyc 
    character(len=24) :: sdcont_cyclac_etat
    integer, pointer :: v_sdcont_cyclac_etat(:) => null()
    character(len=24) :: sdcont_cyclac_hist
    real(kind=8), pointer :: v_sdcont_cyclac_hist(:) => null()
    real(kind=8) :: r_axi, r_smooth
    integer :: jacobian_type
    real(kind=8) :: coef_opt=0.0,pres_cont(2)=0.0, dist_cont(2)=0.0
    real(kind=8) :: bound_coef(2)
    aster_logical:: coef_found=.false._1
    integer :: indi(2)=0
    integer :: type_adap
    
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
    loop_cont_conv = .true.
    loop_cont_vali = 0
    tole_inter     = 1.d-5
    bound_coef(1)     = 1.d-8
    bound_coef(2)     = 1.d8
!
! - Get parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi, 'NZOCO')
    r_smooth     = real(cfdisi(ds_contact%sdcont_defi,'LISSAGE'),kind=8)
    r_axi        = real(cfdisi(ds_contact%sdcont_defi,'AXISYMETRIQUE'),kind=8)
    type_adap    = cfdisi(ds_contact%sdcont_defi,'TYPE_ADAPT')
    write (6,*) 'type d adaptation',type_adap
!
! - Access to mesh (patches)
!
    call jeveuo(jexnum(mesh//'.PATCH',1), 'L', vi = v_mesh_lpatch)
!
! - Acces to contact objects
!
    sdcont_stat = ds_contact%sdcont_solv(1:14)//'.STAT'
    sdcont_lagc = ds_contact%sdcont_solv(1:14)//'.LAGC'
    sdcont_stat_prev = ds_contact%sdcont_solv(1:14)//'.CYCL'
    sdcont_cyclac_etat = ds_contact%sdcont_solv(1:14)//'.CYCE'
    sdcont_cyclac_hist = ds_contact%sdcont_solv(1:14)//'.CYCH'
    call jeveuo(sdcont_stat, 'E', vi = v_sdcont_stat)
    call jeveuo(sdcont_lagc, 'E', vr = v_sdcont_lagc)

    call jeveuo(sdcont_stat_prev, 'E', vi = v_sdcont_stat_prev)
    call jeveuo(sdcont_cyclac_etat, 'E', vi = v_sdcont_cyclac_etat)
    call jeveuo(sdcont_cyclac_hist, 'E', vr = v_sdcont_cyclac_hist)
    
    
!
! - Get pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
    sdappa_gapi = sdappa(1:19)//'.GAPI'
    sdappa_coef = sdappa(1:19)//'.COEF'  
    sdappa_gpre = sdappa(1:19)//'.GPRE'
    sdappa_poid = sdappa(1:19)//'.POID' 
    call jeveuo(sdappa_gapi, 'L', vr = v_sdappa_gapi)
    call jeveuo(sdappa_coef, 'L', vr = v_sdappa_coef)
    call jeveuo(sdcont_stat_prev, 'E', vi = v_sdcont_stat_prev)
    call jeveuo(sdcont_cyclac_etat, 'E', vi = v_sdcont_cyclac_etat)
    call jeveuo(sdcont_cyclac_hist, 'E', vr = v_sdcont_cyclac_hist)
    call jeveuo(sdappa_poid, 'L', vr = v_sdappa_poid)
!
! - Geometric update
!
    oldgeo = mesh//'.COORDO'
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
    call mreacg(mesh, ds_contact, field_update_ = disp_curr)
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
! - Loop on contact zones
!
    do i_cont_zone = 1, nb_cont_zone
!
! ----- Get access to patch
!
        nb_patch = v_mesh_lpatch((i_cont_zone-1)*2+2)
        j_patch  = v_mesh_lpatch((i_cont_zone-1)*2+1)
        jacobian_type= mminfi(ds_contact%sdcont_defi, 'TYPE_JACOBIEN', i_cont_zone)

!
! ----- Loop on patches
!
        do i_patch = 1, nb_patch

!
! --------- Get/Set LAGS_C 
!
            node_nume = v_mesh_patch(v_pa_lcum(j_patch+i_patch-1)+2-1)
            lagc      = v_cnscon_cnsv(node_nume)
            v_sdcont_lagc(j_patch-2+i_patch) = lagc
!
! --------- Get previous parameters
!
            coefint        = v_sdappa_coef(j_patch-2+i_patch)
            gap            = v_sdappa_gapi(j_patch-2+i_patch)
            indi_cont_prev = v_sdcont_stat(j_patch-2+i_patch)
            indi_cont_prev2= v_sdcont_stat_prev(j_patch-2+i_patch)
            lagc_prev = v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+10+5)
!
! --------- Compute new status
!

            if (isnan(gap)) then
                indi_cont_curr = -1
!            elseif (v_sdcont_cyclac_etat(j_patch-2+i_patch) .eq. 1) then 
!                indi_cont_curr = indi_cont_prev
            else
                if ((lagc+gap) .le. r8prem() .and.&
                    v_sdappa_coef(j_patch-2+i_patch).ge.tole_inter) then
                    indi_cont_curr = 1
                else
                    indi_cont_curr = 0
                endif
                
                            
    ! --------- Cycling ?
                
                etatcyc = indi_cont_curr+2*indi_cont_prev+4*indi_cont_prev2
                if( (ds_contact%iteration_newton .ge. 3 ).and.&
                    (etatcyc .eq.2 .or. etatcyc .eq. 5) ) then
                    v_sdcont_cyclac_etat(j_patch-2+i_patch) = 1
                else 
                    v_sdcont_cyclac_etat(j_patch-2+i_patch) = -2
                endif
                
                if( (ds_contact%iteration_newton .ge. 3 ) .and. &
                  v_sdcont_cyclac_etat(j_patch-2+i_patch) .eq. 1) then
                       
                       indi(1) = indi_cont_curr
                       indi(2) = indi_cont_prev
                       pres_cont(1) = lagc
                       pres_cont(2) = v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+10+5)
                       dist_cont(1) = gap
                       dist_cont(2) = gap_prev
                       call search_opt_coef(bound_coef, &
                                       indi, &
                                        pres_cont, dist_cont, &
                                        coef_opt,coef_found)
!                       write (6,*) "coefficient found" , coef_found                                
                       if (coef_found) then
                           indi_cont_curr =  indi(1)
                           indi_cont_prev =  indi(1)  
!                           write (6,*) "a coefficient is found"
!                           if (indi_cont_curr .ne. indi_cont_prev) write (6,*) "Traitement NOOK"
                       endif
    
!                    write (6,*) "traitement cyclage",indi_cont_curr,indi_cont_prev,indi_cont_prev2
                    
                else 
                    v_sdcont_cyclac_etat(j_patch-2+i_patch) = -2
                endif
                v_sdcont_stat(j_patch-2+i_patch) = indi_cont_curr
                v_sdcont_stat_prev(j_patch-2+i_patch) = indi_cont_prev
            
            endif
!
! --------- Save new status
!
            v_sdcont_stat(j_patch-2+i_patch) = indi_cont_curr
            
! --------- Save new status a n-1
!
            v_sdcont_stat_prev(j_patch-2+i_patch) = indi_cont_prev
!

!
! --------- Change status ?
!
            if (indi_cont_curr .ne. indi_cont_prev )  then
                loop_cont_vali = loop_cont_vali+1
            end if    
           
! -------- Copier la valeur precedente :
           do hist_index = 1,11
              v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+11+hist_index) = & 
                       v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+hist_index)  
           enddo
! ---------- Mettre a jours les valeurs actuelle :
           r_smooth       = real(cfdisi(ds_contact%sdcont_defi,'LISSAGE'),kind=8)
           r_axi          = real(cfdisi(ds_contact%sdcont_defi,'AXISYMETRIQUE'),kind=8)
           v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+1) = r_smooth
           v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+2) = jacobian_type
           v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+3) = v_sdappa_coef(j_patch-2+i_patch)
           v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+4) = v_sdcont_stat(j_patch-2+i_patch)
           v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+5) = v_sdcont_lagc(j_patch-2+i_patch)
           v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+6) = r_axi
!           v_sdcont_cyclac_hist(20*(j_patch-2+i_patch-1)+7) = v_sdcont_lagg(j_patch-2+i_patch)
           v_sdcont_cyclac_hist(22*(j_patch-2+i_patch-1)+8) = v_sdappa_poid(j_patch-2+i_patch)
!           v_sdcont_cyclac_hist(20*(j_patch-2+i_patch-1)+9) = v_sdappa_rhon(j_patch-2+i_patch) 
!           v_sdcont_cyclac_hist(20*(j_patch-2+i_patch-1)+10)= v_sdappa_eval(j_patch-2+i_patch) 
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
