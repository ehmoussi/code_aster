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

subroutine zbopti(rho, f, rhoopt, fopt)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
    real(kind=8) :: rho, f, rhoopt, fopt
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
!
! REACTUALISATION DE LA SOLUTION OPTIMALE
!
! ----------------------------------------------------------------------
!
! IN  RHO    : SOLUTION COURANTE
! IN  F      : VALEUR DE LA FONCTION EN RHO
! OUT RHOOPT : SOLUTION OPTIMALE
! I/O FOPT   : VALEUR DE LA FONCTION EN RHOOPT
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: rhoneg, rhopos
    real(kind=8) :: parmul, fneg, fpos
    integer :: dimcpl, nbcpl
    aster_logical :: bpos, lopti
    common /zbpar/ rhoneg,rhopos,&
     &               parmul,fneg  ,fpos  ,&
     &               dimcpl,nbcpl ,bpos  ,lopti
!
! ----------------------------------------------------------------------
!
    if (abs(f) .lt. abs(fopt)) then
        rhoopt = rho
        fopt = f
        lopti = .true.
    endif
!
end subroutine
