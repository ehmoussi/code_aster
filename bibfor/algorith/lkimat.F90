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

subroutine lkimat(mod, imat, nmat, materd, materf,&
                  matcst, ndt, ndi, nvi, nr)
    implicit  none
! person_in_charge: alexandre.foucault at edf.fr
!       --------------------------------------------------------------
!       RECUPERATION PROPRIETES MATERIAU POUR LETK ET DIMENSION NR
!       IN  MOD    :  TYPE DE MODELISATION
!           IMAT   :  ADRESSE DU MATERIAU CODE
!           NMAT   :  DIMENSION 1 DE MATER
!       OUT MATERD :  COEFFICIENTS MATERIAU A T
!           MATERF :  COEFFICIENTS MATERIAU A T+DT
!                     MATER(*,I) = CARACTERISTIQUES MATERIAU
!                                    I = 1  CARACTERISTIQUES ELASTIQUES
!                                    I = 2  CARACTERISTIQUES PLASTIQUES
!           MATCST :  'OUI' SI  MATERIAU A T = MATERIAU A T+DT
!                     'NON' SINON OU 'NAP' SI NAPPE DANS 'VECMAT.F'
!           NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
!           NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
!           NR     :  NB DE COMPOSANTES SYSTEME NL (9 OU 10)
!           NVI    :  NB DE VARIABLES INTERNES
!       --------------------------------------------------------------
#include "asterfort/lklmat.h"
    integer :: imat, nmat, ndt, ndi, nr, nvi
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    character(len=8) :: mod
    character(len=3) :: matcst
!
    integer :: indal
!
    call lklmat(mod, imat, nmat, 0.d0, materd,&
                materf, matcst, ndt, ndi, nvi,&
                indal)
!
! --- L'INCONNUE DU SYSTEME NL EST COMPOSEE :
! --- DES CONTRAINTES + DLAMBDA + XIP + XIVP
    nr = ndt + 3
!
end subroutine
