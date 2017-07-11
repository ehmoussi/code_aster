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
! aslint: disable=W1504,W0104
!
subroutine lc1058(fami , kpg   , ksp   , ndim  , typmod,&
                  imate, compor, carcri, instam, instap,&
                  neps , epsm  , deps  , nsig  , sigm  ,&
                  nvi  , vim   , option, angmas, icomp ,&
                  sigp , vip   , dsidep, codret)
!
implicit none
!
#include "asterc/mfront_behaviour.h"
#include "asterfort/mfrontExternalStateVariable.h"
#include "asterfort/mfront_get_mater_value.h"
#include "asterfort/mfrontPrepareStrain.h"
#include "asterfort/assert.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcicma.h"
#include "asterfort/matrot.h"
#include "asterfort/r8inir.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/get_elas_id.h"
#include "asterfort/get_elas_para.h"
#include "asterfort/lcsmelas.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp, ndim
character(len=8), intent(in) :: typmod(*)
integer, intent(in) :: imate
character(len=16), intent(in) :: compor(*)
real(kind=8), intent(in) :: carcri(*)
real(kind=8), intent(in) :: instam, instap
integer, intent(in) :: neps
real(kind=8), intent(in) :: epsm(6), deps(6)
integer, intent(in) :: nsig
real(kind=8), intent(in) :: sigm(6)
integer, intent(in) :: nvi
real(kind=8), intent(in) :: vim(*)
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angmas(*)
integer, intent(in) :: icomp
real(kind=8), intent(out) :: sigp(6)
real(kind=8), intent(out) :: vip(nvi)
real(kind=8), intent(out) :: dsidep(6, 6)
integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! MFRONT for SIMO_MIEHE
!
! --------------------------------------------------------------------------------------------------
!
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  ndim             : dimension of problem (2 or 3)
! In  typmod           : type of modelization (TYPMOD2)
! In  imate            : coded material address
! In  compor           : name of comportment definition (field)
! In  carcri           : parameters for comportment
! In  instam           : time at beginning of time step
! In  instap           : time at end of time step
! In  neps             : number of components of strains
! In  epsm             : strains at beginning of current step time
! In  deps             : increment of strains during current step time
! In  nsig             : number of components of stresses
! In  sigm             : stresses at beginning of current step time
! In  nvi              : number of components of internal state variables
! In  vim              : internal state variables at beginning of current step time
! In  option           : name of option to compute
! In  angmas           : nautical angles
! In  icomp            : indicator of local sub-step
! Out sigm             : stresses at end of current step time
! Out vip              : internal state variables at end of current step time
! Out dsidep           : tangent matrix
! Out codret           : code for error
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: npropmax = 197
    integer, parameter :: npred = 8
    integer :: nprops, nstatv, j, i, pfcmfr, nummod, elas_id
    real(kind=8), parameter :: rac2 = sqrt(2.d0)
    real(kind=8), parameter :: usrac2 = sqrt(2.d0)*0.5d0
    real(kind=8) :: drot(3, 3), dstran(9), props(npropmax)
    real(kind=8) :: time(2), young, nu
    real(kind=8) :: predef(npred), dpred(npred), detf
    real(kind=8) :: ddsdde(54)
    real(kind=8) :: stran(9)
    real(kind=8) :: dtime, temp, dtemp, pnewdt
    real(kind=8) :: depsth(6), epsth(6), drott(3, 3)
    character(len=16) :: rela_comp, defo_comp, elas_keyword
    aster_logical :: l_pred, l_large_strain, l_czm
    integer :: ntens, ndi
    common/tdim/  ntens  , ndi
!
! --------------------------------------------------------------------------------------------------
!
    ntens          = 2*ndim
    ndi            = 3
    codret         = 0
    nprops         = npropmax
    rela_comp      = compor(NAME)
    defo_comp      = compor(DEFO)
    pfcmfr         = nint(carcri(16))
    l_pred         = option(1:9).eq. 'RIGI_MECA'
    l_large_strain = .true.
    l_czm          = typmod(2).eq.'ELEMJOIN'
    if (l_czm) then
        ntens = 6
    endif
    ASSERT(defo_comp .eq. 'SIMO_MIEHE')
!
! - Get material properties
!
    call mfront_get_mater_value(rela_comp,&
                                fami     , kpg  , ksp, imate,&
                                nprops   , props)
!
! - Get type of modelization
!
    if ( typmod(1)(1:4).eq.'AXIS' ) then
        nummod = 4
    else if ( typmod(1)(1:6).eq.'C_PLAN' ) then
        nummod = 5
    else if ( typmod(1)(1:6).eq.'D_PLAN' ) then
        nummod = 6
    else if ( typmod(1)(1:2).eq.'3D' ) then
        nummod = 3
    else
        ASSERT(.false.)
    endif
!
! - Prepare external state variables
!
    call mfrontExternalStateVariable(carcri,&
                                     fami   , kpg      , ksp, imate, &
                                     temp   , dtemp    , &
                                     predef , dpred    , &
                                     neps   , epsth    , depsth)
!
! - Prepare strains
!
    call mfrontPrepareStrain(l_large_strain, l_pred, l_czm,&
                             neps          , epsm  , deps ,&
                             epsth         , depsth,&
                             stran         , dstran,&
                             detf)
!
! - Modify number of internal state variables: SIMO_MIEHE
!
    nstatv = nvi-6
!
! - Time parameters
!
    time(1) = instap-instam
    time(2) = instam
    dtime   = instap-instam
!
! - Anisotropic case
!
    call matrot(angmas, drott)
    do i = 1,3
        do j = 1,3
            drot(j,i) = drott(i,j)
        end do
    end do
!
!    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
!        write(ifm,*)' '
!        write(ifm,*)'AVANT APPEL MFRONT, INSTANT=',time(2)+dtime
!        write(ifm,*)'DEFORMATIONS INSTANT PRECEDENT STRAN='
!        write(ifm,'(6(1X,E11.4))') (stran(i),i=1,ntens)
!        write(ifm,*)'ACCROISSEMENT DE DEFORMATIONS DSTRAN='
!        write(ifm,'(6(1X,E11.4))') (dstran(i),i=1,ntens)
!        write(ifm,*)'CONTRAINTES INSTANT PRECEDENT STRESS='
!        write(ifm,'(6(1X,E11.4))') (sigm(i),i=1,ntens)
!        write(ifm,*)'NVI=',nstatv,' VARIABLES INTERNES STATEV='
!        write(ifm,'(10(1X,E11.4))') (vim(i),i=1,nstatv)
!    endif
!
! - Type of matrix for MFront
!
    ddsdde = 1.d0
    if (option .eq. 'RIGI_MECA_TANG') then
        ddsdde(1) = 4.d0
    else if (option .eq. 'RIGI_MECA_ELAS') then
        ddsdde(1) = 1.d0
    else if (option .eq. 'FULL_MECA_ELAS') then
        ddsdde(1) = 2.d0
    else if (option .eq. 'FULL_MECA') then
        ddsdde(1) = 4.d0
    else if (option .eq. 'RAPH_MECA') then
        ddsdde(1) = 0.d0
    endif
!
! - Call MFront
!
    pnewdt = 1.d0
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call dcopy(nsig, sigm, 1, sigp, 1)
        call dscal(3, usrac2, sigp(4), 1)
        call lceqvn(nstatv, vim, vip)
        call mfront_behaviour(pfcmfr, sigp, vip, ddsdde,&
                              stran, dstran, dtime, temp, dtemp,&
                              predef, dpred, ntens, nstatv, props,&
                              nprops, drot, pnewdt, nummod)
    else if (option(1:9).eq. 'RIGI_MECA') then
        call get_elas_id(imate, elas_id, elas_keyword)
        call get_elas_para(fami     , imate, '-', kpg, ksp, &
                           elas_id  , elas_keyword,&
                           e = young, nu = nu)
        call lcsmelas(stran, dstran , ddsdde,&
                      nmat = 0, young_ = young, nu_ = nu)
    endif
!
!    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
!        if ((niv.ge.2) .and. (idbg.eq.1)) then
!            write(ifm,*)' '
!            write(ifm,*)'APRES APPEL MFRONT, STRESS='
!            write(ifm,'(6(1X,E11.4))') (sigp(i),i=1,ntens)
!            write(ifm,*)'APRES APPEL MFRONT, STATEV='
!            write(ifm,'(10(1X,E11.4))')(vip(i),i=1,nstatv)
!        endif
!    endif
!
!
! - Convert stresses
!
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call dscal(3, rac2, sigp(4), 1)
        call dscal(3, detf, sigp, 1)
    endif
!
    if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        call dcopy(54, ddsdde, 1, dsidep, 1)  
    endif
!
! - Return code from MFront
!
    if (pnewdt .lt. 0.0d0) then
        if (pnewdt .lt. -0.99d0 .and. pnewdt .gt. -1.01d0) then
            codret=1
        else if (pnewdt .lt. -1.99d0 .and. pnewdt .gt. -2.01d0) then
            call utmess('F', 'MFRONT_1')
        else if (pnewdt .lt. -2.99d0 .and. pnewdt .gt. -3.01d0) then
            call utmess('F', 'MFRONT_2')
        else if (pnewdt .lt. -3.99d0 .and. pnewdt .gt. -4.01d0) then
            codret=1
        else
            call utmess('F', 'MFRONT_3')
        endif
    endif
!
end subroutine
