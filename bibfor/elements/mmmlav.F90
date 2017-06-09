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

subroutine mmmlav(ldyna,  jeusup, ndexfr)
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
    aster_logical ::  ldyna
    real(kind=8) :: jeusup
    integer :: ndexfr
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! PREPARATION DES CALCULS - LECTURE FONCTIONNALITES AVANCEES
!
! ----------------------------------------------------------------------
!
!
! OUT LDYNA  : .TRUE. SI DYNAMIQUE
! OUT JEUSUP : JEU SUPPLEMENTAIRE PAR DIST_ESCL/DIST_MAIT
! OUT NDEXFR : ENTIER CODE POUR EXCLUSION DIRECTION DE FROTTEMENT
! I/O COEFAC : COEF_AUGM_CONT
! I/O COEFAF : COEF_AUGM_FROT
!
! ----------------------------------------------------------------------
!
    integer :: jpcf
    integer :: iform
    real(kind=8) :: theta, deltat
!
! ----------------------------------------------------------------------
!
    call jevech('PCONFR', 'L', jpcf)
!
! --- RECUPERATION DES DONNEES DU CHAM_ELEM DU CONTACT
!
    jeusup = zr(jpcf-1+14)
    ndexfr = nint(zr(jpcf-1+21))
    iform = nint(zr(jpcf-1+22))
    deltat = zr(jpcf-1+23)
    theta = zr(jpcf-1+24)
!
! --- FONCTIONNALITES ACTIVEES
!
    ldyna = iform.ne.0
!
end subroutine
