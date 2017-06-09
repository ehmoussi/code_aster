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

subroutine mmmvcc(phasep, nnl, wpg, ffl, jacobi,&
                  jeu, coefac, dlagrc, vectcc)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
    character(len=9) :: phasep
    integer :: nnl
    real(kind=8) :: wpg, ffl(9), jacobi, dlagrc
    real(kind=8) :: coefac, jeu
    real(kind=8) :: vectcc(9)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DU VECTEUR LAGR_C
!
! ----------------------------------------------------------------------
!
!
! IN  PHASEP : PHASE DE CALCUL
!              'SANS' - PAS DE CONTACT
!              'CONT' - CONTACT
!              'SANS_PENA' - PENALISATION - PAS DE CONTACT
!              'CONT_PENA' - PENALISATION - CONTACT
! IN  NNL    : NOMBRE DE NOEUDS LAGRANGE
! IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFL    : FONCTIONS DE FORMES LAGRANGES
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  JEU    : VALEUR DU JEU
! IN  COEFAC : COEF_AUGM_CONT
! IN  DLAGRC : INCREMENT DEPDEL DU LAGRANGIEN DE CONTACT
! OUT VECTCC : VECTEUR ELEMENTAIRE LAGR_C
!
! ----------------------------------------------------------------------
!
    integer :: inoc
!
! ----------------------------------------------------------------------
!
    if (phasep .eq. 'SANS') then
        do 61 inoc = 1, nnl
            vectcc(inoc) = vectcc(inoc) - wpg*ffl(inoc)*dlagrc*jacobi/ coefac
61      continue
    else if (phasep.eq.'SANS_PENA') then
        do 64 inoc = 1, nnl
            vectcc(inoc) = vectcc(inoc) - wpg*ffl(inoc)*dlagrc*jacobi/ coefac
64      continue
    else if (phasep.eq.'CONT_PENA') then
        do 63 inoc = 1, nnl
            vectcc(inoc) = vectcc(inoc) - wpg*ffl(inoc)*dlagrc*jacobi/ coefac - wpg*ffl(inoc)*jeu&
                           &*jacobi
63      continue
    else if (phasep.eq.'CONT') then
        do 62 inoc = 1, nnl
            vectcc(inoc) = vectcc(inoc)- wpg*ffl(inoc)*jeu*jacobi
62      continue
    else
        ASSERT(.false.)
    endif
!
end subroutine
