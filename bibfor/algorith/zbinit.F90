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

subroutine zbinit(f0, coef, dimmem, mem)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    integer :: dimmem
    real(kind=8) :: f0, coef, mem(2, dimmem)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
!
! INITIALISATION DU COMMON
!
! ----------------------------------------------------------------------
!
!
! IN  F0     : VALEUR DE LA FONCTION EN X0
! IN  COEF   : COEFFICIENT D'AMPLIFICATION POUR LA RECHERCHE DE BORNE
! IN  DIMMEM : NOMBRE MAX DE COUPLES MEMORISES
! IN  MEM    : COUPLES MEMORISES
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
    if (f0 .gt. 0) then
        ASSERT(.false.)
    endif
    parmul = coef
    dimcpl = dimmem
    mem(1,1) = 0.d0
    mem(2,1) = f0
    nbcpl = 1
    bpos = .false.
    rhoneg = 0.d0
    fneg = f0
    lopti = .false.
!
end subroutine
