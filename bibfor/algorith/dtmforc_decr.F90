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

subroutine dtmforc_decr(nl_ind, sd_dtm_, sd_nl_, buffdtm, buffnl,&
                        time  , step   , depl  , vite  , fext)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmforc_decr : Calculates a "discrete model with isotropic behavior's"
!                force at the current step (t)
!
!       nl_ind           : nonlinearity index (for sd_nl access)
!       sd_dtm_, buffdtm : dtm data structure and its buffer
!       sd_nl_ , buffnl  : nl  data structure and its buffer
!       time, step       : current t and integration dt
!       depl, vite       : structural modal displacement and velocity at "t"
!       fext             : projected total non-linear force
!
#include "jeveux.h"
#include "blas/dcopy.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/dtmget.h"
#include "asterfort/fointe.h"
#include "asterfort/gloloc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/locglo.h"
#include "asterfort/rk5adp.h"
#include "asterfort/nlget.h"
#include "asterfort/tophys.h"
#include "asterfort/tophys_ms.h"
#include "asterfort/togene.h"
#include "asterfort/utmess.h"
#include "asterfort/disc_isotr.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"

!
!   -0.1- Input/output arguments
    integer               , intent(in)  :: nl_ind
    character(len=*)      , intent(in)  :: sd_dtm_
    character(len=*)      , intent(in)  :: sd_nl_
    integer     , pointer  :: buffdtm  (:)
    integer     , pointer  :: buffnl   (:)
    real(kind=8)          , intent(in)  :: time
    real(kind=8)          , intent(in)  :: step
    real(kind=8), pointer  :: depl     (:)
    real(kind=8), pointer  :: vite     (:)
    real(kind=8), pointer :: fext     (:)
!
!   -0.2- Local variables
    aster_logical     :: multi_support
    integer           :: i, iex, nbexci, ier, nbno
    integer           :: ino, iret, start, finish
    real(kind=8)      :: sina, cosa, sinb, cosb, sing
    real(kind=8)      :: cosg, depglo(3), vitglo(3), deploc(6), vitloc(6)
    real(kind=8)      :: dvitlo(3), flocal(3), fgloba(3)
    character(len=8)  :: sd_dtm, sd_nl, monmot, obst_typ, ldccar(1)
    character(len=19) :: nomres
!   Dimension for the system equations
    integer :: nbequa, nbdecp, iloi
    parameter  (nbequa=14)
    real(kind=8) :: y0(nbequa), dy0(nbequa), resu(nbequa*2), ynorme(nbequa)
    real(kind=8) :: errmax
!
    integer         , pointer :: vindx (:)   => null()
    integer         , pointer :: ldcfct(:)   => null()
    real(kind=8)    , pointer :: ldcpar(:)   => null()
    real(kind=8)    , pointer :: origob (:)  => null()
    real(kind=8)    , pointer :: coedep (:)  => null()
    real(kind=8)    , pointer :: coevit (:)  => null()
    real(kind=8)    , pointer :: psidel (:)  => null()
    real(kind=8)    , pointer :: psidel1(:)  => null()
    real(kind=8)    , pointer :: psidel2(:)  => null()
    real(kind=8)    , pointer :: sincos_angle_a(:) => null()
    real(kind=8)    , pointer :: sincos_angle_b(:) => null()
    real(kind=8)    , pointer :: sincos_angle_g(:) => null()
    real(kind=8)    , pointer :: sign_dyz(:)   => null()
    real(kind=8)    , pointer :: dplmod (:)   => null()
    real(kind=8)    , pointer :: dplmod1(:)   => null()
    real(kind=8)    , pointer :: dplmod2(:)   => null()
    real(kind=8)    , pointer :: vint(:) => null()
    character(len=8), pointer :: nofdep(:)  => null()
    character(len=8), pointer :: nofvit(:)  => null()
!
! --------------------------------------------------------------------------------------------------
!   0 - Initializations
    sd_dtm = sd_dtm_
    sd_nl  = sd_nl_
!
    call nlget(sd_nl, _INTERNAL_VARS      , vr=vint, buffer=buffnl)
    call nlget(sd_nl, _INTERNAL_VARS_INDEX, vi=vindx, buffer=buffnl)
    start  = vindx(nl_ind)
!
    deploc(1:6) = 0.d0
!
    call dtmget(sd_dtm, _MULTI_AP, kscal=monmot, buffer=buffdtm)
    multi_support = monmot(1:3) .eq. 'OUI'
    if (multi_support) then
        call dtmget(sd_dtm, _CALC_SD , kscal=nomres, buffer=buffdtm)
        call dtmget(sd_dtm, _NB_EXC_T, iscal=nbexci, buffer=buffdtm)

        call jeveuo(nomres//'.FDEP','L', vk8=nofdep)
        call jeveuo(nomres//'.FVIT','L', vk8=nofvit)

        AS_ALLOCATE(vr=coedep, size=nbexci)
        AS_ALLOCATE(vr=coevit, size=nbexci)
        do iex = 1, nbexci
            coedep(iex) = 0.d0
            coevit(iex) = 0.d0
            if (nofdep(iex) .ne. ' ') then
                call fointe('F', nofdep(iex), 1, ['INST'], [time], coedep(iex), ier)
            endif
            if (nofvit(iex) .ne. ' ') then
                call fointe('F', nofvit(iex), 1, ['INST'], [time], coevit(iex), ier)
            endif
        enddo
    endif

    call nlget(sd_nl, _COOR_ORIGIN_OBSTACLE, iocc=nl_ind, vr=origob        , buffer=buffnl)
    call nlget(sd_nl, _SINCOS_ANGLE_A      , iocc=nl_ind, vr=sincos_angle_a, buffer=buffnl)
    call nlget(sd_nl, _SINCOS_ANGLE_B      , iocc=nl_ind, vr=sincos_angle_b, buffer=buffnl)
    call nlget(sd_nl, _SINCOS_ANGLE_G      , iocc=nl_ind, vr=sincos_angle_g, buffer=buffnl)
    call nlget(sd_nl, _SIGN_DYZ            , iocc=nl_ind, vr=sign_dyz      , buffer=buffnl)
    sina = sincos_angle_a(1)
    cosa = sincos_angle_a(2)
    sinb = sincos_angle_b(1)
    cosb = sincos_angle_b(2)
    sing = sincos_angle_g(1)
    cosg = sincos_angle_g(2)

    nbno = 1
    call nlget(sd_nl, _OBST_TYP      , iocc=nl_ind, kscal=obst_typ, buffer=buffnl)
    call nlget(sd_nl, _MODAL_DEPL_NO1, iocc=nl_ind, vr=dplmod1, buffer=buffnl)
    if (multi_support) call nlget(sd_nl, _PSI_DELT_NO1, vr=psidel1, buffer=buffnl)

    if (obst_typ(1:2).eq.'BI') then
        nbno = 2
        call nlget(sd_nl, _MODAL_DEPL_NO2, iocc=nl_ind, vr=dplmod2, buffer=buffnl)
        if (multi_support) call nlget(sd_nl, _PSI_DELT_NO2, vr=psidel2, buffer=buffnl)
    endif

    do ino = 1, nbno
        ! Point toward the modal displacement for the concerned node / 1 or 2 /
        dplmod => dplmod1
        if (multi_support) psidel => psidel1
        if (ino.eq.2) then
            dplmod => dplmod2
            if (multi_support) psidel => psidel2
        endif
        ! Conversion of generalized displacements/velocities
        ! back to the physical (global) basis
        if (multi_support) then
            call tophys_ms(dplmod, psidel, coedep, depl, depglo)
            call tophys_ms(dplmod, psidel, coevit, vite, vitglo)
        else
            call tophys(dplmod, depl, depglo)
            call tophys(dplmod, vite, vitglo)
        endif
        ! Conversion of these vectors to the local basis
        call gloloc(depglo,origob          ,sina,cosa,sinb,cosb,sing,cosg, deploc(1+(ino-1)*3))
        call gloloc(vitglo,[0.d0,0.d0,0.d0],sina,cosa,sinb,cosb,sing,cosg, vitloc(1+(ino-1)*3))
    enddo
!
    if (nbno.eq.2) then
        do i = 1, 3
            dvitlo(i) = vitloc(i) - vitloc(3+i)
        enddo
    else
        do i = 1, 3
            dvitlo(i) = vitloc(i)
        enddo
    endif
!
! --------------------------------------------------------------------------------------------------
!   Non linear behaviour along the local x-axis or in yz-plane
!
!   System equations
!                    1 2 3       4 5 6  7      8         9 10 11  12 13 14
!       y0   : force(x,y,z) depl(x,y,z) Dissip pcum deplp(x,y,z)  X(x,y,z)
!   Internal variables
!       vari : force(x,y,z) depl(x,y,z) Dissip pcum deplp(x,y,z)  X(x,y,z)
! --------------------------------------------------------------------------------------------------
!
!   Behavior type : [nbvale, jprol, jvale, iloi, tecro]
    call nlget(sd_nl, _NL_FUNC_DEF, iocc=nl_ind, vi=ldcfct, buffer=buffnl)
    iloi = ldcfct(4)
!   At initialization, the step is set to zero, there is no need to integrate
    if (abs(step) .le. r8prem()) then
        resu(:) = 0.0
        resu(1:nbequa) = vint(start+6:start+5+nbequa)
    else
        ! Physical (behavior) parameters
        call nlget(sd_nl, _DISC_ISOT_FX0DX0, iocc=nl_ind, vr=ldcpar, buffer=buffnl)
        ! Numerical parameters
        call nlget(sd_nl, _MAX_INTE   , iocc=nl_ind, iscal=nbdecp, buffer=buffnl)
        call nlget(sd_nl, _RES_INTE   , iocc=nl_ind, rscal=errmax, buffer=buffnl)
        ! Initialization
        dy0(:)       = 0.0
        y0(1:nbequa) = vint(start+6:start+5+nbequa)
        ! Velocity (along the local x-axis)
        if ( iloi.eq.1 ) then
            dy0(4) =  -dvitlo(1)
        else
            dy0(5) =  -dvitlo(2)
            dy0(6) =  -dvitlo(3)
        endif
        ! Norme pour le critère d'erreur
        ynorme(1:3)   = ldcpar(1)/10.0
        ynorme(4:6)   = ldcpar(2)/10.0
        ynorme(7)     = ldcpar(1)*ldcpar(2)/100.0
        ynorme(8:11)  = ldcpar(2)/10.0
        ynorme(12:14) = ldcpar(1)/100.0
        !
        ! Runge-Kutta 5/4 integration from t -> t+dt
        iret = 0
        call rk5adp(nbequa, ldcpar, ldcfct, ldccar, time, step, nbdecp,&
                    errmax, y0, dy0, disc_isotr, resu, iret, ynorme)
        if ( iret.ne.0 ) then
            call utmess('A', 'DISCRETS_42',si=nbdecp, sr=errmax)
        endif
    endif
!
!   Retrieve the axial force (along the local x-axis)
    flocal(1:3) = 0.d0
    if ( iloi.eq.1 ) then
        flocal(1) = resu(1)
    else
        flocal(2) = resu(2)
        flocal(3) = resu(3)
    endif
!   Conversion to the global (physical) reference
    call locglo(flocal, sina, cosa, sinb, cosb, sing, cosg, fgloba)
!   Generalized force on the first node
    call togene(dplmod1, fgloba, fext)
!   Generalized force on the second node
    if (nbno.eq.2) then
        call togene(dplmod2, fgloba, fext, coef=-1.d0)
    endif
!
!   Internal variables, storage
    if (step.gt.0.d0) then
        finish = vindx(nl_ind+1)
        ASSERT((finish-start).eq.NBVARINT_DECR)
        ! Local displacement of node 1
        vint(start   ) = deploc(1)
        vint(start+1 ) = deploc(2)
        vint(start+2 ) = deploc(3)
        ! Local displacement of node 2
        vint(start+3 ) = deploc(4)
        vint(start+4 ) = deploc(5)
        vint(start+5 ) = deploc(6)
        ! Internal variables of the behavior
        vint(start+6:start+6+nbequa-1) = resu(1:nbequa)
    endif
!
    if (multi_support) then
        AS_DEALLOCATE(vr=coedep)
        AS_DEALLOCATE(vr=coevit)
    endif
end subroutine
