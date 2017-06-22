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

subroutine sroptg(val, dum, dt, nbmat, mater,&
                  invar, s, sel, ucrpm,&
                  ucrvm, ucriv, seuilv, vinm, nvi, de,&
                  depsv, dside, retcom)

!

!!!
!!! MODELE LKR : CALCUL DE DSIGMA/DEPS
!!!

! ===================================================================================
! IN  : VAL    : INDICATEUR POUR DISTINGUER LES LOIS DE DILATANCE
!     : DUM    : INDICATEUR CONTRACTANCE OU DILATANCE
!     : DGAMV  :  ACCROISSEMENT DE GAMMA VISCOPLASTIQUE
!     : DT     :  PAS DE TEMPS
!     : NBMAT  :  NOMBRE DE PARAMETRES MATERIAU
!     : MATER  :  COEFFICIENTS MATERIAU A T+DT
!                    MATER(*,1) = CARACTERISTIQUES ELASTIQUES
!                    MATER(*,2) = CARACTERISTIQUES PLASTIQUES
!     : INVAR  :  INVARIANT DES CONTRAINTES
!     : S      :  DEVIATEUR DES CONTRAINTES
!     : IEL    :  INVARIANT DES CONTRAINTES DE LA PREDICTION
!     : SEL    :  DEVIATEUR DES CONTRAINTES DE LA PREDICTION
!     : UCRPM  :  VALEUR DE U PLAS POUR LES CONT. A L INSTANT MOINS
!     : UCRVM  :  VALEUR DE U VISC POUR LES CONT. A L INSTANT MOINS
!     : UCRIV  :  VALEUR DE U VISC POUR LES CONT. A LA PREDICTION
!     : SEUILV :  VALEUR DU SEUIL VISQUEUX A LA PREDICTION
!     : VINM   :  VARIABLES INTERNES
!     : DE     :  MATRICE ELASTIQUE
!     : DEPSV  :  ACCROISSEMENT DES DEFORMATIONS VISCOPLASTIQUES A T
! OUT : DSIDE  :  COMPOSANTS DE L OPERATEUR TANGENT
!     : RETCOM : CODE RETOUR POUR REDECOUPAGE DU PAS DE TEMPS
! ===================================================================================

    implicit   none

#include "asterfort/lcprmm.h"                                                                  
#include "asterfort/lcprmv.h"
#include "asterfort/lcprsc.h"
#include "asterfort/lcprte.h"
#include "asterfort/lctrma.h"
#include "asterfort/srbpri.h"
#include "asterfort/srcalg.h"
#include "asterfort/srcaln.h"
#include "asterfort/srdepp.h"
#include "asterfort/srdepv.h"
#include "asterfort/srdfds.h"
#include "asterfort/srdfdx.h"
#include "asterfort/srdhds.h"
#include "asterfort/srdphi.h"
#include "asterfort/srds2h.h"
#include "asterfort/srdvds.h"
#include "asterfort/srvacp.h"
#include "asterfort/srvacv.h"
#include "asterfort/srvarp.h"
#include "asterfort/srvarv.h"
#include "asterfort/r8inir.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: val, dum, nbmat, retcom, nvi
    real(kind=8) :: dt, invar, s(6), sel(6), mater(nbmat,2), vinm(nvi)
    real(kind=8) :: dside(6,6), de(6,6)
    real(kind=8) :: ucrpm, ucrvm, ucriv, seuilv
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: ndi, ndt, i, k
    real(kind=8) :: paraep(3), varpl(4), derpar(3)
    real(kind=8) :: paravi(3), varvi(4)
    real(kind=8) :: dhds(6), ds2hds(6), dfdsp(6)
    real(kind=8) :: dhdsv(6), ds2hdv(6), dfdsv(6)
    real(kind=8) :: dhdsve(6), ds2hde(6), dfdsve(6)
    real(kind=8) :: vecnp(6), vecnv(6), gp(6), gv(6), devgii
    real(kind=8) :: degv(6), degp(6), dgp(6,6), dgv(6,6)
    real(kind=8) :: dfdegp, dfdxip, dphigv(6,6), dedgp(6,6), dedgv(6,6)
    real(kind=8) :: dphi(6), ddlam(6), dvds(6,6)
    real(kind=8) :: aa(6,6), cc(6,6), dd(6), nume(6)
    real(kind=8) :: depsv(6), ddepsv(6), ddgamv(6), dgamv
    real(kind=8) :: bprimp, bprimv, coupl
    real(kind=8) :: bidon, vintr, tmm, tpp, paravit(3), varvit(4)
    real(kind=8) :: aat(6,6), cct(6,6)
    common /tdim/   ndt, ndi
    
    
    !!!
    !!! Recuperation des temperatures et des increments
    !!!
    
    tmm=mater(6,1)
    tpp=mater(7,1)
    vintr=vinm(3)
    
    !!!
    !!! Recuperation des parametres d'ecrouissage a t- et v-
    !!!
    
    call srvarp(vinm, nvi, nbmat, mater, tmm, paraep)
    call srvacp(nbmat, mater, paraep, varpl)
    call srdepp(vinm, nvi, nbmat, mater, paraep, derpar)
    call srvarv(vintr, nbmat, mater, tmm, paravi)
    call srvacv(nbmat, mater, paravi, varvi)
    
    !!!
    !!! Recuperation des parametres d'ecrouissage a t+ v-
    !!!
    
    call srvarv(vintr, nbmat, mater, tpp, paravit)
    call srvacv(nbmat, mater, paravit, varvit)
    
    !!!
    !!! Recuperation de dfp/dsigm(-)
    !!!
    
    call srdhds(nbmat, mater, s, dhds, retcom)
    call srds2h(nbmat, mater, s, dhds, ds2hds, retcom)
    call srdfds(nbmat, mater, paraep, varpl, ds2hds, ucrpm, dfdsp)
    
    !!!
    !!! Recuperation de dfvp/dsigm(-)
    !!!    
    
    call srdhds(nbmat, mater, s, dhdsv, retcom)
    call srds2h(nbmat, mater, s, dhdsv, ds2hdv, retcom)
    call srdfds(nbmat, mater, paravi, varvi, ds2hdv, ucrvm, dfdsv)
    
    !!!
    !!! Recuperation de dfvp/dsigm(e)
    !!!
    
    call srdhds(nbmat, mater, sel, dhdsve, retcom)
    call srds2h(nbmat, mater, sel, dhdsve, ds2hde, retcom)
    call srdfds(nbmat, mater, paravit, varvit, ds2hde, ucriv, dfdsve)
    
    !!!
    !!! Recuperation de gp-
    !!!
    
    bprimp=srbpri(val, vinm, nvi, nbmat, mater, paraep, invar, s, tmm)
    
    call srcaln(s, bprimp, vecnp, retcom)
    call srcalg(dfdsp, vecnp, gp, devgii)
    
    !!!
    !!! Recuperation de gvp-
    !!!
    
    val=0
    bprimv=srbpri(val, vinm, nvi, nbmat, mater, paravi, invar, s, tmm)
    
    call srcaln(s, bprimv, vecnv, retcom)
    call srcalg(dfdsv, vecnv, gv, bidon)
    
    !!!
    !!! Recuperation de dphi/deps et sa multiplication par gvp
    !!!
    
    call srdphi(nbmat, mater, de, seuilv, dfdsve, dphi)
    call lcprmv(de, gv, degv)
    call lcprte(degv, dphi, dphigv)
    
    do i=1, ndt
        do k=1, ndt
            aa(i,k)=de(i,k)-dphigv(i,k)*dt
        end do
    end do
    
    !!!
    !!! Produit de dfp/dsig par aa
    !!!
    
    call lctrma(aa, aat)
    call lcprmv(aat, dfdsp, nume)
    
    !!!
    !!! Recuperation de dfp/dxip(-)
    !!!

    call srdfdx(nbmat, mater, ucrpm, invar, s, paraep, varpl, derpar, dfdxip)
    
    !!!
    !!! Produit de de par gp
    !!!
    
    call r8inir(6, 0.d0, degp, 1)
    call lcprmv(de, gp, degp)
    
    !!!
    !!! Produit de dfp/dsig par de:gp
    !!!

    call lcprsc(dfdsp, degp, dfdegp)
    
    !!!
    !!! Calcul de dgamv/deps
    !!!
    
    call srdepv(depsv, ddepsv, dgamv, ddgamv)
    
    !!!
    !!! Calcul de depsv/dsig
    !!!
    
    call r8inir(6*6, 0.d0, dvds, 1)
    call r8inir(6*6, 0.d0, cc, 1)
    call r8inir(6, 0.d0, dd, 1)
    call srdvds(dt, nbmat, mater, gv, dfdsve, seuilv, dvds)
    call lcprmm(dvds, de, cc)
    call lctrma(cc, cct)
    call lcprmv(cct, ddgamv, dd)
    
    !!!
    !!! Calcul de dlambda
    !!!
    
    coupl=mater(28,2)
    
    do i=1, ndt
        if ((dum.eq.1).and.(coupl.ge.1.d0/2.d0)) then
            ddlam(i)=(nume(i)+dfdxip*dd(i))/(dfdegp-dfdxip*sqrt(2.d0/3.d0)*devgii)
        else
            ddlam(i)=nume(i)/(dfdegp-dfdxip*sqrt(2.d0/3.d0)*devgii)
        endif
    end do
    
    !!!
    !!! Calcul de l'operateur tangent
    !!!
    
    call r8inir(6*6, 0.d0, dgp, 1)
    call r8inir(6*6, 0.d0, dgv, 1)
    call r8inir(6*6, 0.d0, dedgp, 1)
    call r8inir(6*6, 0.d0, dedgv, 1)
    call lcprte(degp, ddlam, dedgp)
    call r8inir(6*6, 0.d0, dside, 1)
    
    do i=1, ndt
        do k=1, ndt
            dside(i,k)=de(i,k)-dedgp(i,k)-dphigv(i,k)*dt
        end do
    end do

end subroutine
