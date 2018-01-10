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
subroutine get_meta_hard(poum       , fami     , kpg      , ksp   , j_mater,&
                         l_hard_line, meta_type, nb_phasis, l_temp, temp   ,&
                         young      , epsp     , r0)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rctype.h"
#include "asterfort/rctrac.h"
#include "asterfort/rcfonc.h"
#include "asterfort/utmess.h"
#include "asterfort/Metallurgy_type.h"
!
character(len=1), intent(in) :: poum
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp
integer, intent(in) :: j_mater
integer, intent(in) :: meta_type
integer, intent(in) :: nb_phasis
logical, intent(in) :: l_hard_line
logical, intent(in) :: l_temp
real(kind=8), intent(in) :: young
real(kind=8), intent(in) :: temp
real(kind=8), intent(in) :: epsp(*)
real(kind=8), intent(out) :: r0(*)
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Get hardening
!
! --------------------------------------------------------------------------------------------------
!
! In  poum         : '-' or '+' for parameters evaluation (previous or current)
! In  fami         : Gauss family for integration point rule
! In  kpg          : current point gauss
! In  ksp          : current "sous-point" gauss
! In  j_mater      : coded material address
! In  meta_type    : type of metallurgy
! In  nb_phasis    : total number of phasis (cold and hot)
! In  l_hard_line  : .true. if linear hardening
! In  young        : Young modulus
! In  l_temp       : .true. if temperature command variable is affected
! In  temp         : temperature
! In  epsp         : cumulated plastic strain
! Out r0           : current hardening
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_res_mx
    parameter (nb_res_mx = 5)
    real(kind=8) :: valres(nb_res_mx)
    integer :: codret(nb_res_mx)
    character(len=16) :: nomres(nb_res_mx)
!
    integer :: nb_res, i_res
    integer :: i_phasis
    character(len=8) :: keyw_trac(5)
    character(len=16) :: keyw_fact
    integer :: j_prol, j_vale
    integer :: nb_vale
    character(len=8) :: para_type
    real(kind=8) :: para_vale, r8dummy, h(5)
!
! --------------------------------------------------------------------------------------------------
!
    if (l_hard_line) then
        nb_res = nb_phasis
        if (meta_type .eq. META_STEEL) then
            nomres(1) = 'F1_D_SIGM_EPSI'
            nomres(2) = 'F2_D_SIGM_EPSI'
            nomres(3) = 'F3_D_SIGM_EPSI'
            nomres(4) = 'F4_D_SIGM_EPSI'
            nomres(5) = 'C_D_SIGM_EPSI'
        elseif (meta_type .eq. META_ZIRC) then
            nomres(1) = 'F1_D_SIGM_EPSI'
            nomres(2) = 'F2_D_SIGM_EPSI'
            nomres(3) = 'C_D_SIGM_EPSI'
        else
            ASSERT(ASTER_FALSE)
        endif
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_ECRO_LINE', 0, ' ', [0.d0],&
                    nb_res, nomres, valres, codret, 2)
        do i_res = 1, nb_res
            h(i_res) = valres(i_res)
            r0(i_res) = h(i_res)*young/(young-h(i_res))
        end do
    else
        nb_vale   = 1
        keyw_fact = 'META_TRACTION'
        if (meta_type .eq. META_STEEL) then
            keyw_trac(1) = 'SIGM_F1'
            keyw_trac(2) = 'SIGM_F2'
            keyw_trac(3) = 'SIGM_F3'
            keyw_trac(4) = 'SIGM_F4'
            keyw_trac(5) = 'SIGM_C'
        elseif (meta_type .eq. META_ZIRC) then
            keyw_trac(1) = 'SIGM_F1'
            keyw_trac(2) = 'SIGM_F2'
            keyw_trac(3) = 'SIGM_C'
        else
            ASSERT(ASTER_FALSE)
        endif

        do i_phasis = 1, nb_phasis
            call rctype(j_mater, nb_vale, 'TEMP', [temp], para_vale,&
                        para_type, keyw_factz = keyw_fact, keywz = keyw_trac(i_phasis))
            if ((para_type.eq.'TEMP') .and. (.not.l_temp)) then
                call utmess('F', 'COMPOR5_5', sk = para_type)
            endif
            call rctrac(j_mater, 2, keyw_trac(i_phasis), para_vale, j_prol,&
                        j_vale, nb_vale, r8dummy)
            call rcfonc('V', 2, j_prol, j_vale, nb_vale,&
                        p = epsp(i_phasis), rprim = r0(i_phasis))
        end do
    endif
!
end subroutine
