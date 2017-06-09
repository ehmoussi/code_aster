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

subroutine dxtpif(temp, ltemp)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    real(kind=8) :: temp(3)
    aster_logical :: ltemp(3)
!
!     GESTION DE TEMP_INF ET TEMP_SUP DANS LES COQUES / TUYAUX :
!
!     IN LTEMP(3) :
!        LTEMP(1) = .T. / .F.   TEMP_MIL EST AFFECTE
!        LTEMP(2) = .T. / .F.   TEMP_INF EST AFFECTE
!        LTEMP(3) = .T. / .F.   TEMP_SUP EST AFFECTE
!
!     IN/OUT TEMP(3) :
!        TEMP(1) =  VALEUR DE TEMP_MIL
!        TEMP(2) =  VALEUR DE TEMP_INF
!        TEMP(3) =  VALEUR DE TEMP_SUP
!
!        SI TEMP_INF (OU TEMP_SUP) N'EST PAS AFFECTE :
!          SI TEMP_MIL EST AFFECTE : TEMP_INF = TEMP_SUP = TEMP_MIL
!          SINON : ERREUR 'F'
    integer :: iadzi, iazk24
    character(len=8) :: nomail
!
!
    if (.not.ltemp(1)) then
        call tecael(iadzi, iazk24)
        nomail=zk24(iazk24-1+3)
        call utmess('F', 'ELEMENTS_53', sk=nomail)
    endif
!
    if (.not.ltemp(2)) temp(2)=temp(1)
    if (.not.ltemp(3)) temp(3)=temp(1)
!
end subroutine
