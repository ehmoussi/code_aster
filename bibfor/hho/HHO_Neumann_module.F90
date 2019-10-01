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
! person_in_charge: mickael.abbas at edf.fr
!
module HHO_Neumann_module
!
use HHO_quadrature_module
use HHO_rhs_module
use HHO_type
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/HHO_size_module.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Module to compute the Neumann loads
!
! --------------------------------------------------------------------------------------------------
!
    public :: hhoTherNeumForces, hhoMecaNeumForces
!
contains
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoTherNeumForces(hhoFace, hhoData, hhoQuad, NeumValuesQP, rhs_forces)
!
    implicit none
!
        type(HHO_Face), intent(in)          :: hhoFace
        type(HHO_Data), intent(in)          :: hhoData
        type(HHO_Quadrature), intent(in)    :: hhoQuad
        real(kind=8), intent(in)            :: NeumValuesQP(MAX_QP_FACE)
        real(kind=8), intent(out)           :: rhs_forces(MSIZE_FACE_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the neumann forces for a thermic load (gn, vF)_F
!   In hhoFace      : the current HHO Face
!   In hhoData      : information on HHO methods
!   In hhoQuad      : Quadrature for the face
!   In NeumValuesQP : Values of the Neumann forces at the quadrature points
!   Out rhs_forces  : surface forces (rhs member)
!
! --------------------------------------------------------------------------------------------------
!
        call hhoMakeRhsFaceScal(hhoFace, hhoQuad, NeumValuesQP, hhoData%face_degree(), rhs_forces)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoMecaNeumForces(hhoFace, hhoData, hhoQuad, NeumValuesQP, rhs_forces)
!
    implicit none
!
        type(HHO_Face), intent(in)          :: hhoFace
        type(HHO_Data), intent(in)          :: hhoData
        type(HHO_Quadrature), intent(in)    :: hhoQuad
        real(kind=8), intent(in)            :: NeumValuesQP(3,MAX_QP_FACE)
        real(kind=8), intent(out)           :: rhs_forces(MSIZE_FACE_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the neumann forces for a mecanical load (gn, vF)_F
!   In hhoFace      : the current HHO Face
!   In hhoData      : information on HHO methods
!   In hhoQuad      : Quadrature for the face
!   In NeumValuesQP : Values of the Neumann forces at the quadrature points
!   Out rhs_forces  : surface forces (rhs member)
!
! --------------------------------------------------------------------------------------------------
!
        call hhoMakeRhsFaceVec(hhoFace, hhoQuad, NeumValuesQP, hhoData%face_degree(), rhs_forces)
!
    end subroutine
!
end module
