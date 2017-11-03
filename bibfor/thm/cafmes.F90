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
subroutine cafmes(ifa   , l_resi, l_matr, maxfa, nface,&
                  fkss  , dfks1 , dfks2 ,&
                  mobfas, dmob1 , dmob2 ,&
                  dmob1f, dmob2f,&
                  fmw   , fm1w  , fm2w)
!
implicit none
!
#include "asterf_types.h"
!
aster_logical, intent(in) :: l_matr, l_resi
integer, intent(in) :: ifa, maxfa, nface
real(kind=8), intent(in) :: fkss, dfks1(1+maxfa, maxfa), dfks2(1+maxfa, maxfa)
real(kind=8), intent(in) :: mobfas,  dmob1(1:maxfa), dmob2(1:maxfa)
real(kind=8), intent(in) :: dmob2f(1:maxfa), dmob1f(1:maxfa)
real(kind=8), intent(out) :: fmw(1:maxfa), fm1w(1+maxfa, maxfa), fm2w(1+maxfa, maxfa)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Compute "massic" flux at current face
!
! --------------------------------------------------------------------------------------------------
!
! In  ifa              : current face
! In  l_matr           : flag to compute matrix
! In  l_resi           : flag to compute residual
! In  maxfa            : maximum number of faces
! In  nface            : number of faces (for finite volume)
! In  fks              : "volumic" flux at current face
! In  dfks1            : derivative of "volumic" flux by capillary pressure at current face
! In  dfks2            : derivative of "volumic" flux by gaz pressure at current face
! In  mobfas           : mobility at current face
! In  dmob1            : derivative of mobility by capillary pressure at center of cell
! In  dmob2            : derivative of mobility by gaz pressure at center of cell
! In  dmob1f           : derivative of mobility by capillary pressure at current face
! In  dmob2f           : derivative of mobility by gaz pressure at current face
! Out fmw              : "massic" flux at current face
! Out fm1w             : derivative of "massic" flux by capillary pressure at current face
! Out fm2w             : derivative of "massic" flux by gaz pressure at current face
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jfa
!
! --------------------------------------------------------------------------------------------------
!
    if (l_resi) then
        fmw(ifa) = fmw(ifa)+ mobfas * fkss
    endif
    if (l_matr) then
        fm1w(1,ifa) = fm1w(1,ifa) + dmob1(ifa) * fkss + mobfas * dfks1(1,ifa)
        fm2w(1,ifa) = fm2w(1,ifa) + dmob2(ifa) * fkss + mobfas * dfks2(1,ifa)
        do jfa = 2, nface+1
            fm1w(jfa,ifa) = fm1w(jfa,ifa) + mobfas * dfks1(jfa,ifa)
            fm2w(jfa,ifa) = fm2w(jfa,ifa) + mobfas * dfks2(jfa,ifa)
        end do
        fm1w(1+ifa,ifa) = fm1w(1+ifa,ifa) + dmob1f(ifa) * fkss
        fm2w(1+ifa,ifa) = fm2w(1+ifa,ifa) + dmob2f(ifa) * fkss
    endif
end subroutine
