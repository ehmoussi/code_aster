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

subroutine lclaze(elem_dime, nb_lagr, nb_node_slav, indi_lagc,&
                  mmat)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: elem_dime
    integer, intent(in) :: nb_node_slav
    integer, intent(in) :: nb_lagr
    integer, intent(in) :: indi_lagc(10)
    real(kind=8), intent(inout) :: mmat(55,55)
!
! --------------------------------------------------------------------------------------------------
!
! Contact (LAC) - Elementary computations
!
! Compute contact matrix (no contact)
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  nb_node_slav     : number of nodes of for slave side from contact element
! In  nb_lagr          : total number of Lagrangian dof on contact element
! In  indi_lagc        : PREVIOUS node where Lagrangian dof is present (1) or not (0)
! IO  mmat             : matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node_slav, indlgc ,shift
    real(kind=8) :: r_nb_lagr
!
! --------------------------------------------------------------------------------------------------
!
    shift     = 0
    r_nb_lagr = real(nb_lagr,kind=8)
    do i_node_slav = 1, nb_node_slav
        shift=shift+indi_lagc(i_node_slav)     
        if (indi_lagc(i_node_slav+1) .eq. 1) then
            indlgc=(i_node_slav-1)*elem_dime+shift+elem_dime+1
            mmat(indlgc,indlgc) = 1.d0/(r_nb_lagr)
        end if
    end do
! 
end subroutine
