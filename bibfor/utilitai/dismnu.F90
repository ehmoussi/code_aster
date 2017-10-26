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

subroutine dismnu(questi, nomobz, repi, repkz, ierd)
    implicit none
!     --     DISMOI(NUME_DDL) (OU PARFOIS NUME_DDL_GENE)
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
#include "asterfort/dismgd.h"
#include "asterfort/dismlg.h"
#include "asterfort/dismpn.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
    integer :: repi, ierd
    character(len=*) :: questi
    character(len=24) :: questl
    character(len=32) :: repk
    character(len=14) :: nomob
    character(len=*) :: nomobz, repkz
! ----------------------------------------------------------------------
!    IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOBZ : NOM D'UN OBJET DE TYPE NUME_DDL (K14)
!    OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPKZ  : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
!
! ----------------------------------------------------------------------
!     VARIABLES LOCALES:
!     ------------------
    character(len=24) :: nomlig
!
!      ATTENTION: POUR UN NUME_DDL_GENE
!
!         NOMLIG = 'LIAISONS'
!         CE N'EST PAS LE NOM D'UN LIGREL
!
!-----------------------------------------------------------------------
    integer ::  iarefe,imatd, iret
    integer, pointer :: nequ(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    repk = ' '
    repi = 0
    ierd = 0
!
    nomob = nomobz
    questl = questi
!
    if (questl(1:7) .eq. 'NOM_GD ') then
        call jeveuo(nomob//'.NUME.REFN', 'L', iarefe)
        repk = zk24(iarefe+1) (1:8)
!
    else if (questi(1:9).eq.'NUM_GD_SI') then
        call jeexin(nomob//'.NUME.REFN', iret)
        if (iret .eq. 0) then
            repi = 0
        else
            call jeveuo(nomob//'.NUME.REFN', 'L', iarefe)
            call dismgd(questi, zk24(iarefe+1) (1:8), repi, repk, ierd)
        endif
!
    else if (questi.eq.'NB_EQUA') then
        call jeveuo(nomob//'.NUME.NEQU', 'L', vi=nequ)
        repi = nequ(1)
!
    else if (questi.eq.'PROF_CHNO') then
        repk = nomob//'.NUME'
!
    else if (questi.eq.'NOM_MODELE') then
        call dismpn(questi, nomob//'.NUME', repi, repk, ierd)
!
    else if (questi.eq.'MATR_DISTRIBUEE') then
        call jeexin(nomob//'.NUML.NULG', imatd)
        if (imatd.eq.0) then
            repk='NON'
        else
            repk='OUI'
        endif
!
    else if (questi.eq.'PHENOMENE') then
        call jenuno(jexnum(nomob//'.NUME.LILI', 2), nomlig)
        if (nomlig(1:8) .eq. 'LIAISONS') then
            repk = 'MECANIQUE'
        else
            call dismlg(questi, nomlig, repi, repk, ierd)
        endif
!
    else if (questi.eq.'NOM_MAILLA') then
        call jeexin(nomob//'.NUME.REFN', iret)
        if (iret .eq. 0) then
            repk = ' '
        else     
            call jeveuo(nomob//'.NUME.REFN', 'L', iarefe)
            repk = zk24(iarefe) (1:8)
        endif
!
    else
        ierd = 1
    endif
!
    repkz = repk
    call jedema()
end subroutine
