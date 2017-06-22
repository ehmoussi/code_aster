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
interface
    subroutine afrela(coef_real, coef_cplx, dof_name, node_name, repe_type,&
                      repe_defi, nbterm, vale_real, vale_cplx, vale_func,&
                      type_coef, vale_type, type_lagr, epsi, lisrez)
        integer, intent(in) :: nbterm
        real(kind=8), intent(in) :: coef_real(nbterm)
        complex(kind=8), intent(in) :: coef_cplx(nbterm)
        character(len=8), intent(in) :: dof_name(nbterm)
        character(len=8), intent(in) :: node_name(nbterm)
        integer, intent(in) :: repe_type(nbterm)
        real(kind=8), intent(in) :: repe_defi(3, nbterm)
        real(kind=8), intent(in) :: vale_real
        complex(kind=8), intent(in) :: vale_cplx
        character(len=*), intent(in) :: vale_func
        character(len=4), intent(in) :: type_coef
        character(len=4), intent(in) :: vale_type
        character(len=2), intent(in) :: type_lagr
        real(kind=8), intent(in) :: epsi
        character(len=*), intent(in) :: lisrez
    end subroutine afrela
end interface
