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

subroutine xmmjac(alias, geom, dff, jac)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
    character(len=8) :: alias
    real(kind=8) :: dff(3, 9), geom(18), jac
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEM GR GLISS - UTILITAIRE)
!
! CALCUL DU JACOBIEN D'UN ELEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  ALIAS  : NOM D'ALIAS DE L'ELEMENT
! IN  GEOM   : VECTEUR GEOMETRIE ACTUALISEE
! IN  DFF    : DERIVEES PREMIERES DES FONCTIONS DE FORME EN XI YI
! OUT JAC    : VALEUR DU JACOBIEN
!
!
!
!
    integer :: i
    real(kind=8) :: dxds, dyds, dzds
    real(kind=8) :: dxde, dxdk, dyde, dydk, dzde, dzdk
!
! ----------------------------------------------------------------------
!
    dxds = 0.d0
    dyds = 0.d0
    dzds = 0.d0
    dxde = 0.d0
    dyde = 0.d0
    dzde = 0.d0
    dxdk = 0.d0
    dydk = 0.d0
    dzdk = 0.d0
!
    if (alias(1:5) .eq. 'SE2') then
        do 10 i = 1, 2
            dxds = dxds + geom(2*(i-1)+1)*dff(1,i)
            dyds = dyds + geom(2*(i-1)+2)*dff(1,i)
10      continue
        jac = sqrt(dxds**2+dyds**2+dzds**2)
    else if (alias(1:5).eq.'SE3') then
        do 20 i = 1, 3
            dxds = dxds + geom(2*(i-1)+1)*dff(1,i)
            dyds = dyds + geom(2*(i-1)+2)*dff(1,i)
20      continue
        jac = sqrt(dxds**2+dyds**2+dzds**2)
    else if (alias(1:5).eq.'TR3') then
        do 30 i = 1, 3
            dxde = dxde + geom(3*i-2)*dff(1,i)
            dxdk = dxdk + geom(3*i-2)*dff(2,i)
            dyde = dyde + geom(3*i-1)*dff(1,i)
            dydk = dydk + geom(3*i-1)*dff(2,i)
            dzde = dzde + geom(3*i)*dff(1,i)
            dzdk = dzdk + geom(3*i)*dff(2,i)
30      continue
        jac = sqrt((dyde*dzdk-dzde*dydk)**2+ (dzde*dxdk-dxde*dzdk)**2+ (dxde*dydk-dyde*dxdk)**2)
    else if (alias(1:5).eq.'TR6') then
        do 40 i = 1, 6
            dxde = dxde + geom(3*i-2)*dff(1,i)
            dxdk = dxdk + geom(3*i-2)*dff(2,i)
            dyde = dyde + geom(3*i-1)*dff(1,i)
            dydk = dydk + geom(3*i-1)*dff(2,i)
            dzde = dzde + geom(3*i)*dff(1,i)
            dzdk = dzdk + geom(3*i)*dff(2,i)
40      continue
        jac = sqrt((dyde*dzdk-dzde*dydk)**2+ (dzde*dxdk-dxde*dzdk)**2+ (dxde*dydk-dyde*dxdk)**2)
    else
        ASSERT(.false.)
    endif
!
end subroutine
