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

subroutine dismcg(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(CHAM_NO)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/dismpn.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=*) :: nomobz, repkz
    character(len=24) :: questl
    character(len=32) :: repk
    character(len=19) :: nomob
! ----------------------------------------------------------------------
!     IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOB  : NOM D'UN OBJET DE TYPE NUM_DDL
!     OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=8) :: nogd
    integer :: iadesc, iarefe, iret
!-----------------------------------------------------------------------
    call jemarq()
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
    questl = questi
!
    if (questi .eq. 'NB_EQUA') then
        call jelira(nomob//'.VALE', 'LONMAX', repi)
    else if (questi.eq.'NOM_MAILLA') then
        call jeveuo(nomob//'.REFE', 'L', iarefe)
        repk = zk24(iarefe-1+1) (1:8)
    else if (questi.eq.'NB_DDLACT') then
        call jeveuo(nomob//'.REFE', 'L', iarefe)
        call dismpn(questi, zk24(iarefe-1+2)(1:8)//'.NUME      ', repi, repk, ierd)
    else if (questi.eq.'TYPE_CHAMP') then
        repk = 'VGEN'
    else if (questl(1:7).eq.'NOM_GD ') then
        call jeveuo(nomob//'.DESC', 'L', iadesc)
        call jenuno(jexnum('&CATA.GD.NOMGD', zi(iadesc)), repk)
    else if (questi.eq.'TYPE_SUPERVIS') then
        call jeveuo(nomob//'.DESC', 'L', iadesc)
        call jenuno(jexnum('&CATA.GD.NOMGD', zi(iadesc)), nogd)
        repk='CHAM_NO_'//nogd
    else if (questi.eq.'PROF_CHNO') then
        call jeveuo(nomob//'.REFE', 'L', iarefe)
        repk = zk24(iarefe+1)
    else if (questi.eq.'NOM_NUME_DDL') then
        call jeveuo(nomob//'.REFE', 'L', iarefe)
        repk = zk24(iarefe+1)
        call jeexin(repk(1:19)//'.NEQU', iret)
        if (iret .eq. 0) then
            call utmess('F', 'UTILITAI_51')
            ierd=1
            goto 9999
        endif
    else
        ierd=1
    endif
!
9999  continue
    repkz = repk
    call jedema()
end subroutine
