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

subroutine dfuuss(nmnbn, nmplas, nmdpla, nmprox, bend,&
                  dfuu)
!
    implicit none
!
!
!     CALUL DES DIRECTIONS DE L ECOULEMENT DES DEFORMATIONS PLASTIQUES
!
! IN  NMNBN : FORCE - BACKFORCE
! IN  NMPLAS : MOMENTS LIMITES DE PLASTICITE
! IN  NMDPLA : DERIVEES DES MOMENTS LIMITES DE PLASTICITE
! IN  NMPROX : NMPROX > 0 : NBN DANS ZONE DE CRITIQUE
! IN  BEND : FLEXION POSITIVE (1) OU NEGATIVE (2)
!
! OUT DFUU : DIRECTIONS DE L ECOULEMENT DES DEFORMATIONS PLASTIQUES
!
#include "asterfort/dfplgl.h"
    integer :: bend, nmprox(2)
!
    real(kind=8) :: dfuu(*), nmnbn(6), nmplas(2, 3), nmdpla(2, 2)
!
    if (nmprox(bend) .gt. 0) then
        if (bend .eq. 1) then
            dfuu(1) = -nmdpla(bend,1)
            dfuu(2) = -nmdpla(bend,2)
            dfuu(4) = 1.d0
            dfuu(5) = 1.d0
        else
            dfuu(1) = nmdpla(bend,1)
            dfuu(2) = nmdpla(bend,2)
            dfuu(4) = -1.d0
            dfuu(5) = -1.d0
        endif
!
        dfuu(3) = 0.d0
        dfuu(6) = 0.d0
    else
!
!     CALCUL LE GRADIENT DU CRITERE DE PLASICITE
        call dfplgl(nmnbn, nmplas, nmdpla, bend, dfuu)
!
    endif
!
end subroutine
