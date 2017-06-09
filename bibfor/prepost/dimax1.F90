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

subroutine dimax1(jvec1, jvec2, nbp1, nbp2, dismax,&
                  cu1max, cv1max, cu2max, cv2max)
    implicit   none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: jvec1, jvec2, nbp1, nbp2
    real(kind=8) :: dismax, cu1max, cv1max, cu2max, cv2max
! person_in_charge: van-xuan.tran at edf.fr
! ---------------------------------------------------------------------
! BUT: ENTRE DEUX LISTES DE POINTS, DETERMINER LES DEUX POINTS QUI SONT
!     LE PLUS ELOIGNES.
! ---------------------------------------------------------------------
! ARGUMENTS :
!     JVEC1   : IN  : ADRESSE DU VECTEUR CONTENANT LES POINTS DU
!                     PREMIER GROUPE DE POINTS.
!     JVEC2   : IN  : ADRESSE DU VECTEUR CONTENANT LES POINTS DU
!                     SECOND GROUPE DE POINTS.
!     NBP1    : IN  : NOMBRE DE POINTS DU PREMIER GROUPE DE POINTS.
!     NBP2    : IN  : NOMBRE DE POINTS DU SECOND GROUPE DE POINTS.
!     DISMAX  : OUT : DISTANCE ENTRE LES DEUX POINTS LES PLUS ELOIGNES.
!     CU1MAX  : OUT : COMPOSANTE U DU POINT LE PLUS ELOIGNE APPARTENANT
!                     AU PREMIER GROUPE.
!     CV1MAX  : OUT : COMPOSANTE V DU POINT LE PLUS ELOIGNE APPARTENANT
!                     AU PREMIER GROUPE.
!     CU2MAX  : OUT : COMPOSANTE U DU POINT LE PLUS ELOIGNE APPARTENANT
!                     AU SECOND GROUPE.
!     CV2MAX  : OUT : COMPOSANTE V DU POINT LE PLUS ELOIGNE APPARTENANT
!                     AU SECOND GROUPE.
!     -----------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: i, j
    real(kind=8) :: cu1, cv1, cu2, cv2, dist
!     ------------------------------------------------------------------
!
!234567                                                              012
    call jemarq()
!
    dismax = 0.0d0
!
    do 10 i = 1, nbp1
        cu1 = zr(jvec1 + (i-1)*2)
        cv1 = zr(jvec1 + (i-1)*2 + 1)
!
        do 20 j = 1, nbp2
            cu2 = zr(jvec2 + (j-1)*2)
            cv2 = zr(jvec2 + (j-1)*2 + 1)
            dist = sqrt((cu1 - cu2)**2 + (cv1 - cv2)**2)
!
            if (dist .gt. dismax) then
                dismax = dist
                cu1max = cu1
                cv1max = cv1
                cu2max = cu2
                cv2max = cv2
            endif
!
20      continue
10  end do
!
    call jedema()
end subroutine
