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
! aslint: disable=W1306,W1504
!
subroutine xxnmgr(elrefp, elrese, ndim, coorse, igeom,&
                  he, nfh, ddlc, ddlm, nfe,&
                  instam, instap, ideplp, sigm, vip,&
                  basloc, nnop, npg, typmod, option,&
                  imate, compor, lgpg, idecpg, carcri,&
                  idepl, lsn, lst, nfiss, heavn,&
                  sigp, vi, matuu, ivectu, codret, jstno,&
                  lMatr, lVect, lSigm)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/indent.h"
#include "asterfort/matinv.h"
#include "asterfort/nmcomp.h"
#include "asterfort/reeref.h"
#include "asterfort/utmess.h"
#include "asterfort/xcinem.h"
#include "asterfort/xcalc_code.h"
#include "asterfort/xcalc_heav.h"
#include "asterfort/xcalfev_wrap.h"
#include "asterfort/xkamat.h"
#include "asterfort/iimatu.h"
#include "asterfort/iipff.h"
#include "asterfort/xnbddl.h"
#include "asterfort/Behaviour_type.h"
!
integer :: ndim, igeom, imate, lgpg, codret, nnop, npg
integer :: nfiss, heavn(nnop, 5), idecpg
integer :: nfh, ddlc, ddlm, nfe
integer :: jstno
character(len=8) :: elrefp, typmod(*), elrese
character(len=16) :: option, compor(*)
real(kind=8) :: basloc(3*ndim*nnop), carcri(*), he(nfiss)
integer :: idepl, ideplp, ivectu
real(kind=8) :: lsn(nnop), lst(nnop), coorse(*)
real(kind=8) :: vi(lgpg, npg), vip(lgpg, npg), sigp(2*ndim, npg), matuu(*)
real(kind=8) :: instam, instap, sigm(2*ndim, npg), sign(6)
aster_logical, intent(in) :: lMatr, lVect, lSigm
!
! --------------------------------------------------------------------------------------------------
!
!     BUT:  CALCUL  DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
!           EN GRANDE ROTATION ET PETITE DEFORMATION AVEC X-FEM EN 2D
!
!     TRAVAIL EFFECTUE EN COLLABORATION AVEC I.F.P.
!
! --------------------------------------------------------------------------------------------------
!
! IN  ELREFP  : ÉLÉMENT DE RÉFÉRENCE PARENT
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  COORSE  : COORDONNÉES DES SOMMETS DU SOUS-ÉLÉMENT
! IN  IGEOM   : COORDONNÉES DES NOEUDS DE L'ÉLÉMENT PARENT
! IN  HE      : VALEUR DE LA FONCTION HEAVISIDE SUR LE SOUS-ÉLT
! IN  NFH     : NOMBRE DE DDL HEAVYSIDE (PAR NOEUD)
! IN  DDLC    : NOMBRE DE DDL DE CONTACT (PAR NOEUD)
! IN  DDLM    : NOMBRE DE DDL PAR NOEUD MILIEU (EN 2D)
! IN  NFE     : NOMBRE DE FONCTIONS SINGULIÈRES D'ENRICHISSEMENT
! IN  BASLOC  : BASE LOCALE AU FOND DE FISSURE AUX NOEUDS
! IN  NNOP    : NOMBRE DE NOEUDS DE L'ELEMENT PARENT
! IN  NPG     : NOMBRE DE POINTS DE GAUSS DU SOUS-ÉLÉMENT
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  IMATE   : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
! IN  IDEPL   : ADRESSE DU DEPLACEMENT A PARTIR DE LA CONF DE REF
! IN  LSN     : VALEUR DE LA LEVEL SET NORMALE AUX NOEUDS PARENTS
! IN  LST     : VALEUR DE LA LEVEL SET TANGENTE AUX NOEUDS PARENTS
!
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
! OUT VI      : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
! OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
! OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, ig, j, j1, k, kk, kkd, kpg, l, m, mn, n, nn
    integer :: ddls, ddld, ddldn, cpt, dec(nnop), hea_se
    integer :: idfde, ipoids, ivf
    integer :: ndimb, nno, nnops, npgbis
    integer :: singu, alp, ii, jj
    real(kind=8) :: dsidep(6, 6), f(3, 3), deps(6), sigma(6), ftf, detf
    real(kind=8) :: fm(3, 3), fr(3, 3), epsp(6), epsm(6), sig(6)
    real(kind=8) :: tmp1, tmp2
    real(kind=8) :: xg(ndim), xe(ndim), ff(nnop), jac
    real(kind=8) :: rbid33(3, 3)
    real(kind=8) :: dfdi(nnop, ndim), pff(1+nfh+nfe*ndim**2, nnop, ndim)
    real(kind=8) :: def(6, nnop, ndim*(1+nfh+nfe*ndim))
    real(kind=8) :: fmm(3, 3)
    real(kind=8) :: fk(27,3,3), dkdgl(27,3,3,3), ka, mu
    aster_logical :: grdepl, axi, cplan
    type(Behaviour_Integ) :: BEHinteg
    real(kind=8) :: angmas(3)
    integer, parameter :: indi(6) = (/ 1 , 2 , 3 , 1 , 1 , 2 /)
    integer, parameter :: indj(6) = (/ 1 , 2 , 3 , 2 , 3 , 3 /)
    real(kind=8), parameter :: rac2 = 1.4142135623731d0
    real(kind=8), parameter :: rind(6) = (/ 0.5d0, 0.5d0,&
                                            0.5d0, 0.70710678118655d0,&
                                            0.70710678118655d0, 0.70710678118655d0 /)
    real(kind=8), parameter :: rind1(6) = (/ 0.5d0 , 0.5d0 ,&
                                             0.5d0 , 1.d0,&
                                             1.d0, 1.d0 /)
!
! --------------------------------------------------------------------------------------------------
!
    angmas = 0.d0
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!     NOMBRE DE DDL DE DEPLACEMENT À CHAQUE NOEUD
    call xnbddl(ndim, nfh, nfe, ddlc, ddld, ddls, singu)
    ddldn = 1+nfh+nfe*ndim**2
!     RECUPERATION DU NOMBRE DE NOEUDS SOMMETS DE L'ELEMENT PARENT
    call elrefe_info(fami='RIGI', nnos=nnops)
!
! - Type of finite element
!
    grdepl = compor(DEFO) .eq. 'GROT_GDEP'
    axi    = typmod(1) .eq. 'AXIS'
    cplan  = typmod(1) .eq. 'C_PLAN'
    if (axi) then
        call utmess('F', 'XFEM2_5')
    endif
!
! - Get element parameters
!
    call elrefe_info(elrefe=elrese, fami='XINT', ndim=ndimb, nno=nno,&
                     npg=npgbis, jpoids=ipoids, jvf=ivf, jdfde=idfde)
    ASSERT(npg.eq.npgbis.and.ndim.eq.ndimb)
!
! - Prepare external state variables
!
    call behaviourPrepESVAElem(carcri   , typmod  ,&
                               nno      , npg     , ndim ,&
                               ipoids   , ivf     , idfde,&
                               zr(igeom), BEHinteg)
!
! - DECALAGES CALCULES EN AMONT: PERF
!
    do n = 1, nnop
        call indent(n, ddls, ddlm, nnops, dec(n))
    end do
!
! - CALCUL DE L IDENTIFIANT DU SS ELEMENT
!
    hea_se=xcalc_code(nfiss, he_real=[he])
!
!  - Loop on Gauss points
!
    do kpg = 1, npg
!
!       COORDONNÉES DU PT DE GAUSS DANS LE REPÈRE RÉEL : XG
        xg = 0.d0
        do i = 1, ndim
            do n = 1, nno
                xg(i) = xg(i) + zr(ivf-1+nno*(kpg-1)+n)*coorse(ndim*( n-1)+i)
            end do
        end do
!
!       COORDONNÉES DU POINT DE GAUSS DANS L'ÉLÉMENT DE RÉF PARENT : XE
!       CALCUL DE FF ET DFDI
        call reeref(elrefp, nnop, zr(igeom), xg, ndim,&
                    xe, ff, dfdi=dfdi)
!
!       FONCTION D'ENRICHISSEMENT AU POINT DE GAUSS ET LEURS DÉRIVÉES
        if (singu .gt. 0) then
            call xkamat(imate, ndim, axi, ka, mu)
            call xcalfev_wrap(ndim, nnop, basloc, zi(jstno), he(1),&
                         lsn, lst, zr(igeom), ka, mu, ff, fk, dfdi, dkdgl)
        endif
! -     CALCUL DE EPS (en T-)
        call xcinem(axi, igeom, nnop, nnops, idepl, grdepl,&
                    ndim, he,&
                    nfiss, nfh, singu, ddls, ddlm,&
                    fk, dkdgl, ff, dfdi, fm,&
                    epsm, rbid33, heavn)
! -     CALCUL DE EPS (en T+)
        call xcinem(axi, igeom, nnop, nnops, ideplp, grdepl,&
                    ndim, he,&
                    nfiss, nfh, singu, ddls, ddlm,&
                    fk, dkdgl, ff, dfdi, f,&
                    epsp, rbid33, heavn)
! -     CALCUL DE DEPS
        do i = 1, 6
            deps(i) = epsp(i)-epsm(i)
        end do
        if (lVect) then
            do i = 1, 3
                do j = 1, 3
                    fr(i,j) = f(i,j)
                end do
            end do
        else
            do i = 1, 3
                do j = 1, 3
                    fr(i,j) = fm(i,j)
                end do
            end do
        endif
!
! - CALCUL DES ELEMENTS GEOMETRIQUES
!
!       CALCUL DES PRODUITS SYMETR. DE F PAR N,
        def(:,:,:)=0.d0
        do n = 1, nnop
!         FONCTIONS DE FORME CLASSIQUES
            do i = 1, ndim
                def(1,n,i) = fr(i,1)*dfdi(n,1)
                def(2,n,i) = fr(i,2)*dfdi(n,2)
                def(3,n,i) = 0.d0
                def(4,n,i) = (fr(i,1)*dfdi(n,2) + fr(i,2)*dfdi(n,1))/ rac2
                if (ndim .eq. 3) then
                    def(3,n,i) = fr(i,3)*dfdi(n,3)
                    def(5,n,i) = (fr(i,1)*dfdi(n,3) + fr(i,3)*dfdi(n, 1))/rac2
                    def(6,n,i) = (fr(i,2)*dfdi(n,3) + fr(i,3)*dfdi(n, 2))/rac2
                endif
            end do
!         ENRICHISSEMENT PAR HEAVISIDE
            do ig = 1, nfh
                do i = 1, ndim
                    cpt = ndim*(1+ig-1)+i
                    do m = 1, 2*ndim
                        def(m,n,cpt) = def(m,n,i) * xcalc_heav(heavn(n,ig),hea_se,heavn(n,5))
                    end do
                    if (ndim .eq. 2) then
                        def(3,n,cpt) = 0.d0
                    endif
                end do
            end do
!         ENRICHISSEMENT PAR LES NFE FONTIONS SINGULIÈRES
            do ig = 1, singu
                do alp = 1, ndim
                    do i = 1, ndim
                        cpt = cpt+1
                        def(1,n,cpt) = fr(i,1)* dkdgl(n,alp,i,1)
                        def(2,n,cpt) = fr(i,2)* dkdgl(n,alp,i,2)
                        def(3,n,cpt) = 0.d0
                        def(4,n,cpt) = (fr(i,1)* dkdgl(n,alp,i,2) +&
                                        fr(i,2)* dkdgl(n,alp,i,1))/rac2
                        if (ndim .eq. 3) then
                            def(3,n,cpt) = fr(i,3)* dkdgl(n,alp,i,3)
                            def(5,n,cpt) = (fr(i,1)* dkdgl(n,alp,i,3) +&
                                            fr(i,3)* dkdgl(n,alp,i,1))/rac2
                            def(6,n,cpt) = (fr(i,3)* dkdgl(n,alp,i,2) +&
                                            fr(i,2)* dkdgl(n,alp,i,3))/rac2
                        endif
                    enddo
                enddo
            enddo
            ASSERT(cpt.eq.ddld)
        end do
!       CALCULER LE JACOBIEN DE LA TRANSFO SSTET->SSTET REF
!       AVEC LES COORDONNEES DU SOUS-ELEMENT
        if (ndim .eq. 2) then
            call dfdm2d(nno, kpg, ipoids, idfde, coorse,&
                        jac)
        else if (ndim.eq.3) then
            call dfdm3d(nno, kpg, ipoids, idfde, coorse,&
                        jac)
        endif
!       CALCUL DES PRODUITS DE FONCTIONS DE FORMES (ET DERIVEES)
        if (lMatr) then
            do i = 1, ndim
                do n = 1, nnop
                    cpt = 1
                    pff(cpt,n,i) = dfdi(n,i)
                    do ig = 1, nfh
                        cpt = cpt+1
                        pff(cpt,n,i) = dfdi(n,i) * xcalc_heav(heavn(n,ig),hea_se,heavn(n,5))
                    end do
                    do alp = 1, ndim*nfe
                        do k = 1, ndim
                          cpt = cpt+1
                          pff(cpt,n,i) = dkdgl(n,alp,k,i)
                        end do
                    end do
                    ASSERT(cpt.eq.ddldn)
                end do
            end do
        endif
! ----- Preparation for behaviour
        if (cplan) then
            fm(3,3) = sqrt(abs(2.d0*epsm(3)+1.d0))
        endif
        call matinv('S', 3, fm, fmm, detf)
        sign = 0.d0
        do i = 1, 2*ndim
            do l = 1, 2*ndim
                ftf = (fmm(indi(i), indi(l)) *&
                       fmm(indj(i), indj(l)) +&
                       fmm(indi(i), indj(l)) *&
                       fmm(indj(i), indi(l))) * rind1(l)
                sign(i) = sign(i) + ftf * sigm(l,kpg)
            end do
            sign(i) = sign(i) * detf
        end do
        if (ndim .eq. 2) then
            sign(4) = sign(4) * rac2
        else if (ndim .eq. 3) then
            do m = 4, 2*ndim
                sign(m) = sigm(m,kpg) * rac2
            end do
        else
            ASSERT(ASTER_FALSE)
        endif
        sigma = 0.d0
! ----- Behaviour
        call nmcomp(BEHinteg,&
                    'XFEM', idecpg+kpg, 1, ndim, typmod,&
                    imate, compor, carcri, instam, instap,&
                    6, epsm, deps, 6, sign,&
                    vi(1, kpg), option, angmas, &
                    sigma, vip(1, kpg), 36, dsidep, codret)
! ----- Rigidity matrix
        if (lMatr) then
! --------- RIGIDITÉ GEOMETRIQUE
            do n = 1, nnop
                nn=dec(n)
                do m = 1, n
                    mn=dec(m)
                    do i = 1, ddldn
                        do j = 1, ddldn
                            tmp1 = 0.d0
                            if (option(1:4) .eq. 'RIGI') then
                                tmp1 = sign(1)*pff(i,n,1)*pff(j,m,1) + sign(2)*pff(i,n,2)*pff(j,m&
                                       &,2) + sign(4)*(pff(i,n,1)*pff(j,m,2) +pff(i,n,2)*pff(j,m,&
                                       &1))/rac2
                                if (ndim .eq. 3) then
                                    tmp1 = tmp1 + sign(3)*pff(i,n,3)* pff(j,m,3) + sign(5)*(pff(i&
                                           &,n,1)* pff(j,m,3) +pff(i,n,3)*pff(j,m,1)) /rac2 + sig&
                                           &n(6)*(pff(i,n,3)*pff(j, m,2) +pff(i,n,2)*pff(j,m,3))/&
                                           &rac2
                                endif
                            else
                                tmp1 = sigma(1)*pff(i,n,1)*pff(j,m,1) + sigma(2)*pff(i,n,2)*pff(j&
                                       &,m,2) + sigma(4)*(pff(i,n,1)*pff(j,m,2) +pff(i,n,2)*pff(j&
                                       &,m,1))/rac2
                                if (ndim .eq. 3) then
                                    tmp1 = tmp1 + sigma(3)*pff(i,n,3)* pff(j,m,3) + sigma(5)*(pff&
                                           &(i,n,1)* pff(j,m,3) +pff(i,n,3)*pff(j,m,1)) /rac2 + s&
                                           &igma(6)*(pff(i,n,3)*pff( j,m,2) +pff(i,n,2)*pff(j,m,3&
                                           &))/ rac2
                                endif
                            endif
!                 STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
                            if (m .eq. n) then
                                j1 = iipff(i,ndim,nfh,nfe)
                            else
                                j1 = ddldn
                            endif
                            if (iipff(j,ndim,nfh,nfe) .le. j1) then
                                do l = 1, ndim
                                    ii=iimatu((iipff(i,ndim,nfh,nfe)-1)*ndim+l,ndim,nfh,nfe)
                                    kkd = ( nn+ii-1) * (nn+ii ) /2
!
                                    jj=iimatu((iipff(j,ndim,nfh,nfe)-1)*ndim+l,ndim,nfh,nfe)
                                    kk = kkd + mn+jj
!
                                    matuu(kk) = matuu(kk) + tmp1*jac
                                end do
                            endif
                        end do
                    end do
                end do
            end do
!         RIGIDITE ELASTIQUE
            do n = 1, nnop
                nn=dec(n)
                do i = 1, ddld
                    ii=iimatu(i,ndim,nfh,nfe)
                    do l = 1, 2*ndim
                        sig(l) = 0.d0
                        do k = 1, 2*ndim
                            sig(l) = sig(l) + def(k,n,i) * dsidep(k,l)
                        end do
                    end do
                    do j = 1, ddld
                        jj=iimatu(j,ndim,nfh,nfe)
                        do m = 1, n
                            tmp2 = 0.d0
                            mn=dec(m)
                            do k = 1, 2*ndim
                                tmp2 = tmp2 + sig(k) * def(k,m,j)
                            end do
!
!                STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
                            if (m .eq. n) then
                                j1 = ii
                            else
                                j1 = ddld
                            endif
                            if (jj .le. j1) then
                                kkd = (nn+ii-1) * (nn+ii) /2
                                matuu(kkd+mn+jj) = matuu(kkd+mn+jj) + tmp2*jac
                            endif
                        end do
                    end do
                end do
            end do
        endif
! ----- Internal forces
        if (lVect) then
            do n = 1, nnop
                nn=dec(n)
                do i = 1, ddld
                    ii=iimatu(i,ndim,nfh,nfe)
                    do l = 1, 2*ndim
                        zr(ivectu-1+nn+ii)= zr(ivectu-1+nn+ii) + def(l,n,i)*sigma(l)*jac
                    end do
                end do
            end do
        endif
! ----- Stress
        if (lSigm) then
            if (cplan) then
                f(3,3) = sqrt(abs(2.d0*epsp(3)+1.d0))
            endif
            detf = f(3,3) * (f(1,1)*f(2,2)-f(1,2)*f(2,1))
            if (ndim .eq. 3) then
                detf = detf - f(2,3)*(f(1,1)*f(3,2)-f(3,1)*f(1,2)) +&
                              f(1,3)*(f(2,1)*f(3,2)-f(3,1)*f(2,2))
            endif
            do i = 1, 2*ndim
                sigp(i,kpg) = 0.d0
                do l = 1, 2*ndim
                    ftf = (&
                          f(&
                          indi(i), indi(l))*f(indj(i), indj(l)) + f(indi(i), indj(l))*f(indj(i),&
                          indi(l))&
                          )*rind(l&
                          )
                    sigp(i,kpg) = sigp(i,kpg) + ftf*sigma(l)
                end do
                sigp(i,kpg) = sigp(i,kpg)/detf
            end do
        endif
!
    end do
end subroutine
