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
!
subroutine aprtpm(pair_tole       , elem_dime     , &
                  elem_mast_nbnode, elem_mast_coor, elem_mast_code,&
                  elem_slav_nbnode, elem_slav_coor, elem_slav_code,&
                  poin_inte_sl    , nb_poin_inte  , poin_inte_ma  ,&
                  poin_gaus_ma    , iret)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/reerel.h"
#include "asterfort/assert.h"
#include "asterfort/lctria.h"
#include "asterfort/lcptga.h"
#include "asterfort/mmdonf.h"
#include "asterfort/mmtang.h"
#include "asterfort/mmnorm.h"
#include "asterfort/mmnewd.h"
#include "asterfort/apdist.h"
!

real(kind=8), intent(in) :: pair_tole
integer, intent(in) :: elem_dime
integer, intent(in) :: elem_mast_nbnode
real(kind=8), intent(in) :: elem_mast_coor(3,9)
character(len=8), intent(in) :: elem_mast_code
integer, intent(in) :: elem_slav_nbnode
real(kind=8), intent(in) :: elem_slav_coor(3,9)
character(len=8), intent(in) :: elem_slav_code
integer, intent(in) :: nb_poin_inte
real(kind=8), intent(out) :: poin_inte_ma(elem_dime-1,8)
real(kind=8), intent(out) :: poin_gaus_ma(elem_dime-1,36)
real(kind=8), intent(in) :: poin_inte_sl(elem_dime-1,8)
integer, intent(out) :: iret

!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Projection from slave parametric space to master one
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_poin_inte, nb_poin_gaus
    real(kind=8) :: node_real(3), ksi(2), ksi_ma(2)
    real(kind=8) :: norm(3)
    real(kind=8) :: dff(2, 9)
    integer :: iret_
    real(kind=8) :: tria_coor_es(2,3)
    integer :: i_tria, i_gauss, nb_tria, nb_gauss, i_node, i_dime
    real(kind=8) :: gauss_weight_es(12), gauss_coor_es(2,12)
    real(kind=8) :: gauss_coou(3), dire_norm(3), gauss_coot(2)
    real(kind=8) :: tau1(3), tau2(3), ksi1, ksi2, elem_slav_coot(27)
    integer :: tria_node(6,3)
    character(len=8) :: gauss_family
    real(kind=8) :: shape_dfunc(2, 9)
    aster_logical :: debug

!
! --------------------------------------------------------------------------------------------------
!
    iret = 0
    poin_inte_ma(:,:) = 0.d0
    shape_dfunc(:,:)  = 0.d0
    poin_gaus_ma(:,:) = 0.d0
    debug = ASTER_FALSE
!
! - Transform the format of slave element coordinates
!
    do i_node = 1,elem_slav_nbnode
        do i_dime = 1, elem_dime
            elem_slav_coot(elem_dime*(i_node-1)+i_dime) = &
                elem_slav_coor(i_dime, i_node)
        end do
    end do
!
! - Loop on intersection points
!
    do i_poin_inte = 1, nb_poin_inte
        norm(1:3)      = 0.d0
        tau1(1:3)      = 0.d0
        tau2(1:3)      = 0.d0
        ksi(:)         = 0.d0
        ksi_ma(:)      = 0.d0
        node_real(1:3) = 0.d0
        ksi(1) = poin_inte_sl (1, i_poin_inte)
        if (elem_dime .eq. 3) then
            ksi(2) = poin_inte_sl (2, i_poin_inte)
        endif
!0
! --------- Transfert slave intersection coordinates in real space
!
        call reerel(elem_slav_code, elem_slav_nbnode, elem_dime, elem_slav_coot,&
                    ksi           , node_real)
!
! --------- Compute normal
!
        call mmdonf(elem_dime, elem_slav_nbnode, elem_slav_code,&
                    ksi(1), ksi(2),&
                    dff)
        call mmtang(elem_dime, elem_slav_nbnode, elem_slav_coor, dff, tau1,&
                    tau2)
        call mmnorm(elem_dime, tau1, tau2, norm)

!
! ----- Project in parametric space
!
        call mmnewd(elem_mast_code, elem_mast_nbnode, elem_dime, elem_mast_coor,&
                    node_real     , 100             , pair_tole, norm          ,&
                    ksi_ma(1)     , ksi_ma(2)       , tau1     , tau2          ,&
                    iret_)
        if (iret_.eq. 1) then
            iret = 1
            go to 99
        endif

        poin_inte_ma(1,i_poin_inte) = ksi_ma(1)
        if (elem_dime .eq. 3) then
            poin_inte_ma(2,i_poin_inte) = ksi_ma(2)
        endif
    end do
!
! - Triangulation of convex polygon defined by intersection points
!
    if ((elem_dime-1) .eq. 2) then
        call lctria(nb_poin_inte, nb_tria, tria_node)
    else
        nb_tria = 1
    end if
!
! - Loop on triangles
!
    nb_poin_gaus = 0

    do i_tria=1, nb_tria
!
! ----- Get coordinates of triangles (parametric slave space)
!
        if ((elem_dime-1) .eq. 2) then
            tria_coor_es(1:2,1) = poin_inte_sl(1:2,tria_node(i_tria,1))
            tria_coor_es(1:2,2) = poin_inte_sl(1:2,tria_node(i_tria,2))
            tria_coor_es(1:2,3) = poin_inte_sl(1:2,tria_node(i_tria,3))
            gauss_family         = 'FPG6'
        else
            tria_coor_es(1,1:2) = poin_inte_sl(1,1:2)
            tria_coor_es(2,1:2) = 0.d0
            gauss_family         = 'FPG3'
        end if
!
! ----- Get integration scheme
!
        call lcptga(elem_dime, tria_coor_es , gauss_family,&
                    nb_gauss , gauss_coor_es   , gauss_weight_es)
!
! ----- Loop on Gauss points
!
        do i_gauss = 1, nb_gauss

            dire_norm(1:3)  = 0.d0
            gauss_coou(1:3) = 0.d0
            gauss_coot(1:2) = 0.d0
            tau1(:)         = 0.d0
            tau2(:)         = 0.d0
!
! --------- Transform the format of Gauss coordinates
!
            gauss_coot(1) = gauss_coor_es(1, i_gauss)
            if (elem_dime .eq. 3) then
                gauss_coot(2) = gauss_coor_es(2, i_gauss)
            end if
!
! --------- Transfert Gauss coordinates in real space
!
            call reerel(elem_slav_code, elem_slav_nbnode, elem_dime, elem_slav_coot,&
                        gauss_coot    , gauss_coou)

!
! - Get shape functions and first derivative only (for perf)
!

            call mmdonf(elem_dime    , elem_slav_nbnode      , elem_slav_code,&
                        gauss_coot(1), gauss_coot(2),&
                        shape_dfunc)
!
! - Compute normal at integration point
!
            call mmtang(elem_dime,  elem_slav_nbnode, elem_slav_coor, shape_dfunc,&
                        tau1, tau2)

            call mmnorm(elem_dime, tau1, tau2, dire_norm)

            dire_norm=-dire_norm
!
! --------- Projection along given direction
!
            call mmnewd(elem_mast_code, elem_mast_nbnode, elem_dime, elem_mast_coor,&
                        gauss_coou    , 200             , pair_tole, dire_norm     ,&
                        ksi1          , ksi2            , tau1     , tau2          ,&
                        iret_)
            if (iret_.eq. 1) then
                iret = 1
                go to 99
            endif
            poin_gaus_ma(1,nb_poin_gaus+i_gauss) = ksi1
            if (elem_dime .eq. 3) then
                poin_gaus_ma(2,nb_poin_gaus+i_gauss) = ksi2
            end if
        end do
        nb_poin_gaus = nb_gauss + nb_poin_gaus
    end do
99  continue
    if (debug) then
        ASSERT(iret .eq. 0)
    end if
end subroutine
