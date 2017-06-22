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

subroutine dismca(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(CARTE)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/fonbpa.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: repi, ierd
    character(len=*) :: nomobz, repkz
    character(len=*) :: questi
    character(len=24) :: questl
    character(len=32) :: repk
    character(len=19) :: nomob
! ----------------------------------------------------------------------
!     IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN OBJET DE TYPE CARTE
!     OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=19) :: nomfon, nomcar
    character(len=8) ::  typfon, nompf(10), type, nogd
!
!-----------------------------------------------------------------------
    integer ::  iexi, iret, jdesc
    integer :: jvale, k, l, long, ltyp, nbpf
    integer, pointer :: desc(:) => null()
    character(len=24), pointer :: prol(:) => null()
    character(len=8), pointer :: noma(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
    questl = questi
!
    call jeexin(nomob//'.NOMA', iexi)
    if (iexi .eq. 0) then
        ierd=1
        goto 9999
    endif
!
!
    if (questi .eq. 'NOM_MAILLA') then
        call jeveuo(nomob//'.NOMA', 'L', vk8=noma)
        repk = noma(1)
!
    else if (questi.eq.'TYPE_CHAMP') then
        repk = 'CART'
!
    else if (questi.eq.'TYPE_SUPERVIS') then
        call jeveuo(nomob//'.DESC', 'L', vi=desc)
        call jenuno(jexnum('&CATA.GD.NOMGD', desc(1)), nogd)
        repk='CART_'//nogd
!
    else if (questl(1:7).eq.'NOM_GD ') then
        call jeveuo(nomob//'.DESC', 'L', jdesc)
        call jenuno(jexnum('&CATA.GD.NOMGD', zi(jdesc)), repk)
!
    else if (questi.eq.'PARA_INST') then
        repk = ' '
        nomcar = nomob
        call jeveuo(nomcar//'.VALE', 'L', jvale)
        call jelira(nomcar//'.VALE', 'TYPE', cval=type)
        if (type(1:1) .eq. 'K') then
            call jelira(nomcar//'.VALE', 'LONMAX', long)
            call jelira(nomcar//'.VALE', 'LTYP', ltyp)
            do 10 k = 1, long
                if (ltyp .eq. 8) then
                    nomfon = zk8(jvale+k-1)
                else if (ltyp.eq.24) then
                    nomfon = zk24(jvale+k-1)
                else
                    ASSERT(.false.)
                endif
!
!
                if (nomfon(1:8) .ne. '        ') then
                    call jeexin(nomfon//'.PROL', iret)
                    if (iret .gt. 0) then
                        call jeveuo(nomfon//'.PROL', 'L', vk24=prol)
                        call fonbpa(nomfon, prol, typfon, 10, nbpf,&
                                    nompf)
                        do 101 l = 1, nbpf
                            if (nompf(l)(1:4) .eq. 'INST') then
                                repk = 'OUI'
                                goto 11
                            endif
101                      continue
                    endif
                endif
10          continue
11          continue
        endif
!
!
    else
        ierd=1
    endif
!
!
9999  continue
    repkz = repk
    call jedema()
end subroutine
