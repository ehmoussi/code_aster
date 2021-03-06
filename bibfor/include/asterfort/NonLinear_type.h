! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! Indicator to compute nodal field from internal forces
#define PRED_EULER          1
#define CORR_NEWTON         2
#define INTE_FORCE          3
!
! Set to 1 to activate DEBUG
#define NONLINEAR_DEBUG     0
!
! Indicator to combine nodal fields for internal forces
#define INTE_FORCE_NONE     0
#define INTE_FORCE_COMB     1
#define INTE_FORCE_INTE     2
#define INTE_FORCE_FNOD     3
