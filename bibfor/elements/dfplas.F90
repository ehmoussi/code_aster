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

subroutine dfplas(mom, plamom, df)
    implicit none
    real(kind=8) :: df(3), mom(3), plamom(3)
!     BUT : CALCUL DU GRADIENT DE LA FONCTION SEUIL
!
! IN  R  MOM     : MOMENT - MOMENT DE RAPPEL (M-BACKM)
!     R  PLASMO  : MOMENTS LIMITES ELASTIQUES DANS LE REPERE ORTHOTROPE
!
! OUT R  DF      : GRADIENT DE LA FONCTION SEUIL
!-----------------------------------------------------------------------
!
    df(1)=-(mom(2)-plamom(2))
    df(2)=-(mom(1)-plamom(1))
    df(3)=2.d0*mom(3)
!
end subroutine
