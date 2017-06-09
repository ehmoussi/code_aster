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

subroutine dfplgl(nmnbn, nmplas, nmdpla, bend, dfpl)
!
    implicit none
!
!     CALCUL LE GRADIENT DU CRITERE DE PLASICITE
!
! IN  NMNBN : FORCE - BACKFORCE
! IN  NMPLAS : MOMENTS LIMITES DE PLASTICITE
! IN  NMDPLA : DERIVEES DES MOMENTS LIMITES DE PLASTICITE
! IN  BEND : FLEXION POSITIVE (1) OU NEGATIVE (2)
!
! OUT DFPL : GRADIENT DU CRITERE DE PLASICITE
!
!
    integer :: bend
!
    real(kind=8) :: dfpl(*), nmnbn(6), nmplas(2, 3), nmdpla(2, 2)
!
    dfpl(4) = -(nmnbn(5)-nmplas(bend,2))
    dfpl(5) = -(nmnbn(4)-nmplas(bend,1))
    dfpl(6) = 2.d0*nmnbn(6)
    dfpl(1) = -nmdpla(bend,1)*dfpl(4)
    dfpl(2) = -nmdpla(bend,2)*dfpl(5)
    dfpl(3) = 0.d0*nmnbn(6)
!
end subroutine
