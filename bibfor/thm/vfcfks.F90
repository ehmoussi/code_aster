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
! aslint: disable=W1306
!
subroutine vfcfks(l_matr, maxfa  , ndim , nface,&
                  uk    , dukp1  , dukp2,&
                  ufa   , dufa1  , dufa2,&
                  c     , gravity,&
                  rho   , drho1  , drho2,&
                  xk    , xface, &
                  fks   , dfks1, dfks2)
!
implicit none
!
#include "asterf_types.h"
!
aster_logical, intent(in) :: l_matr
integer, intent(in) :: maxfa, nface, ndim
real(kind=8), intent(in) :: uk, dukp1, dukp2
real(kind=8), intent(in) :: ufa(1:nface), dufa1(1:nface), dufa2(1:nface)
real(kind=8), intent(in) :: c(1:maxfa, 1:nface), gravity(ndim)
real(kind=8), intent(in) :: rho, drho1, drho2
real(kind=8), intent(in) :: xk(ndim), xface(1:3, 1:nface)
real(kind=8), intent(out) :: fks(nface), dfks1(1+maxfa, nface), dfks2(1+maxfa, nface)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Compute "volumic" flux
!
! --------------------------------------------------------------------------------------------------
!
! In  l_matr           : flag to compute matrix
! In  maxfa            : maximum number of faces
! In  ndim             : dimension of space (2 or 3)
! In  nface            : number of faces (for finite volume)
! In  uk               : value at center of cell
! In  dukp1            : derivative of value by capillary pressure at center of cell
! In  dukp2            : derivative of value by gaz pressure at center of cell
! In  ufa              : value at faces of cell
! In  dufa1            : derivative of value by capillary pressure unknown at faces of cell
! In  dufa2            : derivative of value by gaz pressure at faces of cell
! In  c
! In  gravity          : gravity
! In  rho              : volumic mass
! In  drho1            : derivative of volumic mass by capillary pressure
! In  drho2            : derivative of volumic mass by gaz pressure
! In  xg               : coordinates of center of cell
! In  xface            : for each face => center
! Out fks              : "volumic" flux
! Out dfks1            : derivative of "volumic" flux by capillary pressure
! Out dfks2            : derivative of "volumic" flux by gaz pressure
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: gravi(nface)
    integer :: ifa, jfa, kfa, idim
!
! --------------------------------------------------------------------------------------------------
!
    fks(1:nface)              = 0.d0
    dfks1(1:1+maxfa, 1:nface) = 0.d0
    dfks2(1:1+maxfa, 1:nface) = 0.d0
!
    do ifa = 1, nface
        do jfa = 1, nface
            gravi(jfa) = 0.d0
            do idim = 1, ndim
                gravi(jfa) = gravi(jfa)+gravity(idim)*(xk(idim)-xface(idim,jfa))
            end do
            fks(ifa) = fks(ifa) + c(ifa,jfa)* (uk-ufa(jfa)-rho*gravi(jfa) )
            if (l_matr) then
                kfa=jfa+1
                dfks1(1,ifa)   = dfks1(1,ifa) + c(ifa,jfa)*(dukp1-drho1*gravi(jfa))
                dfks1(kfa,ifa) = dfks1(kfa,ifa) - c(ifa,jfa)*dufa1(jfa)
                dfks2(1,ifa)   = dfks2(1,ifa) + c(ifa,jfa)*(dukp2-drho2*gravi(jfa))
                dfks2(kfa,ifa) = dfks2(kfa,ifa) - c(ifa,jfa)*dufa2(jfa)
            endif
        end do
    end do
end subroutine
