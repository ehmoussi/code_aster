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

subroutine op0020()
    implicit none
!     ECRITURE DES CATALOGUES D'ELEMENTS COMPILES
!     ET PRODUCTION DES IMPRESSIONS DE COMPLETUDE DES OPTIONS ET TYPELEM
!     ------------------------------------------------------------------
!
#include "asterc/getfac.h"
#include "asterfort/aidty2.h"
#include "asterfort/getvis.h"
#include "asterfort/ibcael.h"
#include "asterfort/ulexis.h"
#include "asterfort/ulopen.h"
    integer :: ouielt, impr, n1, nbocc
    character(len=24) :: fichie
!     ------------------------------------------------------------------
!
    impr = 0
    fichie = ' '
    call getvis(' ', 'UNITE', scal=impr, nbret=n1)
    if (.not. ulexis( impr )) then
        call ulopen(impr, ' ', fichie, 'NEW', 'O')
    endif
    call getfac('ELEMENT ', ouielt)
!
!     ---------- COMPILATION DES CATATLOGUES ---------------------------
    if (ouielt .ne. 0) then
        call ibcael('ECRIRE')
    endif
!
!     ---------- TRAITEMENT DE CE QUI EST RELATIF A LA COMPLETUDE ------
    call getfac('TYPE_ELEM', nbocc)
    if (nbocc .gt. 0) call aidty2(impr)
!     ------------------------------------------------------------------
!
end subroutine
