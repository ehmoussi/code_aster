! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine cgveca(ndim, option, cas)
    implicit none
!
    integer :: ndim
    character(len=16) :: option, cas
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : DETERMINATION DU CAS : 2D, 3D LOCAL OU 3D GLOBAL
!
!  IN :
!    NDIM   : DIMENSION DU PROBLEME
!    OPTION : OPTION DE CALC_G
!  OUT :
!    CAS    : '2D', '3D LOCAL' OU '3D GLOBAL'
! ======================================================================
!
!     DETERMINATION DU CAS : 2D, 3D LOCAL OU 3D GLOBAL
    if (ndim .eq. 3) then
!
        if (option .eq. 'CALC_G_GLOB') then
            cas = '3D_GLOBAL'
        else
            cas = '3D_LOCAL'
        endif
!
    else if (ndim.eq.2) then
!
        cas = '2D'
!
    endif
!
end subroutine
