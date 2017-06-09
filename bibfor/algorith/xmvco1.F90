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

subroutine xmvco1(ndim, nno, nnol, sigma, pla,&
                  lact, dtang, nfh, ddls, jac,&
                  ffc, ffp, singu, fk, cstaco,&
                  nd, tau1, tau2, jheavn, ncompn,&
                  nfiss, ifiss, jheafa, ncomph, ifa,&
                  vtmp)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/vecini.h"
#include "blas/ddot.h"
#include "asterfort/xcalc_saut.h"
#include "asterfort/xcalc_code.h"
    integer :: ndim, nno, nnol
    integer :: nfh, ddls, pla(27), lact(8)
    integer :: singu
    integer :: ifiss, nfiss, jheavn, ncompn, jheafa, ifa, ncomph
    real(kind=8) :: vtmp(400), sigma(6)
    real(kind=8) :: ffp(27), jac
!
    real(kind=8) :: dtang(3), nd(3), tau1(3), tau2(3)
    real(kind=8) :: fk(27,3,3), ffc(8), cstaco
!
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
! IN  RR     : DISTANCE AU FOND DE FISSURE
! I/O VTMP   : VECTEUR ELEMENTAIRE DE CONTACT/FROTTEMENT
!
!
!
!
    integer :: i, j, k, pli, nli, ifh, hea_fa(2), alp
    real(kind=8) :: tau(3), coefi
    real(kind=8) :: ffi, ttx(3), eps, sqrtan, sqttan
    aster_logical :: lmultc
!
! ---------------------------------------------------------------------
!
! DIRECTION DU SAUT DE DEPLACEMENT TANGENT
!
    lmultc = nfiss.gt.1
    if (.not.lmultc) then
      hea_fa(1)=xcalc_code(1,he_inte=[-1])
      hea_fa(2)=xcalc_code(1,he_inte=[+1])
    endif
    call vecini(3, 0.d0, tau)
    coefi=xcalc_saut(1,0,1)
    eps=r8prem()
    sqttan=0.d0
    sqrtan=dtang(1)**2+dtang(2)**2+dtang(3)**2
    if (sqrtan .gt. eps) sqttan=sqrt(sqrtan)
    if (sqttan .gt. eps) then
        do 110 i = 1, ndim
            tau(i)=dtang(i)/sqttan
110      continue
    endif
!
    do 450 i = 1, nno
        do 451 j = 1, ndim
          do ifh = 1, nfh
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
            vtmp(ddls*(i-1)+ndim+j) =vtmp(&
                                     ddls*(i-1)+ndim*(1+ifh-1)+j)+ &
                                     (coefi*sigma(1)*nd(j)*ffp(i)*jac)+ (coefi&
                                     &*sigma(2)*tau1(j)* ffp(i)*jac&
                                      )
            if (ndim .eq. 3) then
                vtmp(ddls*(i-1)+ndim+j) = vtmp(&
                                          ddls*(i-1)+ndim*(1+ifh-1)+j)+ &
                                          (coefi*sigma(3)*tau2(j)*ffp(i)*jac)
            endif
!
          enddo
451      continue
        do 452 alp = 1, singu*ndim
          do j = 1, ndim
            vtmp(ddls*(i-1)+ndim*(1+nfh)+alp) = vtmp(&
                                              ddls*(i-1)+ndim*(1+ nfh)+alp)+ (2.d0*sigma(1)*nd(j)&
                                              &*jac*fk(i,alp,j))+ (2.d0*sigma( 2)*tau1(j)*jac*&
                                              &fk(i,alp,j)&
                                              )
            if (ndim .eq. 3) then
                vtmp(ddls*(i-1)+ndim*(1+nfh)+alp) = vtmp(&
                                                  ddls*(i-1)+ ndim*(1+nfh)+alp)+ (2.d0*sigma(3)*tau&
                                                  &2(j)*fk(i,alp,j)*jac&
                                                  )
            endif
          enddo
452     continue
450  end do
!
    call vecini(3, 0.d0, ttx)
!
    do 460 i = 1, nnol
        pli=pla(i)
        ffi=ffc(i)
        nli=lact(i)
        if (nli .eq. 0) goto 460
        ttx(1)=ddot(ndim,tau1,1,tau,1)
        if (ndim .eq. 3) ttx(2)=ddot(ndim,tau2, 1,tau,1)
        do 465 k = 1, ndim-1
            vtmp(pli+k) = vtmp(pli+k) + sqrt(sigma(2)**2+sigma(3)**2)* ttx(k)*ffi*jac
465      continue
460  continue
!
    do 470 i = 1, nnol
        pli=pla(i)
        ffi=ffc(i)
        nli=lact(i)
        if (nli .eq. 0) goto 470
        do 475 k = 1, ndim
            vtmp(pli) = vtmp(pli) + sigma(1)*nd(k)*nd(k)*ffi*jac/ cstaco
475      continue
470  continue
!
end subroutine
