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

subroutine somloc(m, adco, nbso, nusglo, nusloc)
!
!     DONNE LE NUMERO LOCAL : NUSLOC DU SOMMET DONT LE
!     NUMERO GLOBAL EST NUSGLO POUR LA MAILLE M
!     LA MAILLE A NBSO SOMMETS ET L ADRESSE DE SA CONNECTIVITE
!     EST ADCO
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/utmess.h"
    integer :: m, adco, nbso, nusglo, nusloc
!
    aster_logical :: trouve
    integer :: is
    integer :: vali(2)
!
    trouve=.false.
    do 10 is = 1, nbso
        if (zi(adco+is-1) .eq. nusglo) then
            trouve=.true.
            nusloc=is
        endif
 10 end do
    if (.not.trouve) then
        vali(1)=nusglo
        vali(2)=m
        call utmess('F', 'VOLUFINI_2', ni=2, vali=vali)
    endif
!
end subroutine
