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

subroutine i2fccl(tplace, n, existe, adrdbt)
    implicit none
#include "asterf_types.h"
!
!
!*****************************************************************
!
!        RECHERCHE DE LA PRESENCE D' UN CHEMIN CYCLIQUE
!        NON ENCORE EXPLOITE DANS UN GROUPE DE MAILLES.
!
!        N      (IN)  : NBR DE MAILLES DU GROUPE
!
!        TPLACE (IN)  : TABLE DES MAILLES DU GROUPE DEJA PLACEES
!
!        EXISTE (OUT) : INDICATEUR DE PRESENCE
!
!        ADRDBT (I-O) : PREMIERE MAILLE DU CHEMIN TROUVE
!
!*****************************************************************
!
    aster_logical :: existe, tplace(*)
    integer :: n, adrdbt
!
    integer :: i
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    existe = .false.
!
    i = adrdbt + 1
!
 10 continue
    if ((.not. existe) .and. (i .le. n)) then
!
        if (.not. tplace(i)) then
!
            existe = .true.
            adrdbt = i
!
        else
!
            i = i + 1
!
        endif
!
        goto 10
!
    endif
!
end subroutine
