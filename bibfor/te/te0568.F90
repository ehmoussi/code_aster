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
subroutine te0568(nomopt, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jevech.h"
#include "asterfort/lcelem.h"
#include "asterfort/lcstco.h"
#include "asterfort/lcgeominit.h"
#include "asterfort/lcgeog.h"
#include "asterfort/lcsena.h"
#include "asterfort/lcvect.h"
!
character(len=16), intent(in) :: nomopt
character(len=16), intent(in) :: nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Option: CHAR_MECA_CONT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    integer :: nb_node_slav, nb_node_mast, nb_lagr, nb_dof
    integer :: indi_lagc(10)
    integer :: elem_dime
    integer :: jvect
    real(kind=8) :: Lagrc, lagrc_prev
    integer :: algo_reso_geom, indi_cont, indi_cont_prev
    aster_logical :: l_norm_smooth
    aster_logical :: l_axis, l_elem_frot, debug, l_upda_jaco
    character(len=8) :: elem_slav_code, elem_mast_code
    real(kind=8) :: elem_mast_coor(27), elem_slav_coor(27)
    real(kind=8) :: elem_mast_init(27), elem_slav_init(27)
    real(kind=8) :: elem_mast_coop(27), elem_slav_coop(27)
    character(len=8) :: elga_fami_slav, elga_fami_mast 
    real(kind=8) :: vtmp(55), vtmp_prev(55), vtmp_(55)
    real(kind=8) :: gap_curr,gap_prev
    real(kind=8) :: mesure, rho_n, eval, mesure_prev, rho_n_prev, eval_prev
    aster_logical :: l_previous
    integer :: jpcf
    real(kind=8) :: alpha, max_value
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    vtmp(1:55)           = 0.d0
    vtmp_prev(1:55)      = 0.d0
    elem_mast_coor(1:27) = 0.d0
    elem_slav_coor(1:27) = 0.d0
    elem_mast_coop(1:27) = 0.d0
    elem_slav_coop(1:27) = 0.d0
    max_value            = 0.5d0
    debug                = ASTER_FALSE
    ASSERT(nomopt.eq.'CHAR_MECA_CONT')
!
! - Get informations about contact element
!
    call lcelem(nomte         , elem_dime     ,&
                l_axis        , l_elem_frot   ,&
                nb_dof        , nb_lagr       , indi_lagc   ,&
                elem_slav_code, elga_fami_slav, nb_node_slav,&
                elem_mast_code, elga_fami_mast, nb_node_mast)
    ASSERT(nb_dof .le. 55)
!
! - Get information about cycling
!
    call jevech('PCONFR', 'L', jpcf)
    l_previous = nint(zr(jpcf-1+10 )).eq.1 

!
! - Get indicators
!
    call lcstco(algo_reso_geom, indi_cont, l_upda_jaco, &
                lagrc         , gap_curr , mesure, rho_n, eval, ASTER_FALSE)
!
! - S'il y a du cyclage, on récupère les informations à n-1 :
!
    if (l_previous) then
       call lcstco(algo_reso_geom, indi_cont_prev, l_upda_jaco, lagrc_prev,&
                   gap_prev, mesure_prev, rho_n_prev, eval_prev, l_previous)
    end if
!
! - Get initial coordinates
!
    call lcgeominit(elem_dime     ,&
                    nb_node_slav  , nb_node_mast  ,&
                    elem_mast_init, elem_slav_init)
!
! - Compute updated geometry
!
    call lcgeog(algo_reso_geom, ASTER_FALSE   ,&
                elem_dime     , nb_lagr       , indi_lagc ,&
                nb_node_slav  , nb_node_mast  ,&
                elem_mast_init, elem_slav_init,&
                elem_mast_coor, elem_slav_coor,&
                l_norm_smooth)
!
! - S'il y a du cyclage, on calcul la géométrie à n-1 :
!
    if (l_previous) then 
        call lcgeog(algo_reso_geom, ASTER_TRUE    ,&
                    elem_dime     , nb_lagr       , indi_lagc ,&
                    nb_node_slav  , nb_node_mast  ,&
                    elem_mast_init, elem_slav_init,&
                    elem_mast_coop, elem_slav_coop,&
                    l_norm_smooth)
    end if
!
! - Compute vector
!
    if (indi_cont .eq. 1) then
        call lcvect(elem_dime   ,&
                    l_axis      , l_upda_jaco   , l_norm_smooth ,&
                    nb_lagr     , indi_lagc     , lagrc         ,&
                    nb_node_slav, elem_slav_code, elem_slav_init, elga_fami_slav, elem_slav_coor,&
                    nb_node_mast, elem_mast_code, elem_mast_init, elga_fami_mast, elem_mast_coor,&
                    vtmp)
        if (l_previous) then 
            call lcsena(elem_dime, nb_lagr, nb_node_slav, indi_lagc, &
                        lagrc_prev    , vtmp_prev)
            if ((abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr)) .gt. 1.d-6 ) then
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)/&
                        (abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr))
            else
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)
            endif
            alpha = max(alpha,max_value)
            52 continue
            alpha = 0.5*(alpha+1.0)
            vtmp_ = alpha*vtmp+(1-alpha)*vtmp_prev
            if ( norm2(vtmp -vtmp) .gt. 1.d-12*norm2(vtmp) ) goto 52

        endif
    elseif (indi_cont .eq. 0) then
        call lcsena(elem_dime, nb_lagr, nb_node_slav, indi_lagc, &
                    lagrc    , vtmp)
        if (l_previous) then 
        call lcvect(elem_dime   ,&
                    l_axis      , l_upda_jaco   , l_norm_smooth ,&
                    nb_lagr     , indi_lagc     , lagrc         ,&
                    nb_node_slav, elem_slav_code, elem_slav_init, elga_fami_slav, elem_slav_coop,&
                    nb_node_mast, elem_mast_code, elem_mast_init, elga_fami_mast, elem_mast_coop,&
                    vtmp_prev)
            if ((abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr)) .gt. 1.d-6 ) then
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)/&
                        (abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr))
            else
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)
            endif
            alpha = max(alpha,max_value)
            51 continue
            alpha = 0.5*(alpha+1.0)
            vtmp_ = alpha*vtmp+(1-alpha)*vtmp_prev
            if ( norm2(vtmp -vtmp) .gt. 1.d-12*norm2(vtmp) ) goto 51
        endif
    else
!
    endif
!
! - Write vector
!
    call jevech('PVECTUR', 'E', jvect)
    do i = 1, nb_dof
        zr(jvect-1+i) = vtmp(i)
    end do
!
    call jedema()
end subroutine
