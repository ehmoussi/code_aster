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
subroutine nmgr2d(fami , nno   , npg   , ipoids, ivf   , vff      , idfde,&
                  geomi, typmod, option, imate , compor, mult_comp,&
                  lgpg , carcri, instam, instap, deplm ,&
                  deplp, sigm  , vim   , matsym,&
                  sigp , vip   , matuu , vectu , codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/codere.h"
#include "asterfort/lcdetf.h"
#include "asterfort/lcegeo.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmgeom.h"
#include "asterfort/nmgrtg.h"
#include "asterfort/pk2sig.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: nno, npg
integer, intent(in) :: ipoids, ivf, idfde
real(kind=8), intent(in) :: vff(*)
real(kind=8), intent(in) :: geomi(2, nno)
character(len=8), intent(in) :: typmod(*)
character(len=16), intent(in) :: option
integer, intent(in) :: imate
character(len=16), intent(in) :: compor(*)
character(len=16), intent(in) :: mult_comp
real(kind=8), intent(in) :: carcri(*)
integer, intent(in) :: lgpg
real(kind=8), intent(in) :: instam
real(kind=8), intent(in) :: instap
real(kind=8), intent(inout) :: deplm(2*nno)
real(kind=8), intent(inout) :: deplp(2*nno)
real(kind=8), intent(inout) :: sigm(4, npg)
real(kind=8), intent(inout) :: vim(lgpg, npg)
aster_logical, intent(in) :: matsym
real(kind=8), intent(inout) :: sigp(4, npg)
real(kind=8), intent(inout) :: vip(lgpg, npg)
real(kind=8), intent(inout) :: matuu(*)
real(kind=8), intent(inout) :: vectu(2*nno)
integer, intent(inout) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D
! Options: RIGI_MECA_TANG, RAPH_MECA and FULL_MECA - Large displacements/rotations (GROT_GDEP)
!
! --------------------------------------------------------------------------------------------------
!
! IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
! IN  NPG     : NOMBRE DE POINTS DE GAUSS
! IN  POIDSG  : POIDS DES POINTS DE GAUSS
! IN  VFF     : VALEUR  DES FONCTIONS DE FORME
! IN  DFDE    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  DFDK    : DERIVEE DES FONCTIONS DE FORME ELEMENT DE REFERENCE
! IN  GEOMI   : COORDONEES DES NOEUDS SUR CONFIG INITIALE
! IN  TYPMOD  : TYPE DE MODEELISATION
! IN  OPTION  : OPTION DE CALCUL
! IN  IMATE   : MATERIAU CODE
! IN  COMPOR  : COMPORTEMENT
! IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
! IN  INSTAM  : INSTANT PRECEDENT
! IN  INSTAP  : INSTANT DE CALCUL
! IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
! IN  DEPLP   : DEPLACEMENT A L'INSTANT COURANT
! IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
! IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
! IN  MATSYM  : VRAI SI LA MATRICE DE RIGIDITE EST SYMETRIQUE
! OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
! OUT DEF     : PRODUIT DER. FCT. FORME PAR F   AU DERNIER PT DE GAUSS
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
! OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
! OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: grand, axi, cplan
    integer :: kpg, j, jvariexte, ndim
    real(kind=8) :: dsidep(6, 6), f(3, 3), fm(3, 3), epsm(6), epsp(6), deps(6)
    real(kind=8) :: r, sigma(6), sigm_norm(6), detf, poids, maxeps, detfm
    real(kind=8) :: elgeom(10, 9), wkout(1), angl_naut(3)
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    integer :: cod(9)
    real(kind=8) :: dfdi(nno,2), pff(4,nno,nno), def(4,nno,2)
!
! --------------------------------------------------------------------------------------------------
!
    ndim        = 2
    elgeom(:,:) = 0.d0
    wkout(1)    = 0.d0
    cod(:)      = 0
    grand       = ASTER_TRUE
    axi         = typmod(1) .eq. 'AXIS'
    cplan       = typmod(1) .eq. 'C_PLAN'
!
! - Get coded integer for external state variable
!
    jvariexte = nint(carcri(IVARIEXTE))
!
! - Compute intrinsic external state variables
!
    call lcegeo(nno   , npg      , ndim ,&
                ipoids, ivf      , idfde,&
                typmod, jvariexte, &
                geomi , deplm    , deplp )
!
! - Only isotropic material !
!
    angl_naut(1:3) = r8nnem()
!
! - Loop on Gauss points
!
    do kpg = 1, npg
        epsm(1:6)=0.d0
        epsp(1:6)=0.d0
!
! ----- Kinematic - Previous strains
!
        call nmgeom(ndim    , nno   , axi , grand, geomi,&
                    kpg     , ipoids, ivf , idfde, deplm,&
                    .true._1, poids , dfdi, fm   , epsm ,&
                    r)
!
! ----- Kinematic - Increment of strains
!
        call nmgeom(ndim    , nno   , axi , grand, geomi,&
                    kpg     , ipoids, ivf , idfde, deplp,&
                    .true._1, poids , dfdi, f    , epsp ,&
                    r)
        maxeps=0.d0
        do j = 1, 6
            deps (j)=epsp(j)-epsm(j)
            maxeps=max(maxeps,abs(epsp(j)))
        end do
!
! ----- Check "small strains"
!
        if (maxeps .gt. 0.05d0) then
            if (compor(1)(1:4) .ne. 'ELAS') then
                call utmess('A', 'COMPOR2_9', sr=maxeps)
            endif
        endif
!
! ----- Stresses: convert Cauchy to PK2
!
        if (cplan) then
            fm(3,3) = sqrt(abs(2.d0*epsm(3)+1.d0))
        endif
        call lcdetf(ndim, fm, detfm)
        call pk2sig(ndim, fm, detfm, sigm_norm, sigm(1, kpg), -1)
        sigm_norm(4) = sigm_norm(4)*rac2
        !sigm_norm(5) = sigm_norm(5)*rac2
        !sigm_norm(6) = sigm_norm(6)*rac2
!
! ----- Compute behaviour
!
        call nmcomp(fami       , kpg        , 1        , ndim  , typmod        ,&
                    imate      , compor     , carcri   , instam, instap        ,&
                    6          , epsm       , deps     , 6     , sigm_norm     ,&
                    vim(1, kpg), option     , angl_naut, 10    , elgeom(1, kpg),&
                    sigma      , vip(1, kpg), 36       , dsidep, 1             ,&
                    wkout      , cod(kpg)   , mult_comp)
        if (cod(kpg) .eq. 1) then
            goto 999
        endif
!
! ----- Compute internal forces vector and rigidity matrix
!
        call nmgrtg(ndim , nno   , poids, kpg   , vff      ,&
                    dfdi , def   , pff  , option, axi      ,&
                    r    , fm    , f    , dsidep, sigm_norm,&
                    sigma, matsym, matuu, vectu)
!
! ----- Stresses: convert PK2 to Cauchy
!
        if (option(1:4) .eq. 'RAPH' .or. option(1:4) .eq. 'FULL') then
            if (cplan) then
                f(3,3) = sqrt(abs(2.d0*epsp(3)+1.d0))
            endif
            call lcdetf(ndim, f, detf)
            call pk2sig(ndim, f, detf, sigma, sigp(1, kpg), 1)
        endif
!
    end do
!
999 continue
!
! - Return code summary
!
    call codere(cod, npg, codret)
!
end subroutine
