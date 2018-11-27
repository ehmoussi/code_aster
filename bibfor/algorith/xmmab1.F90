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
! aslint: disable=W1504
!
subroutine xmmab1(ndim, jnne, ndeple, nnc, jnnm,&
                  hpg, ffc, ffe,&
                  ffm, jacobi, lambda, coefcr,&
                  dvitet, coeffr, jeu,&
                  coeffp, coefff, lpenaf, tau1, tau2,&
                  rese, mproj, norm, nsinge,&
                  nsingm, fk_escl, fk_mait, nvit, nconta,&
                  jddle, jddlm, nfhe, nfhm, heavn, mmat)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/indent.h"
#include "asterfort/xplma2.h"
#include "blas/ddot.h"
#include "asterfort/xcalc_heav.h"
#include "asterfort/xcalc_code.h"
!
integer :: ndim, jnne(3), nnc, jnnm(3)
integer :: nsinge, nsingm, nconta, jddle(2), jddlm(2)
integer :: nvit, ndeple, nfhe
integer :: nfhm, heavn(*)
real(kind=8) :: hpg, ffc(8), ffe(20), ffm(20), jacobi, norm(3), coeffp
real(kind=8) :: lambda, coefff, coeffr, coefcr, dvitet(3)
real(kind=8) :: tau1(3), tau2(3), rese(3), mmat(336, 336), mproj(3, 3)
real(kind=8) :: jeu
real(kind=8) :: fk_escl(27,3,3), fk_mait(27,3,3)
aster_logical :: lpenaf
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - CALCUL ELEM.)
!
! CALCUL DE B ET DE BT POUR LE CONTACT METHODE CONTINUE
! AVEC ADHERENCE
!
! ----------------------------------------------------------------------
! ROUTINE SPECIFIQUE A L'APPROCHE <<GRANDS GLISSEMENTS AVEC XFEM>>,
! TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
! ----------------------------------------------------------------------
!
! IN  NDIM   : DIMENSION DU PROBLEME
! IN  NNE    : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  NNES   : NOMBRE DE NOEUDS SOMMETS DE LA MAILLE ESCLAVE
! IN  NNC    : NOMBRE DE NOEUDS DE CONTACT
! IN  NNM    : NOMBRE DE NOEUDS DE LA MAILLE MAITRE
! IN  HPG    : POIDS DU POINT INTEGRATION DU POINT DE CONTACT
! IN  FFC    : FONCTIONS DE FORME DU PT CONTACT DANS ELC
! IN  FFE    : FONCTIONS DE FORME DU PT CONTACT DANS ESC
! IN  FFM    : FONCTIONS DE FORME DE LA PROJECTION DU PTC DANS MAIT
! IN  DDLES : NOMBRE DE DDLS D'UN NOEUD SOMMET ESCLAVE
! IN  JACOBI : JACOBIEN DE LA MAILLE AU POINT DE CONTACT
!              INTERSECTEES
! IN  LAMBDA : VALEUR DU SEUIL_INIT
! IN  COEFFA : COEF_REGU_FROT
! IN  COEFFF : COEFFICIENT DE FROTTEMENT DE COULOMB
! IN  TAU1   : PREMIERE TANGENTE
! IN  TAU2   : SECONDE TANGENTE
! IN  RESE   : PROJECTION DE LA BOULE UNITE POUR LE FROTTEMENT
! IN  MPROJ  : MATRICE DE L'OPERATEUR DE PROJECTION
! IN  TYPMAI : NOM DE LA MAILLE ESCLAVE D'ORIGINE (QUADRATIQUE)
! IN  NSINGE : NOMBRE DE FONCTION SINGULIERE ESCLAVE
! IN  NSINGM : NOMBRE DE FONCTION SINGULIERE MAITRE
! IN  NVIT   : POINT VITAL OU PAS
! I/O MMAT   : MATRICE ELEMENTAIRE DE CONTACT/FROTTEMENT
! ----------------------------------------------------------------------
    integer :: i, j, k, l, ii, jj, pli, plj
    integer :: jjn, iin, ddle
    integer :: nne, nnes, nnm, nnms, ddles, ddlem, ddlms, ddlmm
    integer :: hea_fa(2), alpj, alpi
    real(kind=8) :: e(3, 3), a(3, 3), c(3, 3), mp, mb, mbt, mm, mmt
    real(kind=8) :: tt(3, 3), v(2)
    real(kind=8) :: iescl(2), jescl(2), imait(2), jmait(2)
! ----------------------------------------------------------------------
!
! --- INITIALISATIONS
!
    iescl(1) = 1
    iescl(2) = -1
    jescl(1) = 1
    jescl(2) = -1
    imait(1) = 1
    imait(2) = 1
    jmait(1) = 1
    jmait(2) = 1
!    DEFINITION A LA MAIN DE LA TOPOLOGIE DE SOUS-DOMAINE PAR FACETTE (SI NFISS=1)
    hea_fa(1)=xcalc_code(1,he_inte=[-1])
    hea_fa(2)=xcalc_code(1,he_inte=[+1])
!
    nne=jnne(1)
    nnes=jnne(2)
    nnm=jnnm(1)
    nnms=jnnm(2)
    ddles=jddle(1)
    ddlem=jddle(2)
    ddlms=jddlm(1)
    ddlmm=jddlm(2)
    v(:)=0
    a(:,:) = 0.d0
    e(:,:) = 0.d0
    tt(:,:) = 0.d0

    v(1) = ddot(ndim,dvitet,1,tau1,1)
    if (ndim .eq. 3) v(2) = ddot(ndim,dvitet,1,tau2,2)
!     TT = ID
    do i = 1, ndim
        tt(1,1) = tau1(i)*tau1(i) + tt(1,1)
        tt(1,2) = tau1(i)*tau2(i) + tt(1,2)
        tt(2,1) = tau2(i)*tau1(i) + tt(2,1)
        tt(2,2) = tau2(i)*tau2(i) + tt(2,2)
    end do
!
! --- E = [P_TAU]T*[P_TAU]
!
! --- MPROJ MATRICE DE PROJECTION ORTHOGONALE SUR LE PLAN TANGENT
! --- E = [MPROJ]T*[MPROJ] = [MPROJ]*[MPROJ] = [MPROJ]
! ---        CAR ORTHOGONAL^   CAR PROJECTEUR^
    do i = 1, ndim
        do j = 1, ndim
            do k = 1, ndim
                e(i,j) = mproj(k,i)*mproj(k,j) + e(i,j)
            end do
        end do
    end do
!
! --- A = [P_B,TAU1,TAU2]*[P_TAU]
!
! --- RESE = COEFFP*VIT
! ---        GT SEMI MULTIPLICATEUR AUGMENTE FROTTEMENT
    do i = 1, ndim
        do k = 1, ndim
            a(1,i) = rese(k)*mproj(k,i) + a(1,i)
            a(2,i) = tau1(k)*mproj(k,i) + a(2,i)
            a(3,i) = tau2(k)*mproj(k,i) + a(3,i)
        end do
    end do
!
! --- C = (P_B)[P_TAU]*(N)
!
! --- C = GT TENSORIEL N
    do i = 1, ndim
        do j = 1, ndim
            c(i,j) = a(1,i)*norm(j)
        end do
    end do
! ---- MP = MU*GN*WG*JAC
    if (nconta .eq. 3 .and. ndim .eq. 3) then
        mp = (lambda-coefcr*jeu)*coefff*hpg*jacobi
    else
        mp = lambda*coefff*hpg*jacobi
    endif
!
    ddle = ddles*nnes+ddlem*(nne-nnes)
    if (nnm .ne. 0) then
!
! --------------------- CALCUL DE [A] ET [B] -----------------------
!
        do l = 1, ndim
            do k = 1, ndim
! ROUTINE ADHERENTE, ON GARDE LA CONTRIBUTION A [A]
                if (l .eq. 1) then
                    mb = 0.d0
                    mbt = coefff*hpg*jacobi*a(l,k)
                else
                    if (.not.lpenaf) then
                        if (nconta .eq. 3 .and. ndim .eq. 3) then
                            mb = nvit*jacobi*hpg*a(l,k)
                        else
                            mb = nvit*mp*a(l,k)
                        endif
                    endif
                    if (lpenaf) mb = 0.d0
                    if (.not.lpenaf) mbt = mp*a(l,k)
                    if (lpenaf) mbt = 0.d0
                endif
                do i = 1, nnc
                    call xplma2(ndim, nne, nnes, ddles, i,&
                                nfhe, pli)
                    ii = pli+l-1
                    do j = 1, ndeple
! --- BLOCS ES:CONT, CONT:ES
                        mm = mb*ffc(i)*ffe(j)
                        mmt= mbt*ffc(i)*ffe(j)
                        call indent(j, ddles, ddlem, nnes, jjn)
                        jj = jjn+k
                        jescl(2)=xcalc_heav(heavn(j),&
                                            hea_fa(1),&
                                            heavn(nfhe*nne+nfhm*nnm+j))
                        mmat(ii,jj) = mmat(ii,jj)-jescl(1)*mm
                        mmat(jj,ii) = mmat(jj,ii)-jescl(1)*mmt
                        jj = jj + ndim
                        mmat(ii,jj) = mmat(ii,jj)-jescl(2)*mm
                        mmat(jj,ii) = mmat(jj,ii)-jescl(2)*mmt
                        do alpj = 1, nsinge*ndim
                            jj = jjn + (1+nfhe+1-1)*ndim + alpj
                            mmat(ii,jj) = mmat(ii,jj)+mb*ffc(i)*fk_escl(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)+mbt*ffc(i)*fk_escl(j,alpj,k)
                        end do
                    end do
                    do j = 1, nnm
! --- BLOCS MA:CONT, CONT:MA
                        mm = mb*ffc(i)*ffm(j)
                        mmt= mbt*ffc(i)*ffm(j)
                        call indent(j, ddlms, ddlmm, nnms, jjn)
                        jj = ddle + jjn + k
                        jmait(2)=xcalc_heav(heavn(nne+j),&
                                            hea_fa(2),&
                                            heavn((1+nfhe)*nne+nfhm*nnm+j))
                        mmat(ii,jj) = mmat(ii,jj)+jmait(1)*mm
                        mmat(jj,ii) = mmat(jj,ii)+jmait(1)*mmt
                        jj = jj + ndim
                        mmat(ii,jj) = mmat(ii,jj)+jmait(2)*mm
                        if (.not.lpenaf) mmat(jj,ii) = mmat(jj,ii)+jmait(2)*mmt
                        do alpj = 1, nsingm*ndim
                            jj = jjn + (1+nfhm+1-1)*ndim + alpj
                            mmat(ii,jj) = mmat(ii,jj)+mb*ffc(i)*fk_mait(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)+mbt*ffc(i)*fk_mait(j,alpj,k)
                        end do
                    end do
                end do
            end do
        end do
!
! --------------------- CALCUL DE [BU] ---------------------------------
!
        do k = 1, ndim
            do l = 1, ndim
                if (lpenaf) then
                    mb = -mp*coeffp*e(l,k)
                    mbt = -mp*coeffp*e(l,k)
                else
                    if (nconta .eq. 3 .and. ndim .eq. 3) then
                        mb = -mp*coeffr*e(l,k)+coefcr*coefff*hpg* jacobi*c(l,k)
                        mbt = -mp*coeffr*e(l,k)+coefcr*coefff*hpg* jacobi*c(l,k)
                    else
                        mb = -mp*coeffr*e(l,k)
                        mbt = -mp*coeffr*e(l,k)
                    endif
                endif
                do i = 1, ndeple
                    iescl(2)=xcalc_heav(heavn(i),&
                                        hea_fa(1),&
                                        heavn(nfhe*nne+nfhm*nnm+i))
                    do j = 1, ndeple
                        jescl(2)=xcalc_heav(heavn(j),&
                                            hea_fa(1),&
                                            heavn(nfhe*nne+nfhm*nnm+j))
! --- BLOCS ES:ES
                        mm = mb *ffe(i)*ffe(j)
                        mmt= mbt*ffe(i)*ffe(j)
                        call indent(i, ddles, ddlem, nnes, iin)
                        call indent(j, ddles, ddlem, nnes, jjn)
                        ii = iin + l
                        jj = jjn + k
                        mmat(ii,jj) = mmat(ii,jj)+iescl(1)*jescl(1)*mm
                        jj = jj + ndim
                        mmat(ii,jj) = mmat(ii,jj)+iescl(1)*jescl(2)*mm
                        mmat(jj,ii) = mmat(jj,ii)+iescl(1)*jescl(2)*mmt
                        ii = ii + ndim
                        mmat(ii,jj) = mmat(ii,jj)+iescl(2)*jescl(2)*mm
                        do alpj = 1, nsinge*ndim
                            jj = jjn + (1+nfhe+1-1)*ndim + alpj
                            ii = iin + l
                            mmat(ii,jj) = mmat(ii,jj)-iescl(1)*mb*ffe(i)*fk_escl(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)-iescl(1)*mbt*ffe(i)*fk_escl(j,alpj,k)
                            ii = ii + ndim
                            mmat(ii,jj) = mmat(ii,jj)-iescl(2)*mb*ffe(i)*fk_escl(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)-iescl(2)*mbt*ffe(i)*fk_escl(j,alpj,k)
                            do alpi = 1, nsinge*ndim 
                                ii = iin + (1+nfhe+1-1)*ndim + alpi
                                mmat(ii,jj) = mmat(ii,jj)+mb*fk_escl(i,alpi,l)*fk_escl(j,alpj,k)
                            enddo
                        end do
                    end do
                    do j = 1, nnm
                        jmait(2)=xcalc_heav(heavn(nne+j),&
                                            hea_fa(2),&
                                            heavn((1+nfhe)*nne+nfhm*nnm+j))
! --- BLOCS ES:MA, MA:ES
                        mm = mb *ffe(i)*ffm(j)
                        mmt= mbt*ffe(i)*ffm(j)
                        call indent(i, ddles, ddlem, nnes, iin)
                        call indent(j, ddlms, ddlmm, nnms, jjn)
                        ii = iin + l
                        jj = ddle + jjn + k
                        mmat(ii,jj) = mmat(ii,jj)-iescl(1)*jmait(1)*mm
                        mmat(jj,ii) = mmat(jj,ii)-iescl(1)*jmait(1)*mmt
                        jj = jj + ndim
                        mmat(ii,jj) = mmat(ii,jj)-iescl(1)*jmait(2)*mm
                        mmat(jj,ii) = mmat(jj,ii)-iescl(1)*jmait(2)*mmt
                        ii = ii + ndim
                        jj = jj - ndim
                        mmat(ii,jj) = mmat(ii,jj)-iescl(2)*jmait(1)*mm
                        mmat(jj,ii) = mmat(jj,ii)-iescl(2)*jmait(1)*mmt
                        jj = jj + ndim
                        mmat(ii,jj) = mmat(ii,jj)-iescl(2)*jmait(2)*mm
                        mmat(jj,ii) = mmat(jj,ii)-iescl(2)*jmait(2)*mmt
                        do alpj = 1, nsingm*ndim
                            ii = iin + l
                            jj = ddle + jjn + (1+nfhm+1-1)*ndim + alpj
                            mmat(ii,jj) = mmat(ii,jj)-iescl(1)*mb*ffe(i)*fk_mait(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)-iescl(1)*mbt*ffe(i)*fk_mait(j,alpj,k)
                            ii = ii + ndim
                            mmat(ii,jj) = mmat(ii,jj)-iescl(2)*mb*ffe(i)*fk_mait(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)-iescl(2)*mbt*ffe(i)*fk_mait(j,alpj,k)
                        end do
                        do alpi = 1, nsinge*ndim
                            ii = iin + (1+nfhm+1-1)*ndim + alpi
                            jj = ddle + jjn + k
                            mmat(ii,jj) = mmat(ii,jj)+jmait(1)*mb*ffm(j)*fk_escl(i,alpi,l)
                            mmat(jj,ii) = mmat(jj,ii)+jmait(1)*mbt*ffm(j)*fk_escl(i,alpi,l)
                            jj = jj + ndim
                            mmat(ii,jj) = mmat(ii,jj)+jmait(2)*mb*ffm(j)*fk_escl(i,alpi,l)
                            mmat(jj,ii) = mmat(jj,ii)+jmait(2)*mbt*ffm(j)*fk_escl(i,alpi,l)
                        end do
                        do alpi = 1, nsinge*ndim
                            do alpj = 1, nsingm*ndim
                                ii = iin + (1+nfhm+1-1)*ndim + alpi
                                jj = ddle + jjn + (1+nfhm+1-1)*ndim + alpj
                                mmat(ii,jj) = mmat(ii,jj)+mb*fk_escl(i,alpi,l)*fk_mait(j,alpj,k)
                                mmat(jj,ii) = mmat(jj,ii)+mbt*fk_escl(i,alpi,l)*fk_mait(j,alpj,k)
                            enddo
                        end do
                    end do
                end do
                do i = 1, nnm
                    imait(2)=xcalc_heav(heavn(nne+i),&
                                        hea_fa(2),&
                                        heavn((1+nfhe)*nne+nfhm*nnm+i))  
                    do j = 1, nnm
                        jmait(2)=xcalc_heav(heavn(nne+j),&
                                            hea_fa(2),&
                                            heavn((1+nfhe)*nne+nfhm*nnm+j))
! --- BLOCS MA:MA
                        mm = mb *ffm(i)*ffm(j)
                        mmt= mbt*ffm(i)*ffm(j)
                        call indent(i, ddlms, ddlmm, nnms, iin)
                        call indent(j, ddlms, ddlmm, nnms, jjn)
                        ii = ddle + iin + l
                        jj = ddle + jjn + k
                        mmat(ii,jj) = mmat(ii,jj)+imait(1)*jmait(1)*mm
                        jj = jj + ndim
                        mmat(ii,jj) = mmat(ii,jj)+imait(1)*jmait(2)*mm
                        mmat(jj,ii) = mmat(jj,ii)+imait(1)*jmait(2)*mmt
                        ii = ii + ndim
                        mmat(ii,jj) = mmat(ii,jj)+imait(2)*jmait(2)*mm
                        do alpj = 1, nsingm*ndim
                            jj = ddle + jjn + (1+nfhm+1-1)*ndim + alpj
                            ii = ddle + iin + l
                            mmat(ii,jj) = mmat(ii,jj)+imait(1)*mb*ffm(i)*fk_mait(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)+imait(1)*mbt*ffm(i)*fk_mait(j,alpj,k)
                            ii = ii + ndim
                            mmat(ii,jj) = mmat(ii,jj)+imait(2)*mb*ffm(i)*fk_mait(j,alpj,k)
                            mmat(jj,ii) = mmat(jj,ii)+imait(2)*mbt*ffm(i)*fk_mait(j,alpj,k)
                            do alpi = 1, nsingm*ndim 
                                ii = ddle + iin + (1+nfhm+1-1)*ndim + alpi
                                mmat(ii,jj) = mmat(ii,jj)+mb*fk_mait(i,alpi,l)*fk_mait(j,alpj,k)
                            enddo
                        end do
                    end do
                end do
            end do
        end do
!
    else
!
! --------------------- CALCUL DE [A] ET [B] -----------------------
!
        do l = 1, ndim
            do k = 1, ndim
                if (l .eq. 1) then
                    mb = 0.d0
                    mbt = coefff*hpg*jacobi*a(l,k)
                else
                    if (.not.lpenaf) then
                        if (nconta .eq. 3 .and. ndim .eq. 3) then
                            mb = nvit*jacobi*hpg*a(l,k)
                        else
                            mb = nvit*mp*a(l,k)
                        endif
                    endif
                    if (lpenaf) mb = 0.d0
                    if (.not.lpenaf) mbt = mp*a(l,k)
                    if (lpenaf) mbt = 0.d0
                endif
                do i = 1, nnc
                    call xplma2(ndim, nne, nnes, ddles, i,&
                                nfhe, pli)
                    ii = pli+l-1
                    do j = 1, ndeple
! --- BLOCS ES:CONT, CONT:ES
                        mm = mb *ffc(i)
                        mmt= mbt*ffc(i)
                        call indent(j, ddles, ddlem, nnes, jjn)
                        do alpj = 1, nsinge*ndim
                           jj = jjn + alpj
                           mmat(ii,jj) = mmat(ii,jj)+mm*fk_escl(j,alpj,k)
                           if (.not.lpenaf) mmat(jj,ii) = mmat(jj,ii)+mmt*fk_escl(j,alpj,k)
                        enddo
                    end do
                end do
            end do
        end do
!
! --------------------- CALCUL DE [BU] ---------------------------------
!
        do k = 1, ndim
            do l = 1, ndim
                if (lpenaf) then
                    mb = -mp*coeffp*e(l,k)
                else
                    if (nconta .eq. 3 .and. ndim .eq. 3) then
                        mb = -mp*coeffr*e(l,k)+coefcr*coefff*hpg* jacobi*c(l,k)
                    else
                        mb = -mp*coeffr*e(l,k)
                    endif
                endif
                do i = 1, ndeple
                    do j = 1, ndeple
! --- BLOCS ES:ES
                        mm = mb *ffe(i)*ffe(j)
                        call indent(i, ddles, ddlem, nnes, iin)
                        call indent(j, ddles, ddlem, nnes, jjn)
                        do alpj = 1, nsinge*ndim
                            do alpi = 1, nsinge*ndim
                                ii = iin + alpi
                                jj = jjn + alpj
                                mmat(ii,jj) = mmat(ii,jj)+mb * fk_escl(i,alpi,l)*fk_escl(j,alpj,k)
                            enddo
                        enddo
                    end do
                end do
            end do
        end do
    endif
! --------------------- CALCUL DE [F] ----------------------------------
!
! ---------------SEULEMENT EN METHODE PENALISEE-------------------------
    if (lpenaf) then
        if (nvit .eq. 1) then
            do i = 1, nnc
                do j = 1, nnc
                    call xplma2(ndim, nne, nnes, ddles, i,&
                                nfhe, pli)
                    call xplma2(ndim, nne, nnes, ddles, j,&
                                nfhe, plj)
                    do l = 1, ndim-1
                        do k = 1, ndim-1
                            ii = pli+l
                            jj = plj+k
                            mmat(ii,jj) = mmat(ii,jj)+ffc(i)*ffc(j)*hpg*jacobi*tt( l,k)
                        end do
                    end do
                end do
            end do
        endif
    endif
! ------------------- CALCUL DE [E] ------------------------------------
!
! ------------- COUPLAGE MULTIPLICATEURS CONTACT-FROTTEMENT ------------
    if (nvit .eq. 1) then
        do i = 1, nnc
            do j = 1, nnc
                call xplma2(ndim, nne, nnes, ddles, i,&
                            nfhe, pli)
                call xplma2(ndim, nne, nnes, ddles, j,&
                            nfhe, plj)
                do k = 1, ndim-1
                    ii = pli+k
                    jj = plj
                    if (lpenaf) then
                        mmat(ii,jj) = mmat(ii,jj)+0.d0
                    else
                        if (nconta .eq. 3 .and. ndim .eq. 3) then
                            mmat(ii,jj) = mmat(ii,jj)+0.d0
                        else
                            mmat(ii,jj) = mmat(ii,jj)-ffc(i)*ffc(j)*coefff*hpg* jacobi*v(k)
                        endif
                    endif
                end do
            end do
        end do
    endif
!
end subroutine
