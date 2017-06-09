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

function fplass(nmnbn, nmplas, bend)
!
    implicit none
!
!
!     CRITERE DE PLASTICITE
!
! IN  NMNBN : FORCE - BACKFORCE
! IN  NMPLAS : MOMENTS LIMITES DE PLASTICITE
! IN  BEND : SIGNE DE LA FLEXION (1 POSITIVE, 2 NEGATIVE)
!
! OUT FPLASS : CALCUL DES CRITERES DE PLASTICITE F
!
    integer :: bend
!
    real(kind=8) :: fplass, nmnbn(6), nmplas(2, 3)
!
    fplass = - (nmnbn(4)-nmplas(bend,1)) *(nmnbn(5)-nmplas(bend,2)) + nmnbn(6 )**2
!
end function
