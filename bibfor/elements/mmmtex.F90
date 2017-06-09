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

subroutine mmmtex(ndexfr, ndim, nnl, nne, nnm,&
                  nbcps, matrff, matrfe, matrfm, matref,&
                  matrmf)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/isdeco.h"
#include "asterfort/mmmte2.h"
    integer :: ndim, nne, nnl, nnm, nbcps
    integer :: ndexfr
    real(kind=8) :: matrff(18, 18)
    real(kind=8) :: matref(27, 18), matrfe(18, 27)
    real(kind=8) :: matrmf(27, 18), matrfm(18, 27)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! CALCUL DES MATRICES - MODIFICATIONS EXCLUSION
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  NNL    : NOMBRE DE NOEUDS DE LAGRANGE
! IN  NBCPS  : NOMBRE DE COMPOSANTES/NOEUD DES LAGR_C+LAGR_F
! IN  ndexfr : ENTIER CODE POUR EXCLUSION DIRECTION DE FROTTEMENT
! OUT MATRFF : MATRICE ELEMENTAIRE LAGR_F/LAGR_F
! OUT MATRFE : MATRICE ELEMENTAIRE LAGR_F/DEPL_E
! OUT MATRFM : MATRICE ELEMENTAIRE LAGR_F/DEPL_M
! OUT MATREF : MATRICE ELEMENTAIRE DEPL_E/LAGR_F
! OUT MATRMF : MATRICE ELEMENTAIRE DEPL_M/LAGR_F
!
! ----------------------------------------------------------------------
!
    integer :: ndexcl(10), nbcpf
!
! ----------------------------------------------------------------------
!
    nbcpf = nbcps - 1
!
! --- MODIFICATION DES TERMES SI EXCLUSION DIRECTION FROTT. SANS_NO_FR
!
    if (ndexfr .ne. 0) then
        call isdeco([ndexfr], ndexcl, 10)
        call mmmte2(ndim, nnl, nne, nnm, nbcpf,&
                    ndexcl, matrff, matrfe, matrfm, matref,&
                    matrmf)
    endif
!
end subroutine
