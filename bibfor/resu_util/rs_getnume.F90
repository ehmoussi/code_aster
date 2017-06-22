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

subroutine rs_getnume(result_, inst      , criter_, prec, nume,&
                      iret   , vari_name_)
!
implicit none
!
#include "asterfort/rsorac.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: result_
    real(kind=8), intent(in) :: inst
    character(len=*), intent(in) :: criter_
    real(kind=8), intent(in) :: prec
    integer, intent(out) :: nume
    integer, intent(out) :: iret
    character(len=*), optional, intent(in) :: vari_name_
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get index stored in results datastructure for a given time
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  inst             : time to find in results datastructure
! In  criter           : absolute/relative search
! In  prec             : precision to search time
! Out nume             : index stored in results datastructure for given time
! Out iret             : error code
!                        0 - Time not found
!                        1 - One time found
!                        2 - Several times found
!                        
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: vari_name
    character(len=8) :: result, k8bid
    complex(kind=8) :: c16bid
    integer :: tnum(1), ibid, nb_find
!
! --------------------------------------------------------------------------------------------------
!
    result    = result_
    nume      = 0
    iret      = 0
    if (present(vari_name_)) then
        vari_name = vari_name_
    else
        vari_name = 'INST'
    endif
    call rsorac(result , vari_name, ibid   , inst, k8bid,&
                c16bid , prec     , criter_, tnum, 1    ,&
                nb_find)
    if (nb_find.lt.0) then
        iret = 2
    elseif (nb_find.eq.1) then
        iret = 1
        nume = tnum(1)
    elseif (nb_find.eq.0) then
        iret = 0
    endif

end subroutine
