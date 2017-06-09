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

subroutine mmmjeu(ndim  ,jeusup,norm  ,geome ,geomm , &
                  ddeple,ddeplm,mprojt,jeu   ,djeu  , &
                  djeut ,iresog)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/matini.h"
#include "asterfort/assert.h"
    integer :: ndim
    integer :: iresog
    real(kind=8) :: jeusup
    real(kind=8) :: norm(3)
    real(kind=8) :: geomm(3), geome(3)
    real(kind=8) :: ddeple(3), ddeplm(3)
    real(kind=8) :: mprojt(3, 3)
    real(kind=8) :: jeu, djeu(3), djeut(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DES JEUX
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  JEUSUP : JEU SUPPLEMENTAIRE PAR DIST_ESCL/DIST_MAIT
! IN  NORM   : VALEUR DE LA NORMALE
! IN  GEOME  : COORDONNEES ACTUALISEES DU POINT DE CONTACT
! IN  GEOMM  : COORDONNEES ACTUALISEES DU PROJETE DU POINT DE CONTACT
! IN  DDEPLE : INCREMENT DEPDEL DU DEPL. DU POINT DE CONTACT
! IN  DDEPLM : INCREMENT DEPDEL DU DEPL. DU PROJETE DU POINT DE CONTACT
! IN  MPROJT : MATRICE DE PROJECTION TANGENTE
! OUT JEU    : JEU NORMAL ACTUALISE
! OUT DJEU   : INCREMENT DEPDEL DU JEU
! OUT DJEUT  : INCREMENT DEPDEL DU JEU TANGENT
!
! ----------------------------------------------------------------------
!
    integer :: idim, i, j
!
! ----------------------------------------------------------------------
!
   
    do idim = 1, 3
        djeu(idim) = 0.d0
        djeut(idim) = 0.d0
    end do
    jeu = 0.d0
!
! --- CALCUL DE L'INCREMENT DE JEU
!
    do idim = 1, 3
        djeu(idim) = ddeple(idim) - ddeplm(idim)
    end do
!
! ---- CALCUL DU JEU TOTAL :
! ---- LE JEU EST CALCULE A PARTIR DE (MMREAC+MMDEPM) SUIVANT
! ---- POINT FIXE  : (MAILLAGE+DEPMOI          =GEOM_)+DDEPL_ 
! ---- NEWTON GENE : (MAILLAGE+DEPMOI+PPE*DDPL_=GEOM_)
! ---- GEOM_ --> MMREAC, DDEPL_ --> MMDEPM 
!
    jeu = jeusup
    do idim = 1, ndim
        jeu = jeu + ( geome(idim)+(1-iresog)*ddeple(idim) &
                - geomm(idim)-(1-iresog)*ddeplm( idim))*norm(idim)
    end do
!
! --- PROJECTION DE L'INCREMENT DE JEU SUR LE PLAN TANGENT
!
    do i = 1, ndim
        do j = 1, ndim
            djeut(i) = mprojt(i,j)*djeu(j)+djeut(i)
        end do
    end do


end subroutine
