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
! HHO Size module : Parameters <-> integer definitions
! -------------------------------------------------------------------------
!
! - Static size - HHO methods - General
!
! --- maximum degree of a face
#define MAX_DEGREE_FACE 2
! --- maximum number of a cell
#define MAX_DEGREE_CELL 3

! --- maximum number of face for a cell (6 for a hexahedron)
#define MAX_FACE 6
!
! --- Maximum number of componants for scalar cell function (order=3 and dim=3)
#define MSIZE_CELL_SCAL 20
! --- Maximum number of componants for scalar face function (order=3 and dim=3)
#define MSIZE_FACE_SCAL 10
! --- Maximum number of total dofs for a HHO function (dim=3,  and order=2 for a face)
! --- Max size for a hexahedron:   6 (nb faces) * 6 (face dofs)
#define MSIZE_FDOFS_SCAL 36
! --- Maximum number of total dofs for a HHO function (dim=3, order=3 for a cell
! --- and order=2 for a face)
! --- Max size for a hexahedron:  20 (cell dofs) + 6 (nb faces) * 6 (face dofs)
#define MSIZE_TDOFS_SCAL 56
!
! --- vector function
! --- Maximum number of componants for vector cell function (order=3 and dim=3)
#define MSIZE_CELL_VEC 60
! --- Maximum number of componants for vector face function (order=3 and dim=3)
#define MSIZE_FACE_VEC 30
! --- Maximum number of total dofs for vector faces (dim=3,  and order=2 for a face)
! --- Max size for a hexahedron:   6 (nb faces) * 6 (face dofs)
#define MSIZE_FDOFS_VEC 108
! --- Maximum number of total dofs for a HHO function (dim=3, order=3 for a cell
! --- and order=2 for a face)
! --- Max size for a hexahedron:  60 (cell dofs) + 6 (nb faces) * 18 (face dofs)
#define MSIZE_TDOFS_VEC 168
!
! --- matrix function
! --- Maximum number of componants for matrix cell function (order=3 and dim=3)
#define MSIZE_CELL_MAT 180
!
! --- maximum number of quadrature points
#define MAX_QP 64
! --- maximum number of quadrature points on a face QUAD = 16
#define MAX_QP_FACE 16
! --- maximum number of quadrature points on a cell HEXA = 64
#define MAX_QP_CELL 64
