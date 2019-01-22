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
subroutine gapint(elem_dime     , l_axis          ,&
                  elem_slav_code, elem_slav_nbnode, elem_slav_coor , elem_slav_coorN,&
                  elem_mast_code, elem_mast_nbnode, elem_mast_coorN,&
                  nb_poin_inte  , poin_inte       , poin_gaus_ma  ,&
                  gap_moy       , inte_weight)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jecrec.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/jedetr.h"
#include "asterfort/wkvect.h"
#include "asterfort/lctria.h"
#include "asterfort/apdist.h"
#include "asterfort/reerel.h"
#include "asterfort/lcptga.h"
#include "asterfort/mmnorm.h"
#include "asterfort/mmdonf.h"
#include "asterfort/mmnonf.h"
#include "asterfort/mmmjac.h"
#include "asterfort/mmtang.h"
!
integer, intent(in) :: elem_dime
aster_logical, intent(in) :: l_axis
character(len=8), intent(in) :: elem_slav_code
integer, intent(in) :: elem_slav_nbnode
real(kind=8), intent(in) :: elem_slav_coor(3,elem_slav_nbnode)
real(kind=8), intent(in) :: elem_slav_coorN(3,elem_slav_nbnode)
character(len=8), intent(in) :: elem_mast_code
integer, intent(in) :: elem_mast_nbnode
real(kind=8), intent(in) :: elem_mast_coorN(3,elem_mast_nbnode)
integer, intent(in) :: nb_poin_inte
real(kind=8), intent(in) :: poin_inte(elem_dime-1,nb_poin_inte)
real(kind=8), intent(in) :: poin_gaus_ma(elem_dime-1,36)
real(kind=8), intent(out) :: gap_moy
real(kind=8), intent(out) :: inte_weight
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Compute mean square gap and weight of intersection
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  l_axis           : .true. for axisymmetric element
! In  elem_slav_code   : code of slave element
! In  elem_slav_nbnode : number of nodes of slave element
! In  elem_slav_coor   : coordinates of slave element (on old geometry)
! In  elem_slav_coorN  : coordinates of slave element (on new geometry)
! In  elem_mast_code   : code of master element
! In  elem_mast_nbnode : number of nodes of master element
! In  elem_mast_coorN  : coordinates of master element (on new geometry)
! In  nb_poin_inte     : number of intersection points
! In  poin_inte        : list (sorted) of intersection points
! In  poin_gaus_ma     : coordinates of Gauss point in master element
! Out gap moy          : mean square gap
! Out inte_weight      : total weight of intersection
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_tria, i_gauss, nb_tria, nb_gauss, i_node, i_dime, nb_gaus_tot
    real(kind=8) :: tria_coor(2,3),gauss_weight(12), gauss_coor(2,12), dist_sign
    real(kind=8) :: jaco_weight, dire_norm(3), dist, vect_pm(3)
    real(kind=8) :: tau1(3), tau2(3), ksi1, ksi2, jacobian, sig
    integer :: tria_node(6,3)
    character(len=8) :: gauss_family
    real(kind=8) :: shape_func(9), shape_dfunc(2, 9)
    real(kind=8) :: gauss_coot(2)
    real(kind=8) :: elem_slav_cootN(27), gauss_coouN(3)
!
! --------------------------------------------------------------------------------------------------
!
    gap_moy     = 0.d0
    inte_weight = 0.d0
    shape_func(:)    = 0.d0
    shape_dfunc(:,:) = 0.d0
!
! - Transform the format of slave element coordinates
!
    do i_node = 1,elem_slav_nbnode
        do i_dime = 1, elem_dime
            elem_slav_cootN(elem_dime*(i_node-1)+i_dime) = &
                elem_slav_coorN(i_dime, i_node)
        end do
    end do
!
! - Triangulation of convex polygon defined by intersection points
!
    if (elem_dime .eq. 3) then
        call lctria(nb_poin_inte, nb_tria, tria_node)
    else
        nb_tria = 1
    end if
!
! - Loop on triangles
!
    nb_gaus_tot = 0
    do i_tria = 1, nb_tria
!
! ----- Get coordinates of triangles (parametric slave space)
!
        if (elem_dime .eq. 3) then
            tria_coor(1,1) = poin_inte(1,tria_node(i_tria,1))
            tria_coor(2,1) = poin_inte(2,tria_node(i_tria,1))
            tria_coor(1,2) = poin_inte(1,tria_node(i_tria,2))
            tria_coor(2,2) = poin_inte(2,tria_node(i_tria,2))
            tria_coor(1,3) = poin_inte(1,tria_node(i_tria,3))
            tria_coor(2,3) = poin_inte(2,tria_node(i_tria,3))
            gauss_family   = 'FPG6'
        else
            tria_coor(1,1) = poin_inte(1,1)
            tria_coor(2,1) = 0.d0
            tria_coor(1,2) = poin_inte(1,2)
            tria_coor(2,2) = 0.d0
            gauss_family   = 'FPG3'
        end if
!
! ----- Get integration scheme
!
        call lcptga(elem_dime, tria_coor , gauss_family,&
                    nb_gauss , gauss_coor, gauss_weight)
!
! ----- Loop on Gauss points
!
        do i_gauss = 1, nb_gauss
!
            jacobian         = 0.d0
            dist             = 0.d0
            dire_norm(1:3)   = 0.d0
            gauss_coouN(1:3) = 0.d0
            gauss_coot(1:2)  = 0.d0
            tau1(:)          = 0.d0
            tau2(:)          = 0.d0
            ksi1             = 0.d0
            ksi2             = 0.d0
! --------- Transform the format of Gauss coordinates
            gauss_coot(1)  = gauss_coor(1, i_gauss)
            if (elem_dime .eq. 3) then
                gauss_coot(2) = gauss_coor(2, i_gauss)
            end if
! --------- Get shape functions and first derivative
            call mmnonf(elem_dime    , elem_slav_nbnode, elem_slav_code,&
                        gauss_coot(1), gauss_coot(2),&
                        shape_func )
            call mmdonf(elem_dime    , elem_slav_nbnode, elem_slav_code,&
                        gauss_coot(1), gauss_coot(2),&
                        shape_dfunc)
! --------- Transfert Gauss coordinates in real space (new geometry)
            call reerel(elem_slav_code, elem_slav_nbnode, elem_dime, elem_slav_cootN,&
                        gauss_coot    , gauss_coouN)
! --------- Compute jacobian (on old geometry)
            call mmmjac(l_axis        , elem_slav_nbnode, elem_dime,&
                        elem_slav_code, elem_slav_coor  ,&
                        shape_func    , shape_dfunc     ,&
                        jacobian)
            jaco_weight = gauss_weight(i_gauss)*jacobian
! --------- Compute normal and tangents at integration point (on new geometry)
            call mmtang(elem_dime, elem_slav_nbnode, elem_slav_coorN, shape_dfunc,&
                        tau1     , tau2)
            call mmnorm(elem_dime, tau1, tau2, dire_norm)
            dire_norm = -dire_norm
! --------- Compute distance from point to its orthogonal projection (on new geometry)
            ksi1 = poin_gaus_ma(1, nb_gaus_tot+i_gauss)
            if (elem_dime .eq. 3) then
                ksi2 = poin_gaus_ma(2, nb_gaus_tot+i_gauss)
            end if
            call apdist(elem_mast_code, elem_mast_coorN, elem_mast_nbnode, ksi1, ksi2,&
                        gauss_coouN   , dist           , vect_pm)
            if (elem_dime .eq. 3) then
                sig = vect_pm(1)*dire_norm(1)+vect_pm(2)*dire_norm(2)+vect_pm(3)*dire_norm(3)
            elseif (elem_dime .eq. 2) then
                sig = vect_pm(1)*dire_norm(1)+vect_pm(2)*dire_norm(2)
            else
                ASSERT(ASTER_FALSE)
            end if
            dist_sign = -sign(dist,sig)
            !if (abs(dist_sign) .le. 0.1) then
            !    WRITE(6,*) 'SIGNE: ',sig
            !endif
! --------- Total integration weight and mean square gap
            gap_moy     = gap_moy+jaco_weight*dist_sign
            inte_weight = inte_weight+jaco_weight
        enddo
        nb_gaus_tot = nb_gaus_tot + nb_gauss
    enddo

end subroutine
