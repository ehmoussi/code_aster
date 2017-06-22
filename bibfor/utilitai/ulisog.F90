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

subroutine ulisog(unit, fname, etat)
    implicit none
#include "asterfort/ulinit.h"
#include "asterfort/utmess.h"
    integer :: unit
    character(len=255) :: fname
    character(len=1) :: etat
!     ------------------------------------------------------------------
!     RETOURNE LE NOM ET L'ETAT D'UN FICHIER ASSOCIE A UNE UNITE LOGIQUE
!     (INVERSE DE ULNOMF)
!     ------------------------------------------------------------------
!
! IN  UNIT   : NUMERO D'UNITE LOGIQUE ASSOCIE A "FNAME"
! OUT FNAME  : NOM "LONG"  ASSOCIE AU NUMERO D'UNITE LOGIQUE FORTRAN
!     ETAT   : (O)UVERT, (F)ERME, (R)ESERVE
!
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
    integer :: i
!
    if (first .ne. 17111990) call ulinit()
!
    if (unit .lt. 0) then
        write(k8bid,'(I4)') -unit
        call utmess('F', 'UTILITAI5_9', sk=k8bid)
    endif
    fname = ' '
    etat = 'F'
    do 1 i = 1, nbfile
        if (unitfi(i) .eq. unit) then
            fname = namefi(i)
            etat = etatfi(i)
            goto 999
        endif
 1  end do
999  continue
end subroutine
