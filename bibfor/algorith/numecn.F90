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

subroutine numecn(modele, champ, nume)
! person_in_charge: jacques.pellet at edf.fr
!----------------------------------------------------------------------
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/gnomsd.h"
#include "asterfort/idenob.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexnum.h"
#include "asterfort/nueffe.h"
#include "asterfort/wkvect.h"
!
    character(len=*) :: modele, champ
    character(len=*) :: nume
! ----------------------------------------------------------------------
!  IN/JXIN   : MODELE : MODELE
!  IN/JXIN   : CHAMP  : CHAMP "MODELE" POUR LA NUMEROTATION
!  VAR/JXOUT : NUME   : NUME_EQUA
! ----------------------------------------------------------------------
! BUT CREER UN NUME_EQUA (SANS STOCKAGE)
!
! CETTE ROUTINE ETANT APPELEE DANS UNE BOUCLE SUR LES NUMEROS D'ORDRE
! ON CHERCHE A LIMITER LE NOMBRE DE NUME DIFFERENTS CREES
! EN COMPARANT 2 APPELS SUCCESSIFS
! ----------------------------------------------------------------------
!
    character(len=8) :: mo
    character(len=24) :: lligr, lligrs, noojb
    character(len=24), pointer :: list_ligr(:) => null()
    character(len=19) :: prfchn, nomlig, numes
    integer :: nb1, i1, i2, iret, nb2, iexi, nb_ligr
    character(len=14) :: nu14
    character(len=19) :: nu19, k19bid
    aster_logical :: newnum
    save numes
! DEB ------------------------------------------------------------------
!
    call jemarq()
    mo=modele
    call dismoi('PROF_CHNO', champ, 'CHAM_NO', repk=prfchn)
    call jelira(prfchn//'.LILI', 'NOMMAX', nb1)
!
!
!
!     1. -- CALCUL DE LLIGR : LISTE DES LIGRELS:
!     ----------------------------------------
    lligr = '&&NUMECN.LISTE_LIGREL'
    if (nb1 .eq. 1) then
        call wkvect(lligr, 'V V K24', 1, vk24 = list_ligr)
        list_ligr(1) = mo//'.MODELE'
        nb_ligr = 1
    else
!       ON N'AJOUTE QUE LES LIGRELS QUI EXISTENT ENCORE :
        nb2=0
        do i1 = 2, nb1
            call jenuno(jexnum(prfchn//'.LILI', i1), nomlig)
            call jeexin(nomlig//'.LIEL', iret)
            if (iret .ne. 0) then
                if (nomlig .ne. mo//'.MODELE') nb2=nb2+1
            endif
        end do
        call wkvect(lligr, 'V V K24', nb2+1,  vk24 = list_ligr)
        nb_ligr = nb2+1
        i2=1
        list_ligr(i2) = mo//'.MODELE'
        do i1 = 2, nb1
            call jenuno(jexnum(prfchn//'.LILI', i1), nomlig)
            call jeexin(nomlig//'.LIEL', iret)
            if (iret .ne. 0) then
                if (nomlig .ne. mo//'.MODELE') then
                    i2=i2+1
                    list_ligr(i2) = nomlig
                endif
            endif
        end do
    endif
!
!
!     2. -- ON SAUVEGARDE LA LISTE DES LIGRELS D'UNE FOIS SUR L'AUTRE
!           POUR NE PAS RECREER PLUSIEURS FOIS LE MEME NUME_EQUA
!       => NEWNUM : FAUT-IL CREER UN NOUVEAU NUME_EQUA ?
!       => LLIGRS : LISTE DES LIGRELS SAUVEGARDEE
!     ----------------------------------------------------------------
    lligrs= '&&NUMECN.LISTE_LIGREL_S'
    newnum=.true.
    call jeexin(lligrs, iexi)
    if (iexi .gt. 0) then
        if (idenob(lligr,lligrs)) newnum=.false.
        call jedetr(lligrs)
    endif
    call jedupo(lligr, 'V', lligrs, .false._1)
!
!
!
!     3. -- ON CALCULE NU14 SI NECESSAIRE :
!     -------------------------------------
    if (newnum) then
        noojb='12345678.00000.NUME.PRNO'
        call gnomsd(' ', noojb, 10, 14)
        nu14=noojb(1:14)
!
        k19bid=' '
        call nueffe(nb_ligr, list_ligr, 'VG', nu14, 'SANS')
        nu19=nu14
        call jedetr(nu19//'.ADLI')
        call jedetr(nu19//'.ADNE')
        nume=nu14//'.NUME'
        numes=nume
    else
        nume=numes
    endif
!
!
!
    call jedetr(lligr)
    call jedema()
end subroutine
