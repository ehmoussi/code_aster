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
!
subroutine thmEvalSatuInit(hydr  , j_mater, p1m   , p1   ,&
                           satm  , satur  , dsatur, emmag,&
                           retcom)
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
#include "asterfort/utmess.h"
#include "asterfort/THM_type.h"
!
character(len=16), intent(in) :: hydr
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: p1m, p1
real(kind=8), intent(out) :: satm, satur, dsatur, emmag
integer, intent(out) :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Evaluation of initial saturation
!
! --------------------------------------------------------------------------------------------------
!
! In  hydr         : type of hydraulic law
! In  j_mater      : coded material address
! In  p1m          : first pressure at beginning of step
! In  p1           : current first pressure
! Out satm         : saturation at beginning of step
! Out satur        : saturation
! Out dsatur       : derivative of saturation (/pc)
! Out emmag        : storage coefficient
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
    satm         = 0.d0
    satur        = 0.d0
    dsatur       = 0.d0
    emmag        = 0.d0
    retcom       = 0
    para_vale(:) = 0.d0
    if ((hydr.eq.'HYDR_VGM') .or. (hydr.eq.'HYDR_VGC')) then
        satm  = 0.d0
        satur = 0.d0
        call satuvg(p1m, satm)
        call satuvg(p1 , satur, dsatur)
        if (satm .gt. 1.d0 .or. satm .lt. 0.d0) then
            retcom = 2
        endif
        if (satur .gt. 1.d0 .or. satur .lt. 0.d0) then
            retcom = 2
        endif
        ASSERT(ds_thm%ds_behaviour%satur_type .eq. UNSATURATED)
!
    else if (hydr.eq.'HYDR_UTIL' .or. hydr.eq.'HYDR_ENDO') then
        if (ds_thm%ds_behaviour%satur_type .eq. SATURATED) then
            satm  = 1.d0
            satur = 1.d0
        elseif (ds_thm%ds_behaviour%satur_type .eq. SATURATED_SPEC) then
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        1      , 'PCAP'   , [p1m]      ,&
                        1      , para_name, para_vale  , icodre,&
                        1)
            satm = para_vale(1)
        else
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        1      , 'PCAP'   , [p1m]      ,&
                        1      , para_name, para_vale  , icodre,&
                        1)
            satm = para_vale(1)
            call rcvala(j_mater, ' '      , 'THM_DIFFU',&
                        1      , 'PCAP'   , [p1]       ,&
                        nb_para, para_name, para_vale  , icodre,&
                        1)
            satur  = para_vale(1)
            dsatur = para_vale(2)
            if (satm .gt. 1.d0 .or. satm .lt. 0.d0) then
                retcom = 2
            endif
            if (satur .gt. 1.d0 .or. satur .lt. 0.d0) then
                retcom = 2
            endif
        endif
    else
        satm  = 1.d0
        satur = 1.d0
        ASSERT(ds_thm%ds_behaviour%satur_type .eq. SATURATED)
    endif
    emmag = ds_thm%ds_material%hydr%emmag
!
end subroutine
