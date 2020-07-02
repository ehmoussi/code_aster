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

subroutine verifs(fami    , kpg    , ksp    , poum    , j_mater    ,&
                    epsse , materi_, isech_)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/rcvarc.h"
#include "asterfort/rcvalb.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "asterfort/get_elas_id.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg
integer, intent(in) :: ksp
character(len=*), intent(in) :: poum
integer, intent(in) :: j_mater
real(kind=8), intent(out) :: epsse
character(len=8), optional, intent(in) :: materi_
integer, optional, intent(out) :: isech_
!
! --------------------------------------------------------------------------------------------------
!
! Computation of drying shrinkages
! (inspired by verift.F90)
!
! --------------------------------------------------------------------------------------------------
!
! In  fami         : Gauss family for integration point rule
! In  kpg          : current point gauss
! In  ksp          : current "sous-point" gauss
! In  poum         : parameters evaluation
!                     '-' for previous temperature
!                     '+' for current temperature
!                     'T' for current and previous temperature => epsse is increment
! In  j_mater      : coded material address
! In  materi       : name of material if multi-material Gauss point (PMF)
! Out epsse        : strain from drying shrinkage (retrait de dessication)
! Out isech_       : 0 if drying is defined
!                    1 if not
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: materi, elem_name
    integer :: iret_sech, iret_sechm, iret_sechp, iret_sechref
    real(kind=8) :: sechm, sechp, sechref
    real(kind=8) :: kdessm, kdessp
    integer :: elas_id, iadzi, iazk24, icodrm(1), icodrp(1)
    character(len=8) :: nomres, valk(3)
    real(kind=8) :: valres(1)
    character(len=16) :: elas_keyword
!
! --------------------------------------------------------------------------------------------------
!
    materi = ' '
    if (present(materi_)) then
        materi = materi_
    endif
!
    iret_sech     = 0
    iret_sechm    = 0
    iret_sechp    = 0
    iret_sechref  = 0
    sechm         = 0.d0
    sechp         = 0.d0
    sechref       = 0.d0
    epsse         = 0.d0
!
! - No drying -> strain is zero
!
    call rcvarc(' ', 'SECH', '+', fami, kpg,&
                ksp, sechp, iret_sech)
    if (iret_sech .ne. 0) then
        goto 999
    endif
!
! - Get drying
!
    call rcvarc(' ', 'SECH', 'REF', fami, kpg,&
                ksp, sechref, iret_sechref)
    if (iret_sechref .eq. 1) then
        call tecael(iadzi, iazk24)
        elem_name = zk24(iazk24-1+3) (1:8)
        call utmess('F', 'COMPOR5_24', sk=elem_name)
    endif
!
    if (poum.eq.'T'.or.poum.eq.'-') then
        call rcvarc(' ', 'SECH', '-', fami, kpg,&
                    ksp, sechm, iret_sechm)
    endif
!
    if (poum.eq.'T'.or.poum.eq.'+') then
        call rcvarc(' ', 'SECH', '+', fami, kpg,&
                    ksp, sechp, iret_sechp)
    endif
!
! - Get type of elasticity (Isotropic/Orthotropic/Transverse isotropic)
!
    call get_elas_id(j_mater, elas_id, elas_keyword)
!
! - Get elastic parameters
!
    nomres='K_DESSIC'
!
    icodrm = 0
    icodrp = 0
    if (poum.eq.'T'.or.poum.eq.'-') then
        if (iret_sechm.eq.0) then
            call rcvalb(fami, kpg, ksp, '-', j_mater,&
                        materi, elas_keyword, 0, ' ', [0.d0],&
                        1, nomres, valres(1), icodrm(1), 1)
            kdessm = valres(1)
        endif
    endif
!
    if (poum.eq.'T'.or.poum.eq.'+') then
        if (iret_sechp.eq.0) then
            call rcvalb(fami, kpg, ksp, '+', j_mater,&
                        materi, elas_keyword, 0, ' ', [0.d0],&
                        1, nomres, valres(1), icodrp(1), 1)
            kdessp = valres(1)
        endif
    endif
!
! - Test
!
    if ((icodrm(1)+icodrp(1)).ne.0) then
        call tecael(iadzi, iazk24)
        valk(1) = zk24(iazk24-1+3)
        valk(2) = 'SECH'
        valk(3) = nomres
        call utmess('F', 'COMPOR5_32', nk=3, valk=valk)
    endif
!
! - Compute strains
!
    if (poum .eq. 'T') then
        if (iret_sechm + iret_sechp .eq. 0) then
            epsse = (- kdessp*(sechref-sechp)) - (- kdessm*(sechref-sechm))
        endif
    else if (poum .eq. '-') then
        if (iret_sechm.eq.0) then
            epsse = - kdessm*(sechref-sechm)
        endif
    else if (poum .eq. '+') then
        if (iret_sechp.eq.0) then
            epsse = - kdessp*(sechref-sechp)
        endif
    endif
!
999 continue
!
! - Output errors
!
    if (present(isech_)) then
        isech_ = 0
        if ((iret_sechm + iret_sechp) .ne. 0) then
            isech_ = 1
        endif
        if (iret_sech .ne. 0) then
            isech_ = 1
        endif
    endif
!
end subroutine
