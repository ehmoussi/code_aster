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

subroutine lcsees(elem_dime    , nb_node_slav    , nb_lagr  ,&
                  l_norm_smooth, norm            , indi_lagc, lagrc,&
                  poidpg       , shape_slav_func , jacobian ,&
                  vtmp )
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
!
integer, intent(in) :: elem_dime
integer, intent(in) :: nb_node_slav
integer, intent(in) :: nb_lagr
aster_logical, intent(in) :: l_norm_smooth
real(kind=8), intent(in) :: norm(3)
integer, intent(in) :: indi_lagc(10)
real(kind=8), intent(in) :: lagrc
real(kind=8), intent(in) :: poidpg
real(kind=8), intent(in) :: shape_slav_func(9)
real(kind=8), intent(in) :: jacobian
real(kind=8), intent(inout) :: vtmp(55)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute contact vector - geometric (slave side)
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  l_norm_smooth    : indicator for normals smoothing
! In  norm             : normal at integration point
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! In  lagrc            : value of contact pressure (lagrangian)
! In  poidspg          : weight at integration point
! In  shape_slav_func  : shape functions at integration point
! in  jacobian         : jacobian at integration point
! IO  vtmp             : vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node_slav, i_dime, jj, shift, jv_norm
    real(kind=8) :: r_nb_lagr
!
! --------------------------------------------------------------------------------------------------
!
    shift      = 0
    jj         = 0
    r_nb_lagr  = real(nb_lagr,kind=8)
!
    if (l_norm_smooth) then
        call jevech('PSNO', 'L', jv_norm)
        do i_node_slav=1, nb_node_slav
            shift=shift+indi_lagc(i_node_slav)
            do i_dime=1, elem_dime
                jj=(i_node_slav-1)*elem_dime+shift+i_dime
                vtmp(jj)= vtmp(jj)+&
                            (zr(jv_norm+(i_node_slav-1)*elem_dime+i_dime-1))*&
                            jacobian*poidpg*shape_slav_func(i_node_slav)*lagrc
            end do
        end do
    else
        do i_node_slav=1, nb_node_slav
            shift=shift+indi_lagc(i_node_slav)
            do i_dime=1, elem_dime
                jj=(i_node_slav-1)*elem_dime+shift+i_dime
                vtmp(jj)= vtmp(jj)+&
                            norm(i_dime)*&
                            jacobian*poidpg*shape_slav_func(i_node_slav)*lagrc
            end do
        end do
    end if
! 
end subroutine
