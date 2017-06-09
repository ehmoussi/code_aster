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

subroutine affdis(ndim, irep, eta, car, val,&
                  jdc, jdv, ivr, iv, kma,&
                  ncmp, ntp, jdcinf, jdvinf, isym )
!
!
! --------------------------------------------------------------------------------------------------
!
!           Affectation des valeurs des matrices à tous les éléments
!           demandés par l'utilisateur dans les cartes correspondantes
!           les éléments concernés sont les éléments discrets 2D et 3D
!
! --------------------------------------------------------------------------------------------------
implicit   none
!
    integer :: ndim, irep, jdv(3), jdc(3), ivr(*), iv, ncmp, ntp
    integer :: isym, jdcinf, jdvinf
    real(kind=8) :: eta, val(*)
    character(len=1) :: kma(3)
    character(len=*) :: car
!
#include "asterfort/afdi2d.h"
#include "asterfort/afdi3d.h"
!
! --------------------------------------------------------------------------------------------------
!
    if (ndim .eq. 2) then
        call afdi2d(irep, eta, car, val, jdc,&
                    jdv, ivr, iv, kma, ncmp,&
                    ntp, jdcinf, jdvinf, isym)
    else if (ndim.eq.3) then
        call afdi3d(irep, eta, car, val, jdc,&
                    jdv, ivr, iv, kma, ncmp,&
                    ntp, jdcinf, jdvinf, isym)
    endif
!
end subroutine
