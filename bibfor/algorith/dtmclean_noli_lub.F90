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

subroutine dtmclean_noli_lub(sd_dtm_, sd_nl_)
    use lub_module , only : delete_all_bearings, add_bearing
    implicit none
!
!
! person_in_charge: mohamed-amine.hassini@edf.fr
!
! dtmclean_noli_lub : clean everything related to edyos
!
!
! =======================================================================

!--

#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"

      character(len=*), intent(in):: sd_dtm_
      character(len=*), intent(in):: sd_nl_

      call jemarq()

      


      call delete_all_bearings()


      
      call jedema()

end subroutine
