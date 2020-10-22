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

subroutine porea3(nno, nc, deplm, deplp, geom,&
                  gamma, pgl, xl1, angp)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8rddg.h"
#include "asterfort/angvx.h"
#include "asterfort/assert.h"
#include "asterfort/gareac.h"
#include "asterfort/matrot.h"
#include "asterfort/normev.h"
#include "asterfort/tecael.h"
#include "asterfort/trigom.h"
#include "asterfort/utmess.h"
#include "blas/ddot.h"

integer :: nno, nc
real(kind=8) :: deplm(nno*nc), deplp(nno*nc), geom(3, nno), gamma
real(kind=8) :: pgl(3, 3), xl1, angp(3)
!
! --------------------------------------------------------------------------------------------------
!
!     CALCUL DE LA MATRICE DE PASSAGE GLOBALE/LOCALE EN TENANT COMPTE
!     DE LA GEOMETRIE REACTUALISEE POUR LES POUTRES AINSI QUE LA
!     LONGUEUR DE LA POUTRE
!     CALCUL FAIT AU DERNIER INSTANT CONVERGE
!     POUR LES OPTIONS FULL_MECA RAPH_MECA ET RIGI_MECA_TANG
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO    : NOMBRE DE NOEUDS
! IN  NC     : NOMBRE DE COMPOSANTE DU CHAMP DE DEPLACEMENTS
! IN  DEPLM  : DEPLACEMENT AU TEMPS -
! IN  GEOM   : COORDONNEES DES NOEUDS
! IN  GAMMA  : ANGLE DE VRILLE AU TEMPS -
! OUT PGL    : MATRICE DE PASSAGE GLOBAL/LOCAL
! OUT XL     : LONGUEUR DE L'ELEMENT
! OUT ANGP   : ANGLES NAUTIQUES ACTUALISEE

!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: utg(14), xug(6), xd0(3), alfa1, beta1

! --------------------------------------------------------------------------------------------------
    ASSERT(nno.eq.2)
    !   Calcul du vecteur xlocal au temps t-
!   Déplacement total a t+
    do i = 1, nno*nc
        utg(i) = deplm(i) + deplp(i)
    enddo
    do i = 1, 3
        xug(i)   = geom(i,1) + utg(i)
        xug(i+3) = geom(i,2) + utg(i+nc)
        xd0(i)   = xug(i+3) - xug(i)
    enddo
!
    call normev(xd0,xl1)

!   calcul des deux premiers angles nautiques 
    call angvx(xd0, alfa1, beta1)

!   Sauvegarde des angles nautiques
    angp(1) = alfa1
    angp(2) = beta1
    angp(3) = gamma

!   Matrice de passage global -> local
    call matrot(angp, pgl)

  end subroutine porea3
