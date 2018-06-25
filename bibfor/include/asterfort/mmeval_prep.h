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

!
!
#include "asterf_types.h"
! aslint: disable=W1504
!
interface
    subroutine mmeval_prep(mesh   , time_curr  , model_ndim     , ds_contact,&
                            i_zone         ,&
                           ksipc1 , ksipc2     , ksipr1         , ksipr2    ,&
                           tau1   , tau2       ,&
                           elem_slav_indx,  elem_slav_nbno,&
                           elem_slav_type, elem_slav_coor,&
                           elem_mast_nume,&
                           lagr_cont_node,&
                           norm   , &
                           gap    , gap_user,  lagr_cont_poin,&
                        poin_slav_coor, poin_proj_coor)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        real(kind=8), intent(in) :: time_curr
        integer, intent(in) :: model_ndim
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer, intent(in) :: i_zone
        real(kind=8), intent(in) :: ksipc1
        real(kind=8), intent(in) :: ksipc2
        real(kind=8), intent(in) :: ksipr1
        real(kind=8), intent(in) :: ksipr2
        real(kind=8), intent(in) :: tau1(3)
        real(kind=8), intent(in) :: tau2(3)
        integer, intent(in) :: elem_slav_nbno
        integer, intent(in) :: elem_slav_indx
        character(len=8), intent(in) :: elem_slav_type
        real(kind=8), intent(in) :: elem_slav_coor(27)
        integer, intent(in) :: elem_mast_nume
        real(kind=8), intent(in) :: lagr_cont_node(9)
        real(kind=8), intent(out) :: norm(3)
        real(kind=8), intent(out) :: gap
        real(kind=8), intent(out) :: gap_user
        real(kind=8), intent(out) :: lagr_cont_poin
        real(kind=8),intent(out),optional :: poin_slav_coor(3), poin_proj_coor(3)
    end subroutine mmeval_prep
end interface
