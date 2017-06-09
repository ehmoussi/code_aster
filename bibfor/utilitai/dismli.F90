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

subroutine dismli(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(INTERF_DYNA)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=32) :: repk
    character(len=14) :: nomob
    character(len=*) :: repkz, nomobz
! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN OBJET DE TYPE INTERF_DYNA (K14)
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
    integer :: lldes, llref
!-----------------------------------------------------------------------
    call jemarq()
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
!
    if (questi(1:10) .eq. 'NOM_MAILLA') then
        call jeveuo(nomob(1:8)//'.IDC_REFE', 'L', llref)
        repk(1:8)=zk24(llref)
    else if (questi(1:12).eq.'NOM_NUME_DDL') then
        call jeveuo(nomob(1:8)//'.IDC_REFE', 'L', llref)
        repk(1:19)=zk24(llref+1)
    else if (questi.eq.'NOM_MODE_CYCL') then
        call jeveuo(nomob(1:8)//'.IDC_REFE', 'L', llref)
        repk(1:8)=zk24(llref+2)
    else if (questi(1:5).eq.'NB_EC') then
        call jeveuo(nomob(1:8)//'.IDC_DESC', 'L', lldes)
        repi=zi(lldes+1)
    else if (questi(1:10).eq.'NB_CMP_MAX') then
        call jeveuo(nomob(1:8)//'.IDC_DESC', 'L', lldes)
        repi=zi(lldes+2)
    else if (questi(1:6).eq.'NUM_GD') then
        call jeveuo(nomob(1:8)//'.IDC_DESC', 'L', lldes)
        repi=zi(lldes+3)
    else
        ierd=1
    endif
!
    repkz = repk
    call jedema()
end subroutine
