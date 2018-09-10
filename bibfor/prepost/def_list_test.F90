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

subroutine def_list_test(nbma, jcninv , lima, liout, nbout)
    implicit none
! person_in_charge: guillaume.drouet at edf.fr
!     ------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/utlisi.h"

    integer, intent(in)  :: nbma
    integer, intent(in)  :: lima(nbma)
    integer, intent(in)  :: jcninv
    integer, intent(inout)  :: liout(nbma)
    integer, intent(inout) :: nbout
!
    integer :: nb_doubl, nbin, res(1)

    nbin = nbout
    nbout = 1
    nb_doubl = 0
    liout(1:nbout)=lima(nbin+1:nbin+nbout)
    do while((nb_doubl .eq. 0) .and. (nbout .le. (nbma-1-nbin)))
        call utlisi('INTER', zi(jcninv+nbin+nbout), 1, zi(jcninv+nbin),&
                    nbout, res, 1, nb_doubl)
        if (nb_doubl.eq.0)  then
           nbout=nbout+1
           liout(nbout)=lima(nbin+nbout)
        endif
    end do

end subroutine
