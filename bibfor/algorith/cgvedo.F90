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

subroutine cgvedo(ndim, option)
    implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
    integer :: ndim
    character(len=16) :: option
!
! person_in_charge: samuel.geniaut at edf.fr
!
!      SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!      BUT : VERIFICATION DE LA COMPATIBILITE ENTRE NDIM ET OPTION
!
!  IN :
!     NDIM   : DIMENSION DU PROBLEME
!     OPTION : OPTION DE CALC_G
! ======================================================================
!
    integer :: nbop3d, i
    parameter   (nbop3d=1)
    aster_logical :: bool
    character(len=16) :: liop3d(nbop3d)
    data         liop3d / 'CALC_G_GLOB'/
!
!     VERIFICATION DE NDIM VAUT 2 OU 3
    if (.not.(ndim.eq.2.or.ndim.eq.3)) then
        call utmess('F', 'RUPTURE0_2')
    endif
!
!     VERIFICATION DE L'OPTION (NORMALEMENT, C'EST FAIT DANS LE CAPY)
    bool = option .eq. 'CALC_G' .or. option .eq. 'CALC_G_GLOB' .or. option .eq. 'CALC_K_G' .or.&
           option .eq. 'K_G_MODA' .or. option .eq. 'CALC_GTP'
    ASSERT(bool)
!
!     CERTAINES OPTIONS NE S'UTILISENT (OU NE SONT PROGRAMMEES) QU'EN 3D
    if (ndim .eq. 2) then
        do i = 1, nbop3d
            if (option .eq. liop3d(i)) then
                call utmess('F', 'RUPTURE0_3', sk=option)
            endif
        enddo
    endif
!
end subroutine
