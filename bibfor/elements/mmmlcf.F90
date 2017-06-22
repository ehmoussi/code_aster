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

subroutine mmmlcf(coefff, coefac, coefaf, lpenac, lpenaf,&
                  iresof, iresog, lambds, l_previous)
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
    real(kind=8) :: coefac, coefaf
    real(kind=8) :: coefff, lambds
    aster_logical :: lpenac, lpenaf, l_previous
    integer :: iresof, iresog
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! PREPARATION DES CALCULS - RECUPERATION DES COEFFICIENTS
!
! ----------------------------------------------------------------------
!
!
! OUT COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
! OUT COEFAC : COEF_AUGM_CONT
! OUT COEFAF : COEF_AUGM_FROT
! OUT LPENAC : .TRUE. SI CONTACT PENALISE
! OUT LPENAF : .TRUE. SI FROTTEMENT PENALISE
! OUT IRESOF : ALGO. DE RESOLUTION POUR LE FROTTEMENT
!              0 - POINT FIXE
!              1 - NEWTON
! OUT IRESOG : ALGO. DE RESOLUTION POUR LA GEOMETRIE
!              0 - POINT FIXE
!              1 - NEWTON
!
! ----------------------------------------------------------------------
!
    integer :: jpcf
    integer :: ialgoc, ialgof
!
! ----------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
!
! --- RECUPERATION DES DONNEES DU CHAM_ELEM DU CONTACT
!
    coefac = zr(jpcf-1+16)
    coefaf = zr(jpcf-1+19)
    coefff = zr(jpcf-1+20)
    ialgoc = nint(zr(jpcf-1+15))
    ialgof = nint(zr(jpcf-1+18))
    iresof = nint(zr(jpcf-1+17))
    iresog = nint(zr(jpcf-1+25))
    
    if (l_previous) then 
        lambds = zr(jpcf-1+26)
    else 
        lambds = zr(jpcf-1+13)    
    endif
    
!
! --- PENALISATION ?
!
!    lpenac = (ialgoc.eq.3)
    lpenac = (ialgoc.eq.3) .or. &
              nint(zr(jpcf-1+45)) .eq. 4
              
!    lpenaf = (ialgof.eq.3) 
    lpenaf = (ialgof.eq.3) .or. &
             nint(zr(jpcf-1+46)) .eq. 4
             
!
end subroutine
