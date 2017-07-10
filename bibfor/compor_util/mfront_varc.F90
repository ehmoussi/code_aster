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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mfront_varc(fami   , kpg      , ksp, imate, &
                       nb_varc, list_varc, &
                       temp   , dtemp    , &
                       predef , dpred    , &
                       neps   , epsth    , depsth)
!
use calcul_module, only : ca_vext_eltsize1_, ca_vext_coorga_, ca_vext_eltsize2_, ca_vext_gradvelo_
!
implicit none
!
#include "asterc/r8nnem.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/verift.h"
#include "asterfort/get_elas_id.h"
!    
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg
integer, intent(in) :: ksp
integer, intent(in) :: imate
integer, intent(in) :: nb_varc
character(len=8), intent(in) :: list_varc(*)
real(kind=8), intent(out) :: temp, dtemp
real(kind=8), intent(out) :: predef(*), dpred(*)
integer, intent(in) :: neps
real(kind=8), intent(out) :: epsth(neps), depsth(neps)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour (MFront)
!
! Compute inelastic strains from external state variables
!
! --------------------------------------------------------------------------------------------------
!
! In  fami             : Gauss family for integration point rule
! In  imate            : coded material address
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  nb_varc          : total number of external state variables
! In  list_varc        : list of external state variables
! Out temp             : temperature at beginning of current step time
! Out dtemp            : increment of temperature during current step time
! Out predef           : external state variables at beginning of current step time
! Out dpred            : increment of external state variables during current step time
! In  neps             : number of components of strains
! Out epsth            : thermic strains at beginning of current step time
! Out depsth           : increment of thermic strains during current step time
!
! --------------------------------------------------------------------------------------------------
!
    integer           :: iret, iret2, codret(3), i_dim, i_varc
    integer, parameter :: nb_varc_maxi = 8
    real(kind=8)      :: vrcm, vrcp, valres(3)
    real(kind=8)      :: hydrm, hydrp, sechm, sechp, sref
    real(kind=8)      :: epsbp, epsbm, bendom, kdessm, bendop, kdessp
    real(kind=8)      :: tm,tp,tref
    character(len=16) :: nomres(3)
    integer           :: elas_id
    character(len=16) :: elas_keyword
    real(kind=8) :: epsthm, epsth_anism(3), epsth_metam
    real(kind=8) :: epsthp, epsth_anisp(3), epsth_metap
!
! --------------------------------------------------------------------------------------------------
!
    call r8inir(neps, 0.d0, depsth, 1)
    call r8inir(neps, 0.d0, epsth, 1)
    call r8inir(nb_varc_maxi, r8nnem(), predef, 1)
    call r8inir(nb_varc_maxi, r8nnem(), dpred, 1)
!
! - Get type of elasticity (Isotropic/Orthotropic/Transverse isotropic)
!
    call get_elas_id(imate, elas_id, elas_keyword)
!
! - Compute thermic dilatation
!
    call verift(fami, kpg, ksp, '-', imate,&
                epsth_      = epsthm,&
                epsth_anis_ = epsth_anism,&
                epsth_meta_ = epsth_metam,&
                temp_prev_  = tm  ,&
                temp_refe_  = tref,&
                iret_       = iret)
    if (iret .ne. 0) then
        tm = 0.d0
    endif
    call verift(fami, kpg, ksp, '+', imate,&
                epsth_      = epsthp,&
                epsth_anis_ = epsth_anisp,&
                epsth_meta_ = epsth_metap,&
                temp_curr_  = tp,&
                iret_       = iret)
    if (iret .ne. 0) then
        tp = 0.d0
    endif
!
! - Compute thermic strains
!
    if (elas_keyword .eq. 'ELAS_META') then
        do i_dim = 1, 3
            depsth(i_dim) = epsth_metap - epsth_metam
            epsth(i_dim)  = epsth_metam
        enddo
    else
        if (elas_id .eq. 1) then
            do i_dim = 1, 3
                depsth(i_dim) = epsthp - epsthm
                epsth(i_dim)  = epsthm
            enddo
        else
            do i_dim = 1, 3
                depsth(i_dim) = epsth_anisp(i_dim) - epsth_anism(i_dim)
                epsth(i_dim)  = epsth_anism(i_dim)
            enddo
        endif
    endif
!
    do i_varc = 1, nb_varc
        if (list_varc(i_varc) .eq. 'SECH' ) then
            call rcvarc(' ', 'SECH', '-', fami, kpg, ksp, vrcm, iret)
            if (iret .eq. 0) then
                predef(i_varc) = vrcm
                call rcvarc('F', 'SECH', '+', fami, kpg, ksp, vrcp, iret2)
                dpred(i_varc)  = vrcp-vrcm
!               RETRAIT DESSICATION
                nomres(1) = 'K_DESSIC'
                call rcvalb(fami  , kpg   , ksp   ,&
                            '-'   , imate , ' '   , 'ELAS',&
                            0     , ' '   , [0.d0],&
                            1     , nomres, valres,&
                            codret, 1)
                kdessm = valres(1)
                call rcvalb(fami  , kpg   , ksp   ,&
                            '+'   , imate , ' '   , 'ELAS',&
                            0     , ' '   , [0.d0],&
                            1     , nomres, valres,&
                            codret, 1)
                kdessp = valres(1)
                call rcvarc(' ', 'SECH', 'REF', fami, kpg,   ksp, sref, iret2)
                if (iret2 .ne. 0) sref=0.d0
                sechm = predef(i_varc)
                sechp = predef(i_varc)+dpred(i_varc)
                epsbm = -kdessm*(sref-sechm)
                epsbp = -kdessp*(sref-sechp)
                do i_dim = 1, 3
                   epsth(i_dim)  = epsth(i_dim)+epsbm
                   depsth(i_dim) = depsth(i_dim)+epsbp-epsbm
                enddo
            endif
        endif
        if (list_varc(i_varc) .eq. 'HYDR' ) then
            call rcvarc(' ', 'HYDR', '-', fami, kpg, ksp, vrcm, iret)
            if (iret .eq. 0) then
                predef(i_varc) = vrcm
                call rcvarc('F', 'HYDR', '+', fami, kpg, ksp, vrcp, iret2)
                dpred(i_varc)  = vrcp-vrcm
!               RETRAIT ENDOGENE
                nomres(1)='B_ENDOGE'
                call rcvalb(fami  , kpg   , ksp   ,&
                            '-'   , imate , ' '   , 'ELAS',&
                            0     , ' '   , [0.d0],&
                            1     , nomres, valres,&
                            codret, 1)
                bendom = valres(1)
                call rcvalb(fami  , kpg   , ksp   ,&
                            '+'  , imate , ' '   , 'ELAS',&
                            0     , ' '   , [0.d0],&
                            1     , nomres, valres,&
                            codret, 1)
                bendop = valres(1)
                hydrm  = predef(i_varc)
                hydrp  = predef(i_varc)+dpred(i_varc)
                epsbm  = -bendom*hydrm
                epsbp  = -bendop*hydrp
                do i_dim = 1, 3
                   epsth(i_dim)  = epsth(i_dim)+epsbm
                   depsth(i_dim) = depsth(i_dim)+epsbp-epsbm
                enddo
            endif
        endif
        call rcvarc(' ', list_varc(i_varc), '-', fami, kpg, ksp, vrcm, iret)
        if (iret .eq. 0) then
            predef(i_varc) = vrcm
            call rcvarc('F', list_varc(i_varc), '+', fami, kpg, ksp, vrcp, iret2)
            dpred(i_varc)  = vrcp-vrcm
        else
            if (list_varc(i_varc) .eq. 'ELTSIZE1') then
                predef(i_varc) = ca_vext_eltsize1_
            endif
        endif
    end do
!
! - Get temperature
!
    temp  = tm
    dtemp = tp-tm
!
end subroutine
