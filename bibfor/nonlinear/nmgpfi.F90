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
! aslint: disable=W1504, W1306
!
subroutine nmgpfi(fami, option, typmod, ndim, nno,&
                  npg, iw, vff, idff, geomInit,&
                  dff, compor, imate, mult_comp, lgpg, carcri,&
                  angmas, instm, instp, dispPrev, dispIncr,&
                  sigmPrev, vim, sigmCurr, vip, fint,&
                  matr, codret)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/crirup.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"
#include "asterfort/nmgpin.h"
#include "asterfort/nmmalu.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
#include "asterfort/Behaviour_type.h"
!
integer :: ndim, nno, npg, imate, lgpg, iw, idff
character(len=8) :: typmod(*)
character(len=*) :: fami
character(len=16) :: option, compor(*)
character(len=16), intent(in) :: mult_comp
real(kind=8) :: geomInit(*), dff(nno, *), carcri(*), instm, instp
real(kind=8) :: vff(nno, npg)
real(kind=8) :: angmas(3)
real(kind=8) :: dispPrev(*), dispIncr(*), sigmPrev(2*ndim, npg)
real(kind=8) :: vim(lgpg, npg), sigmCurr(2*ndim, npg), vip(lgpg, npg)
real(kind=8) :: matr(*), fint(*)
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D, C_PLAN, D_PLAN, AXIS
! Options: RIGI_MECA_TANG, RAPH_MECA and FULL_MECA - SIMO_MIEHE
!
! --------------------------------------------------------------------------------------------------
!
! IN  OPTION  : OPTION DE CALCUL
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  IW      : PTR. POIDS DES POINTS DE GAUSS
! IN  VFF     : VALEUR  DES FONCTIONS DE FORME
! IN  IDFF    : PTR. DERIVEE DES FONCTIONS DE FORME ELEMENT DE REF.
! IN  GEOMI   : COORDONNEES DES NOEUDS (CONFIGURATION INITIALE)
! MEM DFF     : ESPACE MEMOIRE POUR LA DERIVEE DES FONCTIONS DE FORME
!               DIM :(NNO,3) EN 3D, (NNO,4) EN AXI, (NNO,2) EN D_PLAN
! IN  COMPOR  : COMPORTEMENT
! IN  MATE    : MATERIAU CODE
! IN  LGPG    : DIMENSION DU VECTEUR DES VAR. INTERNES POUR 1 PT GAUSS
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
! IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
! IN  INSTM   : VALEUR DE L'INSTANT T-
! IN  INSTP   : VALEUR DE L'INSTANT T+
! IN  DEPLM   : DEPLACEMENT EN T-
! IN  DEPLD   : INCREMENT DE DEPLACEMENT ENTRE T- ET T+
! IN  SIGM    : CONTRAINTES DE CAUCHY EN T-
! IN  VIM     : VARIABLES INTERNES EN T-
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA_*)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA_*)
! OUT FINT    : FORCES INTERIEURES (RAPH_MECA ET FULL_MECA_*)
! OUT MATR    : MATR. DE RIGIDITE NON SYM. (RIGI_MECA_* ET FULL_MECA_*)
! OUT IRET    : CODE RETOUR DE L'INTEGRATION DE LA LDC
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: grand, axi
    aster_logical :: lMatr, lSigm
    integer :: lij(3, 3), ia, ja, na, ib, jb, nb, kpg, kk, os, ija
    integer :: nddl, ndu, vu(3, 27)
    integer :: cod(npg)
    real(kind=8) :: geomPrev(3*27), geomCurr(3*27), r, w
    real(kind=8) :: jacoPrev, jacoIncr, jacoCurr, fPrev(3, 3), fIncr(3, 3), coef
    real(kind=8) :: sigmPrevComp(6), tauCurr(6), dsidep(6, 3, 3)
    real(kind=8) :: rbid, tbid(6), t1, t2
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    type(Behaviour_Integ) :: BEHinteg
    integer, parameter :: vij(3,3) = reshape((/1, 4, 5, 4, 2, 6, 5, 6, 3 /),(/3,3/))
    aster_logical :: resi
!
! --------------------------------------------------------------------------------------------------
!
    

    grand      = ASTER_TRUE
    axi        = typmod(1) .eq. 'AXIS'
    lSigm      = L_SIGM(option)
! - Special case for SIMO_MIEHE
    resi       = option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL'
    lMatr      = L_MATR(option)
    rbid       = r8vide()
    tbid       = r8vide()
    codret     = 0
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
    ASSERT(nno.le.27)
    ASSERT(typmod(1) .ne. 'C_PLAN')
!
    nddl = ndim*nno
    ndu = ndim
    if (axi) ndu = 3
    call nmgpin(ndim, nno, axi, vu)
!
! - Update configuration
! - geomPrev = geomInit + dispPrev
! - geomCurr = geomPrev + dispIncr
!
    call dcopy(nddl, geomInit, 1, geomPrev, 1)
    call daxpy(nddl, 1.d0, dispPrev, 1, geomPrev, 1)
    call dcopy(nddl, geomPrev, 1, geomCurr, 1)
    call daxpy(nddl, 1.d0, dispIncr, 1, geomCurr, 1)
!
! - Loop on Gauss points
!
    cod = 0
    do kpg = 1, npg
        tauCurr = 0.d0
        dsidep  = 0.d0
! ----- Kinematic - Previous strains
        call dfdmip(ndim, nno, axi, geomInit, kpg,&
                    iw, vff(1, kpg), idff, r, w,&
                    dff)
        call nmepsi(ndim, nno, axi, grand, vff(1, kpg),&
                    r, dff, dispPrev, fPrev)
! ----- Kinematic - Increment of strains
        call dfdmip(ndim, nno, axi, geomPrev, kpg,&
                    iw, vff(1, kpg), idff, r, rbid,&
                    dff)
        call nmepsi(ndim, nno, axi, grand, vff(1, kpg),&
                    r, dff, dispIncr, fIncr)
! ----- LU decomposition of GRAD U
        call dfdmip(ndim, nno, axi, geomCurr, kpg,&
                    iw, vff(1, kpg), idff, r, rbid,&
                    dff)
        call nmmalu(nno, axi, r, vff(1, kpg), dff,&
                    lij)
! ----- Kinematic - Jacobians
        jacoPrev = fPrev(1,1)*(fPrev(2,2)*fPrev(3,3)-fPrev(2,3)*fPrev(3,2)) -&
                   fPrev(2,1)*(fPrev(1,2)*fPrev(3,3)-fPrev(1,3)*fPrev(3,2)) +&
                   fPrev(3,1)*(fPrev(1,2)*fPrev(2,3)-fPrev(1,3)*fPrev(2,2))
        jacoIncr = fIncr(1,1)*(fIncr(2,2)*fIncr(3,3)-fIncr(2,3)*fIncr(3,2)) -&
                   fIncr(2,1)*(fIncr(1,2)*fIncr(3,3)-fIncr(1,3)*fIncr(3,2)) +&
                   fIncr(3,1)*(fIncr(1,2)*fIncr(2,3)-fIncr(1, 3)*fIncr(2,2))
        jacoCurr = jacoPrev*jacoIncr
! ----- Check jacobian
        if (jacoIncr .le. 1.d-2 .or. jacoIncr .gt. 1.d2) then
            cod(kpg) = 1
            goto 999
        endif
! ----- Prepare stresses (for compatibility with behaviour using previous stress)
        sigmPrevComp = 0.d0
        call dcopy(ndim*2, sigmPrev(1, kpg), 1, sigmPrevComp, 1)
! ----- Compute behaviour
        cod(kpg) = 0
        call nmcomp(BEHinteg   ,&
                    fami       , kpg        , 1     , 3     , typmod      ,&
                    imate      , compor     , carcri, instm , instp       ,&
                    9          , fPrev      , fIncr , 6     , sigmPrevComp,&
                    vim(1, kpg), option     , angmas, & 
                    tauCurr    , vip(1, kpg), 54    , dsidep,&
                    cod(kpg)   , mult_comp)
        if (cod(kpg) .eq. 1) then
            goto 999
        endif
! ----- Conversion from/to Voigt notation
        if (resi) then
            call dscal(3, 1/rac2, tauCurr(4), 1)
        endif
        if (lMatr) then
            coef=1.d0/rac2
            call dscal(9, coef, dsidep(4, 1, 1), 6)
            call dscal(9, coef, dsidep(5, 1, 1), 6)
            call dscal(9, coef, dsidep(6, 1, 1), 6)
        endif
! ----- Internal forces and Cauchy stresses
        if (resi) then
            call dcopy(2*ndim, tauCurr, 1, sigmCurr(1, kpg), 1)
            coef = 1.d0/jacoCurr
            call dscal(2*ndim, coef, sigmCurr(1, kpg), 1)
            do na = 1, nno
                do ia = 1, ndu
                    kk = vu(ia,na)
                    t1 = 0
                    do ja = 1, ndu
                        t2 = tauCurr(vij(ia,ja))
                        t1 = t1 + t2*dff(na,lij(ia,ja))
                    end do
                    fint(kk) = fint(kk) + w*t1
                end do
            end do
        endif
! ----- Tangent matrix (non-symmetric)
        if (lMatr) then
            if (.not. resi) then
                call dcopy(2*ndim, sigmPrev(1, kpg), 1, tauCurr, 1)
                call dscal(2*ndim, jacoPrev, tauCurr, 1)
            endif
            if (ndu .eq. 3) then
                do  na = 1, nno
                    do ia = 1, 3
                        os = (vu(ia,na) - 1)*nddl
                        do nb = 1, nno
                            do ib = 1, 3
                                kk = os + vu(ib,nb)
                                t1 = 0.d0
! ----------------------------- Material part
                                do ja = 1, 3
                                    do jb = 1, 3
                                        ija = vij(ia,ja)
                                        t2 = dsidep(ija,ib,jb)
                                        t1 = t1 +&
                                             dff(na, lij(ia, ja))*t2*dff(nb, lij(ib, jb))
                                    end do
                                end do
! ----------------------------- Geometric part
                                do jb = 1, 3
                                    t1 = t1 -&
                                         dff(na, lij(ia, ib))*&
                                         dff(nb, lij(ib, jb))*&
                                         tauCurr(vij(ia, jb))
                                end do
                                matr(kk) = matr(kk) + w*t1
                            end do
                        end do
                    end do
                end do
            else if (ndu.eq.2) then
                do na = 1, nno
                    do ia = 1, 2
                        os = (vu(ia,na) - 1)*nddl
                        do nb = 1, nno
                            do ib = 1, 2
                                kk = os + vu(ib,nb)
                                t1 = 0.d0
! ----------------------------- Material part
                                do ja = 1, 2
                                    do jb = 1, 2
                                        ija = vij(ia,ja)
                                        t2 = dsidep(ija,ib,jb)
                                        t1 = t1 +&
                                             dff(na, lij(ia, ja))*t2*dff(nb, lij(ib, jb))
                                    end do
                                end do
! ----------------------------- Geometric part
                                do jb = 1, 2
                                    t1 = t1 -&
                                         dff(na, lij(ia, ib))*&
                                         dff(nb, lij(ib, jb))*&
                                         tauCurr(vij(ia, jb))
                                end do
                                matr(kk) = matr(kk) + w*t1
                            end do
                        end do
                    end do
                end do
            endif
        endif
    end do
!
! - For POST_ITER='CRIT_RUPT'
!
    if (carcri(13) .gt. 0.d0) then
        call crirup(fami  , imate , ndim    , npg, lgpg,&
                    option, compor, sigmCurr, vip, vim ,&
                    instm , instp)
    endif
!
999 continue
!
! - Return code summary
!
    call codere(cod, npg, codret)
end subroutine
