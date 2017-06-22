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

subroutine mmmtcm(phasep, ndim, nnl, nnm, norm,&
                  wpg, ffl, ffm, jacobi, matrcm)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
    character(len=9) :: phasep
    integer :: ndim, nnm, nnl
    real(kind=8) :: ffm(9), ffl(9)
    real(kind=8) :: wpg, jacobi
    real(kind=8) :: norm(3)
    real(kind=8) :: matrcm(9, 27)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! CALCUL DE LA MATRICE LAGR_C/DEPL_MAIT
!
! ----------------------------------------------------------------------
!
!
! IN  PHASEP : PHASE DE CALCUL
!              'CONT'      - CONTACT
!              'CONT_PENA' - CONTACT PENALISE
!              'ADHE'      - ADHERENCE
!              'ADHE_PENA' - ADHERENCE PENALISE
!              'GLIS'      - GLISSEMENT
!              'GLIS_PENA' - GLISSEMENT PENALISE
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  NNL    : NOMBRE DE NOEUDS DE LAGRANGE
! IN  NORM   : NORMALE AU POINT DE CONTACT
! IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFM    : FONCTIONS DE FORMES DEPL. MAIT.
! IN  FFL    : FONCTIONS DE FORMES LAGR.
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! OUT MATRCM : MATRICE ELEMENTAIRE LAGR_C/DEPL_M
!
! ----------------------------------------------------------------------
!
    integer :: inoc, inom, idim, jj
!
! ----------------------------------------------------------------------
!
    if (phasep(1:4) .eq. 'CONT') then
        do 200 inoc = 1, nnl
            do 190 inom = 1, nnm
                do 180 idim = 1, ndim
                    jj = ndim*(inom-1)+idim
                    matrcm(inoc,jj) = matrcm(inoc,jj) + wpg*ffl(inoc)* ffm(inom)*jacobi*norm(idim&
                                      &)
180              continue
190          continue
200      continue
    else
        ASSERT(.false.)
    endif
!
end subroutine
