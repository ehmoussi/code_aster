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

subroutine vsols_3d(dssol, dsf, daft, dafm, sc,&
                    phi, sr, dalpha, vsr, ssol)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!      provient de rsi_3d : 
!     Calcul de la vitesse en solution du sulfate dans les csh
!=====================================================================
    implicit none
    real(kind=8) :: dssol
    real(kind=8) :: dsf
    real(kind=8) :: daft
    real(kind=8) :: dafm
    real(kind=8) :: dalpha
    real(kind=8) :: phi
    real(kind=8) :: sr
    real(kind=8) :: sc
    real(kind=8) :: ssol
    real(kind=8) :: vsr
    dssol=(-dsf-3.d0*daft-dafm+sc*dalpha-phi*vsr*ssol)/(phi*sr)
end subroutine
