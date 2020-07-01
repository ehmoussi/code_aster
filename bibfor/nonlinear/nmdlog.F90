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
subroutine nmdlog(fami    , option  , typmod  , ndim     , nno     ,&
                  npg     , iw      , ivf     , vff      , idff    ,&
                  geomInit, dff     , compor  , mult_comp, mate    , lgpg,&
                  carcri  , angmas  , instm   , instp    , matsym  ,&
                  dispPrev, dispIncr, sigmPrev, vim      , sigmCurr,&
                  vip     , fint    , matuu   , codret)
!
use Behaviour_type
use Behaviour_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmepsi.h"
#include "asterfort/nmgrtg.h"
#include "asterfort/poslog.h"
#include "asterfort/prelog.h"
#include "asterfort/r8inir.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "asterfort/Behaviour_type.h"
!
integer, intent(in) :: ndim, nno, npg
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: D_PLAN, C_PLAN, AXIS
!           AXIS_SI, C_PLAN_SI (QUAD8), D_PLAN_SI (QUAD8)
!           3D
!           3D_SI (HEXA20)
!
! Options: RIGI_MECA_TANG, RAPH_MECA and FULL_MECA - GDEF_LOG
!
! --------------------------------------------------------------------------------------------------
!
! IN  FAMI    : FAMILLE DE POINTS DE GAUSS
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
! IN  MATSYM  : .TRUE. SI MATRICE SYMETRIQUE
! IN  DEPLM   : DEPLACEMENT EN T-
! IN  DEPLD   : INCREMENT DE DEPLACEMENT ENTRE T- ET T+
! IN  SIGM    : CONTRAINTES DE CAUCHY EN T-
! IN  VIM     : VARIABLES INTERNES EN T-
! OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA_*)
! OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA_*)
! OUT FINT    : FORCES INTERIEURES (RAPH_MECA ET FULL_MECA_*)
! OUT MATUU   : MATR. DE RIGIDITE NON SYM. (RIGI_MECA_* ET FULL_MECA_*)
! OUT CODRET  : CODE RETOUR DE L'INTEGRATION DE LA LDC
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: grand, axi, cplan
    aster_logical :: matsym, lintbo
    aster_logical :: lVect, lMatr, lSigm, lMatrPred
    integer :: kpg, nddl, cod(npg), ivf
    integer :: mate, lgpg, codret, iw, idff, iret
    character(len=8) :: typmod(*)
    character(len=*) :: fami
    character(len=16) :: option
    character(len=16), intent(in) :: compor(*)
    character(len=16), intent(in) :: mult_comp
    real(kind=8), intent(in) :: carcri(*)
    real(kind=8) :: geomInit(*), dff(nno, *), instm, instp
    real(kind=8) :: vff(nno, npg), dtde(6, 6)
    real(kind=8) :: angmas(3), dispPrev(*), dispIncr(*), sigmPrev(2*ndim, npg), epslPrev(6)
    real(kind=8) :: vim(lgpg, npg), sigmCurr(2*ndim, npg), vip(lgpg, npg)
    real(kind=8) :: matuu(*), fint(ndim*nno)
    real(kind=8) :: geomPrev(3*27), fPrev(3, 3), fCurr(3, 3), dispCurr(3*27)
    real(kind=8) :: r, poids, tlogPrev(6), tlogCurr(6), epslIncr(6)
    real(kind=8) :: gn(3, 3), lamb(3), logl(3)
    real(kind=8) :: def(2*ndim, nno, ndim), pff(2*ndim, nno, nno)
    real(kind=8) :: dsidep(6, 6), pk2Curr(6), pk2Prev(6)
    type(Behaviour_Integ) :: BEHinteg
    aster_logical :: resi
!
! --------------------------------------------------------------------------------------------------
!
    resi = option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL'
    grand     = ASTER_TRUE
    axi       = typmod(1) .eq. 'AXIS'
    cplan     = typmod(1).eq.'C_PLAN'
    lSigm     = L_SIGM(option)
    lVect     = L_VECT(option)
    lMatr     = L_MATR(option)
    lMatrPred = L_MATR_PRED(option)
    nddl      = ndim*nno
!
! - Initialisation of behaviour datastructure
!
    call behaviourInit(BEHinteg)
!
    ASSERT(nno.le.27)
    if (compor(PLANESTRESS)(1:7) .eq. 'DEBORST') then
        ASSERT(.false.)
    endif
!
! - Prepare external state variables
!
    call behaviourPrepESVAElem(carcri  , typmod  ,&
                               nno     , npg     , ndim,&
                               iw      , ivf     , idff,&
                               geomInit, BEHinteg,&
                               dispPrev, dispIncr)
!
! - Update configuration
!
    call dcopy(nddl, geomInit, 1, geomPrev, 1)
    call daxpy(nddl, 1.d0, dispPrev, 1, geomPrev, 1)
    call dcopy(nddl, dispPrev, 1, dispCurr, 1)
    if (resi) then
        call daxpy(nddl, 1.d0, dispIncr, 1, dispCurr, 1)
    endif
!
! - Loop on Gauss points
!
    lintbo = ASTER_FALSE
    cod    = 0
    do kpg = 1, npg
! ----- Kinematic - Previous strains
        call dfdmip(ndim, nno, axi, geomInit, kpg,&
                    iw, vff(1, kpg), idff, r, poids,&
                    dff)
        call nmepsi(ndim, nno, axi, grand, vff(1, kpg),&
                    r, dff, dispPrev, fPrev)
! ----- Kinematic - Current strains
        call nmepsi(ndim, nno, axi, grand, vff(1, kpg),&
                    r, dff, dispCurr, fCurr)
! ----- Pre-treatment of kinematic quantities
        call prelog(ndim    , lgpg , vim(1, kpg), gn      , lamb    ,&
                    logl    , fPrev, fCurr      , epslPrev, epslIncr,&
                    tlogPrev, resi , cod(kpg))
        if (cod(kpg) .ne. 0) then
            goto 999
        endif
! ----- Compute behaviour
        cod(kpg) = 0
        dtde     = 0.d0
        tlogCurr    = 0.d0
        call nmcomp(BEHinteg   ,&
                    fami       , kpg        , 1       , ndim , typmod  ,&
                    mate       , compor     , carcri  , instm, instp   ,&
                    6          , epslPrev   , epslIncr, 6    , tlogPrev,&
                    vim(1, kpg), option     , angmas  , &
                    tlogCurr   , vip(1, kpg), 36      , dtde ,&
                    cod(kpg)   , mult_comp)
        if (cod(kpg) .eq. 1) then
            goto 999
        endif
        if (cod(kpg) .eq. 4) then
            lintbo= .true.
        endif
! ----- Post-treatment of sthenic quantities
        call poslog(resi            , lMatr           , tlogPrev, tlogCurr, fPrev,&
                    lgpg            , vip(1, kpg)     , ndim    , fCurr   , kpg  ,&
                    dtde            , sigmPrev(1, kpg), cplan   , fami    , mate ,&
                    instp           , angmas          , gn      , lamb    , logl ,&
                    sigmCurr(1, kpg), dsidep          , pk2Prev , pk2Curr , iret)
        if (iret .eq. 1) then
            cod(kpg) = 1
            goto 999
        end if
! ----- Compute internal forces and matrix
        call nmgrtg(ndim   , nno   , poids    , kpg   , vff    ,&
                    dff    , def   , pff      , axi    ,&
                    lVect  , lMatr , lMatrPred,&
                    r      , fPrev , fCurr    , dsidep, pk2Prev,&
                    pk2Curr, matsym, matuu    , fint)
    end do
    if (lintbo) then
        cod(1) = 4
    endif
!
999 continue
!
! - Return code summary
!
    call codere(cod, npg, codret)
!
end subroutine
