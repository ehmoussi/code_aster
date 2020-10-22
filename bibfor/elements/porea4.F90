! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine porea4(nno, nc, geom, gamma, pgl,&
                  xl)
    implicit none
#include "jeveux.h"
#include "asterfort/angvx.h"
#include "asterfort/assert.h"
#include "asterfort/matrot.h"
#include "asterfort/tecach.h"
#include "asterfort/normev.h"
#include "blas/ddot.h"
!
    integer :: nno, nc
    real(kind=8) :: geom(3, nno), gamma
!
    real(kind=8) :: pgl(3, 3), xl
!
!
!     ------------------------------------------------------------------
!     CALCUL DE LA MATRICE DE PASSAGE GLOBALE/LOCALE EN TENANT COMPTE
!     DE LA GEOMETRIE REACTUALISEE AINSI QUE LA LONGUEUR DE LA POUTRE
!     POUR L'OPTION FORC_NODA
!     ------------------------------------------------------------------
! IN  NNO    : NOMBRE DE NOEUDS
! IN  NC     : NOMBRE DE COMPOSANTE DU CHAMP DE DEPLACEMENTS
! IN  GEOM   : COORDONNEES DES NOEUDS
! IN  GAMMA  : ANGLE DE VRILLE AU TEMPS -
! OUT PGL    : MATRICE DE PASSAGE GLOBAL/LOCAL
!     ------------------------------------------------------------------
!
!     VARIABLES LOCALES
    integer :: i, ideplm, ideplp, iret
    real(kind=8) :: utg(14), xug(6), xd(3), alfa1, beta1, ang1(3)
!
    ASSERT(nno.eq.2)
!
    call tecach('ONO', 'PDEPLMR', 'L', iret, iad=ideplm)
    if (iret .ne. 0) then
       do i = 1, 2*nc
          utg(i) = 0.d0
       enddo
    else
       do  i = 1, 2*nc
          utg(i) = zr(ideplm-1+i)
       enddo
    endif
!
    call tecach('ONO', 'PDEPLPR', 'L', iret, iad=ideplp)
    if (iret .eq. 0) then
        do i = 1, 2*nc
            utg(i) = utg(i) + zr(ideplp-1+i)
        end do
    endif
!
    do i = 1, 3
       xug(i)   = utg(i) + geom(i,1)
       xug(i+3) = utg(i+nc) + geom(i,2)
       xd(i)    = xug(i+3) - xug(i)
    enddo
!
    call angvx(xd, alfa1, beta1)
    call normev(xd, xl)

!
    ang1(1) = alfa1
    ang1(2) = beta1
    ang1(3) = gamma
!
    call matrot(ang1, pgl)

  end subroutine porea4
  
