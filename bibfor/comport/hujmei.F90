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

subroutine hujmei(vin)
    implicit none
!   ENREGISTREMENT DES VARIABLES MEMOIRE POUR LE MECANISME ISOTROPE
!   IN  MATER  :  COEFFICIENTS MATERIAU A T+DT
!       VIN    :  VARIABLES INTERNES
!       SIG    :  CONTRAINTE
!
!   OUT VIN    :  VARIABLES INTERNES MODIFIEES
!   ------------------------------------------------------------------
    real(kind=8) :: un, zero, vin(*)
! ----------------------------------------------------------------------
    data      zero, un  /0.d0, 1.d0/
!
! ==================================================================
! --- MISE A JOUR DES VARIABLES INTERNES DE MEMOIRE ----------------
! ==================================================================
!
    if (vin(21) .eq. zero) then
        vin(21) = vin(4)
    else
        vin(21)= vin(21)-vin(22)*vin(8)
    endif
!
    if (vin(22) .eq. zero) then
        vin(22) = un
    else
        vin(22) = - vin(22)
    endif
!
end subroutine
