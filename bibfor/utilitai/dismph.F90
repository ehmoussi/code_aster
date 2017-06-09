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

subroutine dismph(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(PHENOMENE)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismgd.h"
#include "asterfort/utmess.h"
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=32) :: repk
    character(len=16) :: nomob
    character(len=*) :: nomobz, repkz
! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN PHENOMENE
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=8) :: k8bid
!
! DEB-------------------------------------------------------------------
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
    if (nomob(1:9) .eq. 'THERMIQUE') then
        repk = 'TEMP_R'
    else if (nomob(1:9).eq.'MECANIQUE') then
        repk = 'DEPL_R'
    else if (nomob(1:9).eq.'ACOUSTIQU') then
        repk = 'PRES_C'
    else if (nomob(1:9).eq.'NON_LOCAL') then
        repk = 'VANL_R'
    else
        call utmess('F', 'UTILITAI_66', sk=nomob)
        ierd = 1
        goto 10
    endif
!
!
    if (questi .eq. 'NOM_GD') then
!        C'EST DEJA FAIT !
    else if (questi.eq.'NUM_GD') then
        call dismgd('NUM_GD', repk(1:8), repi, k8bid, ierd)
    else if (questi.eq.'NOM_MOLOC') then
        if (nomob(1:9) .eq. 'THERMIQUE') then
            repk = 'DDL_THER'
        else if (nomob(1:9).eq.'MECANIQUE') then
            repk = 'DDL_MECA'
        else if (nomob(1:9).eq.'ACOUSTIQU') then
            repk = 'DDL_ACOU'
        else
            ASSERT(.false.)
        endif
    else
        ierd = 1
    endif
!
10  continue
    repkz = repk
end subroutine
