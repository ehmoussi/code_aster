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

subroutine mmalgo(ds_contact, l_loop_cont, l_frot_zone, &
                  l_glis_init, type_adap, zone_index, i_cont_poin, &
                  indi_cont_eval, indi_frot_eval, dist_cont_curr,  &
                  pres_cont_curr, dist_frot_curr, pres_frot_curr, v_sdcont_cychis,&
                  v_sdcont_cyccoe, v_sdcont_cyceta, indi_cont_curr,indi_frot_curr,&
                  ctcsta, mmcvca,l_pena_frot,l_pena_cont,vale_pene)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterc/r8prem.h"
#include "asterfort/mmstac.h"
#include "asterfort/mm_cycl_detect.h"
#include "asterfort/mm_cycl_trait.h"
#include "asterfort/cfdisi.h"
#include "asterfort/search_opt_coef.h"
#include "asterfort/bussetta_algorithm.h"
!#include "asterfort/proscal.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
! aslint: disable=W1504
!
    type(NL_DS_Contact), intent(inout) :: ds_contact
    aster_logical, intent(in) :: l_loop_cont
    aster_logical, intent(in) :: l_frot_zone
    aster_logical, intent(in) :: l_glis_init
    aster_logical, intent(in) :: l_pena_frot
    aster_logical, intent(in) :: l_pena_cont
    integer, intent(in) :: type_adap
    integer, intent(in) :: i_cont_poin
    integer, intent(in) :: zone_index
    integer, intent(inout) :: indi_cont_eval
    integer, intent(inout) :: indi_frot_eval
    real(kind=8), intent(in) :: vale_pene
    real(kind=8), intent(inout) :: dist_cont_curr
    real(kind=8), intent(inout) :: pres_cont_curr
    real(kind=8), intent(inout) :: dist_frot_curr(3)
    real(kind=8), intent(in) :: pres_frot_curr(3)
    real(kind=8), pointer :: v_sdcont_cychis(:)
    real(kind=8), pointer :: v_sdcont_cyccoe(:)
    integer, pointer :: v_sdcont_cyceta(:)
    integer, intent(out) :: indi_cont_curr
    integer, intent(out) :: indi_frot_curr
    integer, intent(out) :: ctcsta
    aster_logical, intent(out) :: mmcvca
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CONTRAINTES ACTIVES)
!
! TRAITEMENT DES DIFFERENTS CAS
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  l_frot_zone      : .true. if friction on zone
! In  l_loop_cont      : .true. if fixed poitn on contact loop
! In  l_coef_adap      : .true. if automatic lagrangian adaptation
! In  l_glis_init      : .true. if bilateral contact for first step
! In  i_cont_poin      : contact point index
! In  indi_cont_eval   : evaluation of new contact status
! In  indi_frot_eval   : evaluation of new friction status
! In  dist_cont_curr   : current contact gap
! In  pres_cont_curr   : current contact pressure
! In  dist_frot_curr   : current friction distance
! In  pres_frot_curr   : current friction pressure
! In  v_sdcont_cychis  : pointer to cycling history
! In  v_sdcont_cyccoe  : pointer to coefficient history
! Out indi_cont_curr   : current contact status
! Out indi_frot_curr   : current friction status
! Out mmcvca           : .true. if contact loop converged
! Out ctcsta           : number of contact points has changed their status
!
! --------------------------------------------------------------------------------------------------
!
    integer :: hist_index = 0 
    real(kind=8) :: coef_cont_prev = 0.0, coef_frot_prev=0.0
    real(kind=8) :: coef_cont_curr=0.0, coef_frot_curr=0.0
    real(kind=8) ::  coefficient=0.0
    aster_logical:: coef_found=.false._1,treatment =.true._1
    aster_logical:: l_coef_adap = .false._1
    integer      ::  mode_cycl = 0
    real(kind=8) :: pres_frot_prev(3)=0.0, pres_cont_prev=0.0
    real(kind=8) :: dist_frot_prev(3)=0.0, dist_cont_prev=0.0
    integer :: indi_cont_prev=0, indi_frot_prev=0,indi(2)=0,i_reso_cont=0
    real(kind=8) :: coef_frot_mini=0.0, coef_frot_maxi=0.0
    real(kind=8) :: alpha_cont_matr=0.0, alpha_cont_vect=0.0
    real(kind=8) :: alpha_frot_matr=0.0, alpha_frot_vect=0.0
    real(kind=8) :: coef_opt=0.0,pres_cont(2)=0.0, dist_cont(2)=0.0
    real(kind=8) :: coef_bussetta=0.0, dist_max=0.0
    integer      ::  i_algo_cont=0
    integer :: i_reso_frot=0
    integer :: n_cychis,nb_cont_poin
!    real(kind=8) :: coef_bussetta=0.0, dist_max, coef_tmp
    real(kind=8) ::  coef_tmp,F_refe,resi_press_curr
!    real(kind=8) ::  racine,racine1,racine2,racinesup
!    real(kind=8) ::  a,b,c,discriminant
    real(kind=8) :: bound_coef(2)
    bound_coef(1)     = 1.d-8
    bound_coef(2)     = 1.d8
    




!
! --------------------------------------------------------------------------------------------------
!
!
! - Initializations
!
    n_cychis  = ds_contact%n_cychis
    
    l_coef_adap = ((type_adap .eq. 1) .or. (type_adap .eq. 2) .or. &
                  (type_adap .eq. 5) .or. (type_adap .eq. 6 ))
! le cas type_adap = 3 est particulier : on adapte coef_cont avec bussetta mais pas coef_frot    
    treatment =  ((type_adap .eq. 4) .or. (type_adap .eq. 5) .or. &
                  (type_adap .eq. 6) .or. (type_adap .eq. 7 ))
    i_reso_cont  = cfdisi(ds_contact%sdcont_defi,'ALGO_RESO_CONT')
    i_reso_frot  = cfdisi(ds_contact%sdcont_defi,'ALGO_FROT')
    i_algo_cont  = cfdisi(ds_contact%sdcont_defi,'ALGO_CONT')
!
! - Save old history
!
    if (nint(v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24)) .ne. &
        nint(v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+24))) then
!        write (6,*) "la maille maitre a changé : on e fait rien "
        treatment =.false.
    endif

!    do hist_index = 1, 12
!        v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+hist_index) = &
!            v_sdcont_cychis(n_cychis*(i_cont_poin-1)+hist_index)
!    enddo
!
! - Previous informations
!
    indi_cont_prev = nint(v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+1))
    coef_cont_prev = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+2)
    pres_cont_prev = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+3)
    dist_cont_prev = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+4)
! XXX next value seems uniniatiliased in ssnp121i
    indi_frot_prev = nint(v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+5))
    coef_frot_prev = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+6)
    pres_frot_prev(1) = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+7)
    pres_frot_prev(2) = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+8)
    pres_frot_prev(3) = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+9)
    dist_frot_prev(1) = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+10)
    dist_frot_prev(2) = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+11)
    dist_frot_prev(3) = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+12)
!
! - Current max/min ratio
!
    coef_frot_mini = v_sdcont_cyccoe(6*(zone_index-1)+5)
    coef_frot_maxi = v_sdcont_cyccoe(6*(zone_index-1)+6)
!
! - Cycling detection
!
    call mm_cycl_detect(ds_contact, l_loop_cont, l_frot_zone, i_cont_poin,&
                         coef_cont_prev,coef_frot_prev, pres_cont_prev,&
                         dist_cont_prev, pres_frot_curr,pres_frot_prev ,& 
                         indi_frot_prev, dist_frot_prev, indi_cont_eval,&
                         indi_frot_eval, indi_cont_prev, dist_cont_curr, pres_cont_curr,&
                         dist_frot_curr,alpha_cont_matr, alpha_cont_vect,&
                         alpha_frot_matr, alpha_frot_vect)
    
!
! - Cycling treatment: automatic adaptation of augmented lagrangian ratio
!
    if (l_coef_adap) then
        call mm_cycl_trait(ds_contact, i_cont_poin, coef_cont_prev, coef_frot_prev,&
                           pres_frot_prev, dist_frot_prev, pres_frot_curr, dist_frot_curr,&
                           indi_cont_eval, indi_frot_eval, indi_cont_curr, coef_cont_curr,&
                           indi_frot_curr, coef_frot_curr)
    else
        coef_cont_curr = coef_cont_prev
        coef_frot_curr = coef_frot_prev
        indi_cont_curr = indi_cont_eval
        indi_frot_curr = indi_frot_eval
    endif
!
! - Saving max/min ratio
!
    if (coef_frot_curr .ge. coef_frot_maxi) coef_frot_maxi = coef_frot_curr
    if (coef_frot_curr .le. coef_frot_mini) coef_frot_mini = coef_frot_curr
    v_sdcont_cyccoe(6*(zone_index-1)+5) = coef_frot_mini
    v_sdcont_cyccoe(6*(zone_index-1)+6) = coef_frot_maxi
!
! - Special treatment if bilateral contact : every point is in contact
!
    if (l_glis_init) indi_cont_curr = 1
!
! - Save history for automatic cycling algorithm
!
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+1) = indi_cont_curr
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2) = coef_cont_curr
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+3) = pres_cont_curr
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+4) = dist_cont_curr
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+5) = indi_frot_curr
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+6) = coef_frot_curr
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+7) = pres_frot_curr(1)
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+8) = pres_frot_curr(2)
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+9) = pres_frot_curr(3)
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+10) = dist_frot_curr(1)
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+11) = dist_frot_curr(2)
    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+12) = dist_frot_curr(3)
    
    
    if (i_reso_cont .eq. 0) then
        if (v_sdcont_cyceta(4*(i_cont_poin-1)+1) .eq. -10) then
            mmcvca = .true.
!             write (6,*) "ON A DECLENCHE LE FLIP-FLOP AVANT LE TRAITEMENT DE CYCLAGE "
!             write (6,*) "LE POINT QUI CYCLE PEUVENT ETRE TRAITE EN FLIP-FLOP SANS PASSER   "
!             write (6,*) "PAR UNE METHODE QUI ADAPTE LES MATRICES DE CONTACT   "
    !                 goto 911
        endif
    endif
    if ((ds_contact%iteration_newton .ge. 3 ) .and. &
        (v_sdcont_cyceta(4*(i_cont_poin-1)+1) .gt. 0 .and. treatment )) then
       
            if (v_sdcont_cyceta(4*(i_cont_poin-1)+4) .eq. -10) then
                mmcvca = .true.
            endif
!ADAPTATION DE MATRICES, VECTEURS ET COEFF POUR LES TE :
! MATR_PREVIOUS + MATR_CURRENT       
       v_sdcont_cychis(n_cychis*(i_cont_poin-1)+57) = 1.0d0
       v_sdcont_cychis(n_cychis*(i_cont_poin-1)+59) = alpha_cont_matr
       v_sdcont_cychis(n_cychis*(i_cont_poin-1)+56) = alpha_cont_vect
!       coefficient = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2) /1.d4
       coef_found = .false.
       indi(1) = indi_cont_curr
       indi(2) = indi_cont_prev
       pres_cont(1) = pres_cont_curr
       pres_cont(2) = pres_cont_prev
       dist_cont(1) = dist_cont_curr
       dist_cont(2) = dist_cont_prev
       
       call search_opt_coef(bound_coef, &
                                       indi, pres_cont, dist_cont, &
                                       coef_opt,coef_found)
!      write (6,*) "coefficient found" , coef_found                                
       if (coef_found) then
           if (i_reso_cont .ne. 0) then
               indi_cont_curr =  indi(1)
               indi_cont_prev =  indi(2)  
               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+1)    = indi_cont_curr
               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+1) = indi_cont_prev
           endif
           dist_cont_curr =  dist_cont(1)
           dist_cont_prev =  dist_cont(2)
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2)    = coef_opt
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+2) = coef_opt       
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+3)    = pres_cont_curr
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+3) = pres_cont_prev
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+4)    = dist_cont_curr
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+4) = dist_cont_prev          
!           if (indi_cont_curr .ne. indi_cont_prev) write (6,*) "Traitement NOOK"
       endif
         
    endif

! WARNING CYCLAGE FROTTEMENT    : ADHE_GLIS
                
    if ((ds_contact%iteration_newton .ge. 3 ) .and. &
       (v_sdcont_cyceta(4*(i_cont_poin-1)+2) .ge. 10 ) .and. treatment   ) then   
        
           if (v_sdcont_cyceta(4*(i_cont_poin-1)+1) .eq. 11) then
               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50) = 0.0d0
           else
               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50) = 1.0d0
           endif
         
           if (nint(v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50)) .eq. 1)  then
       
               if (  v_sdcont_cyceta(4*(i_cont_poin-1)+2) .eq. 11   ) then  
                  indi_frot_curr = 1
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+5) = indi_frot_curr
                  alpha_frot_matr = 1.0
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = alpha_frot_matr         
                  alpha_frot_vect = 1.0
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = alpha_frot_vect
                       
               elseif (  v_sdcont_cyceta(4*(i_cont_poin-1)+2) .eq. 12   ) then  
                  alpha_frot_matr = 1.0
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = alpha_frot_matr         
                  alpha_frot_vect = 1.0
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = alpha_frot_vect
                       
               elseif (  v_sdcont_cyceta(4*(i_cont_poin-1)+2) .eq. 13   ) then  
                  alpha_frot_matr = 1.0
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = alpha_frot_matr         
                  alpha_frot_vect = 1.0
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = alpha_frot_vect
                       
               elseif (  v_sdcont_cyceta(4*(i_cont_poin-1)+2) .eq. 14   ) then  
                  alpha_frot_matr = 0.5
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = alpha_frot_matr         
                  alpha_frot_vect = 0.5
                  v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = alpha_frot_vect
               endif
           endif    
         
       else 
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50) = 0.0d0
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = 1.0
           v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = 1.0
       endif
    
                    
    if ((ds_contact%iteration_newton .ge. 3 ) .and. &
       (v_sdcont_cyceta(4*(i_cont_poin-1)+3) .ge. 10 )  .and. treatment  ) then   
        
         if (v_sdcont_cyceta(4*(i_cont_poin-1)+1) .eq. 11) then
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50) = 0.0d0
         else
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50) = 1.0d0
         endif
         
         if     (nint(v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50)) .eq. 1)  then
             if (  v_sdcont_cyceta(4*(i_cont_poin-1)+3) .eq. 11   ) then  
           
                alpha_frot_matr = 0.5
                v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = alpha_frot_matr            
                alpha_frot_vect = 1.0
                v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = alpha_frot_vect
                      
             elseif (  v_sdcont_cyceta(4*(i_cont_poin-1)+3) .eq. 12   ) then  
           
                alpha_frot_matr = 0.5
                v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = alpha_frot_matr            
                alpha_frot_vect = 1.0
                v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = alpha_frot_vect
                      
                      
             elseif (  v_sdcont_cyceta(4*(i_cont_poin-1)+3) .eq. 13   ) then  
           
                alpha_frot_matr = 0.5
                v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = alpha_frot_matr            
                alpha_frot_vect = 1.0
                v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = alpha_frot_vect
                
             endif
         endif    
         
       else 
          v_sdcont_cychis(n_cychis*(i_cont_poin-1)+50) = 0.0d0
          v_sdcont_cychis(n_cychis*(i_cont_poin-1)+54) = 1.0
          v_sdcont_cychis(n_cychis*(i_cont_poin-1)+55) = 1.0
       endif

! WARNING CYCLAGE FROTTEMENT: END
! - Convergence ?
!
    mmcvca =  indi_cont_prev .eq. indi_cont_curr
    if (.not. mmcvca .and. treatment) then
!         write (6,*) "point traite ", (.not. mmcvca .and. treatment), i_cont_poin
        mode_cycl = 1
        if (mode_cycl .eq. 1 .and. &
            ds_contact%iteration_newton .gt. ds_contact%it_cycl_maxi+3 ) then 
            ! On fait la projection sur le cône négatif des valeurs admissibles
             if (dist_cont_curr .gt. 1.d-6 )  dist_cont_curr = 0.0
             if (pres_cont_curr .gt. 1.d-6 )  pres_cont_curr = -1.d-15
             if (dist_cont_prev .gt. 1.d-6 )  dist_cont_prev = 0.0
             if (pres_cont_prev .gt. 1.d-6 )  pres_cont_prev = -1.d-15
             if (i_reso_cont .ne. 0) then
                 call mmstac(dist_cont_curr, pres_cont_curr,coefficient,indi_cont_curr)
                 call mmstac(dist_cont_prev, pres_cont_prev,coefficient,indi_cont_prev)
                 v_sdcont_cychis(n_cychis*(i_cont_poin-1)+1)    = indi_cont_curr
                 v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+1) = indi_cont_prev
             endif       
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+3)    = pres_cont_curr
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+3) = pres_cont_prev
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+4)    = dist_cont_curr
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+4) = dist_cont_prev      
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+57) = 1.0
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+59) = 0.999
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+56) = 1.0
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+51) = 4.0
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+52) = 4.0
             v_sdcont_cyceta(4*(i_cont_poin-1)+1)   = 10
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2)    = 1.d2
             v_sdcont_cychis(n_cychis*(i_cont_poin-1)+24+2) = 1.d2
             mmcvca =  indi_cont_prev .eq. indi_cont_curr
        endif
!         write (6,*) "pres_cont_curr",pres_cont_curr
!         write (6,*) "pres_cont_prev",pres_cont_prev
!         write (6,*) "F_refe",F_refe
!        ctcsta  = ctcsta + 1
    endif
    
!     nb_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC')
!     if ((abs(ds_contact%cont_pressure) .lt. 1.d-15) .or. (ds_contact%iteration_newton .eq. 1)) then 
!         F_refe = nb_cont_poin* (ds_contact%arete_max/ds_contact%arete_min)*ds_contact%arete_max
!     else 
!         F_refe = abs(ds_contact%cont_pressure)
!     endif
! !On verifie que le point est stabilise en pression, suivant le cas
! !     if ((indi_cont_curr .eq. 1) .and. (indi_cont_prev .eq. 1)) resi_press_curr = abs(pres_cont_curr-pres_cont_prev)/F_refe
! !     if ((indi_cont_curr .eq. 1) .and. (indi_cont_prev .eq. 0)) resi_press_curr = abs(pres_cont_curr)/F_refe
! !     if ((indi_cont_curr .eq. 0) .and. (indi_cont_prev .eq. 1)) resi_press_curr = 1.d-100
! !     if ((indi_cont_curr .eq. 0) .and. (indi_cont_prev .eq. 0)) resi_press_curr = 1.d-100
!     if (indi_cont_curr .eq. 1 ) then 
!         resi_press_curr = abs(abs(pres_cont_curr)-abs(pres_cont_prev))/F_refe
!     else 
!         resi_press_curr = 1.d-100
!     endif
!     if (resi_press_curr .gt. ds_contact%resi_pressure)    ds_contact%resi_pressure = resi_press_curr
! !     write (6,*) ds_contact%resi_pressure,pres_cont_curr,pres_cont_prev,F_refe,ds_contact%cont_pressure
! !     if ( (mmcvca .and. (ds_contact%resi_pressure .gt. 1.d-6*abs(ds_contact%cont_pressure)) .and. indi_cont_curr .eq. 1 )) then 
! ! !         write (6,*) "ds_contact%resi_pressure", ds_contact%resi_pressure
! !         mmcvca = .false.
! !     endif
!     if ((.not. mmcvca) .and. (resi_press_curr .lt.1.d-6*abs(ds_contact%cont_pressure)) .and. (ds_contact%iteration_newton .gt. 1) ) then 
!         mmcvca = .true.
!         ctcsta = ctcsta+1 
!     endif
    if (.not. mmcvca ) ctcsta = ctcsta+1
!     911 continue
    mmcvca = mmcvca .and. (ctcsta .eq. 0) 
!
!  Algorithm of Bussetta
!  
    if ((type_adap .eq. 2) .or. (type_adap .eq. 3) .or. &
        (type_adap .eq. 6) .or. (type_adap .eq. 7)) then
        
            coef_bussetta = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2)
            coef_tmp = v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2)
            
            if (indi_cont_curr .eq. 1 .and. l_pena_cont) then
                if (nint(vale_pene) .eq. -1) then 
                ! Mode relatif 
                    dist_max = 1.d-2*ds_contact%arete_min
                else
                ! Mode absolu
                    dist_max = vale_pene
                endif
            
                mmcvca = mmcvca .and. (ctcsta .eq. 0)
                call bussetta_algorithm(dist_cont_curr, dist_cont_prev,dist_max, coef_bussetta)
                v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2) = max(coef_bussetta,&
                                                        v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2))
            !endif
                                                    
            ! Traitement de fortes interpenetrations         
            !if (indi_cont_curr .eq. 1 .and. l_pena_cont) then            
                    
                if (dist_cont_curr .gt. dist_max) then 
                    coef_tmp =coef_tmp*(abs(dist_cont_curr)/dist_max)*100
                    call bussetta_algorithm(dist_cont_curr, dist_cont_prev,dist_max, coef_bussetta)
                    if (coef_bussetta .lt. coef_tmp) coef_bussetta = coef_tmp
                    ! On approche de la fin des iterations de Newton mais penetration pas satisfait
                    ! Le calcul du coefficient n'est pas satisfaisant on l'augmente
                    if (nint(ds_contact%continue_pene) .eq. 1) coef_bussetta = coef_bussetta*10
                    if (coef_bussetta .gt. ds_contact%max_coefficient)  then
                        coef_bussetta = coef_bussetta *0.1
                        ! critere trop severe : risque de non convergence
                        ds_contact%continue_pene = 2.0
                    endif
                    v_sdcont_cychis(n_cychis*(i_cont_poin-1)+2) = coef_bussetta
                    ! critere trop lache
                    if (dist_max .gt. ds_contact%arete_min) &
                        ds_contact%continue_pene = 1.0
                endif
            endif
       ! cas ALGO_CONT=PENALISATION, ALGO_FROT=STANDARD
       ! On fixe un statut adherent en cas de fortes interpenetration
       if ((.not. l_pena_frot .and. l_pena_cont ).and. indi_cont_curr .eq. 1) then 
           if ((dist_cont_curr .gt. dist_max) .and. (indi_frot_curr .eq. 0.)&
                .and. (norm2(dist_frot_curr) .lt. 0.01*dist_max)) then 
               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+5)  = 2
           endif
       endif
       
       ! cas ALGO_CONT=PENALISATION, ALGO_FROT=PENALISATION
!        if ( indi_cont_curr .eq. 1 .and. l_pena_frot .and. l_pena_cont) then   
!           if (dist_cont_curr .gt. dist_max .and. indi_frot_curr .eq. 0.&
!                .and. (norm2(dist_frot_curr) .lt. 1.d-6*dist_max)) then 
!               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+5)  = 2

!cas 1 : Forte interpenetrations : statut = adherent + recherche du coef_frot_curr optimale
!        Statut doit etre adherent :
!        (Lamba+r*dt).(Lambda+r*dt) < 1
!         On aboutit a une equation du 2nd degre : 
!         Lambda.Lambda+2r*Lambda.dt+r2*dt.dt < 1
!         Discriminant = (2Lambda.dt)**2 - 4(dt.dt)(Lambda*Lambda)
!         Si Discriminant < 0 Alors c'est le pire cas  qui puisse arriver
!         On ne fait rien. On laisse l'algorithme de Newton se débrouiller.
!         Si Discriminant > 0  Alors
!         Pour que l'inequation soit verifiee alors il faut prendre une valeur 
!         legerement inferieure a la racine superieure. coef_frot_curr peut devenir negatif
!         Dans ce dernier cas, cela veut dire qu'on a calculer un glissement dans une mauvaise
!         direction tangentielle : coef_frot_curr*dist_frot_curr
!                a = proscal(3,dist_frot_curr,dist_frot_curr)
!                b = 2*proscal(3,pres_frot_curr,dist_frot_curr)
!                c = proscal(3,pres_frot_curr,pres_frot_curr)
!                discriminant = b**2 -4.0*a*c
!                if (discriminant .gt. 0.0d0) then
!                    racine1 = (-b - sqrt(discriminant))/(2*a)
!                    racine2 = (-b + sqrt(discriminant))/(2*a)
!                    racinesup =racine2 
!                    if (racine1 .gt. racine2) racinesup = racine1 
!                else
!                    racinesup = ds_contact%estimated_coefficient**0.2
!                endif               
                
!                if (racinesup .gt. 0.0) then 
!                    coef_frot_curr = 0.99*racinesup
!                else
!                    coef_frot_curr = coef_frot_curr*norm2(dist_frot_curr) / dist_max 
!                endif
!                if (i_cont_poin .eq. 1) &
!                   write (6,*) "coef_frott gliss",coef_frot_curr, i_cont_poin  
!            endif    
                
                
!            if (indi_frot_curr .eq. 1 .and. norm2(dist_frot_curr) .gt. 1.d-6*dist_max) then
!               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+5)  = 1
!                coef_frot_curr = coef_frot_curr*norm2(dist_frot_curr) / dist_max 
                
!                if (i_cont_poin .eq. 1) &
!                write (6,*) "coef_frott adhe",coef_frot_curr, i_cont_poin
!            elseif  (indi_frot_curr .eq. 0 .and. dist_cont_curr .gt. dist_max ) then
!               v_sdcont_cychis(n_cychis*(i_cont_poin-1)+5)  = 1
!                coef_frot_curr = coef_frot_curr*norm2(dist_frot_curr) / dist_max 
!                if (i_cont_poin .eq. 1) &
!                 write (6,*) "coef_frott gliss",coef_frot_curr, i_cont_poin          
!            endif
!            v_sdcont_cychis(n_cychis*(i_cont_poin-1)+6)  = coef_frot_curr
!        endif
    endif
end subroutine
