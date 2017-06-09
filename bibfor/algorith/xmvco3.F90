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

subroutine xmvco3(sigref, depref, ndim, nno, nnol,&
                  nnos, pla, lact, nfh, ddls,&
                  ddlm, nfiss, ifiss, jheafa, ifa,&
                  ncomph, jheavn, ncompn, jac, ffc, ffp,&
                  singu, fk, vtmp)
!
! aslint: disable=W1504
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/indent.h"
#include "asterfort/xcalc_saut.h"
    integer :: ndim, nno, nnol
    integer :: nfh, ddls, pla(27), lact(8)
    integer :: singu, jheavn, ncompn
    real(kind=8) :: vtmp(400)
    real(kind=8) :: ffp(27), jac, depref, sigref, fk(27,3,3)
    real(kind=8) :: ffc(8)
!
!
! ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
!
! --- CALCUL DES SECONDS MEMBRES DE COHESION
!
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT DE REF PARENT
! IN  SIGMA  : VECTEUR CONTRAINTE EN REPERE LOCAL
! IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
! IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) À CHAQUE NOEUD SOMMET
! IN  JAC    : PRODUIT DU JACOBIEN ET DU POIDS
! IN  FFP    : FONCTIONS DE FORME DE L'ELEMENT PARENT
! IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
! IN  FK     : FONCTION VECTORIELLE EN FOND DE FISSURE
! I/O VTMP   : VECTEUR ELEMENTAIRE DE CONTACT/FROTTEMENT
!
!
    integer :: i, j, k, pli, nli, ddlm, ifa, ifh, ifiss
    integer :: in, jheafa, ncomph, nfiss, nnos, alp
    real(kind=8) :: ffi, coefi
    aster_logical :: lmultc
!
! ---------------------------------------------------------------------
!
    coefi = xcalc_saut(1,0,1)
    lmultc = nfiss.gt.1
    do 10 i = 1, nno
        call indent(i, ddls, ddlm, nnos, in)
        do 11 ifh = 1, nfh
            if (lmultc) then
                coefi = xcalc_saut(zi(jheavn-1+ncompn*(i-1)+ifh),&
                                       zi(jheafa-1+ncomph*(ifiss-1)+2*ifa-1), &
                                       zi(jheafa-1+ncomph*(ifiss-1)+2*ifa))
            endif
            do 12 j = 1, ndim
                vtmp(in+ndim*ifh+j) = vtmp(in+ndim*ifh+j) + abs(coefi* ffp(i)*sigref*jac)
 12         continue
 11     continue
        do 13 alp = 1, singu*ndim
          do j = 1, ndim
            vtmp(in+ndim*(1+nfh)+j) = vtmp( in+ndim*(1+nfh)+j) + abs(2.d0*ffp(i)*&
                                        fk(i,alp,j)*sigref*jac )
          enddo
 13     continue
 10 continue
!
! SECOND MEMBRE DE L EQUATION D INTERFACE: EXPRESSION DIRECTE
! ATTENTION INVERSION DE CONVENTIONS
!
    do 20 i = 1, nnol
        pli=pla(i)
        ffi=ffc(i)
        nli=lact(i)
        do 21 k = 1, ndim
! SI LAGRANGE ACTIF ON MET LA FORCE NODALE DE REF
            if (nli .ne. 0) then
                vtmp(pli-1+k) = vtmp(pli-1+k) + abs(depref*ffi*jac)
! SINON ON MET SIGREF
            else if (nli.eq.0) then
                vtmp(pli-1+k) = vtmp(pli-1+k) + abs(sigref)
            endif
 21     continue
 20 continue
!
end subroutine
