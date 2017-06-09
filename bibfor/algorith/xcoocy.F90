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

subroutine xcoocy(ndim, xg, pfon, p, rg, tg, l_not_zero)
!
! person_in_charge: samuel.geniaut at edf.fr
!
    implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/xnormv.h"
!
    integer :: ndim
    real(kind=8) :: rg, tg, xg(ndim), pfon(ndim)
    real(kind=8) :: p(ndim,ndim)
    aster_logical :: l_not_zero
!
!
!
!     BUT:  CALCUL DES COORDONNEES CYLINDRIQUES EN FOND DE FISSURE
!
!----------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: cosi, og(ndim), sinu, tole
    parameter (tole=1.d-12)
!----------------------------------------------------------------
!
    do i = 1, ndim
      og(i)=xg(i)-pfon(i)
    enddo
    call xnormv(ndim, og, rg)
    cosi=0.d0
    sinu=0.d0
    do i = 1, ndim
      cosi=cosi+p(i,1)*og(i)
      sinu=sinu+p(i,2)*og(i)
    enddo
!    tg=he*abs(atan2(sinu,cosi))
    tg=atan2(sinu,cosi)
!  - CETTE COMPARAISON POURRIE, IL FAUT L AMALIORER:
!      * LA PROBABILITE QUE RG SOIT TRES PETIT EST QUASI NULLE
!      * LE TEST ICI N EST PAS MIS A L ECHELLE
    l_not_zero=.true.
    if (rg .lt. tole) l_not_zero=.false.
!
end subroutine
