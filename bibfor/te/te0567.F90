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
subroutine te0567(nomopt, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jevech.h"
#include "asterfort/lcelem.h"
#include "asterfort/lcstco.h"
#include "asterfort/lcgeominit.h"
#include "asterfort/lcnorm_line.h"
#include "asterfort/lcgeog.h"
#include "asterfort/lclaze.h"
#include "asterfort/mmmtdb.h"
#include "asterfort/lcmatr.h"
!
character(len=16), intent(in) :: nomopt
character(len=16), intent(in) :: nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Option: RIGI_CONT
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, ij, count_consi
    integer :: nb_node_slav, nb_node_mast, nb_lagr, nb_dof
    integer :: indi_lagc(10)
    integer :: elem_dime
    integer :: jmatt
    real(kind=8) :: lagrc, lagrc_prev
    integer :: indi_cont
    aster_logical :: l_norm_smooth
    aster_logical :: l_axis, debug, l_upda_jaco
    character(len=8) :: elem_slav_code, elem_mast_code
    real(kind=8) :: elem_mast_coor(27), elem_slav_coor(27)
    real(kind=8) :: elem_mast_init(27), elem_slav_init(27)
    real(kind=8) :: elem_mast_coop(27), elem_slav_coop(27)
    character(len=8) :: elga_fami_slav, elga_fami_mast
    real(kind=8) :: mmat(55, 55), mmat_prev(55, 55), mmat_(55,55)
    real(kind=8) :: gap_curr, gap_prev
    aster_logical :: l_previous
    real(kind=8) :: alpha
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    mmat(1:55,1:55)      = 0.d0
    mmat_prev(1:55,1:55) = 0.d0
    elem_mast_coor(1:27) = 0.d0
    elem_mast_coop(1:27) = 0.d0
    elem_slav_coor(1:27) = 0.d0
    elem_slav_coop(1:27) = 0.d0
    alpha                = 0.7
    debug                = ASTER_FALSE
    ASSERT(nomopt.eq.'RIGI_CONT')
!
! - Get informations about contact element
!
    call lcelem(nomte         , elem_dime     ,&
                l_axis        , &
                nb_dof        , nb_lagr       , indi_lagc   ,&
                elem_slav_code, elga_fami_slav, nb_node_slav,&
                elem_mast_code, elga_fami_mast, nb_node_mast)
    ASSERT(nb_dof .le. 55)
!
! - Get indicators
!
    call lcstco(l_previous, l_upda_jaco  ,&
                lagrc_prev, lagrc        ,&
                gap_prev  , gap_curr     ,&
                indi_cont , l_norm_smooth)
!
! - Get initial coordinates
!
    call lcgeominit(elem_dime     ,&
                    nb_node_slav  , nb_node_mast  ,&
                    elem_mast_init, elem_slav_init)
!
! - Get initial coordinates
!
    call lcgeominit(elem_dime     ,&
                    nb_node_slav  , nb_node_mast  ,&
                    elem_mast_init, elem_slav_init)
!
! - Compute updated geometry
!
    call lcgeog(ASTER_FALSE   ,&
                elem_dime     , nb_lagr       , indi_lagc ,&
                nb_node_slav  , nb_node_mast  ,&
                elem_mast_init, elem_slav_init,&
                elem_mast_coor, elem_slav_coor,&
                l_norm_smooth)

!
! - S'il y a du cyclage, on calcule la géométrie à n-1 :
!
    if (l_previous) then
        call lcgeog(ASTER_TRUE    ,&
                    elem_dime     , nb_lagr       , indi_lagc ,&
                    nb_node_slav  , nb_node_mast  ,&
                    elem_mast_init, elem_slav_init,&
                    elem_mast_coop, elem_slav_coop,&
                    l_norm_smooth)
    end if
!
! - Compute matrix
!
    if (indi_cont .eq. 1) then
        call lcmatr(elem_dime   ,&
                    l_axis      , l_upda_jaco   , l_norm_smooth ,&
                    nb_lagr     , indi_lagc     ,&
                    nb_node_slav, elem_slav_code, elem_slav_init, elga_fami_slav, elem_slav_coor,&
                    nb_node_mast, elem_mast_code, elem_mast_init, elga_fami_mast, elem_mast_coor,&
                    mmat)
        if (l_previous) then
            call lclaze(elem_dime, nb_lagr, nb_node_slav, indi_lagc,&
                        mmat_prev)
            if ((abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr)) .gt. 1.d-6 ) then
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)/&
                        (abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr))
            else
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)
            endif
            count_consi = 0
            50 continue
            count_consi = count_consi + 1
            alpha = 0.5*(alpha+1)
            mmat_ = alpha*mmat+(1-alpha)*mmat_prev
            if ( norm2(mmat_-mmat) .gt. 1.d-6*norm2(mmat) .and. count_consi .lt. 30 ) goto 50
            mmat = mmat_

        endif

    elseif (indi_cont .eq. 0) then
        call lclaze(elem_dime, nb_lagr, nb_node_slav, indi_lagc,&
                    mmat     )
        if (l_previous) then
            call lcmatr(elem_dime   ,&
                        l_axis      , l_upda_jaco   , l_norm_smooth ,&
                        nb_lagr     , indi_lagc     ,&
                      nb_node_slav, elem_slav_code, elem_slav_init, elga_fami_slav, elem_slav_coop,&
                      nb_node_mast, elem_mast_code, elem_mast_init, elga_fami_mast, elem_mast_coop,&
                        mmat_prev)
            if ((abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr)) .gt. 1.d-6 ) then
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)/&
                        (abs(lagrc_prev+100.d0*gap_prev)+abs(lagrc+100.d0*gap_curr))
            else
                alpha = 1.0-abs(lagrc+100.d0*gap_curr)
            endif

            count_consi = 0
            51 continue
            count_consi = count_consi + 1
            alpha = 0.5*(alpha+1.0)
            mmat_ = alpha*mmat+(1-alpha)*mmat_prev

            if ( norm2(mmat_-mmat) .gt. 1.d-6*norm2(mmat) .and. count_consi .lt. 30) goto 51
            mmat = mmat_

        endif

    else
!
    endif
!
! - Write (symmetric matrix)
!
    call jevech('PMATUUR', 'E', jmatt)
    do j = 1, nb_dof
        do i = 1, j
            ij = (j-1)*j/2 + i
            zr(jmatt+ij-1) = mmat(i,j)
            if (debug) then
                call mmmtdb(mmat(i, j), 'IJ', i, j)
            endif
        end do
    end do
!
    call jedema()
end subroutine
