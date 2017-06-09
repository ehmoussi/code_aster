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

function dpvpcr(fonecp, seq, i1)
    implicit      none
    integer :: ndt, ndi
    real(kind=8) :: fonecp(3), seq, i1
    real(kind=8) :: dpvpcr
! =====================================================================
! --- MODELE DRUCKER PRAGER VISCOPLASTIQUE - VISC_DRUC_PRAG  ----------
! --- CRITERE ---------------------------------------------------------
! =====================================================================
    real(kind=8) :: alpha, r
! =====================================================================
    common /tdim/   ndt, ndi
! =====================================================================
! --- RECUPERATION DES FONCTIONS D ECROUISSAGE  -----------------------
! =====================================================================
    alpha = fonecp(1)
    r = fonecp(2)
! =====================================================================
! --- CRITERE ---------------------------------------------------------
! =====================================================================
    dpvpcr = seq + alpha * i1 -r
! =====================================================================
end function
