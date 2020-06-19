! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W1306,W1504,W1501
!
subroutine nmplgs(ndim, nno1, vff1, idfde1, nno2,&
                  vff2, idfde2, npg, iw, geom,&
                  typmod, option, mate, compor, carcri,&
                  instam, instap, angmas, ddlm, ddld,&
                  sigm, lgpg, vim, sigp, vip,&
                  matr, vect, codret, dfdi2, livois,&
                  nbvois, numa, lisoco, nbsoco,&
                  lVari, lSigm, lMatr, lVect)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cavini.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsb.h"
#include "asterfort/nmepsi.h"
#include "asterfort/nmmabu.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/tecach.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
#include "blas/dspev.h"
!
! --------------------------------------------------------------------------------------------------
!
! CALCUL  RAPH_MECA, RIGI_MECA_* ET FULL_MECA_* POUR GRAD_SIGM(2D ET 3D)
!
! --------------------------------------------------------------------------------------------------
!
! IN  NDIM    : DIMENSION DES ELEMENTS
! IN  NNO1    : NOMBRE DE NOEUDS (FAMILLE U)
! IN  VFF1    : VALEUR DES FONCTIONS DE FORME (FAMILLE U)
! IN  IDFDE1  : DERIVEES DES FONCTIONS DE FORME DE REFERENCE (FAMILLE U)
! IN  NNO2    : NOMBRE DE NOEUDS (FAMILLE E)
! IN  VFF2    : VALEUR DES FONCTIONS DE FORME (FAMILLE E)
! IN  IDFDE2  : DERIVEES DES FONCTIONS DE FORME DE REFERENCE (FAMILLE E)
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  IW      : POIDS DES POINTS DE GAUSS DE REFERENCE (INDICE)
! IN  GEOM    : COORDONNEES DES NOEUDS
! IN  TYPMOD  : TYPE DE MODEELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  MATE   : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
! IN  INSTAM  : INSTANT PRECEDENT
! IN  INSTAP  : INSTANT DE CALCUL
! IN  DDLM    : DDL A L'INSTANT PRECEDENT
! IN  DDLD    : INCREMENT DES DDL
! IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
! IN  LGPG    : LONGUEUR DU TABLEAU DES VARIABLES INTERNES
! IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
! IN  ANGMAS  : REPERE LOCAL 3D
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA   ET FULL_MECA_*)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA   ET FULL_MECA_*)
! OUT MATR    : MATRICE DE RIGIDITE   (RIGI_MECA_* ET FULL_MECA_*)
! OUT VECT    : FORCES INTERIEURES    (RAPH_MECA   ET FULL_MECA_*)
! OUT CODRET  : CODE RETOUR
!
! --------------------------------------------------------------------------------------------------
!
    common  /trucit/iteamm
    character(len=8) :: typmod(*), fami, poum
    character(len=16) :: option, compor(*)
    integer :: nbvois, nvoima, numav, iret, nscoma, iteamm
    integer(kind=4) :: reuss
    parameter(nvoima=12,nscoma=4)
    integer :: ndim, nno1, nno2, npg, idfde1, idfde2, iw, mate, lgpg, codret
    integer :: livois(1:nvoima), numa
    integer :: nbsoco(1:nvoima), lisoco(1:nvoima, 1:nscoma, 1:2)
    real(kind=8) :: vff1(nno1, npg), vff2(nno2, npg), geom(ndim, nno1)
    real(kind=8) :: carcri(*), instam, instap
    real(kind=8) :: ddlm(*), ddld(*), sigm(2*ndim, npg), sigp(2*ndim, npg)
    real(kind=8) :: vim(lgpg, npg), vip(lgpg, npg), matr(*), vect(*)
    real(kind=8) :: dfdi2(nno2, ndim), angmas(3), compar
    integer :: k2(1), kpg, spt
    aster_logical :: grand, axi
    integer :: ndimsi, nddl, g, gg, cod(npg), n, i, m, j, kl, pq, os, kk, vivois
    integer :: iu(3, 27), ie(6, 8), kvois, ll
    integer :: nfin, vrarr(nno2), nn, nnn, vivonu, kvoinu, nini, nunu
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8) :: lc(1), c, deplm(3*27), depld(3*27), dfdi1(27, 3), nono
    real(kind=8) :: r, wg, epsgm(6, 2), epsgd(6, 2), gepsm(6, 3), geps(6, 3)
    real(kind=8) :: f(3, 3)
    real(kind=8) :: b(6, 3, 27), de(6), sigma(6), dsidep(6, 6, 2), t1, t2
    real(kind=8) :: p(6, 6), sigmam(6), epsrss(6), sigell(6), dist(nno2, 2)
    real(kind=8) :: z(3, 3), w(3), work(9), bary(ndim), baryo(ndim), scal(3)
    real(kind=8) :: dirr(ndim)
    type(Behaviour_Integ) :: BEHinteg
    aster_logical, intent(in) :: lVari, lSigm, lMatr, lVect
!
! --------------------------------------------------------------------------------------------------
!
    grand  = ASTER_FALSE
    axi    = ASTER_FALSE
    ndimsi = 2*ndim
    nddl   = nno1*ndim + nno2*ndimsi
    cod    = 0
!
! - Get length
!
    fami   = 'FPG1'
    kpg    = 1
    spt    = 1
    poum   = '+'
    call rcvalb(fami, kpg, spt, poum, mate,&
                ' ', 'NON_LOCAL', 0, ' ', [0.d0],&
                1, 'LONG_CARA', lc, k2, 1)
    c = lc(1)**2
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
! INITIALISATION CAVINI + INCREMENTATION
! DU COMPTEUR D'ITERATION + L ELEMENT EST-IL POINTE?
    call cavini(ndim, nno2, geom, vim, npg,&
                lgpg, mate)
!
    nono=0.d0
    nini=0
!
100 continue
!
    nunu=0
!
    if (lVari) then
        if (nini .eq. 0) then
            do gg = 1, npg
                vip(8,gg) = vip(8,gg)+1.0d0
            end do
        endif
!
        do kvois = 1, nbvois
!
            numav=livois(kvois)
            call tecach('OOO', 'PVARIMP', 'L', iret, iad=vivois, numa=numav)
            ASSERT(iret.eq.0)
!
            if (nint(zr(vivois-1+5)) .eq. numa) then
                if (zr(vivois-1+7) .lt. vip(8,1)) then
                    vivonu=vivois
                    kvoinu=kvois
                    if (nint(vip(2,1)) .eq. 0) then
                        do gg = 1, npg
                            vip(2,gg)=1.d0
                        end do
                    endif
                    if (nint(vip(2,1)) .eq. 1) then
                        bary(1)=zr(vivonu-1+9)
                        bary(2)=zr(vivonu-1+10)
                        baryo(1)=zr(vivonu-1+11)
                        baryo(2)=zr(vivonu-1+12)
                    endif
                endif
            endif
!
            if (nint(zr(vivois-1+6)) .eq. numa) then
                if (zr(vivois-1+7) .lt. vip(8,1)) then
                    vivonu=vivois
                    kvoinu=kvois
                    if (nint(vip(2,1)) .eq. 0) then
                        do gg = 1, npg
                            vip(2,gg)=1.0d0
                        end do
                    endif
                    if (nint(vip(2,1)) .eq. 1) then
                        bary(1)=zr(vivonu-1+11)
                        bary(2)=zr(vivonu-1+12)
                        baryo(1)=zr(vivonu-1+9)
                        baryo(2)=zr(vivonu-1+10)
                    endif
                endif
            endif
        end do
!
        call r8inir(6, 0.d0, epsrss, 1)
        if (nint(vip(2,1)) .eq. 0) then
            do kl = 1, ndimsi
                do i = 1, nno2
                    ll=kl+ndim+((i-1)*(ndim+ndimsi))
                    epsrss(kl)=epsrss(kl)+ddlm(ll)/dble(nno2)
                    epsrss(kl)=epsrss(kl)+ddld(ll)/dble(nno2)
                end do
            end do
            call dscal(ndimsi-3, 1.d0/rac2, epsrss(4), 1)
        endif
!
        if (nint(vip(2,1)) .eq. 1) then
            scal(1)=0
            scal(2)=0
            scal(3)=0
            do n = 1, nbsoco(kvoinu)
                pq=lisoco(kvoinu,n,1)
                do i = 1, ndim
                    scal(n)=scal(n)+(geom(i,pq)-bary(i))**2.d0
                end do
            end do
            scal(1)=sqrt(scal(1))
            scal(2)=sqrt(scal(2))
            scal(3)=scal(1)+scal(2)
            do kl = 1, ndimsi
                do i = 1, nbsoco(kvoinu)
                    pq=lisoco(kvoinu,i,1)
                    ll=kl+ndim+((pq-1)*(ndim+ndimsi))
                    epsrss(kl)=epsrss(kl)+(1.0d0-scal(i)/scal(3))*ddlm(ll)
                    epsrss(kl)=epsrss(kl)+(1.0d0-scal(i)/scal(3))*ddld(ll)
                end do
            end do
            call dscal(ndimsi-3, 1.d0/rac2, epsrss(4), 1)
        endif
!
        sigell(1) = epsrss(1)
        sigell(2) = epsrss(4)
        sigell(3) = epsrss(2)
        sigell(4) = epsrss(5)
        sigell(5) = epsrss(6)
        sigell(6) = epsrss(3)
!
        call dspev('V', 'U', 3, sigell, w,&
                   z, 3, work, reuss)
!
        if (nini .eq. 0) then
            do i = 1, ndim
                dirr(i)=z(i,3)
            end do
        endif
!
        if (nint(vip(2,1)) .eq. 1) then
            if (w(3) .gt. vim(4,1)) then
                do i = 1, npg
                    vip(2,i)=3.d0
                    vip(7,i)=vip(8,i)
                end do
            endif
        endif
!
        if (nint(vip(2,1)) .eq. 0) then
            if (w(3) .gt. vim(3,1)) then
                if (nint(vip(8,1)) .gt. iteamm) then
                    iteamm=nint(vip(8,1))
                else
                    iteamm=0
                    nono=1.d0
                endif
                do i = 1, npg
                    vip(2,i)=2.d0
                    vip(7,i)=vip(8,i)
                end do
            endif
        endif
!
        if (nint(vip(7,1)) .eq. nint(vip(8,1))) then
!
            nnn=5
!
            if (nint(vip(2,1)) .eq. 2) then
                bary(1)=0.d0
                bary(2)=0.d0
                do i = 1, ndim
                    bary(i)=0
                    do n = 1, nno2
                        bary(i)=bary(i)+geom(i,n)/nno2
                    end do
                end do
            endif
!
            do n = 1, nno2
                nfin=n+1
                if (nfin .gt. nno2) then
                    nfin=nfin-nno2
                endif
                scal(1)=0
                scal(2)=0
                scal(3)=0
                do i = 1, ndim
                    scal(1)=scal(1)+dirr(i)*(geom(i,n)-bary(i))
                    scal(2)=scal(2)+dirr(i)*(geom(i,nfin)-bary(i))
                end do
                scal(3)=scal(1)*scal(2)
                if (scal(3) .lt. 0.d0) then
                    vrarr(n)=1
                else
                    vrarr(n)=0
                endif
            end do
!
            if (nint(vip(2,1)) .eq. 2) then
!
                do n = 1, nno2
                    nfin=n+1
                    if (nfin .gt. nno2) then
                        nfin=nfin-nno2
                    endif
                    dist(n,1)=0.d0
                    dist(n,2)=0.d0
                    if (vrarr(n) .eq. 1) then
                        scal(1)=0.d0
                        scal(2)=0.d0
                        scal(3)=0.d0
                        do i = 1, ndim
                            scal(1)=scal(1)+dirr(i)*(geom(i,n)-bary(i))
                            scal(2)=scal(2)+dirr(i)*(geom(i,nfin)-bary(i))
                        end do
                        scal(1)=sqrt(scal(1)**2.d0)
                        scal(2)=sqrt(scal(2)**2.d0)
                        scal(3)=scal(1)+scal(2)
                        dist(n,1)= dist(n,1)+scal(2)*dirr(2)*(geom(1,n)-bary(1))
                        dist(n,1)= dist(n,1)+scal(1)*dirr(2)*(geom(1,nfin)-bary(1))
                        dist(n,1)= dist(n,1)-scal(2)*dirr(1)*(geom(2,n)-bary(2))
                        dist(n,1)= dist(n,1)-scal(1)*dirr(1)*(geom(2,nfin)-bary(2))
                        dist(n,1)=dist(n,1)/scal(3)
                    endif
                end do
!
                do n = 1, nno2
                    nfin=n+1
                    if (nfin .gt. nno2) then
                        nfin=nfin-nno2
                    endif
                    if (vrarr(n) .eq. 1) then
                        do kvois = 1, nbvois
                            nn=0
                            do i = 1, nbsoco(kvois)
                                if (lisoco(kvois,i,1) .eq. n) nn=nn+1
                                if (lisoco(kvois,i,1) .eq. nfin) nn=nn+ 1
                            end do
                            if (nn .eq. 2) then
                                do gg = 1, npg
                                    vip(nnn,gg)=livois(kvois)
                                    vip(2*nnn-1,gg)=bary(1)+dist(n,1)*dirr(2)
                                    vip(2*nnn,gg)=bary(2)-dist(n,1)*dirr(1)
                                end do
                                nnn=nnn+1
                            endif
                        end do
                    endif
                end do
            endif
!
            if (nint(vip(2,1)) .eq. 3) then
                compar=0.d0
                do n = 1, nno2
                    nfin=n+1
                    if (nfin .gt. nno2) then
                        nfin=nfin-nno2
                    endif
                    dist(n,1)=0.d0
                    dist(n,2)=0.d0
                    if (vrarr(n) .eq. 1) then
                        scal(1)=0.d0
                        scal(2)=0.d0
                        scal(3)=0.d0
                        do i = 1, ndim
                            scal(1)=scal(1)+dirr(i)*(geom(i,n)-bary(i))
                            scal(2)=scal(2)+dirr(i)*(geom(i,nfin)-bary(i))
                        end do
                        scal(1)=sqrt(scal(1)**2.d0)
                        scal(2)=sqrt(scal(2)**2.d0)
                        scal(3)=scal(1)+scal(2)
                        dist(n,1)= dist(n,1)+scal(2)*dirr(2)*(geom(1,n)-bary(1))
                        dist(n,1)= dist(n,1)+scal(1)*dirr(2)*(geom(1,nfin)-bary(1))
                        dist(n,1)= dist(n,1)-scal(2)*dirr(1)*(geom(2,n)-bary(2))
                        dist(n,1)= dist(n,1)-scal(1)*dirr(1)*(geom(2,nfin)-bary(2))
                        dist(n,1)=dist(n,1)/scal(3)
                        dist(n,2)=dist(n,1)*dist(n,1)
                        compar=compar+dist(n,2)/2.d0
                    endif
                end do
!
                do n = 1, nno2
                    if (dist(n,2) .gt. compar) then
                        vrarr(n)=1
                    else
                        vrarr(n)=0
                    endif
                end do
                scal(1)=0.d0
                scal(2)=0.d0
                scal(3)=0.d0
                do n = 1, nno2
                    nfin=n+1
                    if (nfin .gt. nno2) then
                        nfin=nfin-nno2
                    endif
                    if (vrarr(n) .eq. 1) then
                        do kvois = 1, nbvois
                            nn=0
                            do i = 1, nbsoco(kvois)
                                if (lisoco(kvois,i,1) .eq. n) nn=nn+1
                                if (lisoco(kvois,i,1) .eq. nfin) nn=nn+ 1
                            end do
                            if (nn .eq. 2) then
                                do gg = 1, npg
                                    vip(5,gg)=livois(kvois)
                                    vip(9,gg)=bary(1)+dist(n,1)*dirr(2)
                                    vip(10,gg)=bary(2)-dist(n,1)*dirr(1)
                                    vip(11,gg)=bary(1)
                                    vip(12,gg)=bary(2)
                                end do
                                scal(1)=bary(1)+dist(n,1)*dirr(2)
                                scal(2)=bary(2)-dist(n,1)*dirr(1)
                                nunu=1
                                nnn=nnn+1
                            endif
                        end do
                    endif
                end do
                nini=0
                if (nunu .eq. 1) then
                    scal(3)=(scal(1)-bary(1))*(bary(1)-baryo(1))
                    scal(3)=scal(3)+(scal(2)-bary(2))*(bary(2)-baryo(2))
                    if (scal(3) .lt. 0.d0) then
                        scal(3)=0.d0
                        scal(3)=scal(3)+(baryo(2)-bary(2))**(2.d0)
                        scal(3)=scal(3)+(bary(1)-baryo(1))**(2.d0)
                        scal(3)=scal(3)**(0.5d0)
                        dirr(1)=(baryo(2)-bary(2))/scal(3)
                        dirr(2)=(bary(1)-baryo(1))/scal(3)
                        nini=1
                    endif
                endif
!
            endif
!
        endif
    endif
!
    if (nini .eq. 1) goto 100 
! IL FAUDRA PREVOIR DE POUVOIR SORTIR DU DOMAINE GEOMETRIQUE ADMIS
!  AVEC UN CODRET = 2
!
!
!
    if (lMatr) then
        call r8inir(nddl*nddl, 0.d0, matr, 1)
    endif
    if (lVect) then
        call r8inir(nddl, 0.d0, vect, 1)
    endif
    call r8inir(6, 0.d0, sigmam, 1)
!
!    POSITION DES INDICES POUR LES DEPLACEMENTS ET LES DEFORMATIONS
!
    do n = 1, nno2
        do i = 1, ndim
            iu(i,n) = i + (n-1)*(ndim+ndimsi)
        end do
        do kl = 1, ndimsi
            ie(kl,n) = kl + ndim + (n-1)*(ndim+ndimsi)
        end do
    end do
    os = (ndimsi+ndim)*nno2
    do n = 1, nno1-nno2
        do i = 1, ndim
            iu(i,n+nno2) = i + (n-1)*ndim + os
        end do
    end do
!
!
!    EXTRACTION DES DEPLACEMENTS
!
    do n = 1, nno1
        do i = 1, ndim
            deplm(i+(n-1)*ndim) = ddlm(iu(i,n))
            depld(i+(n-1)*ndim) = ddld(iu(i,n))
        end do
    end do
!
! - CALCUL POUR CHAQUE POINT DE GAUSS
!
    do g = 1, npg
!
!      CALCUL DES ELEMENTS GEOMETRIQUES DE L'EF POUR E-BARRE
!
        call dfdmip(ndim, nno2, axi, geom, g,&
                    iw, vff2(1, g), idfde2, r, wg,&
                    dfdi2)
        call nmepsb(ndim, nno2, axi, vff2(1, g), dfdi2,&
                    ddlm, epsgm(1, 2), gepsm)
        call nmepsb(ndim, nno2, axi, vff2(1, g), dfdi2,&
                    ddld, epsgd(1, 2), geps)
!
!      CALCUL DES ELEMENTS GEOMETRIQUES DE L'EF POUR U
!
        call dfdmip(ndim, nno1, axi, geom, g,&
                    iw, vff1(1, g), idfde1, r, wg,&
                    dfdi1)
        call nmepsi(ndim, nno1, axi, grand, vff1(1, g),&
                    r, dfdi1, deplm, f, epsgm)
        call nmepsi(ndim, nno1, axi, grand, vff1(1, g),&
                    r, dfdi1, depld, f, epsgd)
        call nmmabu(ndim, nno1, axi, grand, dfdi1,&
                    b)
!
!      DEFORMATIONS ET ECARTS EN FIN DE PAS DE TEMPS
!
        call daxpy(18, 1.d0, gepsm, 1, geps, 1)
        do  kl = 1, ndimsi
            de(kl) = epsgm(kl,2)+epsgd(kl,2)
        end do
!
!      LOI DE COMPORTEMENT
!
        call dcopy(ndimsi, sigm(1, g), 1, sigmam, 1)
        call dscal(3, rac2, sigmam(4), 1)
        call r8inir(36, 0.d0, p, 1)
        if (nono .gt. 0.d0) then
            cod(g) = 1
            goto 999
        endif
!
        call nmcomp(BEHinteg,&
                    'RIGI', g, 1, ndim, typmod,&
                    mate, compor, carcri, instam, instap,&
                    12, epsgm, epsgd, 6, sigmam,&
                    vim(1, g), option, angmas, &
                    sigma, vip(1, g), 72, dsidep, cod(g))
        if (cod(g) .eq. 1) then
            goto 999
        endif
!
        call r8inir(6, 1.d0, p, 7)
! ----- Internal forces
        if (lVect) then
!        VECTEUR FINT:U
            do n = 1, nno1
                do i = 1, ndim
                    kk = iu(i,n)
                    t1 = 0
                    do kl = 1, ndimsi
                        t1 = t1 + sigma(kl)*b(kl,i,n)
                    end do
                    vect(kk) = vect(kk) + wg*t1
                end do
            end do
            do n = 1, nno2
                do kl = 1, ndimsi
                    kk = ie(kl,n)
                    t1 = 0
                    do pq = 1, ndimsi
                        t1 = t1 + p(kl,pq)*de(pq)*vff2(n,g)
                        t1 = t1 - p(kl,pq)*sigma(pq)*vff2(n,g)
                    end do
                    t2 = 0
                    do i = 1, ndim
                        do pq = 1, ndimsi
                            t2 = t2 + c*dfdi2(n,i)*p(kl,pq)*geps(pq,i)
                        end do
                    end do
                    vect(kk) = vect(kk) + wg*(t1+t2)
                end do
            end do
        endif
! ----- Stress
        if (lSigm) then
            call dcopy(ndimsi, sigma, 1, sigp(1, g), 1)
            call dscal(ndimsi-3, 1.d0/rac2, sigp(4, g), 1)
        endif
! ----- Rigidity matrix
        if (lMatr) then
!        MATRICE K:U(I,N),U(J,M)
            do n = 1, nno1
                do i = 1, ndim
                    os = nddl*(iu(i,n)-1)
                    do m = 1, nno1
                        do j = 1, ndim
                            kk = os+iu(j,m)
                            t1 = 0
                            do kl = 1, ndimsi
                                do pq = 1, ndimsi
                                    t1 = t1 + dsidep(kl,pq,1)*b(pq,j, m)*b(kl,i,n)
                                end do
                            end do
                            matr(kk) = matr(kk) + wg*t1
                        end do
                    end do
!        MATRICE K:U(I,N),E(PQ,M)
                    do m = 1, nno2
                        do pq = 1, ndimsi
                            kk = os+ie(pq,m)
                            t1 = 0
                            matr(kk) = matr(kk) + wg*t1
                        end do
                    end do
                end do
            end do
!        MATRICE K:E(KL,N),U(J,M)
            do n = 1, nno2
                do kl = 1, ndimsi
                    os = nddl*(ie(kl,n)-1)
                    do m = 1, nno1
                        do j = 1, ndim
                            kk = os+iu(j,m)
                            t1 = 0
                            do pq = 1, ndimsi
                                t1=t1 - dsidep(kl,pq,1)*b(pq,j,m)*&
                                vff2(n,g)
                            end do
                            matr(kk) = matr(kk) + wg*t1
                        end do
                    end do
                end do
            end do
!        MATRICE K:E(KL,N),E(PQ,M)
            do n = 1, nno2
                do m = 1, nno2
                    t1 = vff2(n,g)*vff2(m,g)
                    do i = 1, ndim
                        t1 = t1 + c*dfdi2(n,i)*dfdi2(m,i)
                    end do
                    do kl = 1, ndimsi
                        do pq = 1, ndimsi
                            kk = (ie(kl,n)-1)*nddl + ie(pq,m)
                            matr(kk) = matr(kk) + wg*t1*p(kl,pq)
                        end do
                    end do
                end do
            end do
        endif
    end do
!
! - SYNTHESE DES CODES RETOUR
!
999 continue
!
    call codere(cod, npg, codret)
!
end subroutine
