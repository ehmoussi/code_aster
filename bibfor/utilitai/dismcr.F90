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

subroutine dismcr(questi, nomobz, repi, repkz, ierd)
!
!
    implicit none
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=*) :: nomobz, repkz
!
! --------------------------------------------------------------------------------------------------
!     DISMOI(CARA_ELEM)
!
!     IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE : NOM_MAILLA NOM_MODELE EXI_AMOR
!       NOMOBZ : NOM D'UN OBJET DE TYPE NUM_DDL
!     OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! --------------------------------------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/dismca.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/zerobj.h"
!
! --------------------------------------------------------------------------------------------------
!
    character(len=32) :: repk
    character(len=8) :: nomob
    integer :: k, ncarte, iexi, jadr
    parameter (ncarte=12)
    character(len=11) :: cartes(ncarte)
    character(len=19) :: cart1
    data cartes/'.CARCOQUE',  '.CARGEOPO',  '.CARARCPO',&
                '.CARCABLE',  '.CARDISCA',  '.CARDISCK',&
                '.CARDISCM',  '.CARGENBA',  '.CARGENPO',&
                '.CARMASSI',  '.CARORIEN',  '.CARPOUFL' /
! --------------------------------------------------------------------------------------------------
!
    repk = ' '
    repi = 0
    ierd = 0
    nomob=nomobz
!
! --------------------------------------------------------------------------------------------------
    if (questi .eq. 'NOM_MAILLA') then
        do k=1,ncarte
            cart1=nomob//cartes(k)
            call dismca(questi, cart1, repi, repk, ierd)
            if (ierd .eq. 0) exit
        enddo
! --------------------------------------------------------------------------------------------------
    else if (questi .eq. 'NOM_MODELE') then
        call jeexin(nomob//'.MODELE', iexi)
        if (iexi .ne. 0) then
            call jeveuo(nomob//'.MODELE', 'L', jadr)
            repk = zk8(jadr)
        else
            ierd = 1
        endif
! --------------------------------------------------------------------------------------------------
    else if (questi.eq.'EXI_AMOR') then
        repk='NON'
        call jeexin(nomob//'.CARDISCA  .VALE', iexi)
        if (iexi .ne. 0) then
            if (.not.zerobj(nomob//'.CARDISCA  .VALE')) repk='OUI'
        endif
! --------------------------------------------------------------------------------------------------
    else
        ierd=1
    endif
!
    repkz=repk
end subroutine
