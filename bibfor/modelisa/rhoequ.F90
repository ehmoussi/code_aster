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

subroutine rhoequ(rho, rhos, rhofi, rhofe, cm,&
                  phii, phie)
    implicit none
!
! CALCUL D UN RHO EQUIVALENT D UNE STRUCTURE AVEC PRISE EN COMPTE
!   DE L EFFET DE MASSE AJOUTEE ET DU CONFINEMENT DE LA STRUCTURE
!     -----------------------------------------------------------------
!
!-----------------------------------------------------------------------
#include "asterc/r8pi.h"
    real(kind=8) :: cm, phie, phieq, phii, pi, rho
    real(kind=8) :: rhofe, rhofi, rhos
!-----------------------------------------------------------------------
    pi = r8pi()
    rho = (rhofi*phii*phii) + rhos*(phie*phie - phii*phii)
    phieq = (2.d0*cm/pi)*(phie*phie)
    rho = rho + rhofe*phieq
    rho = rho / (phie*phie - phii*phii)
end subroutine
