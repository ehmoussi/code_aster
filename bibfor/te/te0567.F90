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
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jevech.h"
#include "asterfort/lcelem.h"
#include "asterfort/lcstco.h"
#include "asterfort/lcgeog.h"
#include "asterfort/lcpjit.h"
#include "asterfort/lctria.h"
#include "asterfort/lcptga.h"
#include "asterfort/lctppe.h"
#include "asterfort/lccoes.h"
#include "asterfort/lccoma.h"
#include "asterfort/lclaze.h"
#include "asterfort/lctrco.h"
#include "asterfort/lcrtma.h"
#include "asterfort/mmmtdb.h"
#include "asterfort/apdcma.h"
#include "asterfort/aprtpe.h"
#include "asterf_types.h"
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
    integer :: nb_node_slav, nb_node_mast, nb_lagr, nb_poin_inte, nb_dof, nb_tria, nb_gauss
    integer :: indi_lagc(10)
    integer :: elem_dime
    integer :: jmatt, jv_geom
    integer :: i_tria, i_dime, i_elin_mast, i_elin_slav, i_node, i_gauss
    real(kind=8) :: proj_tole, lagrc,lagrc_prev
    integer :: algo_reso_geom, indi_cont, indi_cont_prev, norm_smooth,norm_smooth_prev
    aster_logical :: l_axis, l_elem_frot, loptf, debug, l_upda_jaco, l_upda_jaco_prev
    real(kind=8) :: norm(3)
    character(len=8) :: elem_slav_code, elem_mast_code
    real(kind=8) :: elem_mast_coor(27),elem_slav_coor(27)
    real(kind=8) :: elem_mast_coop(27),elem_slav_coop(27)
    real(kind=8) :: elin_mast_coor(27)
    integer :: elin_mast_nbsub, elin_mast_sub(2,3), elin_mast_nbnode(2)
    character(len=8) :: elin_mast_code
    real(kind=8) :: elin_slav_coor(27)
    integer :: elin_slav_nbsub, elin_slav_sub(2,3), elin_slav_nbnode(2)
    character(len=8) :: elin_slav_code
    real(kind=8) :: poin_inte(32), tria_coot(2,3), tria_coor(32), tria_coor_aux(32)
    integer :: tria_node(6,3)
    real(kind=8) :: inte_weight
    real(kind=8) :: gauss_weight(12), gauss_coor(2,12), gauss_coot(2)
    character(len=8) :: elga_fami_slav, elga_fami_mast
    real(kind=8) :: poidpg, jacobian
    real(kind=8) :: shape_func(9), shape_dfunc(2, 9)
    real(kind=8) :: mmat(55, 55),mmat_prev(55, 55), mmat_(55,55)
    real(kind=8) :: gap_curr,gap_prev
    real(kind=8) :: mesure,rho_n,eval,mesure_prev,rho_n_prev,eval_prev
    aster_logical :: l_previous
    integer :: jpcf
    real(kind=8) :: alpha
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    mmat(:,:)         = 0.d0
    mmat_prev(:,:)    = 0.d0
    elem_mast_coor(:) = 0.d0
    elem_mast_coop(:) = 0.d0
    elem_slav_coor(:) = 0.d0
    elem_slav_coop(:) = 0.d0
    proj_tole         = 1.d-9
    alpha             = 0.7
    debug             = ASTER_FALSE
    loptf             = nomopt.eq.'RIGI_FROT'
    ASSERT(.not.loptf)
    call jevech('PGEOMER', 'L', jv_geom)
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
    l_previous  = nint(zr(jpcf-1+10 )) .eq. 1
    ! On s'assure que le patch n'a pas change de maille maitre.
    l_previous  = l_previous  .and. (nint(zr(jpcf-1+28 )).eq.1 )

!
! - Get indicators
!
    call lcstco(algo_reso_geom, indi_cont, l_upda_jaco, lagrc,&
                gap_curr, mesure, rho_n, eval, ASTER_FALSE)
!
! - S'il y a du cyclage, on récupère les informations à n-1 :
!
    if (l_previous) then
       call lcstco(algo_reso_geom, indi_cont_prev, l_upda_jaco_prev, lagrc_prev,&
                 gap_prev, mesure_prev, rho_n_prev, eval_prev, l_previous)
    end if
!
! - Compute updated geometry
!
    call lcgeog(elem_dime     , nb_lagr       , indi_lagc ,&
                nb_node_slav  , nb_node_mast  , &
                algo_reso_geom, elem_mast_coor, elem_slav_coor,&
                norm_smooth,ASTER_FALSE)
!    if (l_previous) write(6,*) "cyclage",lagrc,indi_cont

!
! - S'il y a du cyclage, on calcul la géométrie à n-1 :
!
        if (l_previous) then
             call lcgeog(elem_dime     , nb_lagr       , indi_lagc ,&
                nb_node_slav  , nb_node_mast  , &
                algo_reso_geom, elem_mast_coop, elem_slav_coop,&
                norm_smooth_prev, l_previous)
        end if
!
! - Compute matrix
!
    if (indi_cont .eq. 1) then
! ----- Cut elements in linearized sub-elements
        call apdcma(elem_mast_code,&
                    elin_mast_sub, elin_mast_nbnode, elin_mast_nbsub, elin_mast_code)
        call apdcma(elem_slav_code,&
                    elin_slav_sub, elin_slav_nbnode, elin_slav_nbsub, elin_slav_code)
! ----- Loop on linearized slave sub-elements
        do i_elin_slav = 1, elin_slav_nbsub
! --------- Get coordinates for current linearized slave sub-element
            elin_slav_coor(:) = 0.d0
            do i_node = 1, elin_slav_nbnode(i_elin_slav)
                do i_dime = 1, elem_dime
                    elin_slav_coor((i_node-1)*elem_dime+i_dime) = &
                       elem_slav_coor((elin_slav_sub(i_elin_slav,i_node)-1)*elem_dime+i_dime)
                end do
            end do
! --------- Loop on linearized master sub-elements
            do i_elin_mast = 1, elin_mast_nbsub
! ------------- Get coordinates for current linearized master sub-element
                elin_mast_coor(:) = 0.d0
                do i_node = 1, elin_mast_nbnode(i_elin_mast)
                    do i_dime = 1, elem_dime
                        elin_mast_coor((i_node-1)*elem_dime+i_dime) = &
                            elem_mast_coor((elin_mast_sub(i_elin_mast,i_node)-1)*elem_dime+i_dime)
                    end do
                end do
! ------------- Projection/intersection
                call lcpjit(proj_tole                    , elem_dime     ,&
                            elin_mast_nbnode(i_elin_mast), elin_mast_coor, elin_mast_code,&
                            elin_slav_nbnode(i_elin_slav), elin_slav_coor, elin_slav_code,&
                            poin_inte                    , inte_weight   , nb_poin_inte)
                if (debug) then
                    write(*,*) "Intersection - Master: ", 'Mast', i_elin_mast
                    write(*,*) "Intersection - Slave : ", 'Slav', i_elin_slav
                    write(*,*) "Intersection - Poids : ", inte_weight
                    write(*,*) "Intersection - Nb    : ", nb_poin_inte
                    write(*,*) "Intersection - Points: ", poin_inte
                endif
                if (inte_weight .gt. proj_tole) then
! ----------------- Triangulation of convex polygon defined by intersection points
                    if (elem_dime .eq. 3) then
                        call lctria(nb_poin_inte, nb_tria, tria_node)
                    elseif (elem_dime .eq. 2) then
                        nb_tria = 1
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                    if (debug) then
                        write(*,*) "Triangulation: ", nb_poin_inte, nb_tria
                    endif
! ----------------- Loop on triangles
                    do i_tria = 1, nb_tria
! --------------------- Coordinates of current triangle
                        if (elem_dime .eq. 3) then
                            call lctrco(i_tria, tria_node, poin_inte, tria_coor)
                        elseif (elem_dime .eq. 2) then
                            tria_coor(1:32) = poin_inte(1:32)
                        endif
                        if (debug) then
                            write(*,*) "Triangle: ", i_tria, tria_coor
                        endif
                        tria_coor_aux(1:32)=tria_coor(1:32)
! --------------------- Projection from para. space of triangle into sub-element para. space
                        if (elem_slav_code .ne. elin_slav_code ) then
                            call aprtpe(elem_dime     , tria_coor  , 3,&
                                        elem_slav_code, i_elin_slav)
                        endif
! --------------------- Change shape of vector
                        tria_coot(1:2,1:3)=0.d0
                        if (elem_dime .eq. 3) then
                            do i_node = 1,3
                                do i_dime = 1,(elem_dime-1)
                                    tria_coot(i_dime, i_node) = &
                                        tria_coor((i_node-1)*(elem_dime-1)+i_dime)
                                end do
                            end do
                        else
                            tria_coot(1,1) = tria_coor(1)
                            tria_coot(2,1) = 0.d0
                            tria_coot(1,2) = tria_coor(2)
                            tria_coot(2,2) = 0.d0
                        end if
! --------------------- Get integration points for slave element
                        call lcptga(elem_dime, tria_coot , elga_fami_slav,&
                                    nb_gauss , gauss_coor, gauss_weight)
! --------------------- Loop on integration points in slave element
                        do i_gauss = 1, nb_gauss
! ------------------------- Get current integration point
                            gauss_coot(1:2) = 0.d0
                            do i_dime = 1, elem_dime-1
                                gauss_coot(i_dime) = gauss_coor(i_dime, i_gauss)
                            end do
                            poidpg = gauss_weight(i_gauss)
! ------------------------- Compute geometric quantities for contact (slave side)
                            call lctppe('Slave'     , elem_dime     , l_axis        ,&
                                        nb_node_slav, elem_slav_coor, elem_slav_code,&
                                        gauss_coot  , shape_func    , shape_dfunc   ,&
                                        jacobian   , l_upda_jaco    , norm, jv_geom )
! ------------------------- Compute contact matrix (slave side)
                            call lccoes(elem_dime  , nb_node_slav, nb_lagr  ,&
                                        norm_smooth, norm        , indi_lagc,&
                                        poidpg     , shape_func  , jacobian ,&
                                        mmat )
                        end do
! --------------------- Projection of triangle in master parametric space
                        call lcrtma(elem_dime       , proj_tole,&
                                    tria_coor_aux   , &
                                    elin_slav_nbnode(i_elin_slav), elin_slav_coor, elin_slav_code,&
                                    nb_node_mast                 , elem_mast_coor, elem_mast_code,&
                                    tria_coot)
! --------------------- Get integration points for master element
                        call lcptga(elem_dime, tria_coot , elga_fami_mast,&
                                    nb_gauss , gauss_coor, gauss_weight)
! --------------------- Loop on integration points in master element
                        do i_gauss = 1, nb_gauss
! ------------------------- Get current integration point
                            gauss_coot(1:2) = 0.d0
                            do i_dime = 1, elem_dime-1
                                gauss_coot(i_dime) = gauss_coor(i_dime,i_gauss)
                            end do
                            poidpg = gauss_weight(i_gauss)
! ------------------------- Compute geometric quantities for contact (master side)
                            call lctppe('Master'    , elem_dime     , l_axis        ,&
                                        nb_node_mast, elem_mast_coor, elem_mast_code,&
                                        gauss_coot  , shape_func    , shape_dfunc   ,&
                                        jacobian  , l_upda_jaco   , norm, jv_geom ,&
                                        elem_dime*nb_node_slav)
! ------------------------- Compute contact matrix (master side)
                            call lccoma(elem_dime  , nb_node_mast, nb_node_slav, nb_lagr,&
                                        norm_smooth, norm        , indi_lagc   ,&
                                        poidpg     , shape_func  , jacobian    ,&
                                        mmat       )
                       end do
                    end do
                end if
            end do
        end do
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
            count_consi = count_consi+ 1
            alpha = 0.5*(alpha+1)
            mmat_ = alpha*mmat+(1-alpha)*mmat_prev
            if ( norm2(mmat_-mmat) .gt. 1.d-6*norm2(mmat) .and. count_consi .lt. 30 ) goto 50
            mmat = mmat_

        endif

    elseif (indi_cont .eq. 0) then
        call lclaze(elem_dime, nb_lagr, nb_node_slav, indi_lagc,&
                    mmat     )
        if (l_previous) then
! ------------- Cut elements in linearized sub-elements
                call apdcma(elem_mast_code,&
                            elin_mast_sub, elin_mast_nbnode, elin_mast_nbsub, elin_mast_code)
                call apdcma(elem_slav_code,&
                            elin_slav_sub, elin_slav_nbnode, elin_slav_nbsub, elin_slav_code)
! ------------- Loop on linearized slave sub-elements

                do i_elin_slav = 1, elin_slav_nbsub
! ----------------- Get coordinates for current linearized slave sub-element
                    elin_slav_coor(:) = 0.d0
                    do i_node = 1, elin_slav_nbnode(i_elin_slav)
                        do i_dime = 1, elem_dime
                            elin_slav_coor((i_node-1)*elem_dime+i_dime) = &
                               elem_slav_coop((elin_slav_sub(i_elin_slav,i_node)-1)*&
                               elem_dime+i_dime)
                        end do
                    end do
! ----------------- Loop on linearized master sub-elements        

                    do i_elin_mast = 1, elin_mast_nbsub
! --------------------- Get coordinates for current linearized master sub-element
                        elin_mast_coor(:) = 0.d0
                        do i_node = 1, elin_mast_nbnode(i_elin_mast)
                            do i_dime = 1, elem_dime
                                elin_mast_coor((i_node-1)*elem_dime+i_dime) = &
                                    elem_mast_coop((elin_mast_sub(i_elin_mast,i_node)-1)*&
                                    elem_dime+i_dime)
                            end do
                        end do
! --------------------- Projection/intersection
                        call lcpjit(proj_tole                    , elem_dime     ,&
                                    elin_mast_nbnode(i_elin_mast), elin_mast_coor, elin_mast_code,&
                                    elin_slav_nbnode(i_elin_slav), elin_slav_coor, elin_slav_code,&
                                    poin_inte                    , inte_weight   , nb_poin_inte)
                        if (debug) then
                            write(*,*) "Intersection - Master: ", 'Mast', i_elin_mast
                            write(*,*) "Intersection - Slave : ", 'Slav', i_elin_slav
                            write(*,*) "Intersection - Poids : ", inte_weight
                            write(*,*) "Intersection - Nb    : ", nb_poin_inte
                            write(*,*) "Intersection - Points: ", poin_inte
                        endif
                        if (inte_weight .gt. proj_tole) then
! ------------------------- Triangulation of convex polygon defined by intersection points
                            if (elem_dime .eq. 3) then
                                call lctria(nb_poin_inte, nb_tria, tria_node)
                            elseif (elem_dime .eq. 2) then
                                nb_tria = 1
                            else
                                ASSERT(ASTER_FALSE)
                            end if
                            if (debug) then
                                write(*,*) "Triangulation: ", nb_poin_inte, nb_tria
                            endif
! ------------------------- Loop on triangles
                            do i_tria = 1, nb_tria
! ----------------------------- Coordinates of current triangle
                                if (elem_dime .eq. 3) then
                                    call lctrco(i_tria, tria_node, poin_inte, tria_coor)
                                elseif (elem_dime .eq. 2) then
                                    tria_coor(1:32) = poin_inte(1:32)
                                endif
                                if (debug) then
                                    write(*,*) "Triangle: ", i_tria, tria_coor
                                endif
                                tria_coor_aux(1:32)=tria_coor(1:32)
! ----------------------------- Projection from para. space of triangle into sub-element para. space
                                if (elem_slav_code .ne. elin_slav_code ) then
                                    call aprtpe(elem_dime     , tria_coor  , 3,&
                                                elem_slav_code, i_elin_slav)
                                endif
! ----------------------------- Change shape of vector
                                tria_coot(1:2,1:3)=0.d0
                                if (elem_dime .eq. 3) then
                                    do i_node = 1,3
                                        do i_dime = 1,(elem_dime-1)
                                            tria_coot(i_dime, i_node) = &
                                                tria_coor((i_node-1)*(elem_dime-1)+i_dime)
                                        end do
                                    end do
                                else
                                    tria_coot(1,1) = tria_coor(1)
                                    tria_coot(2,1) = 0.d0
                                    tria_coot(1,2) = tria_coor(2)
                                    tria_coot(2,2) = 0.d0
                                end if
! ----------------------------- Get integration points for slave element
                                call lcptga(elem_dime, tria_coot , elga_fami_slav,&
                                            nb_gauss , gauss_coor, gauss_weight)
! ----------------------------- Loop on integration points in slave element
                                do i_gauss = 1, nb_gauss
! --------------------------------- Get current integration point
                                    gauss_coot(1:2) = 0.d0
                                    do i_dime = 1, elem_dime-1
                                        gauss_coot(i_dime) = gauss_coor(i_dime, i_gauss)
                                    end do
                                    poidpg = gauss_weight(i_gauss)
! --------------------------------- Compute geometric quantities for contact (slave side)
                                    call lctppe('Slave'     , elem_dime     , l_axis        ,&
                                                nb_node_slav, elem_slav_coor, elem_slav_code,&
                                                gauss_coot  , shape_func    , shape_dfunc   ,&
                                                jacobian   , l_upda_jaco    , norm, jv_geom )
! --------------------------------- Compute contact matrix (slave side)
                                    call lccoes(elem_dime  , nb_node_slav, nb_lagr  ,&
                                                norm_smooth_prev, norm        , indi_lagc,&
                                                poidpg     , shape_func  , jacobian ,&
                                                mmat_prev )          
                                end do             
! ----------------------------- Projection of triangle in master parametric space
                                call lcrtma(elem_dime       , proj_tole,&
                                            tria_coor_aux   , &
                                            elin_slav_nbnode(i_elin_slav), &
                                            elin_slav_coor, elin_slav_code,&
                                            nb_node_mast                 , &
                                            elem_mast_coor, elem_mast_code,&
                                            tria_coot)
! ----------------------------- Get integration points for master element
                                call lcptga(elem_dime, tria_coot , elga_fami_mast,&
                                            nb_gauss , gauss_coor, gauss_weight)
! ----------------------------- Loop on integration points in master element
                                do i_gauss = 1, nb_gauss
! --------------------------------- Get current integration point
                                    gauss_coot(1:2) = 0.d0
                                    do i_dime = 1, elem_dime-1
                                        gauss_coot(i_dime) = gauss_coor(i_dime,i_gauss)
                                    end do
                                    poidpg = gauss_weight(i_gauss)
! --------------------------------- Compute geometric quantities for contact (master side)
                                    call lctppe('Master'    , elem_dime     , l_axis        ,&
                                                nb_node_mast, elem_mast_coor, elem_mast_code,&
                                                gauss_coot  , shape_func    , shape_dfunc   ,&
                                                jacobian  , l_upda_jaco   , norm, jv_geom ,&
                                                elem_dime*nb_node_slav)
! --------------------------------- Compute contact matrix (master side)
                                    call lccoma(elem_dime  , nb_node_mast, nb_node_slav, nb_lagr,&
                                                norm_smooth, norm        , indi_lagc   ,&
                                                poidpg     , shape_func  , jacobian    ,&
                                                mmat_prev       )
                               end do
                            end do
                        end if
                    end do


                enddo
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
