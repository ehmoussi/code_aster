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

subroutine ngfore(w, b, ni2ldc, sref, fref)
!
    implicit none
!
#include "asterfort/ngforc.h"

    real(kind=8),intent(in) :: w(:,:), ni2ldc(:,:), b(:,:,:)
    real(kind=8),intent(in) :: sref(:) 
    real(kind=8) :: fref(*)
! ----------------------------------------------------------------------
!     REFE_FORC_NODA - FORMULATION GENERIQUE
! ----------------------------------------------------------------------
! IN  NDDL    : NOMBRE DE DEGRES DE LIBERTE
! IN  NEPS    : NOMBRE DE COMPOSANTES DE DEFORMATION ET CONTRAINTE
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  W       : POIDS DES POINTS DE GAUSS
! IN  B       : MATRICE CINEMATIQUE : DEFORMATION = B.DDL
! IN  LI2LDC  : CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (RAC2)
! IN  SREF    : CONTRAINTES DE REFERENCE (PAR COMPOSANTE)
! OUT FREF    : FORCES DE REFERENCE
! ----------------------------------------------------------------------
    integer :: sizes(3), neps, npg
! ----------------------------------------------------------------------
!
!    INITIALISATION
    sizes = shape(b)
    neps = sizes(1)
    npg  = sizes(2)
 
    call ngforc(w,abs(b),ni2ldc,transpose(spread(sref(1:neps),1,npg)), &
                fref) 

end subroutine
