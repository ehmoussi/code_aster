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
subroutine nmgr2d(option  , typmod  ,&
                  fami    , imate   ,&
                  nno     , npg     , lgpg     ,&
                  ipoids  , ivf     , vff      , idfde,&
                  compor  , carcri  , mult_comp,&
                  instam  , instap  ,&
                  geomInit, dispPrev, dispIncr ,&
                  sigmPrev, sigmCurr,&
                  vim     , vip     ,&
                  matsym  , matuu   , vectu    ,&
                  codret)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/lcdetf.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmgeom.h"
#include "asterfort/nmgrtg.h"
#include "asterfort/pk2sig.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: option
character(len=8), intent(in) :: typmod(*)
character(len=*), intent(in) :: fami
integer, intent(in) :: imate
integer, intent(in) :: nno, npg, lgpg
integer, intent(in) :: ipoids, ivf, idfde
real(kind=8), intent(in) :: vff(*)
character(len=16), intent(in) :: compor(*)
real(kind=8), intent(in) :: carcri(*)
character(len=16), intent(in) :: mult_comp
real(kind=8), intent(in) :: instam, instap
real(kind=8), intent(in) :: geomInit(2, nno)
real(kind=8), intent(inout) :: dispPrev(2*nno),  dispIncr(2*nno)
real(kind=8), intent(inout) :: sigmPrev(4, npg), sigmCurr(4, npg)
real(kind=8), intent(inout) :: vim(lgpg, npg), vip(lgpg, npg)
aster_logical, intent(in) :: matsym
real(kind=8), intent(inout) :: matuu(*)
real(kind=8), intent(inout) :: vectu(2*nno)
integer, intent(inout) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: C_PLAN, D_PLAN, AXIS
!
! Options: RIGI_MECA_TANG, RAPH_MECA and FULL_MECA - Large displacements/rotations (GROT_GDEP)
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  fami             : Gauss family for integration point rule
! In  imate            : coded material address (JEVEUX)
! In  nno              : number of nodes
! In  npg              : number of Gauss integration point
! In  lgpg             : total length of vector for internal state variable
! In  ipoids           : Gauss point weight address (JEVEUX)
! In  ivf              : shape functions address (JEVEUX)
! In  idfde            : derivative of shape functions address (JEVEUX)
! In  vff              : shape functions
! In  carcri           : parameters for behaviour
! In  compor           : behaviour
! In  mult_comp        : multi-comportment (DEFI_COMPOR for PMF)
! In  instam           : time at beginning of time step
! In  instap           : time at end of time step
! In  geomInit        : initial coordinates of nodes (from mesh)
! IO  dispPrev        : displacements at beginning of time step
! IO  dispIncr        : displacements from beginning of time step
! IO  sigmPrev             : stresses at beginning of time step
! IO  sigmCurr             : stresses at end of time step
! IO  vim              : internal state variables at beginning of time step
! IO  vip              : internal state variables at end of time step
! In  matsym           : .true. if symmetric matrix
! IO  matuu            : matrix
! IO  vectu            : vector (internal forces)
! Out codret           : code for error
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: ndim = 2
    aster_logical :: grand, axi, cplan
    aster_logical :: lVect, lMatr, lSigm, lMatrPred
    integer :: kpg, j, strain_model
    integer :: cod(npg)
    real(kind=8) :: dsidep(6, 6)
    real(kind=8) :: fPrev(3, 3), fCurr(3, 3)
    real(kind=8) :: epsgPrev(6), epsgIncr(6), epsgCurr(6)
    real(kind=8) :: detfPrev, detfCurr
    real(kind=8) :: dispCurr(2*nno)
    real(kind=8) :: r, sigmPost(6), sigmPrep(6), poids, maxeps
    real(kind=8) :: angl_naut(3)
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8) :: dfdi(nno,2), pff(4,nno,nno), def(4,nno,2)
    character(len=16) :: rela_comp
    type(Behaviour_Integ) :: BEHinteg
!
! --------------------------------------------------------------------------------------------------
!
    grand      = ASTER_TRUE
    axi        = typmod(1) .eq. 'AXIS'
    cplan      = typmod(1) .eq. 'C_PLAN'
    cod        = 0
    lSigm      = L_SIGM(option)
    lVect      = L_VECT(option)
    lMatr      = L_MATR(option)
    lMatrPred  = L_MATR_PRED(option)
    dispCurr   = 0.d0
    rela_comp  = compor(RELA_NAME)
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
! - Get coded integer for external state variable
!
    strain_model = nint(carcri(EXTE_STRAIN))
!
! - Prepare external state variables
!
    call behaviourPrepESVAElem(carcri  , typmod  ,&
                               nno     , npg     , ndim ,&
                               ipoids  , ivf     , idfde,&
                               geomInit, BEHinteg,&
                               dispPrev, dispIncr)
!
! - Only isotropic material !
!
    angl_naut(1:3) = r8nnem()
!
! - Update displacements
!
    dispCurr(:) = dispPrev(:) + dispIncr(:)
!
! - Loop on Gauss points
!
    do kpg = 1, npg
        epsgPrev = 0.d0
        epsgIncr = 0.d0
        epsgCurr = 0.d0
! ----- Kinematic - Previous strains
        call nmgeom(ndim    , nno   , axi , grand, geomInit,&
                    kpg     , ipoids, ivf , idfde, dispPrev,&
                    .true._1, poids , dfdi, fPrev, epsgPrev,&
                    r)
! ----- Kinematic - Current strains
        call nmgeom(ndim     , nno   , axi , grand, geomInit,&
                    kpg      , ipoids, ivf , idfde, dispCurr,&
                    .true._1, poids , dfdi, fCurr, epsgCurr,&
                    r)
! ----- Stresses: convert Cauchy to PK2
        if (cplan) then
            fPrev(3,3) = sqrt(abs(2.d0*epsgPrev(3)+1.d0))
        endif
        call lcdetf(ndim, fPrev, detfPrev)
        call pk2sig(ndim, fPrev, detfPrev, sigmPrep, sigmPrev(1, kpg), -1)
        sigmPrep(4) = sigmPrep(4)*rac2
! ----- Compute behaviour
        if ((strain_model .eq. MFRONT_STRAIN_GROTGDEP_S) .or. &
            (strain_model .eq. 0)) then
! --------- Check "small strains"
            maxeps = 0.d0
            do j = 1, 6
                epsgIncr(j) = epsgCurr(j)-epsgPrev(j)
                maxeps       = max(maxeps,abs(epsgIncr(j)))
            end do
            if (maxeps .gt. 0.05d0) then
                if (rela_comp(1:4) .ne. 'ELAS') then
                    call utmess('A', 'COMPOR2_9', sr=maxeps)
                endif
            endif
! --------- Compute behaviour
            call nmcomp(BEHinteg   ,&
                        fami       , kpg        , 1        , ndim  , typmod  ,&
                        imate      , compor     , carcri   , instam, instap  ,&
                        6          , epsgPrev   , epsgIncr , 6     , sigmPrep,&
                        vim(1, kpg), option     , angl_naut,&
                        sigmPost   , vip(1, kpg), 36       , dsidep,&
                        cod(kpg)   , mult_comp)
            if (cod(kpg) .eq. 1) then
                goto 999
            endif
        elseif (strain_model .eq. MFRONT_STRAIN_GROTGDEP_L) then
! --------- Jacobian must been positive !
            call lcdetf(ndim, fCurr, detfCurr)
            if (detfCurr .le. 1.D-6) then
                cod(kpg) = 1
                goto 999
            endif
! --------- Compute behaviour
            call nmcomp(BEHinteg   ,&
                        fami       , kpg        , 1        , ndim  , typmod  ,&
                        imate      , compor     , carcri   , instam, instap  ,&
                        9          , fPrev      , fCurr    , 6     , sigmPrep,&
                        vim(1, kpg), option     , angl_naut,&
                        sigmPost   , vip(1, kpg), 36       , dsidep,&
                        cod(kpg)   , mult_comp)
            if (cod(kpg) .eq. 1) then
                goto 999
            endif
        else
            ASSERT(ASTER_FALSE)
        endif
! ----- Compute internal forces vector and rigidity matrix
        call nmgrtg(ndim    , nno   , poids    , kpg   , vff     ,&
                    dfdi    , def   , pff      , axi     ,&
                    lVect   , lMatr , lMatrPred,&
                    r       , fPrev , fCurr    , dsidep, sigmPrep,&
                    sigmPost, matsym, matuu    , vectu)
! ----- Stresses: convert PK2 to Cauchy
        if (option(1:4) .eq. 'RAPH' .or. option(1:4) .eq. 'FULL') then
            if (cplan) then
                fCurr(3,3) = sqrt(abs(2.d0*epsgCurr(3)+1.d0))
            endif
            call lcdetf(ndim, fCurr, detfCurr)
            call pk2sig(ndim, fCurr, detfCurr, sigmPost, sigmCurr(1, kpg), 1)
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
