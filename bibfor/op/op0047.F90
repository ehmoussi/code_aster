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

subroutine op0047()
    implicit none
!   - FONCTIONS REALISEES:
!       COMMANDE PRE_IDEAS
!       COMMANDE PRE_GMSH
!       INTERFACE ENTRE MAILLAGE IDEAS ET FICHIER MAILLAGE ASTER
!   - OUT :
!       IERR   : NON UTILISE
!     ------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/gmsast.h"
#include "asterfort/infmaj.h"
#include "asterfort/stbast.h"
    integer :: nfie, nfis, n
    aster_logical :: lgrcou
    character(len=8) :: k8b
    character(len=16) :: k16b, cmd
!
    call infmaj()
    call getres(k8b, k16b, cmd)
!
    if (cmd(5:9) .eq. 'IDEAS') then
        lgrcou = .false.
        call getvis(' ', 'UNITE_IDEAS', scal=nfie, nbret=n)
        call getvtx(' ', 'CREA_GROUP_COUL', scal=k8b, nbret=n)
        if (k8b(1:3) .eq. 'OUI') then
            lgrcou = .true.
        else
            lgrcou = .false.
        endif
!
!
    else if (cmd(5:8).eq.'GMSH') then
        call getvis(' ', 'UNITE_GMSH', scal=nfie, nbret=n)
!
    endif
!
    call getvis(' ', 'UNITE_MAILLAGE', scal=nfis, nbret=n)
!
!
    if (cmd(5:9) .eq. 'IDEAS') then
        call stbast(nfie, nfis, lgrcou)
!
    else if (cmd(5:8).eq.'GMSH') then
        call gmsast(nfie, nfis)
!
    endif
!
end subroutine
