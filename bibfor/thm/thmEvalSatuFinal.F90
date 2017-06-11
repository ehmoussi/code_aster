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

subroutine thmEvalSatuFinal(hydr , j_mater, p1    ,&
                            satur, dsatur , retcom)
!
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvala.h"
#include "asterfort/satuvg.h"
!
! --------------------------------------------------------------------------------------------------
!
character(len=16), intent(in) :: hydr
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: p1
real(kind=8), intent(out) :: satur, dsatur
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Evaluation of final saturation
!
! --------------------------------------------------------------------------------------------------
!
! In  hydr         : type of hydraulic law
! In  j_mater      : coded material address
! In  p1           : current first pressure
! Out satur        : saturation
! Out dsatur       : derivative of saturation (/pc)
! Out retcom       : return code for error
!                     2 - If saturation doesn't belon to ]0,1[
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para = 2
    real(kind=8) :: para_vale(nb_para)
    integer :: icodre(nb_para)
    character(len=16), parameter :: para_name(nb_para) = (/'SATU_PRES  ', 'D_SATU_PRES' /)
!
! --------------------------------------------------------------------------------------------------
!
    retcom       = 0
    para_vale(:) = 0.d0
    if ((hydr.eq.'HYDR_VGM') .or. (hydr.eq.'HYDR_VGC')) then
        call satuvg(p1, satur, dsatur)
        ASSERT(ds_thm%ds_behaviour%satur_type .ne. SATURATED)
!
    else if (hydr.eq.'HYDR_UTIL' .or. hydr.eq.'HYDR_ENDO') then        
        if (ds_thm%ds_behaviour%satur_type .eq. SATURATED) then
            satur  = 1.d0
            dsatur = 0.d0
        else
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        1      , 'PCAP'   , [p1]       ,&
                        nb_para, para_name, para_vale  , icodre,&
                        1)
            satur  = para_vale(1)
            dsatur = para_vale(2)
        endif
    else
        satur  = 1.d0
        dsatur = 0.d0
        ASSERT(ds_thm%ds_behaviour%satur_type .eq. SATURATED)
    endif
    if (satur .gt. 1.d0 .or. satur .lt. 0.d0) then
        retcom = 2
    endif
!
end subroutine
