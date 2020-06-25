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

subroutine nmco1d(fami, kpg, ksp, imate, rela_comp, rela_cpla,&
                  option, epsm, deps, angmas, sigm,&
                  vim, sigp, vip, dsidep, codret)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/comp1d.h"
#include "asterfort/nm1dci.h"
#include "asterfort/nm1dis.h"
#include "asterfort/nm1dpm.h"
#include "asterfort/nmmaba.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterfort/verift.h"
#include "asterfort/vmci1d.h"
!
integer :: imate, codret, kpg, ksp
character(len=16) :: option, rela_comp, rela_cpla
character(len=*) :: fami
real(kind=8) :: epsm, deps, sigm, vim(*)
real(kind=8) :: angmas(3)
real(kind=8) :: sigp, vip(*), dsidep
! --------------------------------------------------------------------------------------------------
!
!          REALISE LES LOIS 1D (DEBORST OU EXPLICITEMENT 1D)
!
!
! IN  IMATE   : ADRESSE DU MATERIAU CODE
! IN  OPTION  : OPTION DEMANDEE : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA
! IN  EPSM    : DEFORMATIONS A L'INSTANT DU CALCUL PRECEDENT
! IN  DEPS    : INCREMENT DE DEFORMATION (SCALAIRE DANS CE CAS)
! IN  SIGM    : CONTRAINTE A L'INSTANT DU CALCUL PRECEDENT
! IN  VIM     : VARIABLES INTERNES A L'INSTANT DU CALCUL PRECEDENT
! IN   TM     : TEMPERATURE L'INSTANT DU CALCUL PRECEDENT
! IN   TP     : TEMPERATURE A L'INSTANT DU
! IN  TREF    : TEMPERATURE DE REFERENCE
! OUT SIGP    : CONTRAINTE A L'INSTANT ACTUEL
!     VIP     : VARIABLES INTERNES A L'INSTANT ACTUEL
!     DSIDEP  : RIGIDITE (SCALAIRE DANS CE CAS)
!     CODRET  : CODE RETOUR NON NUL SI SIGYY OU SIGZZ NON NULS
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: cine, isot, pinto, com1d, elas, cinegc
    real(kind=8) :: e, et, sigy
    integer :: nvarpi
    parameter    ( nvarpi=8)
    integer :: ncstpm
    parameter     (ncstpm=13)
    real(kind=8) :: cstpm(ncstpm)
    real(kind=8) :: em, ep, depsth, depsm, val(1)
    integer :: codres(1)
! --------------------------------------------------------------------------------------------------
!
    elas = .false.
    isot = .false.
    cine = .false.
    cinegc = .false.
    pinto = .false.
    com1d = .false.
    codret = 0
!
    if (rela_comp(1:16) .eq. 'GRILLE_ISOT_LINE') then
        isot = .true.
    else if (rela_comp(1:16) .eq. 'GRILLE_CINE_LINE') then
        cine = .true.
    else if (rela_comp(1:12) .eq. 'VMIS_CINE_GC') then
        cinegc = .true.
    else if (rela_comp(1:16) .eq. 'GRILLE_PINTO_MEN') then
        pinto = .true.
    else if (rela_comp(1:4) .eq. 'ELAS') then
        elas = .true.
    else
        com1d=.true.
        if ((rela_cpla .ne. 'DEBORST') .and. (rela_comp .ne.'SANS')) then
            call utmess('F', 'COMPOR4_32', sk=rela_comp)
        endif
    endif
!
    if (.not.com1d) then
!       caractéristiques élastiques à t-
        call rcvalb(fami, kpg, ksp, '-', imate,&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'E', val, codres, 1)
        em=val(1)
!       caractéristiques élastiques à t+
        call rcvalb(fami, kpg, ksp, '+', imate,&
                    ' ', 'ELAS', 0, ' ', [0.d0],&
                    1, 'E', val, codres, 1)
        ep=val(1)
    endif
!
    if (isot) then
        call verift(fami, kpg, ksp, 'T', imate,&
                    epsth_=depsth)
        depsm = deps-depsth
        call nm1dis(fami, kpg, ksp, imate, em,&
                    ep, sigm, depsm, vim, option,&
                    rela_comp, ' ', sigp, vip, dsidep)
!
    else if (cine) then
        call verift(fami, kpg, ksp, 'T', imate,&
                    epsth_=depsth)
        depsm = deps-depsth
        call nm1dci(fami, kpg, ksp, imate, em,&
                    ep, sigm, depsm, vim, option,&
                    ' ', sigp, vip, dsidep)
!
    else if (cinegc) then
        call verift(fami, kpg, ksp, 'T', imate,&
                    epsth_=depsth)
        depsm = deps-depsth
        call vmci1d('RIGI', kpg, ksp, imate, em,&
                    ep, sigm, depsm, vim, option,&
                    ' ', sigp, vip, dsidep)
    else if (elas) then
        if (option(1:9) .eq. 'FULL_MECA' .or. option(1:10) .eq. 'RIGI_MECA_') then
            dsidep = ep
        endif
        if (option .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
            vip(1) = 0.d0
            call verift(fami, kpg, ksp, 'T', imate,&
                        epsth_=depsth)
            sigp = ep* (sigm/em+deps-depsth)
        endif
!
    else if (com1d) then
        call comp1d(fami, kpg, ksp, option, sigm,&
                    epsm, deps, angmas, vim, vip,&
                    sigp, dsidep, codret)
!
    else if (pinto) then
        call nmmaba(imate, rela_comp, e, et, sigy,&
                    ncstpm, cstpm)
        call verift(fami, kpg, ksp, 'T', imate,&
                    epsth_=depsth)
        depsm = deps-depsth
        call nm1dpm(fami, kpg, ksp, imate, option,&
                    nvarpi, ncstpm, cstpm, sigm, vim,&
                    depsm, vip, sigp, dsidep)
    endif
end subroutine
