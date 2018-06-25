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
interface
    subroutine romEvalGappyPOD(ds_para    , result, nb_store, v_matr_phi,&
                               v_coor_redu, ind_dual)
        use Rom_Datastructure_type
        type(ROM_DS_ParaRRC), intent(in) :: ds_para
        character(len=8), intent(in) :: result
        integer, intent(in) :: nb_store
        real(kind=8), pointer :: v_matr_phi(:)
        real(kind=8), pointer :: v_coor_redu(:)
        integer, intent(in) :: ind_dual
    end subroutine romEvalGappyPOD
end interface
