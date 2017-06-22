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

subroutine xmmsa3(ndim, nno, nnos, ffp, nddl,&
                  nvec, v1, v2, v3, nfh,&
                  singu, fk, ddls, ddlm, jheavn, ncompn,&
                  nfiss, ifiss, jheafa, ncomph, ifa,&
                  saut)
!
! aslint: disable=W1504
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/indent.h"
#include "asterfort/vecini.h"
#include "asterfort/xcalc_saut.h"
#include "asterfort/xcalc_code.h"
    integer :: ndim, nno, nnos
    integer :: nfh, ddls, ddlm
    integer :: singu, nvec, nddl, nfiss, ifiss, jheafa, ncomph, ifa, jheavn, ncompn
    real(kind=8) :: saut(3), ffp(27)
    real(kind=8) :: v1(nddl), v2(*), v3(*)
    real(kind=8) :: fk(27,3,3)
!
!
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
! IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) À CHAQUE NOEUD SOMMET
! IN  DDLM   : NOMBRE DE DDL A CHAQUE NOEUD MILIEU
! I/O SAUT   : SAUT
!
!
!
!
    integer :: i, j, in, ifh, hea_fa(2)
    integer :: alpi
    real(kind=8) :: coefi
    aster_logical :: lmultc
!
! ----------------------------------------------------------------------
!
    ASSERT(nvec.gt.0.and.nvec.le.3)
    lmultc = nfiss.gt.1
    call vecini(3, 0.d0, saut)
    coefi = xcalc_saut(1,0,1)
    if (.not.lmultc) then
      hea_fa(1)=xcalc_code(1,he_inte=[-1])
      hea_fa(2)=xcalc_code(1,he_inte=[+1])
    endif
    do 161 i = 1, nno
        call indent(i, ddls, ddlm, nnos, in)
        do 164 ifh = 1, nfh
            if (lmultc) then
                coefi = xcalc_saut(zi(jheavn-1+ncompn*(i-1)+ifh),&
                                   zi(jheafa-1+ncomph*(ifiss-1)+2*ifa-1), &
                                   zi(jheafa-1+ncomph*(ifiss-1)+2*ifa),&
                                   zi(jheavn-1+ncompn*(i-1)+ncompn))
            else
                coefi = xcalc_saut(zi(jheavn-1+ncompn*(i-1)+ifh),&
                                   hea_fa(1), &
                                   hea_fa(2),&
                                   zi(jheavn-1+ncompn*(i-1)+ncompn))
            endif
            do 162 j = 1, ndim
                saut(j) = saut(j) - coefi*ffp(i)*v1(in+ndim*ifh+j)
                if (nvec .ge. 2) saut(j) = saut(j) - coefi*ffp(i)*v2(in+ ndim*ifh+j)
                if (nvec .eq. 3) saut(j) = saut(j) - coefi*ffp(i)*v3(in+ ndim*ifh+j)
162         continue
164     continue
        do 163 j = 1, singu*ndim
          do alpi = 1, ndim
            saut(j) = saut(j)-2.d0*fk(i,alpi,j)*v1(in+ndim*(1+nfh)+alpi)
            if (nvec .ge. 2) saut(j) = saut(j)-2.d0*fk(i,alpi,j)*v2(in+ ndim*(1+nfh)+alpi)
            if (nvec .eq. 3) saut(j) = saut(j)-2.d0*fk(i,alpi,j)*v3(in+ ndim*(1+nfh)+alpi)
          enddo
163     continue
161 end do
!
end subroutine
