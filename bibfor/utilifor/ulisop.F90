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

function ulisop(unit, name)
    implicit none
    integer :: ulisop
#include "asterfort/ulinit.h"
#include "asterfort/utmess.h"
    integer :: unit
    character(len=16) :: name
!     ------------------------------------------------------------------
!     RETOURNE LE NOM LOCAL NAME (DDNAME) ASSOCIE A L'UNITE LOGIQUE
!     ------------------------------------------------------------------
!
! OUT  NAME     : CH*16 : NOM "LOCALE" ASSOCIE AU NUMERO D'UNITE LOGIQUE
!                         FORTRAN
!      ULISOP   : IS    : 0 L'UNITE LOGIQUE N'EST PAS OUVERTE
!                         UNIT SINON
! IN   UNIT     : IS    : NUMERO D'UNITE LOGIQUE ASSOCIE A "NAME"
!
! person_in_charge: j-pierre.lefebvre at edf.fr
!
    integer :: mxf
    parameter       (mxf=100)
    character(len=1) :: typefi(mxf), accefi(mxf), etatfi(mxf), modifi(mxf)
    character(len=16) :: ddname(mxf)
    character(len=255) :: namefi(mxf)
    integer :: first, unitfi(mxf), nbfile
    common/ asgfi1 / first, unitfi      , nbfile
    common/ asgfi2 / namefi,ddname,typefi,accefi,etatfi,modifi
!
    character(len=8) :: k8bid
    integer :: i, ival
!
    if (first .ne. 17111990) call ulinit()
!
    if (unit .lt. 0) then
        write(k8bid,'(I4)') unit
        call utmess('F', 'UTILITAI5_9', sk=k8bid)
    endif
    name = '?'
    ival = 0
    do 1 i = 1, nbfile
        if (unitfi(i) .eq. unit .and. etatfi(i) .eq. 'O') then
            name = ddname(i)
            ival = i
            goto 2
        endif
 1  end do
 2  continue
    ulisop = ival
end function
