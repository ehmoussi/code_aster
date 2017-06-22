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

subroutine xmmsa4(ndim, nno, nnos, ffp, nddl,&
                  nvec, v1, v2, v3, nfh,&
                  singu, rr, ddls, ddlm, saut)
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/indent.h"
#include "asterfort/vecini.h"
#include "asterfort/xcalc_saut.h"
    integer :: ndim, nno, nnos
    integer :: nfh, ddls, ddlm
    integer :: singu, nvec, nddl
    real(kind=8) :: saut(3), rr, ffp(27)
    real(kind=8) :: v1(nddl), v2(*), v3(*)
!
! ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
!
! CALCUL DU SAUT
!
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT DE REF PARENT
! IN  NNOS   : NOMBRE DE NOEUDS SOMMET DE L'ELEMENT DE REF PARENT
! IN  FFP    : FONCTIONS DE FORME DE L'ELEMENT PARENT
! IN  NDDL   : NOMBRE TOTAL DE DDL DE L ELEMENT
! IN  NVEC   : NOMBRE VECTEURS DEPLACEMENT
! IN  VEC1   : PREMIER VECTEUR
! IN  VEC2   : DEUXIEME VECTEUR
! IN  VEC3   : TROISIEME VECTEUR
! IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
! IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
! IN  RR     : DISTANCE AU FOND DE FISSURE
! IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) À CHAQUE NOEUD SOMMET
! IN  DDLM   : NOMBRE DE DDL A CHAQUE NOEUD MILIEU
! I/O SAUT   : SAUT
!
!
!
!
    real(kind=8) :: coefj
    integer :: i, j, in, ig
!
! ----------------------------------------------------------------------
!
    call vecini(3, 0.d0, saut)
    coefj=xcalc_saut(1,0,1)
    ASSERT(nvec.gt.0)
    do 161 i = 1, nno
        call indent(i, ddls, ddlm, nnos, in)
        do 162 j = 1, ndim
          do ig = 1, nfh
            saut(j) = saut(j) - coefj*ffp(i)*v1(in+ndim*(1+ig-1)+j)
            if (nvec .ge. 2) saut(j) = saut(j) - coefj*ffp(i)*v2(in+ndim*(1+ig-1)+ j)
            if (nvec .ge. 3) saut(j) = saut(j) - coefj*ffp(i)*v3(in+ndim*(1+ig-1)+ j)
          enddo
162      continue
        do 163 j = 1, singu*ndim
            saut(j) = saut(j)-2.d0*ffp(i)*rr*v1(in+ndim*(1+nfh)+j)
            if (nvec .ge. 2) saut(j) = saut(j)-2.d0*ffp(i)*rr*v2(in+ndim* (1+nfh)+j)
            if (nvec .ge. 3) saut(j) = saut(j)-2.d0*ffp(i)*rr*v3(in+ndim* (1+nfh)+j)
163      continue
161  end do
!
end subroutine
