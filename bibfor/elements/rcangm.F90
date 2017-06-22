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

subroutine rcangm(ndim, coor, angmas)
    implicit none
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterc/r8nnem.h"
#include "asterfort/angvxy.h"
#include "asterfort/r8inir.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/utrcyl.h"
    integer :: ndim
    real(kind=8) :: angmas(7), coor(3)
! ......................................................................
!    - ORIENTATION DU MASSIF
!
!   IN      NDIM    I      : DIMENSION DU PROBLEME
!   IN      COOR    R        COORDONNEE DU POINT
!                            (CAS CYLINDRIQUE)
!   OUT     ANGMAS  R      : ANGLE NAUTIQUE ( OU EULERIEN )
! ......................................................................
    integer :: icamas, iret, i
    real(kind=8) :: p(3, 3), xg(3), yg(3), orig(3), dire(3)
    real(kind=8) :: alpha, beta
!     ------------------------------------------------------------------
!
    call tecach('NNO', 'PCAMASS', 'L', iret, iad=icamas)
    call r8inir(7, 0.d0, angmas, 1)
!
    if (iret .eq. 0) then
        call r8inir(7, 0.d0, angmas, 1)
        if (zr(icamas) .gt. 0.d0) then
            angmas(1) = zr(icamas+1)*r8dgrd()
            if (ndim .eq. 3) then
                angmas(2) = zr(icamas+2)*r8dgrd()
                angmas(3) = zr(icamas+3)*r8dgrd()
                angmas(4) = 1.d0
            endif
!           ECRITURE DES ANGLES D'EULER A LA FIN LE CAS ECHEANT
            if (abs(zr(icamas)-2.d0) .lt. 1.d-3) then
                if (ndim .eq. 3) then
                    angmas(5) = zr(icamas+4)*r8dgrd()
                    angmas(6) = zr(icamas+5)*r8dgrd()
                    angmas(7) = zr(icamas+6)*r8dgrd()
                else
                    angmas(5) = zr(icamas+1)*r8dgrd()
                endif
                angmas(4) = 2.d0
            endif
!
        else if (abs(zr(icamas)+1.d0).lt.1.d-3) then
!
! ON TRANSFORME LA DONNEE DU REPERE CYLINDRIQUE EN ANGLE NAUTIQUE
! (EN 3D, EN 2D ON MET A 0)
!
            if (ndim .eq. 3) then
                alpha=zr(icamas+1)*r8dgrd()
                beta =zr(icamas+2)*r8dgrd()
                dire(1) = cos(alpha)*cos(beta)
                dire(2) = sin(alpha)*cos(beta)
                dire(3) = -sin(beta)
                orig(1)=zr(icamas+4)
                orig(2)=zr(icamas+5)
                orig(3)=zr(icamas+6)
                call utrcyl(coor, dire, orig, p)
                do 1 i = 1, 3
                    xg(i)=p(1,i)
                    yg(i)=p(2,i)
 1              continue
                call angvxy(xg, yg, angmas)
            else
                call utmess('F', 'ELEMENTS2_38')
                call r8inir(7, 0.d0, angmas, 1)
            endif
        endif
!
    else if (iret.eq.1) then
        call r8inir(7, r8nnem(), angmas, 1)
!
    else if (iret.eq.2) then
        call r8inir(7, 0.d0, angmas, 1)
!
    endif
!
end subroutine
