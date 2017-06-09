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

!
!
#include "asterf_types.h"
!
interface
    subroutine mmtanr(mesh, model_ndim, ds_contact, i_zone,&
                      lexfro, node_slav_indx, ksi1, ksi2, elem_mast_indx,&
                      elem_mast_nume, tau1m, tau2m, tau1, tau2)
        use NonLin_Datastructure_type
        character(len=8) :: mesh
        integer :: i_zone
        integer :: model_ndim
        integer :: node_slav_indx, elem_mast_indx, elem_mast_nume
        real(kind=8) :: ksi1, ksi2
        type(NL_DS_Contact), intent(in) :: ds_contact
        real(kind=8) :: tau1m(3), tau2m(3)
        real(kind=8) :: tau1(3), tau2(3)
        aster_logical :: lexfro
    end subroutine mmtanr
end interface
