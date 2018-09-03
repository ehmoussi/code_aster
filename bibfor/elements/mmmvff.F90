! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine mmmvff(phasep, ndim, nnl, nbcps, wpg,&
                  ffl, tau1, tau2, jacobi, coefaf,&
                  dlagrf, rese, lambda, coefff, dvite,&
                  mprojt, vectff)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/assert.h"
#include "asterfort/normev.h"
    character(len=9) :: phasep
    integer :: ndim, nnl, nbcps
    real(kind=8) :: wpg, ffl(9), jacobi, dlagrf(2)
    real(kind=8) :: tau1(3), tau2(3), rese(3)
    real(kind=8) :: coefaf
    real(kind=8) :: lambda, coefff
    real(kind=8) :: vectff(18)
    real(kind=8) :: dvite(3), mprojt(3, 3)
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
!              'ADHE' - CONTACT ADHERENT
!              'GLIS' - CONTACT GLISSANT
!              'SANS_PENA' - PENALISATION - PAS DE CONTACT
!              'ADHE_PENA' - PENALISATION - CONTACT ADHERENT
!              'GLIS_PENA' - PENALISATION - CONTACT GLISSANT
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNL    : NOMBRE DE NOEUDS LAGRANGE
! IN  WPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFL    : FONCTIONS DE FORMES LAGR.
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
! IN  NBCPS  : NOMBRE DE COMPOSANTES/NOEUD DES LAGR_C+LAGR_F
! IN  TAU1   : PREMIER VECTEUR TANGENT
! IN  TAU2   : SECOND VECTEUR TANGENT
! IN  COEFAF : COEF_AUGM_FROT
! IN  DLAGRF : INCREMENT DEPDEL DU LAGRANGIEN DE FROTTEMENT
! IN  RESE   : SEMI-MULTIPLICATEUR GTK DE FROTTEMENT
!               GTK = LAMBDAF + COEFAF*VITESSE
! IN  LAMBDA : VALEUR DU MULT. DE CONTACT (SEUIL DE TRESCA)
! IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
! IN  DVITE  : SAUT D'INCREMENT DES DEPLACEMENTS A L'INTERFACE
!               [[DELTA X]]
! IN  MPROJT : MATRICE DE PROJECTION TANGENTE
! OUT VECTFF : VECTEUR ELEMENTAIRE LAGR_F
!
! ----------------------------------------------------------------------
!
    integer :: i, k, l, ii, nbcpf
    real(kind=8) :: tt(2)
    real(kind=8) :: nrese, inter(2)
    real(kind=8) :: dvitet(3)
!
! ----------------------------------------------------------------------
!
!
! --- INITIALISATIONS
!
    do  i = 1, 3
        dvitet(i) = 0.0d0
  end do
    do  i = 1, 2
        tt(i) = 0.d0
        inter(i) = 0.d0
  end do
    nbcpf = nbcps-1
!
! --- MATRICE DE CHANGEMENT DE REPERE DES LAGR. DE FROTTEMENT
!
    if (ndim .eq. 2) then
        do  k = 1, ndim
            tt(1) = tau1(k)*tau1(k) +tt(1)
        enddo
        tt(1) = dlagrf(1)*tt(1)
        tt(2) = 0.d0
!
    else if (ndim.eq.3) then
        do  k = 1, ndim
            tt(1) = (dlagrf(1)*tau1(k)+dlagrf(2)*tau2(k))*tau1(k)+tt( 1)
        enddo
        do  k = 1, ndim
            tt(2) = (dlagrf(1)*tau1(k)+dlagrf(2)*tau2(k))*tau2(k)+tt( 2)
        enddo
    else
        ASSERT(.false.)
    endif
!
! --- QUANTITES POUR LE CAS ADHERENT
!
    if (phasep(1:4) .eq. 'ADHE') then
!
! --- PROJECTION DU SAUT SUR LE PLAN TANGENT
!
        do  i = 1, ndim
            do  k = 1, ndim
                dvitet(i) = mprojt(i,k)*dvite(k)+dvitet(i)
            enddo
        enddo
!
        if (ndim .eq. 2) then
            do  i = 1, 2
                inter(1)= dvitet(i)*tau1(i)+inter(1)
            enddo
        else if (ndim.eq.3) then
            do  i = 1, 3
                inter(1)= dvitet(i)*tau1(i)+inter(1)
                inter(2)= dvitet(i)*tau2(i)+inter(2)
            enddo
        endif
    endif
!
! --- QUANTITES POUR LE CAS GLISSANT
!
    if (phasep(1:4) .eq. 'GLIS') then
!
        call normev(rese, nrese)
        if (ndim .eq. 2) then
            do  i = 1, 2
                inter(1) = (dlagrf(1)*tau1(i)-rese(i))*tau1(i)+inter( 1)
            enddo
        else if (ndim.eq.3) then
            do  i = 1, 3
                inter(1)=(dlagrf(1)*tau1(i)+ dlagrf(2)*tau2(i)-rese(i)&
                )*tau1(i)+inter(1)
                inter(2)=(dlagrf(1)*tau1(i)+ dlagrf(2)*tau2(i)-rese(i)&
                )*tau2(i)+inter(2)
            enddo
        else
            ASSERT(.false.)
        endif
!
    endif
!
! --- CALCUL DU VECTEUR
!
    if (phasep .eq. 'SANS') then
        do  i = 1, nnl
            do  l = 1, nbcpf
                ii = (i-1)*nbcpf+l
                vectff(ii) = vectff(ii)+ wpg*ffl(i)*jacobi* tt(l)
            enddo
        enddo
    else if (phasep.eq.'SANS_PENA') then
        do  i = 1, nnl
            do  l = 1, nbcpf
                ii = (i-1)*nbcpf+l
                vectff(ii) = vectff(ii)- wpg*ffl(i)*jacobi* tt(l)/ coefaf
          enddo
      enddo
    else if (phasep.eq.'ADHE') then
        do  i = 1, nnl
            do  l = 1, nbcpf
                ii = (i-1)*nbcpf+l
                vectff(ii) = vectff(ii)- wpg*ffl(i)*jacobi* coefff* lambda*inter(l)
          enddo
      enddo
    else if (phasep.eq.'GLIS') then
        do  i = 1, nnl
            do  l = 1, nbcpf
                ii = (i-1)*nbcpf+l
                vectff(ii) = vectff(ii)+ wpg*ffl(i)*jacobi* coefff* lambda*inter(l)/coefaf
             enddo
         enddo
    else if (phasep.eq.'ADHE_PENA') then
        do  i = 1, nnl
            do  l = 1, nbcpf
                ii = (i-1)*nbcpf+l
                vectff(ii) = vectff(ii) + wpg*ffl(i)*jacobi*coefff* lambda*((tt(l)/coefaf)-inter(&
                             &l))
            enddo
        enddo
    else if (phasep.eq.'GLIS_PENA') then
        do  i = 1, nnl
            do  l = 1, nbcpf
                ii = (i-1)*nbcpf+l
                vectff(ii) = vectff(ii)+ wpg*ffl(i)*jacobi* coefff* lambda*inter(l)/coefaf
            enddo
        enddo
    else
        ASSERT(.false.)
    endif
!
end subroutine
