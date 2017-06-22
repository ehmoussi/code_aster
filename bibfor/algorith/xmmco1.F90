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

subroutine xmmco1(ndim, nno, dsidep, pp, p,&
                  nd, nfh, ddls, jac, ffp,&
                  singu, fk, tau1, tau2, mmat)
    implicit none
#include "jeveux.h"
#include "asterfort/matcox.h"
#include "asterfort/matini.h"
    integer :: ndim, nno, nfh, ddls, singu
    real(kind=8) :: mmat(216, 216), dsidep(6, 6)
    real(kind=8) :: ffp(27), jac, nd(3)
    real(kind=8) :: pp(3, 3), p(3, 3)
    real(kind=8) :: fk(27,3,3)
!
! ROUTINE CONTACT (METHODE XFEM HPP - CALCUL ELEM.)
!
! --- CALCUL DES MATRICES DE COHESION
!
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NNO    : NOMBRE DE NOEUDS DE L'ELEMENT DE REF PARENT
! IN  DSIDEP :
! IN  PP     :
! IN  P      :
! IN  ND     : DIRECTION NORMALE
! IN  NFH    : NOMBRE DE FONCTIONS HEAVYSIDE
! IN  DDLS   : NOMBRE DE DDL (DEPL+CONTACT) À CHAQUE NOEUD SOMMET
! IN  JAC    : PRODUIT DU JACOBIEN ET DU POIDS
! IN  FFP    : FONCTIONS DE FORME DE L'ELEMENT PARENT
! IN  SINGU  : 1 SI ELEMENT SINGULIER, 0 SINON
! IN  TAU1   : PREMIERE DIRECTION TANGENTE
! IN  AM     :
! I/O MMAT   : MATRICE ELEMENTAITRE DE CONTACT/FROTTEMENT
!
!
!
!
    integer :: i, j
    real(kind=8) :: ddt1(3, 3), ddt2(3, 3), ddt3(3, 3), ddt4(3, 3)
    real(kind=8) :: tau1(3), tau2(3)
!
! ----------------------------------------------------------------------
!
!     INITIALISATION
    call matini(3, 3, 0.d0, ddt1)
    call matini(3, 3, 0.d0, ddt2)
    call matini(3, 3, 0.d0, ddt3)
    call matini(3, 3, 0.d0, ddt4)
!
!           II.2.3. CALCUL DES MATRICES DE COHESION
!        ..............................
!
    do 216 i = 1, ndim
        do 217 j = 1, ndim
            ddt1(i,j)=dsidep(1,1)*nd(i)*nd(j)
            if (ndim .eq. 2) then
                ddt2(i,j)=dsidep(1,2)*nd(i)*tau1(j) +dsidep(2,1)*tau1(&
                i)*nd(j)
            else if (ndim.eq.3) then
                ddt2(i,j)=dsidep(1,2)*nd(i)*tau1(j) +dsidep(1,3)*nd(i)&
                *tau2(j) +dsidep(2,1)*tau1(i)*nd(j) +dsidep(3,1)*tau2(&
                i)*nd(j)
            endif
            ddt3(i,j)=ddt2(i,j)
            if (ndim .eq. 2) then
                ddt4(i,j)=dsidep(2,2)*tau1(i)*tau1(j)
            else if (ndim.eq.3) then
                ddt4(i,j)=dsidep(2,2)*tau1(i)*tau1(j) +dsidep(2,3)*&
                tau1(i)*tau2(j) +dsidep(3,2)*tau2(i)*tau1(j) +dsidep(&
                3,3)*tau2(i)*tau2(j)
            endif
217      continue
216  end do
!
    call matcox(ndim, pp, ddt1, ddt2, ddt3,&
                ddt4, p, nno, nfh*ndim, ddls,&
                jac, ffp, singu, fk, mmat)
!
end subroutine
