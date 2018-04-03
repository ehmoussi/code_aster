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
subroutine nmgr3d(option   , typmod    ,&
                  fami     , imate     ,&
                  nno      , npg       , lgpg     ,&
                  ipoids   , ivf       , vff      , idfde,&
                  compor   , carcri    , mult_comp,&
                  instam   , instap    ,&
                  geom_init, disp_prev , disp_incr,&
                  sigm     , sigp      ,&
                  vim      , vip       ,&
                  matsym   , matuu     , vectu    ,&
                  codret)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
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
real(kind=8), intent(in) :: geom_init(3, nno)
real(kind=8), intent(inout) :: disp_prev(3*nno),  disp_incr(3*nno)
real(kind=8), intent(inout) :: sigm(6, npg), sigp(6, npg)
real(kind=8), intent(inout) :: vim(lgpg, npg), vip(lgpg, npg)
aster_logical, intent(in) :: matsym
real(kind=8), intent(inout) :: matuu(*)
real(kind=8), intent(inout) :: vectu(3, nno)
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
! In  geom_init        : initial coordinates of nodes (from mesh)
! IO  disp_prev        : displacements at beginning of time step
! IO  disp_incr        : displacements from beginning of time step
! IO  sigm             : stresses at beginning of time step
! IO  sigp             : stresses at end of time step
! IO  vim              : internal state variables at beginning of time step
! IO  vip              : internal state variables at end of time step
! In  matsym           : .true. if symmetric matrix
! IO  matuu            : matrix
! IO  vectu            : vector (internal forces)
! Out codret           : code for error
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: grand, axi, cplan
    integer :: kpg, j, jvariexte, jstrainexte, ndim
    real(kind=8) :: dsidep(6, 6)
    real(kind=8) :: f_prev(3, 3), f_curr(3, 3)
    real(kind=8) :: epsg_prev(6), epsg_incr(6), epsg_curr(6)
    real(kind=8) :: detf_prev, detf_curr
    real(kind=8) :: disp_curr(3*nno)
    real(kind=8) :: r, sigma(6), sigm_norm(6), poids, maxeps
    real(kind=8) :: elgeom(10, 27), wkout(1), angl_naut(3)
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    integer :: cod(27)
    real(kind=8) :: dfdi(nno, 3), pff(6,nno,nno), def(6,nno,3) 
    character(len=16) :: rela_comp
!
! --------------------------------------------------------------------------------------------------
!
    ndim        = 3
    elgeom(:,:) = 0.d0
    wkout(1)    = 0.d0
    cod(:)      = 0
    grand       = ASTER_TRUE
    axi         = ASTER_FALSE
    cplan       = ASTER_FALSE
    disp_curr(:) = 0.d0
    rela_comp    = compor(RELA_NAME)
!
! - Get coded integer for external state variable
!
    jvariexte = nint(carcri(IVARIEXTE))
    jstrainexte = nint(carcri(ISTRAINEXTE))
!
! - Compute intrinsic external state variables
!
    call lcegeo(nno      , npg      , ndim ,&
                ipoids   , ivf      , idfde,&
                typmod   , jvariexte, &
                geom_init, disp_prev, disp_incr)
!
! - Only isotropic material !
!
    angl_naut(1:3) = r8nnem()
!
! - Update displacements
!
    disp_curr(:) = disp_prev(:) + disp_incr(:)
!
! - Loop on Gauss points
!
    do kpg = 1, npg
!
        epsg_prev(1:6) = 0.d0
        epsg_incr(1:6) = 0.d0
        epsg_curr(1:6) = 0.d0
!
! ----- Kinematic - Previous strains
!
        call nmgeom(ndim    , nno   , axi , grand , geom_init,&
                    kpg     , ipoids, ivf , idfde , disp_prev,&
                    .true._1, poids , dfdi, f_prev, epsg_prev,&
                    r)
!
! ----- Kinematic - Current strains
!
        call nmgeom(ndim     , nno   , axi , grand , geom_init,&
                    kpg      , ipoids, ivf , idfde , disp_curr,&
                    .false._1, poids , dfdi, f_curr, epsg_curr,&
                    r)

!
! ----- Stresses: convert Cauchy to PK2
!
        call lcdetf(ndim, f_prev, detf_prev)
        call pk2sig(ndim, f_prev, detf_prev, sigm_norm, sigm(1, kpg), -1)
        sigm_norm(4) = sigm_norm(4)*rac2
        sigm_norm(5) = sigm_norm(5)*rac2
        sigm_norm(6) = sigm_norm(6)*rac2
!
! ----- Compute behaviour
!
        if ((jstrainexte .eq. MFRONT_STRAIN_GROTGDEP_S) .or. &
            (jstrainexte .eq. 0)) then
! --------- Check "small strains"
            maxeps = 0.d0
            do j = 1, 6
                epsg_incr(j) = epsg_curr(j)-epsg_prev(j)
                maxeps       = max(maxeps,abs(epsg_incr(j)))
            end do
            if (maxeps .gt. 0.05d0) then
                if (rela_comp(1:4) .ne. 'ELAS') then
                    call utmess('A', 'COMPOR2_9', sr=maxeps)
                endif
            endif
! --------- Compute behaviour
            call nmcomp(fami       , kpg        , 1        , ndim  , typmod        ,&
                        imate      , compor     , carcri   , instam, instap        ,&
                        6          , epsg_prev  , epsg_incr, 6     , sigm_norm     ,&
                        vim(1, kpg), option     , angl_naut, 10    , elgeom(1, kpg),&
                        sigma      , vip(1, kpg), 36       , dsidep, 1             ,&
                        wkout      , cod(kpg)   , mult_comp)
            if (cod(kpg) .eq. 1) then
                goto 999
            endif
        elseif (jstrainexte .eq. MFRONT_STRAIN_GROTGDEP_L) then
            call nmcomp(fami       , kpg        , 1        , ndim  , typmod        ,&
                        imate      , compor     , carcri   , instam, instap        ,&
                        9          , f_prev     , f_curr   , 6     , sigm_norm     ,&
                        vim(1, kpg), option     , angl_naut, 10    , elgeom(1, kpg),&
                        sigma      , vip(1, kpg), 36       , dsidep, 1             ,&
                        wkout      , cod(kpg)   , mult_comp)
            if (cod(kpg) .eq. 1) then
                goto 999
            endif
        else
            ASSERT(.false.)
        endif
! ----- Compute internal forces vector and rigidity matrix
        call nmgrtg(ndim , nno   , poids , kpg   , vff      ,&
                    dfdi , def   , pff   , option, axi      ,&
                    r    , f_prev, f_curr, dsidep, sigm_norm,&
                    sigma, matsym, matuu , vectu)
! ----- Stresses: convert PK2 to Cauchy
        if (option(1:4) .eq. 'RAPH' .or. option(1:4) .eq. 'FULL') then
            call lcdetf(ndim, f_curr, detf_curr)
            call pk2sig(ndim, f_curr, detf_curr, sigma, sigp(1, kpg), 1)
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
