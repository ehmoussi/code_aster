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
subroutine nmpl2d(fami    , nno      , npg   ,&
                  ipoids  , ivf      , idfde ,&
                  geom    , typmod   , option, imate ,&
                  compor  , mult_comp, lgpg  , carcri,&
                  instam  , instap   ,&
                  dispPrev, dispIncr ,&
                  angmas  , sigmPrev , vim   ,&
                  matsym  , sigmCurr , vip   ,&
                  matuu   , vectu    , codret)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/codere.h"
#include "asterfort/crirup.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmgeom.h"
#include "asterfort/Behaviour_type.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: nno, npg
integer, intent(in) :: ipoids, ivf, idfde
real(kind=8), intent(in) :: geom(2, nno)
character(len=8), intent(in) :: typmod(*)
character(len=16), intent(in) :: option
integer, intent(in) :: imate
character(len=16), intent(in) :: compor(*), mult_comp
real(kind=8), intent(in) :: carcri(*)
integer, intent(in) :: lgpg
real(kind=8), intent(in) :: instam, instap
real(kind=8), intent(inout) :: dispPrev(2, nno), dispIncr(2, nno)
real(kind=8), intent(in) :: angmas(*)
real(kind=8), intent(inout) :: sigmPrev(4, npg), vim(lgpg, npg)
aster_logical, intent(in) :: matsym
real(kind=8), intent(inout) :: sigmCurr(4, npg), vip(lgpg, npg)
real(kind=8), intent(inout) :: matuu(*), vectu(2, nno)
integer, intent(inout) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: C_PLAN, D_PLAN, AXIS
!
! Options: RIGI_MECA_TANG, RAPH_MECA and FULL_MECA - Hypoelasticity (PETIT/PETIT_REAC)
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  POIDSG  : POIDS DES POINTS DE GAUSS
! IN  VFF     : VALEUR  DES FONCTIONS DE FORME
! IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  GEOM    : COORDONEES DES NOEUDS
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  IMATE   : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  CARCRI  : CRITERES DE CONVERGENCE LOCAUX
! IN  INSTAM  : INSTANT PRECEDENT
! IN  INSTAP  : INSTANT DE CALCUL
! IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
! IN  DEPLP   : INCREMENT DE DEPLACEMENT
! IN  ANGMAS  : LES TROIS ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
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
    aster_logical :: lVect, lMatr, lSigm
    integer :: kpg, kk, j, m, j1, kkd
    integer :: i_node, i_dime, i_tens
    integer :: cod(npg)
    real(kind=8) :: dfdi(nno, ndim), def(sz_tens, nno, ndim)
    real(kind=8) :: r
    real(kind=8) :: f(3, 3), epsiPrev(6), epsiIncr(6)
    real(kind=8) :: dsidep(6, 6), sigmPost(6), sig(6), sigmPrep(6)
    real(kind=8) :: poids, tmp
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    type(Behaviour_Integ) :: BEHinteg
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
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
! - Prepare external state variables
!
    call behaviourPrepESVAElem(carcri   , typmod  ,&
                               nno      , npg     , ndim ,&
                               ipoids   , ivf     , idfde,&
                               geom     , BEHinteg,&
                               dispPrev , dispIncr)
!
! - Loop on Gauss points
!
    do kpg = 1, npg
        epsiPrev = 0.d0
        epsiIncr = 0.d0
! ----- Kinematic - Previous strains
        call nmgeom(ndim    , nno   , axi , grand, geom ,&
                    kpg     , ipoids, ivf , idfde, dispPrev,&
                    .true._1, poids , dfdi, f    , epsiPrev,&
                    r)
! ----- Kinematic - Increment of strains
        call nmgeom(ndim    , nno   , axi , grand, geom ,&
                    kpg     , ipoids, ivf , idfde, dispIncr,&
                    .true._1, poids , dfdi, f    , epsiIncr ,&
                    r)
! ----- Kinematic - Product [F].[B]
        do i_node = 1, nno
            do i_dime = 1, ndim
                def(1,i_node,i_dime) = f(i_dime,1)*dfdi(i_node,1)
                def(2,i_node,i_dime) = f(i_dime,2)*dfdi(i_node,2)
                def(3,i_node,i_dime) = 0.d0
                def(4,i_node,i_dime) = (f(i_dime,1)*dfdi(i_node,2) +&
                                        f(i_dime,2)*dfdi(i_node,1))/rac2
            end do
        end do
        if (axi) then
            do i_node = 1, nno
                def(3,i_node,1) = f(3,3)*zr(ivf+i_node+(kpg-1)*nno-1)/r
            end do
        endif
! ----- Prepare stresses
        do i_tens = 1, 3
            sigmPrep(i_tens) = sigmPrev(i_tens, kpg)
        end do
        sigmPrep(4) = sigmPrev(4, kpg)*rac2
! ----- Compute behaviour
        call nmcomp(BEHinteg   ,&
                    fami       , kpg        , 1       , ndim  , typmod  ,&
                    imate      , compor     , carcri  , instam, instap  ,&
                    6          , epsiPrev   , epsiIncr, 6     , sigmPrep,&
                    vim(1, kpg), option     , angmas  ,&
                    sigmPost   , vip(1, kpg), 36      , dsidep          ,&
                    cod(kpg)   , mult_comp)
        if (cod(kpg) .eq. 1) then
            goto 999
        endif
! ----- Rigidity matrix
        if (lMatr) then
            if (matsym) then
                do i_node = 1, nno
                    do i_dime = 1, ndim
                        kkd = (ndim*(i_node-1)+i_dime-1) * (ndim*(i_node-1)+i_dime) /2
                        do i_tens = 1, sz_tens
                            sig(i_tens) = 0.d0
                            sig(i_tens) = sig(i_tens)+def(1,i_node,i_dime)*dsidep(1,i_tens)
                            sig(i_tens) = sig(i_tens)+def(2,i_node,i_dime)*dsidep(2,i_tens)
                            sig(i_tens) = sig(i_tens)+def(3,i_node,i_dime)*dsidep(3,i_tens)
                            sig(i_tens) = sig(i_tens)+def(4,i_node,i_dime)*dsidep(4,i_tens)
                        end do
                        do j = 1, ndim
                            do m = 1, i_node
                                if (m .eq. i_node) then
                                    j1 = i_dime
                                else
                                    j1 = ndim
                                endif
                                tmp = def(1,m,j)*sig(1) + def(2,m,j)*sig(2)+&
                                      def(3,m,j)*sig(3) + def(4,m,j)*sig(4)
                                if (j .le. j1) then
                                    kk = kkd + ndim*(m-1)+j
                                    matuu(kk) = matuu(kk) + tmp*poids
                                endif
                            end do
                        end do
                    end do
                end do
            else
                do i_node = 1, nno
                    do i_dime = 1, ndim
                        do i_tens = 1, sz_tens
                            sig(i_tens) = 0.d0
                            sig(i_tens) = sig(i_tens)+def(1,i_node,i_dime)*dsidep(1,i_tens)
                            sig(i_tens) = sig(i_tens)+def(2,i_node,i_dime)*dsidep(2,i_tens)
                            sig(i_tens) = sig(i_tens)+def(3,i_node,i_dime)*dsidep(3,i_tens)
                            sig(i_tens) = sig(i_tens)+def(4,i_node,i_dime)*dsidep(4,i_tens)
                        end do
                        do j = 1, ndim
                            do m = 1, nno
                                tmp = def(1,m,j)*sig(1) + def(2,m,j)*sig(2)+&
                                      def(3,m,j)*sig(3) + def(4,m,j)*sig(4)
                                kk = ndim*nno*(ndim*(i_node-1)+i_dime-1) + ndim*(m-1)+j
                                matuu(kk) = matuu(kk) + tmp*poids
                            end do
                        end do
                    end do
                end do
            endif
        endif
! ----- Internal forces
        if (lVect) then
            do i_node = 1, nno
                do i_dime = 1, ndim
                    do i_tens = 1, sz_tens
                        vectu(i_dime,i_node) = vectu(i_dime,i_node)+&
                                               poids*def(i_tens,i_node,i_dime)*sigmPost(i_tens)
                    end do
                end do
            end do
        endif
! ----- Cauchy stresses
        if (lSigm) then
            do i_tens = 1, 3
                sigmCurr(i_tens,kpg) = sigmPost(i_tens)
            end do
            sigmCurr(4,kpg) = sigmPost(4)/rac2
        endif
! ----- Cauchy stresses for IMPLEX
        if (option .eq. 'RIGI_MECA_IMPLEX') then
            do i_tens = 1, 3
                sigmCurr(i_tens,kpg) = sigmPost(i_tens)
            end do
            sigmCurr(4,kpg) = sigmPost(4)/rac2
        endif
    end do
!
! - For POST_ITER='CRIT_RUPT'
!
    if (carcri(13) .gt. 0.d0) then
        call crirup(fami  , imate , ndim, npg, lgpg,&
                    option, compor, sigmCurr, vip, vim ,&
                    instam, instap)
    endif
!
999 continue
!
! - Return code summary
!
    call codere(cod, npg, codret)
!
end subroutine
