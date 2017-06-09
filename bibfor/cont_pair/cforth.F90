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

subroutine cforth(ndimg, tau1, tau2, iret)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "asterc/r8prem.h"
#include "asterfort/mmmron.h"
#include "asterfort/mmnorm.h"
#include "asterfort/mmtann.h"
    integer :: ndimg
    real(kind=8) :: tau1(3), tau2(3)
    integer :: iret
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - APPARIEMENT )
!
! ORTHOGONALISATION DES VECTEURS TANGENTS
!
! ----------------------------------------------------------------------
!
!
! IN  NDIMG  : DIMENSION DU MODELE
! I/O TAU1   : PREMIERE TANGENTE SUR LA MAILLE MAITRE EN KSI1
! I/O TAU2   : SECONDE TANGENTE SUR LA MAILLE MAITRE EN KSI2
! OUT IRET   : VAUT 1 SI TANGENTES NULLES
!                   2 SI NORMALE NULLE
!
!  NB: LE REPERE EST ORTHORNORME ET TEL QUE LA NORMALE POINTE VERS
!  L'INTERIEUR DE LA MAILLE
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: norm(3), noor
!
! ----------------------------------------------------------------------
!
!
! --- NORMALISATION DES VECTEURS TANGENTS
!
    call mmtann(ndimg, tau1, tau2, iret)
!
! --- ORTHOGONALISATION VECTEURS TANGENTS
!
    if (iret .eq. 0) then
        call mmnorm(ndimg, tau1, tau2, norm, noor)
        if (noor .le. r8prem()) then
            iret = 2
            goto 99
        else
            call mmmron(ndimg, norm, tau1, tau2)
        endif
    endif
!
! --- NORMALISATION
!
    call mmtann(ndimg, tau1, tau2, iret)
!
99  continue
!
end subroutine
