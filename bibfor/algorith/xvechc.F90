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

subroutine xvechc(nnops, pla, ffc, pinf,&
                  pf, psup, jac, vect)
    implicit none   
!
#include "jeveux.h"
!
! ======================================================================
! person_in_charge: daniele.colombo at ifpen.fr
!
!
! ROUTINE MODELE HM-XFEM
! 
! CALCUL DES SECONDS MEMBRES VECT (CONTINUITE DE LA PRESSION)
!
! ----------------------------------------------------------------------
!
    integer :: i, nnops, pli, pla(27)
    real(kind=8) :: ffc(16), pinf, pf, psup, jac
    real(kind=8) :: vect(560), ffi
!   CALCUL DE LA CONTINUITE DE LA PRESSION
    do i = 1, nnops
       pli = pla(i)
       ffi = ffc(i)
!
       vect(pli+1) = vect(pli+1) + ffi*(psup-pf)*jac
!
       vect(pli+2) = vect(pli+2) + ffi*(pinf-pf)*jac
    end do
end subroutine
