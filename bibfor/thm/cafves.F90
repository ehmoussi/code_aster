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
!
subroutine cafves(l_matr, maxfa , nface,&
                  fks   , dfks1 , dfks2,&
                  mobfa , dmob1 , dmob2,&
                  dmob1f, dmob2f,&
                  flux  , dflx1 , dflx2)
!
implicit none
!
#include "asterf_types.h"
!
aster_logical, intent(in) :: l_matr
integer, intent(in) :: maxfa, nface
real(kind=8), intent(in) :: fks(maxfa), dfks1(maxfa+1, maxfa), dfks2(maxfa+1, maxfa)
real(kind=8), intent(in) :: mobfa(maxfa), dmob1(maxfa), dmob2(maxfa)
real(kind=8), intent(in) :: dmob1f(maxfa), dmob2f(maxfa)
real(kind=8), intent(inout) :: flux, dflx1(maxfa+1), dflx2(maxfa+1)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Compute total "volumic" flux at current cell
!
! --------------------------------------------------------------------------------------------------
!
! In  l_matr           : flag to compute matrix
! In  maxfa            : maximum number of faces
! In  nface            : number of faces (for finite volume)
! In  fks              : "volumic" flux at current cell
! In  dfks1            : derivative of "volumic" flux by capillary pressure at current cell
! In  dfks2            : derivative of "volumic" flux by gaz pressure at current cell
! In  mobfa            : mobility at current cell
! In  dmob1            : derivative of mobility by capillary pressure at center of cell
! In  dmob2            : derivative of mobility by gaz pressure at center of cell
! In  dmob1f           : derivative of mobility by capillary pressure at current cell
! In  dmob2f           : derivative of mobility by gaz pressure at current cell
! IO  flux             : total "volumic" flux at current cell
! IO  dflx1            : derivative of total "volumic" flux by capillary pressure at current cell
! IO  dflx2            : derivative of total "volumic" flux by gaz pressure at current cell
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifa, jfa
!
! --------------------------------------------------------------------------------------------------
!
    do ifa = 1, nface
        flux = flux +mobfa(ifa) * fks(ifa)
    end do
!
    if (l_matr) then
        do jfa = 1, nface
            dflx1(1) = dflx1(1) + dmob1(jfa) * fks(jfa) + mobfa(jfa) * dfks1(1,jfa)
            dflx2(1) = dflx2(1) + dmob2(jfa) * fks(jfa) + mobfa(jfa) * dfks2(1,jfa)
        end do
        do ifa = 1, nface
            dflx1(1+ifa) = dflx1(1+ifa) + dmob1f(ifa)* fks(ifa)
            dflx2(1+ifa) = dflx2(1+ifa) + dmob2f(ifa)* fks(ifa)
            do jfa = 1, nface
                dflx1(1+ifa) = dflx1(1+ifa) + mobfa(jfa) * dfks1(ifa+ 1,jfa)
                dflx2(1+ifa) = dflx2(1+ifa) + mobfa(jfa) * dfks2(ifa+ 1,jfa)
            end do
        end do
    endif
end subroutine
