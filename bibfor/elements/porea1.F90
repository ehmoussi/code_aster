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

subroutine porea1(nno, nc, deplm, deplp, geom,&
                  gamma, vecteu, pgl, xl1, angp)
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
#include "asterfort/vdiff.h"
#include "blas/ddot.h"
    integer :: nno, nc
    real(kind=8) :: deplm(nno*nc), deplp(nno*nc), geom(3, nno), gamma
!
    real(kind=8) :: pgl(3, 3), xl1, angp(3)
    aster_logical :: vecteu
!
! --------------------------------------------------------------------------------------------------
!
!     CALCUL DE LA MATRICE DE PASSAGE GLOBALE/LOCALE EN TENANT COMPTE
!     DE LA GEOMETRIE REACTUALISEE POUR LES POUTRES AINSI QUE LA
!     LONGUEUR DE LA POUTRE
!     POUR LES OPTIONS FULL_MECA RAPH_MECA ET RIGI_MECA_TANG
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO    : NOMBRE DE NOEUDS
! IN  NC     : NOMBRE DE COMPOSANTE DU CHAMP DE DEPLACEMENTS
! IN  DEPLM  : DEPLACEMENT AU TEMPS -
! IN  DEPLP  : INCREMENT DE DEPLACEMENT AU TEMPS +
! IN  GEOM   : COORDONNEES DES NOEUDS
! IN  GAMMA  : ANGLE DE VRILLE AU TEMPS -
! IN  VECTEU : TRUE SI FULL_MECA OU RAPH_MECA
! OUT PGL    : MATRICE DE PASSAGE GLOBAL/LOCAL
! OUT XL     : LONGUEUR DE L'ELEMENT
! OUT ANGP   : ANGLES NAUTIQUES ACTUALISEE
!              ATTENTION ANGP(3) EST DIFFERENT DE GAMMA1 QUI A SERVIT
!              POUR CALCUL PGL
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: utg(14), xug(6), xd0(3), xd1(3), alfa1, beta1, xdn0(3), xdn1(3), cosangle
    real(kind=8) :: dgamma, tet1, tet2, gamma1, xl0
    real(kind=8) :: ang1(3)
!
    integer :: iadzi, iazk24
    character(len=24) :: valkm(2)
    real(kind=8) :: valrm
!
! --------------------------------------------------------------------------------------------------
    ASSERT(nno.eq.2)
!   Calcul du vecteur xlocal au temps t-
    do i = 1, 3
        xug(i)   = geom(i,1) + deplm(i)
        xug(i+3) = geom(i,2) + deplm(i+nc)
    enddo
    call vdiff(3, xug(4), xug(1), xd0)
!   Déplacement total a t+
    do i = 1, nno*nc
        utg(i) = deplm(i) + deplp(i)
    enddo
!   Calcul du vecteur xlocal au temps t+
    do i = 1, 3
        xug(i)   = geom(i,1) + utg(i)
        xug(i+3) = geom(i,2) + utg(i+nc)
    enddo
    call vdiff(3, xug(4), xug(1), xd1)
!   Angle entre xd0 et xd1
    xdn0(:) = xd0(:)
    xdn1(:) = xd1(:)
    call normev(xdn0, xl0)
    call normev(xdn1, xl1)
!   si angle > pi/8 : cos(angle) < 0.9238
    cosangle = ddot(3,xdn0,1,xdn1,1)
    if (cosangle .lt. 0.9238) then
        call tecael(iadzi, iazk24)
        valkm(1) = zk24(iazk24+3-1)
        valkm(2) = ' '
        valrm = trigom('ACOS',cosangle)
        call utmess('A', 'ELEMENTS_38', nk=2, valk=valkm, sr=cosangle)
    endif
!
    if (vecteu) then
!       mise a jour du 3eme angle nautique au temps t+
        call gareac(xd0, xd1, dgamma)
!       si dgamma > pi/8
        if (abs(dgamma) .gt. 0.3927d+00) then
            call tecael(iadzi, iazk24)
            valkm(1) = zk24(iazk24+3-1)
            valkm(2) = 'GAMMA'
            valrm = dgamma*r8rddg()
            call utmess('A', 'ELEMENTS_38', nk=2, valk=valkm, sr=valrm)
        endif
    else
        dgamma = 0.d0
    endif
!
!   calcul des deux premiers angles nautiques au temps t+, pour mémorisation
    call angvx(xd1, alfa1, beta1)
!
    tet1 = ddot(3,utg(4),1,xd1,1)
    tet2 = ddot(3,utg(nc+4),1,xd1,1)
    tet1 = tet1/xl1
    tet2 = tet2/xl1
    gamma1 = gamma + dgamma + (tet1+tet2)/2.d0
!   Sauvegarde des angles nautiques
    angp(1) = alfa1
    angp(2) = beta1
    angp(3) = gamma + dgamma
!   Matrice de passage global -> local
    ang1(1) = alfa1
    ang1(2) = beta1
    ang1(3) = gamma1
    call matrot(ang1, pgl)
end subroutine
