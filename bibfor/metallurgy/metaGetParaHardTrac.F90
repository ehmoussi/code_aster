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
subroutine metaGetParaHardTrac(j_mater, meta_type, nb_phasis,&
                               l_temp , temp     ,&
                               epsp   , h0       , rp_      , maxval_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rctype.h"
#include "asterfort/rctrac.h"
#include "asterfort/rcfonc.h"
#include "asterfort/utmess.h"
#include "asterfort/Metallurgy_type.h"
!
integer, intent(in) :: j_mater
integer, intent(in) :: meta_type
integer, intent(in) :: nb_phasis
aster_logical, intent(in) :: l_temp
real(kind=8), intent(in) :: temp
real(kind=8), intent(in) :: epsp(*)
real(kind=8), intent(out) :: h0(*)
real(kind=8), optional, intent(out) :: rp_(*)
integer, optional, intent(out) :: maxval_
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Get hardening slope (non-linear)
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
! In  meta_type    : type of metallurgy
! In  nb_phasis    : total number of phasis (cold and hot)
! In  l_temp       : .true. if temperature command variable is affected
! In  temp         : temperature
! In  epsp         : cumulated plastic strain
! Out h0           : current hardening slope
! Out rp_          : current isotropic hardening value
! Out maxval_      : nombre de valeurs de la fonction r(p)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_phasis
    character(len=8) :: keyw_trac(5)
    character(len=16) :: keyw_fact
    integer :: j_prol, j_vale
    integer :: nb_vale, maxval
    character(len=8) :: para_type
    real(kind=8) :: para_vale, r8dummy
!
! --------------------------------------------------------------------------------------------------
!
    keyw_fact = 'META_TRACTION'
    maxval    = -1
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
!
    do i_phasis = 1, nb_phasis
        call rctype(j_mater, 1, 'TEMP', [temp], para_vale,&
                    para_type, keyw_factz = keyw_fact, keywz = keyw_trac(i_phasis))
        if ((para_type .eq. 'TEMP') .and. (.not. l_temp)) then
            call utmess('F', 'COMPOR5_5', sk = para_type)
        endif
        call rctrac(j_mater, 2, keyw_trac(i_phasis), temp, j_prol,&
                    j_vale, nb_vale, r8dummy)
        if (present(rp_)) then
            call rcfonc('V', 2, j_prol, j_vale, nb_vale,&
                        p = epsp(i_phasis), rp = rp_(i_phasis), rprim = h0(i_phasis))
        else
            call rcfonc('V', 2, j_prol, j_vale, nb_vale,&
                         p = epsp(i_phasis), rprim = h0(i_phasis))
        endif
        if (nb_vale .ge. maxval) then
            maxval = nb_vale
        endif
    end do
    if (present(maxval_)) then
        maxval_ = maxval
    endif
!
end subroutine
