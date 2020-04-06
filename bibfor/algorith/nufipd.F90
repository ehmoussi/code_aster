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
subroutine nufipd(ndim, nno1, nno2, npg, iw,&
                  vff1, vff2, idff1, vu, vp,&
                  geomi, typmod, option, mate, compor,&
                  lgpg, carcri, instm, instp, ddlm,&
                  ddld, angmas, sigm, vim, sigp,&
                  vip, mini, vect,&
                  matr, codret,&
                  lSigm, lVect, lMatr)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calkbb.h"
#include "asterfort/calkbp.h"
#include "asterfort/calkce.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"
#include "asterfort/pmat.h"
#include "asterfort/tanbul.h"
#include "asterfort/utmess.h"
#include "blas/ddot.h"
#include "asterfort/Behaviour_type.h"
!
aster_logical :: mini
integer :: ndim, nno1, nno2, npg, iw, idff1, lgpg
integer :: mate
integer :: vu(3, 27), vp(27)
integer :: codret
real(kind=8) :: vff1(nno1, npg), vff2(nno2, npg)
real(kind=8) :: instm, instp
real(kind=8) :: geomi(ndim, nno1), ddlm(*), ddld(*), angmas(*)
real(kind=8) :: sigm(2*ndim+1, npg), sigp(2*ndim+1, npg)
real(kind=8) :: vim(lgpg, npg), vip(lgpg, npg)
real(kind=8) :: vect(*), matr(*)
real(kind=8) :: carcri(*)
character(len=8) :: typmod(*)
character(len=16) :: compor(*), option
aster_logical, intent(in) :: lSigm, lVect, lMatr
!
! --------------------------------------------------------------------------------------------------
!
!          CALCUL DES FORCES INTERNES POUR LES ELEMENTS
!          INCOMPRESSIBLES POUR LES PETITES DEFORMATIONS
!          3D/D_PLAN/AXIS
!
! --------------------------------------------------------------------------------------------------
!
! IN  MINI    : STABILISATION BULLE - MINI ELEMENT
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  NNO1    : NOMBRE DE NOEUDS DE L'ELEMENT LIES AUX DEPLACEMENTS
! IN  NNO2    : NOMBRE DE NOEUDS DE L'ELEMENT LIES A LA PRESSION
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  IW      : POIDS DES POINTS DE GAUSS
! IN  VFF1    : VALEUR  DES FONCTIONS DE FORME LIES AUX DEPLACEMENTS
! IN  VFF2    : VALEUR  DES FONCTIONS DE FORME LIES A LA PRESSION
! IN  IDFF1   : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  VU      : TABLEAU DES INDICES DES DDL DE DEPLACEMENTS
! IN  VP      : TABLEAU DES INDICES DES DDL DE PRESSION
! IN  GEOMI   : COORDONEES DES NOEUDS
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  MATE    : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
! IN  INSTM   : INSTANT PRECEDENT
! IN  INSTP   : INSTANT DE CALCUL
! IN  DDLM    : DEGRES DE LIBERTE A L'INSTANT PRECEDENT
! IN  DDLD    : INCREMENT DES DEGRES DE LIBERTE
! IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
! IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
! IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
! OUT VECT    : FORCES INTERNES
! OUT MATR    : MATRICE DE RIGIDITE (RIGI_MECA_TANG ET FULL_MECA)
! OUT CODRET  : CODE RETOUR
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: axi, grand
    integer :: kpg, nddl
    integer :: ia, na, sa, ib, nb, sb, ja, jb
    integer :: os, kk
    integer :: vuiana, vpsa
    integer :: cod(npg)
    character(len=16) :: rela_comp
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8) :: deplm(3*27), depld(3*27)
    real(kind=8) :: r, w, dff1(nno1, ndim)
    real(kind=8) :: presm(27), presd(27)
    real(kind=8) :: pm, pd
    real(kind=8) :: fm(3, 3), epsm(6), deps(6)
    real(kind=8) :: sigma(6), sigmPrep(6), sigtr
    real(kind=8) :: dsidep(6, 6)
    real(kind=8) :: def(2*ndim, nno1, ndim), deftr(nno1, ndim), ddivu, divum
    real(kind=8) :: ddev(6, 6), devd(6, 6), dddev(6, 6)
    real(kind=8) :: t1, t2
    real(kind=8) :: alpha, trepst
    real(kind=8) :: dsbdep(2*ndim, 2*ndim), kbb(ndim, ndim), kbp(ndim, nno2)
    real(kind=8) :: kce(nno2, nno2), rce(nno2)
    type(Behaviour_Integ) :: BEHinteg
    real(kind=8), parameter :: idev(6,6) = reshape((/ 2.d0,-1.d0,-1.d0, 0.d0, 0.d0, 0.d0,&
                                                     -1.d0, 2.d0,-1.d0, 0.d0, 0.d0, 0.d0,&
                                                     -1.d0,-1.d0, 2.d0, 0.d0, 0.d0, 0.d0,&
                                                      0.d0, 0.d0, 0.d0, 3.d0, 0.d0, 0.d0,&
                                                      0.d0, 0.d0, 0.d0, 0.d0, 3.d0, 0.d0,&
                                                      0.d0, 0.d0, 0.d0, 0.d0, 0.d0, 3.d0/),(/6,6/))
!
! --------------------------------------------------------------------------------------------------
!
    grand  = ASTER_FALSE
    axi    = typmod(1).eq.'AXIS'
    cod    = 0
    nddl   = nno1*ndim + nno2
    dsidep = 0.d0
    codret = 0
    if (lVect) then
        vect(1:nddl) = 0.d0
    endif
    if (lMatr) then
        matr(1:nddl*(nddl+1)/2) = 0.d0
    endif
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
! - Extract for fields
!
    do na = 1, nno1
        do ia = 1, ndim
            deplm(ia+ndim*(na-1)) = ddlm(vu(ia,na))
            depld(ia+ndim*(na-1)) = ddld(vu(ia,na))
        end do
    end do
    do sa = 1, nno2
        presm(sa) = ddlm(vp(sa))
        presd(sa) = ddld(vp(sa))
    end do
!
! - Properties of behaviour
!
    rela_comp = compor(RELA_NAME)
!
! - Loop on Gauss points
!
    do kpg = 1, npg
        epsm = 0.d0
        deps = 0.d0
! ----- Kinematic - Previous strains
        call dfdmip(ndim, nno1, axi, geomi, kpg,&
                    iw, vff1(1, kpg), idff1, r, w,&
                    dff1)
        call nmepsi(ndim, nno1, axi, grand, vff1(1, kpg),&
                    r, dff1, deplm, fm, epsm)
        divum = epsm(1) + epsm(2) + epsm(3)
! ----- Kinematic - Increment of strains
        call nmepsi(ndim, nno1, axi, grand, vff1(1, kpg),&
                    r, dff1, depld, fm, deps)
        ddivu = deps(1) + deps(2) + deps(3)
! ----- Pressure
        pm = ddot(nno2,vff2(1,kpg),1,presm,1)
        pd = ddot(nno2,vff2(1,kpg),1,presd,1)
! ----- Kinematic - Product [F].[B]
        if (ndim .eq. 2) then
            do na = 1, nno1
                do ia = 1, ndim
                    def(1,na,ia)= fm(ia,1)*dff1(na,1)
                    def(2,na,ia)= fm(ia,2)*dff1(na,2)
                    def(3,na,ia)= 0.d0
                    def(4,na,ia)=(fm(ia,1)*dff1(na,2)+fm(ia,2)*dff1(na,1))/rac2
                end do
            end do
            if (axi) then
                do na = 1, nno1
                    def(3,na,1) = fm(3,3)*vff1(na,kpg)/r
                end do
            endif
        elseif (ndim .eq. 3) then
            do na = 1, nno1
                do ia = 1, ndim
                    def(1,na,ia)= fm(ia,1)*dff1(na,1)
                    def(2,na,ia)= fm(ia,2)*dff1(na,2)
                    def(3,na,ia)= fm(ia,3)*dff1(na,3)
                    def(4,na,ia)=(fm(ia,1)*dff1(na,2)+fm(ia,2)*dff1(na,1))/rac2
                    def(5,na,ia)=(fm(ia,1)*dff1(na,3)+fm(ia,3)*dff1(na,1))/rac2
                    def(6,na,ia)=(fm(ia,2)*dff1(na,3)+fm(ia,3)*dff1(na,2))/rac2
                end do
            end do
        else
            ASSERT(ASTER_FALSE)
        endif
! ----- CALCUL DE TRACE(B)
        do na = 1, nno1
            do ia = 1, ndim
                deftr(na,ia) = def(1,na,ia) + def(2,na,ia) + def(3,na,ia)
            end do
        end do
! ----- Prepare stresses
        do ia = 1, 3
            sigmPrep(ia) = sigm(ia,kpg) + sigm(2*ndim+1,kpg)
        end do
        do ia = 4, 2*ndim
            sigmPrep(ia) = sigm(ia,kpg)*rac2
        end do
! ----- Compute behaviour
        call nmcomp(BEHinteg,&
                    'RIGI', kpg, 1, ndim, typmod,&
                    mate, compor, carcri, instm, instp,&
                    6, epsm, deps, 6, sigmPrep,&
                    vim(1, kpg), option, angmas, &
                    sigma, vip(1, kpg), 36, dsidep, cod(kpg))
        if (cod(kpg) .eq. 1) then
            goto 999
        endif
! ----- Compute "bubble" matrix
        call tanbul(option, ndim, kpg, mate, rela_comp,&
                    lVect, mini, alpha, dsbdep, trepst)
! ----- Static condensation (for MINI element)
        rce (1:nno2) = 0.d0
        kce(1:nno2,1:nno2) = 0.d0
        if (mini) then
            call calkbb(nno1, ndim, w, def, dsbdep, kbb)
            call calkbp(nno2, ndim, w, dff1, kbp)
            call calkce(nno1, ndim, kbp, kbb, presm, presd, kce, rce)
        endif
! ----- Internal forces
        if (lVect) then
            sigtr = sigma(1) + sigma(2) + sigma(3)
            do ia = 1, 3
                sigma(ia) = sigma(ia) - sigtr/3.d0 + (pm+pd)
            end do
            do na = 1, nno1
                do ia = 1, ndim
                    kk = vu(ia,na)
                    t1 = ddot(2*ndim, sigma,1, def(1,na,ia),1)
                    vect(kk) = vect(kk) + w*t1
                end do
            end do
            t2 = (divum+ddivu-(pm+pd)*alpha-trepst)
            do sa = 1, nno2
                kk = vp(sa)
                t1 = vff2(sa,kpg)*t2
                vect(kk) = vect(kk) + w*t1 - rce(sa)
            end do
        endif
! ----- Cauchy stresses
        if (lSigm) then
            do ia = 1, 3
                sigp(ia,kpg) = sigma(ia)
            end do
            do ia = 4, 2*ndim
                sigp(ia,kpg) = sigma(ia)/rac2
            end do
            sigp(2*ndim+1,kpg) = sigtr/3.d0 - (pm+pd)
        endif
! ----- Rigidity matrix
        if (lMatr) then
            call pmat(6, idev/3.d0, dsidep, devd)
            call pmat(6, dsidep, idev/3.d0, ddev)
            call pmat(6, devd, idev/3.d0, dddev)
! - TERME K:UX
            do na = 1, nno1
                do ia = 1, ndim
                    vuiana = vu(ia,na)
                    os = (vuiana-1)*vuiana/2
! - TERME K:UU      KUU(NDIM,NNO1,NDIM,NNO1)
                    do nb = 1, nno1
                        do ib = 1, ndim
                            if (vu(ib,nb) .le. vuiana) then
                                kk = os+vu(ib,nb)
                                t1 = 0.d0
                                do ja = 1, 2*ndim
                                    do jb = 1, 2*ndim
                                        t1 = t1 + def(ja,na,ia)*dddev(ja,jb)*def(jb,nb,ib)
                                    end do
                                end do
                                matr(kk) = matr(kk) + w*t1
                            endif
                        end do
                    end do
! - TERME K:UP      KUP(NDIM,NNO1,NNO2)
                    do sb = 1, nno2
                        if (vp(sb) .lt. vuiana) then
                            kk = os + vp(sb)
                            t1 = deftr(na,ia)*vff2(sb,kpg)
                            matr(kk) = matr(kk) + w*t1
                        endif
                    end do
                end do
            end do
! - TERME K:PX
            do sa = 1, nno2
                vpsa = vp(sa)
                os = (vpsa-1)*vpsa/2
! - TERME K:PU      KPU(NDIM,NNO2,NNO1)
                do nb = 1, nno1
                    do ib = 1, ndim
                        if (vu(ib,nb) .lt. vpsa) then
                            kk = os + vu(ib,nb)
                            t1 = vff2(sa,kpg)*deftr(nb,ib)
                            matr(kk) = matr(kk) + w*t1
                        endif
                    end do
                end do
! - TERME K:PP      KPP(NNO2,NNO2)
                do sb = 1, nno2
                    if (vp(sb) .le. vpsa) then
                        kk = os + vp(sb)
                        t1 = - vff2(sa,kpg)*vff2(sb,kpg)*alpha
                        matr(kk) = matr(kk) + w*t1 - kce(sa,sb)
                    endif
                end do
            end do
        endif
    end do
!
999 continue
!
! - Return code summary
!
    call codere(cod, npg, codret)
!
end subroutine
