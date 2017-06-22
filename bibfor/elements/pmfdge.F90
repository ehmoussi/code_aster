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

subroutine pmfdge(b, g, depl, alpha, dege)
    implicit none
! ---  CALCUL DES DEFORMATIONS GENERALISEES
!         DE L'ELEMENT POUTRE EULER (A LA POSITION X)
! --- IN : MATRICE B POUR LA POSITION CONSIDEREE
! --- IN : MATRICE G POUR LA POSITION CONSIDEREE (MODE INCOMPATIBLE)
! --- IN : DEPLACEMENTS DANS LE REPERE LOCAL (6 DDL PAR NOEUD)
!          DEPL(12)
! --- IN : ALPHA VARIABLE MODE INCOMPATIBLE
! --- OUT : DEFORMATIONS GENERALISEES A LA POSITION OU B EST CALCULEE
!          DEGE(6)
!           1 : DEFORMATION AXIALE
!           2 ET 3 : DISTORSION TRANCHANTE NULLE POUR EULER BERNOULLI
!           4 : ANGLE UNITAIRE DE TORSION
!           5 : COURBURE AUTOUR DE Y
!           6 : COURBURE AUTOUR DE Z
! -----------------------------------------------------------
    real(kind=8) :: b(4), g, depl(12), alpha, dege(6)
    real(kind=8) :: zero
    parameter (zero=0.0d+0)
!
! --- DEF. GENERALISEES DE L'ELEMENT POUTRE EULER A LA POSITION DE B
    dege(1)=(depl(7)-depl(1))*b(1)+g*alpha
    dege(2)=zero
    dege(3)=zero
    dege(4)=(depl(10)-depl(4))*b(1)
    dege(5)=b(4)*depl(11)+b(3)*depl(5)+b(2)*(depl(9)-depl(3))
    dege(6)=b(4)*depl(12)+b(3)*depl(6)+b(2)*(depl(2)-depl(8))
!
end subroutine
