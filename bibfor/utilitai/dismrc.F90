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

subroutine dismrc(questi, nomobz, repi, repk, ierd)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jelira.h"
#include "asterfort/jexnum.h"
    integer :: repi, ierd
    character(len=*) :: questi, repk
    character(len=19) :: nomob
    character(len=*) :: nomobz
! IN  : QUESTI : TEXTE PRECISANT LA QUESTION POSEE
! IN  : NOMOBZ : NOM D'UN OBJET DE TYPE RESU_COMPO (K19)
! OUT : REPI   : REPONSE ( SI ENTIERE )
! OUT : REPK   : REPONSE ( SI CHAINE DE CARACTERES )
! OUT : IERD   : CODE RETOUR (0--> OK, 1 --> PB)
! ----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    nomob = nomobz
! ----------------------------------------------------------------------
    ierd = 0
!
    if (questi .eq. 'NB_CHAMP_MAX') then
        call jelira(jexnum(nomob//'.TACH', 1), 'LONMAX', repi)
    else if (questi.eq.'NB_CHAMP_UTI') then
        call jelira(nomob//'.ORDR', 'LONUTI', repi)
    else
        ierd = 1
    endif
!
    repk=' '
end subroutine
