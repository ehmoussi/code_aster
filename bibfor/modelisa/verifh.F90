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

subroutine verifh(fami    , kpg    , ksp    , poum    , j_mater    ,&
                  epshy   , materi_, ihydr_ )
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
real(kind=8), intent(out) :: epshy
character(len=8), optional, intent(in) :: materi_
integer, optional, intent(out) :: ihydr_
!
! --------------------------------------------------------------------------------------------------
!
! Computation of autogenous shrinkage
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
!                     'T' for current and previous temperature => epshy is increment
! In  j_mater      : coded material address
! In  materi       : name of material if multi-material Gauss point (PMF)
! Out epshy        : strain from autogenous shrinkage (retrait endogène)
! Out ihydr_       : 0 if hydratation is defined
!!                   1 if not
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: materi
    integer :: iret_hydr, iret_hydrm, iret_hydrp
    real(kind=8) :: hydrm, hydrp
    real(kind=8) :: bendom, bendop
    integer :: elas_id, iadzi, iazk24, icodrm(1), icodrp(1)
    character(len=8) :: nomres, valk(3)
    character(len=16) :: elas_keyword
    real(kind=8) :: valres(1)
!
! --------------------------------------------------------------------------------------------------
!
    materi = ' '
    if (present(materi_)) then
        materi = materi_
    endif
!
    iret_hydr   = 0
    iret_hydrm  = 0
    iret_hydrp  = 0
    hydrm       = 0.d0
    hydrp       = 0.d0
    epshy       = 0.d0
!
! - No hydratation -> strain is zero
!
    call rcvarc(' ', 'HYDR', '+', fami, kpg,&
                ksp, hydrp, iret_hydr)
    if (iret_hydr .ne. 0) then
        goto 999
    endif
!
! - Get hydratation
!
    if (poum.eq.'T'.or.poum.eq.'-') then
        call rcvarc(' ', 'HYDR', '-', fami, kpg,&
                    ksp, hydrm, iret_hydrm)
    endif
!
    if (poum.eq.'T'.or.poum.eq.'+') then
        call rcvarc(' ', 'HYDR', '+', fami, kpg,&
                    ksp, hydrp, iret_hydrp)
    endif
!
! - Get type of elasticity (Isotropic/Orthotropic/Transverse isotropic)
!
    call get_elas_id(j_mater, elas_id, elas_keyword)
!
! - Get elastic parameters
!
    nomres='B_ENDOGE'
!
    icodrm = 0
    icodrp = 0
    if (poum.eq.'T'.or.poum.eq.'-') then
        if (iret_hydrm.eq.0) then
            call rcvalb(fami, kpg, ksp, '-', j_mater,&
                        materi, elas_keyword, 0, ' ', [0.d0],&
                        1, nomres, valres(1), icodrm(1), 1)
            bendom = valres(1)
        endif
    endif
    if (poum.eq.'T'.or.poum.eq.'+') then
        if (iret_hydrp.eq.0) then
            call rcvalb(fami, kpg, ksp, '+', j_mater,&
                        materi, elas_keyword, 0, ' ', [0.d0],&
                        1, nomres, valres(1), icodrp(1), 1)
            bendop = valres(1)
        endif
    endif
!
! - Test
!
    if ((icodrm(1)+icodrp(1)).ne.0) then
        call tecael(iadzi, iazk24)
        valk(1) = zk24(iazk24-1+3)
        valk(2) = 'HYDR'
        valk(3) = nomres
        call utmess('F', 'COMPOR5_32', nk=3, valk=valk)
    endif
!
! - Compute strains
!
    if (poum .eq. 'T') then
        if (iret_hydrm + iret_hydrp .eq. 0) then
            epshy = (- bendop*hydrp) - (- bendom*hydrm)
        endif
    else if (poum .eq. '-') then
        if (iret_hydrm.eq.0) then
            epshy = - bendom*hydrm
        endif
    else if (poum .eq. '+') then
        if (iret_hydrp.eq.0) then
            epshy = - bendop*hydrp
        endif
    endif
!
999 continue
!
! - Output errors
!
    if (present(ihydr_)) then
        ihydr_ = 0
        if ((iret_hydrm + iret_hydrp) .ne. 0) then
            ihydr_ = 1
        endif
        if (iret_hydr .ne. 0) then
            ihydr_ = 1
        endif
    endif
!
end subroutine
