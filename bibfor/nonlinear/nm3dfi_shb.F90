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

subroutine nm3dfi_shb(nno, poids, def, sigma, vectu)
implicit none
!
! aslint: disable=W1504
!
    integer, intent(in) :: nno
    real(kind=8), intent(in) :: poids
    real(kind=8), intent(in) :: def(6,nno,3)
    real(kind=8), intent(in) :: sigma(6)
    real(kind=8), intent(inout) :: vectu(3,nno)
!
! Non linear  3D isoparametric elements Force Internal
!
!
! Evaluation of internal forces for 3D isoparametric and solid-shell elements.
!
!
! IN  nno      number of nodes in element
! IN  poids    Gauss point weight
! IN  def        product F . DFF
!                           F is the tensor of gradient transformation
!                           DFF are the shape function derivatives
! IN  sigma    Cauchy stress (with root square 2 for shear components)
! INOUT  vectu     internal forces
!
    integer :: i_node
!
! ......................................................................
!
    do i_node = 1, nno
       vectu(1,i_node) = vectu(1,i_node)+ poids*&
                                          (def(1,i_node,1)*sigma(1)+&
                                           def(2,i_node,1)*sigma(2)+&
                                           def(3,i_node,1)*sigma(3)+&
                                           def(4,i_node,1)*sigma(4)+&
                                           def(5,i_node,1)*sigma(5)+&
                                           def(6,i_node,1)*sigma(6))
       vectu(2,i_node) = vectu(2,i_node)+ poids*&
                                          (def(1,i_node,2)*sigma(1)+&
                                           def(2,i_node,2)*sigma(2)+&
                                           def(3,i_node,2)*sigma(3)+&
                                           def(4,i_node,2)*sigma(4)+&
                                           def(5,i_node,2)*sigma(5)+&
                                           def(6,i_node,2)*sigma(6))
       vectu(3,i_node) = vectu(3,i_node)+ poids*&
                                          (def(1,i_node,3)*sigma(1)+&
                                           def(2,i_node,3)*sigma(2)+&
                                           def(3,i_node,3)*sigma(3)+&
                                           def(4,i_node,3)*sigma(4)+&
                                           def(5,i_node,3)*sigma(5)+&
                                           def(6,i_node,3)*sigma(6))
    end do
!
end subroutine
