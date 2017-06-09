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

subroutine dismml(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(MACR_ELEM_STAT)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/dismmo.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=32) :: repk
    character(len=8) :: nomob
    character(len=*) :: nomobz, repkz
! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN OBJET DE TYPE LIGREL
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    integer ::  iexi
    character(len=8) :: modele
    character(len=8), pointer :: refm(:) => null()
!
!
!
    call jemarq()
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
!
    call jeveuo(nomob//'.REFM', 'L', vk8=refm)
    if (questi .eq. 'NOM_MAILLA') then
        repk= refm(2)
    else if (questi.eq.'NOM_MODELE') then
        repk= refm(1)
    else if (questi.eq.'NOM_NUME_DDL') then
        repk= refm(5)
    else if (questi.eq.'NOM_PROJ_MESU') then
        repk= refm(9)
!
    else if (questi.eq.'DIM_GEOM') then
        modele=refm(1)
        call dismmo(questi, modele, repi, repk, ierd)
!
    else if (questi.eq.'EXI_AMOR') then
        call jeexin(nomob//'.MAEL_AMOR_VALE', iexi)
        if (iexi .ne. 0) then
            repk='OUI'
        else
            repk='NON'
        endif
    else
        ierd=1
    endif
!
    repkz = repk
    call jedema()
end subroutine
