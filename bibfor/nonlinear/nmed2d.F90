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
! aslint: disable=W1504,W1306
!
subroutine nmed2d(nno, npg, ipoids, ivf, idfde,&
                  geom, typmod, option, imate, compor,&
                  lgpg, ideplm, iddepl, sigm,&
                  vim, dfdi, def, sigp, vip,&
                  matuu, ivectu, codret)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/codere.h"
#include "asterfort/nmedco.h"
#include "asterfort/nmedel.h"
#include "asterfort/nmedsq.h"
#include "asterfort/nmgeom.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
integer :: nno, npg, imate, lgpg, codret
integer :: ipoids, ivf, idfde, ivectu, ideplm, iddepl
character(len=8) :: typmod(*)
character(len=16) :: option, compor(*)
real(kind=8) :: geom(2, nno)
real(kind=8) :: dfdi(nno, 2), def(4, nno, 2)
real(kind=8) :: sigm(4, npg), sigp(4, npg)
real(kind=8) :: vim(lgpg, npg), vip(lgpg, npg)
real(kind=8) :: matuu(*)
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: AXIS_ELDI, PLAN_ELDI
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  IPOIDS  : POINTEUR SUR LES POIDS DES POINTS DE GAUSS
! IN  IVF     : POINTEUR SUR LES VALEURS DES FONCTIONS DE FORME
! IN  IDFDE   : POINTEUR SUR DERIVEES DES FONCT DE FORME DE ELEM REFE
! IN  GEOM    : COORDONEES DES NOEUDS
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  IMATE   : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
! IN  DDEPL   : INCREMENT DE DEPLACEMENT
! IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
! IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
! OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
! OUT DEF     : PRODUIT DER. FCT. FORME PAR F   AU DERNIER PT DE GAUSS
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
! OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
! OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: ndim = 2, sz_tens = 4
    aster_logical :: grand, axi
    aster_logical :: elas
    aster_logical :: lVect, lMatr, lSigm
    integer :: kpg, kk, kkd, i_node, i_dime, m, j, j1, i_tens, k
    integer :: cod(npg)
    real(kind=8) :: alpham(2), alphap(2)
    real(kind=8) :: s(2), q(2, 2), dsdu(2, 8), sg(2), qg(2, 2), dsdug(2, 8)
    real(kind=8) :: d(4, 2)
    real(kind=8) :: dda, xa, xb, ya, yb
    real(kind=8) :: rot(2, 2), cotmp, sitmp, co, si, drot, rtemp(4, 2)
    real(kind=8) :: dalfu(2, 8), dh(4, 8), dalfs(2, 2)
    real(kind=8) :: bum(6), bdu(6)
    real(kind=8) :: r
    real(kind=8) :: f(3, 3), deps(6)
    real(kind=8) :: dsidep(6, 6), sigma(6), sig(6), sigm_norm(6)
    real(kind=8) :: poids, tmp
    real(kind=8), parameter :: rac2 = sqrt(2.d0)

!
! --------------------------------------------------------------------------------------------------
!
    grand  = ASTER_FALSE
    axi    = typmod(1) .eq. 'AXIS'
    cod    = 0
    lSigm  = L_SIGM(option)
    lVect  = L_VECT(option)
    lMatr  = L_MATR(option)
!
! - MATRICE DE CHANGEMENT DE REPERE : DU GLOBAL AU LOCAL  : ROT X = XLOC
! - SOIT A ET B LES MILIEUX DES COTES [14] ET [23] t TANGENT AU COTE [AB]
!
    xa = ( geom(1,1) + geom(1,4) ) / 2
    ya = ( geom(2,1) + geom(2,4) ) / 2
    xb = ( geom(1,2) + geom(1,3) ) / 2
    yb = ( geom(2,2) + geom(2,3) ) / 2
    cotmp = (yb - ya)
    sitmp = (xa - xb)
    co = cotmp / sqrt(cotmp*cotmp + sitmp*sitmp)
    si = sitmp / sqrt(cotmp*cotmp + sitmp*sitmp)
    rot(1,1) = co
    rot(2,1) = -si
    rot(1,2) = si
    rot(2,2) = co
!
! - Loop on Gauss points
!
    s    = 0.d0
    q    = 0.d0
    dsdu = 0.d0
    do kpg = 1, npg
! ----- CALCUL DE DFDI,F,EPS (BUM),DEPS (BDU),R(EN AXI) ET POIDS
        bum = 0.d0
        bdu = 0.d0
        call nmgeom(ndim    , nno   , axi , grand, geom      ,&
                    kpg     , ipoids, ivf , idfde, zr(ideplm),&
                    .true._1, poids , dfdi, f    , bum       ,&
                    r)
        call nmgeom(ndim    , nno   , axi , grand, geom,&
                    kpg     , ipoids, ivf , idfde, zr(iddepl),&
                    .true._1, poids , dfdi, f    , bdu       ,&
                    r)
! ----- CALCUL DE D (LES AUTRES TERMES SONT NULS):
        d = 0.d0
        d(1,1) = - (dfdi(1,1) + dfdi(2,1))
        d(4,1) = - rac2*(dfdi(1,2) + dfdi(2,2))/2
        d(2,2) = - (dfdi(1,2) + dfdi(2,2))
        d(4,2) = - rac2*(dfdi(1,1) + dfdi(2,1))/2
! ----- CHANGEMENT DE REPERE DANS D : ON REMPLACE D PAR DRt :
        rtemp = 0.d0
        do i_dime = 1, 4
            do j = 1, 2
                drot = 0.d0
                do k = 1, 2
                    drot = drot + d(i_dime,k)*rot(j,k)
                end do
                rtemp(i_dime,j) = drot
            end do
        end do
        do i_dime = 1, 4
            do j = 1, 2
                d(i_dime,j) = rtemp(i_dime,j)
            end do
        end do
! ----- Kinematic - Product [F].[B]
        def = 0.d0
        do i_node = 1, nno
            do i_dime = 1, ndim
                def(1,i_node,i_dime) = f(i_dime,1)*dfdi(i_node,1)
                def(2,i_node,i_dime) = f(i_dime,2)*dfdi(i_node,2)
                def(3,i_node,i_dime) = 0.d0
                def(4,i_node,i_dime) = (f(i_dime,1)*dfdi(i_node,2) +&
                                        f(i_dime,2)*dfdi(i_node,1))/ rac2
            end do
        end do
        if (axi) then
            do i_node = 1, nno
                def(3,i_node,1) = f(3,3)*zr(ivf+i_node+(kpg-1)*nno-1)/r
            end do
        endif
! ----- Prepare stresses
        do i_tens = 1, 3
            sigm_norm(i_tens) = sigm(i_tens, kpg)
        end do
        sigm_norm(4) = sigm(4,kpg)*rac2
! ----- CALCUL DE S ET Q AU POINT DE GAUSS COURANT I.E. SG ET QG :
        call nmedsq(sg, qg, dsdug, d, npg,&
                    typmod, imate, bum, bdu, sigm_norm,&
                    vim, option, geom, nno, lgpg,&
                    kpg, def)
! ----- CALCUL DES S ET Q POUR L'ELEMENT :
        do i_dime = 1, 2
            s(i_dime) = s(i_dime) + poids*sg(i_dime)
            do j = 1, 2
                q(i_dime,j) = q(i_dime,j) + poids*qg(i_dime,j)
            end do
            do j = 1, 8
                dsdu(i_dime,j) = dsdu(i_dime,j) + poids*dsdug(i_dime,j)
            end do
        end do
    end do
!
! - Compute behaviour
!
    call nmedco(compor, option, imate, npg, lgpg,&
                s, q, vim, vip, alphap,&
                dalfs)
!
! - Loop on Gauss points
!
    do kpg = 1, npg
! ----- CALCUL DE DFDI,F,BUM, BDU ,R(EN AXI) ET POIDS
        bum = 0.d0
        bdu = 0.d0
        call nmgeom(2, nno, axi, grand, geom,&
                    kpg, ipoids, ivf, idfde, zr( ideplm),&
                    .true._1, poids, dfdi, f, bum,&
                    r)
        call nmgeom(2, nno, axi, grand, geom,&
                    kpg, ipoids, ivf, idfde, zr( iddepl),&
                    .true._1, poids, dfdi, f, bdu,&
                    r)
! ----- CALCUL DE D (LES AUTRES TERMES SONT NULS):
        d      = 0.d0
        d(1,1) = - (dfdi(1,1) + dfdi(2,1))
        d(4,1) = - rac2*(dfdi(1,2) + dfdi(2,2))/2
        d(2,2) = - (dfdi(1,2) + dfdi(2,2))
        d(4,2) = - rac2*(dfdi(1,1) + dfdi(2,1))/2
! ----- CHANGEMENT DE REPERE DANS D : ON REMPLACE D PAR DRt :
        rtemp = 0.d0
        do i_dime = 1, 4
            do j = 1, 2
                drot = 0.d0
                do k = 1, 2
                    drot = drot + d(i_dime,k)*rot(j,k)
                end do
                rtemp(i_dime,j) = drot
            end do
        end do
        do i_dime = 1, 4
            do j = 1, 2
                d(i_dime,j) = rtemp(i_dime,j)
            end do
        end do
! ----- CALCUL DES PRODUITS SYMETR. DE F PAR N,
        def = 0.d0
        do i_node = 1, nno
            do i_dime = 1, ndim
                def(1,i_node,i_dime) = f(i_dime,1)*dfdi(i_node,1)
                def(2,i_node,i_dime) = f(i_dime,2)*dfdi(i_node,2)
                def(3,i_node,i_dime) = 0.d0
                def(4,i_node,i_dime) = (f(i_dime,1)*dfdi(i_node,2) +&
                                        f(i_dime,2)*dfdi(i_node,1))/ rac2
            end do
        end do
! ----- TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1
        if (axi) then
            do i_node = 1, nno
                def(3,i_node,1) = f(3,3)*zr(ivf+i_node+(kpg-1)*nno-1)/r
            end do
        endif
        do i_tens = 1, 3
            sigm_norm(i_tens) = sigm(i_tens, kpg)
        end do
        sigm_norm(4) = sigm(4,kpg)*rac2
! ----- LA VARIATION DE DEF DEPS : DEVIENT LA SOMME DES VARIATION
! ----- DE DEF LIEE AU DEPL : 'BDU' PLUS CELLE LIEE AU SAUT : 'DDA'
        alpham(1) = vim(1,kpg)
        alpham(2) = vim(2,kpg)
        do i_tens = 1, 4
            dda = 0.d0
            do j = 1, 2
                dda = dda + d(i_tens,j)*(alphap(j)-alpham(j))
            end do
            deps(i_tens) = bdu(i_tens) + dda
        end do
! ----- APPEL DE LA LDC ELASTIQUE : SIGMA=A.EPS AVEC EPS=BU-DA
! ----- ON PASSE EN ARG LA VARIATION DE DEF 'DEPS' ET LA CONTRAINTE -
! ----- 'SIGN' ET ON SORT LA CONTAINTE + 'SIGMA'
        call nmedel(2, typmod, imate, deps, sigm_norm,&
                    option, sigma, dsidep)
! ----- Rigidity matrix
        if (lMatr) then
! --------- Compute DH
            if (option .eq. 'RIGI_MECA_TANG') then
                elas=(nint(vim(4,kpg)).eq.0)
            else
                elas=(nint(vip(4,kpg)).eq.0)
            endif
            if ((elas) .and. (vim(3,kpg).eq.0.d0)) then
                dh = 0.d0
            else
! ------------- CALCUL DE LA DERIVE DE ALPHA PAR RAPPORT A U : 'DALFU' EN UTILISANT LA
! ------------- DERIVEE ALPHA PAR RAPPORT A S : 'DALFS' (CALCULE DANS LE COMPORTEMENT
! ------------- CF NMEDCO.F) ET DE LA DERIVEE DE S PAR RAPPORT A U : 'DSDU'.
                dalfu = 0.d0
                do i_dime = 1, 2
                    do j = 1, 8
                        do k = 1, 2
                            dalfu(i_dime,j) = dalfu(i_dime,j) + dalfs(i_dime,k)*dsdu( k,j)
                        end do
                    end do
                end do
                dh = 0.d0
                do i_dime = 1, 4
                    do j = 1, 8
                        do k = 1, 2
                            dh(i_dime,j) = dh(i_dime,j) + d(i_dime,k)*dalfu(k,j)
                        end do
                    end do
                end do
            endif
! --------- Rigidity matrix
            do i_node = 1, nno
                do i_dime = 1, ndim
                    do i_tens = 1, sz_tens
                        sig(i_tens)=0.d0
                        sig(i_tens)=sig(i_tens) + def(1,i_node,i_dime)*dsidep(1,i_tens)
                        sig(i_tens)=sig(i_tens) + def(2,i_node,i_dime)*dsidep(2,i_tens)
                        sig(i_tens)=sig(i_tens) + def(3,i_node,i_dime)*dsidep(3,i_tens)
                        sig(i_tens)=sig(i_tens) + def(4,i_node,i_dime)*dsidep(4,i_tens)
                    end do
                    do j = 1, 2
                        do m = 1, i_node
                            if (m .eq. i_node) then
                                j1 = i_dime
                            else
                                j1 = 2
                            endif
! ------------------------  RIGIDITE ELASTIQUE + TERME LIE AU SAUT : TMP = Bt E (B + DH)
                            tmp = 0.d0
                            tmp = tmp + sig(1)*( def(1,m,j) + dh(1, 2*(m-1)+j))
                            tmp = tmp + sig(2)*( def(2,m,j) + dh(2, 2*(m-1)+j))
                            tmp = tmp + sig(3)*( def(3,m,j) + dh(3, 2*(m-1)+j))
                            tmp = tmp + sig(4)*( def(4,m,j) + dh(4, 2*(m-1)+j))
! ------------------------   STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
                            if (j .le. j1) then
                                kkd = (2*(i_node-1)+i_dime-1) * (2*(i_node-1)+i_dime) /2
                                kk = kkd + 2*(m-1)+j
                                matuu(kk) = matuu(kk) + tmp*poids
                            endif
                        end do
                    end do
                end do
            end do
        endif
! ----- Internal forces
        if (lVect) then
            do i_node = 1, nno
                do i_dime = 1, ndim
                    do i_tens = 1, sz_tens
                        zr(ivectu-1+2*(i_node-1)+i_dime) = zr(ivectu-1+2*(i_node-1)+i_dime)+&
                            poids*def(i_tens,i_node,i_dime)*sigma(i_tens)
                    end do
                end do
            end do
        endif
! ----- Cauchy stresses
        if (lSigm) then
            do i_tens = 1, 3
                sigp(i_tens,kpg) = sigma(i_tens)
            end do
            sigp(4,kpg) = sigma(4)/rac2
        endif
    end do
!
! - Return code summary
!
    call codere(cod, npg, codret)
!
end subroutine
