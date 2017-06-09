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

subroutine mmmtcc(phasep, nnl, wpg, ffl, jacobi,&
                  coefac, matrcc)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
    character(len=9) :: phasep
    integer :: nnl
    real(kind=8) :: wpg, ffl(9), jacobi
    real(kind=8) :: coefac
    real(kind=8) :: matrcc(9, 9)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DE LA MATRICE LAGR_C/LAGR_C
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
! IN  FFL    : FONCTIONS DE FORMES LAGR.
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  COEFAC : COEF_AUGM_CONT
! OUT MATRCC : MATRICE ELEMENTAIRE LAGR_C/LAGR_C
!
! ----------------------------------------------------------------------
!
    integer :: inoc1, inoc2
!
! ----------------------------------------------------------------------
!
!
    if (phasep .eq. 'SANS') then
        do 61 inoc1 = 1, nnl
            do 51 inoc2 = 1, nnl
                matrcc(inoc1,inoc2) = matrcc(inoc1,inoc2)- wpg*jacobi/ coefac* ffl(inoc2)*ffl(ino&
                                      &c1)
51          continue
61      continue
    else if (phasep.eq.'SANS_PENA') then
        do 62 inoc1 = 1, nnl
            do 52 inoc2 = 1, nnl
                matrcc(inoc1,inoc2) = matrcc(inoc1,inoc2)- wpg*jacobi/ coefac* ffl(inoc2)*ffl(ino&
                                      &c1)
52          continue
62      continue
    else if (phasep.eq.'CONT_PENA') then
        do 63 inoc1 = 1, nnl
            do 53 inoc2 = 1, nnl
                matrcc(inoc1,inoc2) = matrcc(inoc1,inoc2)- wpg*jacobi/ coefac* ffl(inoc2)*ffl(ino&
                                      &c1)
53          continue
63      continue
    else
        ASSERT(.false.)
    endif
!
end subroutine
