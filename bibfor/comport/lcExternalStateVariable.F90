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
!
subroutine lcExternalStateVariable(carcri, compor, &
                                       fami  , kpg      , ksp, imate, &
                                       neps  , epsth    , depsth, &
                                       temp  , dtemp, &
                                       predef, dpred )
!
implicit none
!
#include "asterfort/Behaviour_type.h"
#include "asterc/r8nnem.h"
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
#include "asterfort/verift.h"
#include "asterfort/get_elas_id.h"
#include "asterfort/comp_meca_l.h"
#include "asterfort/mfrontExternalStateVariable.h"
!
real(kind=8), intent(in) :: carcri(*)
character(len=16), intent(in) :: compor(*)
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp
integer, intent(in) :: imate
integer, intent(in) :: neps
real(kind=8), intent(out) :: epsth(neps), depsth(neps)
real(kind=8), intent(out) :: temp, dtemp
real(kind=8), intent(out) :: predef(*), dpred(*)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour
!
! Compute volumic "thermic" strains caused by some external state variables :
! TEMP, SECH, HYDR, EPSAXX / YY / ZZ / XY / XZ / YZ
! Prepare predef and dpred variables for MFront
!
! --------------------------------------------------------------------------------------------------
!
! In  compor           : name of comportment definition (field)
! In  carcri           : parameters for comportment
! In  fami             : Gauss family for integration point rule
! In  imate            : coded material address
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  neps             : number of components of strains
! Out epsth            : thermic strains at beginning of current step time
! Out depsth           : increment of thermic strains during current step time
! Out temp             : temperature at beginning of current step time
! Out dtemp            : increment of temperature during current step time
! Out predef           : external state variables at beginning of current step time
! Out dpred            : increment of external state variables during current step time
!
! --------------------------------------------------------------------------------------------------

    integer           :: iret, irets, irets2, ireth, ireth2, codret(3)
    integer           :: i_dim, k
    real(kind=8)      :: valres(3)
    real(kind=8)      :: hydrm, hydrp, sechm, sechp, sref
    real(kind=8)      :: defam(neps), defap(neps)
    real(kind=8)      :: epsbp, epsbm, bendom, kdessm, bendop, kdessp
    real(kind=8)      :: tm,tp,tref
    character(len=16) :: nomres(3)
    integer           :: elas_id
    character(len=16) :: elas_keyword, rela_comp
    real(kind=8)      :: epsthm, epsth_anism(3), epsth_metam
    real(kind=8)      :: epsthp, epsth_anisp(3), epsth_metap
    character(len=6), parameter :: epsa(6) = (/'EPSAXX','EPSAYY','EPSAZZ','EPSAXY','EPSAXZ',&
                                            'EPSAYZ'/)
    aster_logical     :: l_mfront_proto, l_mfront_offi
    real(kind=8)      :: rac2
!
! --------------------------------------------------------------------------------------------------
!
    rac2 = sqrt(2.d0)
!
    call r8inir(neps, 0.d0, depsth, 1)
    call r8inir(neps, 0.d0, epsth, 1)
!
! - TEMP
!     * Compute thermic dilatation
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
!     * Compute thermic strains
!
    call get_elas_id(imate, elas_id, elas_keyword)
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
!     * Get temperature
!
    temp  = tm
    dtemp = tp-tm
!
! - SECH
!
    call rcvarc(' ', 'SECH', '-', fami, kpg, ksp, sechm, irets)
    if (irets .eq. 0) then
        call rcvarc('F', 'SECH', '+', fami, kpg, ksp, sechp, irets2)
!       RETRAIT DESSICATION
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
        call rcvarc(' ', 'SECH', 'REF', fami, kpg,   ksp, sref, irets2)
        if (irets2 .ne. 0) then
            sref=0.d0
        endif
        epsbm = -kdessm*(sref-sechm)
        epsbp = -kdessp*(sref-sechp)
        do i_dim = 1, 3
           epsth(i_dim)  = epsth(i_dim)+epsbm
           depsth(i_dim) = depsth(i_dim)+epsbp-epsbm
        enddo
    endif
!
! - HYDR
!
    call rcvarc(' ', 'HYDR', '-', fami, kpg, ksp, hydrm, ireth)
    if (ireth .eq. 0) then
        call rcvarc('F', 'HYDR', '+', fami, kpg, ksp, hydrp, ireth2)
!       RETRAIT ENDOGENE
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
        epsbm  = -bendom*hydrm
        epsbp  = -bendop*hydrp
        do i_dim = 1, 3
           epsth(i_dim)  = epsth(i_dim)+epsbm
           depsth(i_dim) = depsth(i_dim)+epsbp-epsbm
        enddo
    endif
!
! - EPSA
!
    do k = 1, 3
        call rcvarc(' ', epsa(k), '-', fami, kpg, ksp, defam(k), iret)
        if (iret .ne. 0) defam(k)=0.d0
        call rcvarc(' ', epsa(k), '+', fami, kpg, ksp, defap(k), iret)
        if (iret .ne. 0) defap(k)=0.d0
!
        epsth(k)=epsth(k)+defam(k)
        depsth(k) = depsth(k)+defap(k)-defam(k)
    enddo
    
    do k = 4, neps
! Nondiagonal terms of EPSA are rescaled with rac2
        call rcvarc(' ', epsa(k), '-', fami, kpg, ksp, defam(k), iret)
        if (iret .ne. 0) defam(k)=0.d0
        call rcvarc(' ', epsa(k), '+', fami, kpg, ksp, defap(k), iret)
        if (iret .ne. 0) defap(k)=0.d0
!
        epsth(k)=epsth(k)+defam(k)*rac2
        depsth(k) = depsth(k)+(defap(k)-defam(k))*rac2
    enddo     
!
! - Prepare predef and dpred for MFront
!
    rela_comp = compor(RELA_NAME)
    call comp_meca_l(rela_comp, 'MFRONT_PROTO', l_mfront_proto)
    call comp_meca_l(rela_comp, 'MFRONT_OFFI' , l_mfront_offi)
    
    if (l_mfront_proto .or. l_mfront_offi) then
        call mfrontExternalStateVariable(carcri, rela_comp, fami, kpg, ksp, &
                                         irets, ireth, &
                                         sechm, sechp, hydrm, hydrp, &
                                         predef, dpred)
    endif
!
end subroutine
