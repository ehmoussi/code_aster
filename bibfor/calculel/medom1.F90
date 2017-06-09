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

subroutine medom1(modele, mate, cara, kcha, ncha,&
                  ctyp, result, nuord)
    implicit none
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rcmfmc.h"
#include "asterfort/rslesd.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: ncha, nuord
    character(len=4) :: ctyp
    character(len=8) :: modele, cara, result
    character(len=24) :: mate
    character(len=19) :: kcha
!     SAISIE ET VERIFICATION DE LA COHERENCE DES DONNEES MECANIQUES
!     DU PROBLEME
!
! ----------------------------------------------------------------------
! OUT : MODELE : NOM DU MODELE
! OUT : MATE   : CHAMP MATERIAU
! OUT : CARA   : NOM DU CHAMP DE CARACTERISTIQUES
! IN  : KCHA   : NOM JEVEUX POUR STOCKER LES CHARGES
! OUT : NCHA   : NOMBRE DE CHARGES
! OUT : CTYP   : TYPE DE CHARGE
! IN  : RESULT : NOM DE LA SD RESULTAT
! IN  : NUORD  : NUMERO D'ORDRE
! ----------------------------------------------------------------------
    integer :: iret
    integer :: iexcit, i, icha, ie, ikf, in
    integer ::    n, n1, n2, n3, n5
!-----------------------------------------------------------------------
    character(len=8) :: k8b, nomo, materi
    character(len=8) :: blan8
    character(len=16) :: concep, nomcmd, phenom
    character(len=19) :: excit
    integer, pointer :: infc(:) => null()
    character(len=24), pointer :: fcha(:) => null()
    character(len=24), pointer :: lcha(:) => null()
!
    call jemarq()
!              12345678
    blan8 = '        '
    ncha = 0
    ctyp = ' '
    modele = ' '
    cara = ' '
    materi = ' '
    nomo = blan8
    iexcit = 1
    n1=0
!
    call getres(k8b, concep, nomcmd)
!
    if ((nomcmd.eq.'CALC_CHAMP' ) .or. (nomcmd.eq.'CALC_ERREUR' ) .or.&
        (nomcmd.eq.'CALC_META  ' ) .or. (nomcmd.eq.'CALC_G' )) then
!
!        RECUPERATION DU MODELE, MATERIAU, CARA_ELEM et EXCIT
!        POUR LE NUMERO d'ORDRE NUORD
!
        call rslesd(result, nuord, modele, materi, cara,&
                    excit, iexcit)
        if (materi .ne. blan8) then
            call rcmfmc(materi, mate)
        else
            mate = ' '
        endif
    else
!
        call getvid(' ', 'MODELE', scal=modele, nbret=n1)
        call getvid(' ', 'CARA_ELEM', scal=cara, nbret=n2)
        call dismoi('EXI_RDM', modele, 'MODELE', repk=k8b)
        if ((n2.eq.0) .and. (k8b(1:3).eq.'OUI')) then
            call utmess('A', 'CALCULEL3_39')
        endif
!
        call getvid(' ', 'CHAM_MATER', scal=materi, nbret=n3)
        call dismoi('BESOIN_MATER', modele, 'MODELE', repk=k8b)
        if ((n3.eq.0) .and. (k8b(1:3).eq.'OUI')) then
            call utmess('A', 'CALCULEL3_40')
        endif
!
        if (n3 .ne. 0) then
            call rcmfmc(materi, mate)
        else
            mate = ' '
        endif
    endif
!
!     TRAITEMENT DU CHARGEMENT
!
!     SI IEXCIT=1 ON PREND LE CHARGEMENT DONNE PAR L'UTILISATEUR
    if (iexcit .eq. 1) then
        if (getexm('EXCIT',' ') .eq. 0) then
            n5 = 0
        else
            call getfac('EXCIT', n5)
        endif
!
        if (n5 .ne. 0) then
            ncha = n5
            call jeexin(kcha//'.LCHA', iret)
            if (iret .ne. 0) then
                call jedetr(kcha//'.LCHA')
                call jedetr(kcha//'.FCHA')
            endif
            call wkvect(kcha//'.LCHA', 'V V K8', n5, icha)
            call wkvect(kcha//'.FCHA', 'V V K8', n5, ikf)
            do iexcit = 1, n5
                call getvid('EXCIT', 'CHARGE', iocc=iexcit, scal=zk8(icha+ iexcit-1), nbret=n)
                call getvid('EXCIT', 'FONC_MULT', iocc=iexcit, scal=k8b, nbret=n)
                if (n .ne. 0) then
                    zk8(ikf+iexcit-1) = k8b
                endif
            end do
        else
            call jeexin(kcha//'.LCHA', iret)
            if (iret .ne. 0) then
                call jedetr(kcha//'.LCHA')
                call jedetr(kcha//'.FCHA')
            endif
            call wkvect(kcha//'.LCHA', 'V V K8', 1, icha)
            call wkvect(kcha//'.FCHA', 'V V K8', 1, ikf)
        endif
!
        if (ncha .gt. 0) then
!           VERIFICATION QUE LES CHARGES PORTENT SUR LE MEME MODELE.
            call dismoi('NOM_MODELE', zk8(icha), 'CHARGE', repk=nomo)
            do i = 1, ncha
                call dismoi('NOM_MODELE', zk8(icha-1+i), 'CHARGE', repk=k8b)
                if (k8b .ne. nomo) then
                    call utmess('F', 'CALCULEL3_41')
                endif
            end do
!           VERIFICATION QUE LES CHARGES PORTENT SUR LE MODELE
            if (n1 .ne. 0 .and. modele .ne. nomo) then
                call utmess('F', 'CALCULEL3_42')
            endif
        endif
!
!     SI IEXCIT=0 ON PREND LE CHARGEMENT PRESENT DANS LA SD
!
    else
!
        call jeveuo(excit//'.INFC', 'L', vi=infc)
        call jeveuo(excit//'.LCHA', 'L', vk24=lcha)
        call jeveuo(excit//'.FCHA', 'L', vk24=fcha)
        ncha=infc(1)
!
        call jeexin(kcha//'.LCHA', iret)
        if (iret .ne. 0) then
            call jedetr(kcha//'.LCHA')
            call jedetr(kcha//'.FCHA')
        endif
        call wkvect(kcha//'.LCHA', 'V V K8', ncha, icha)
        call wkvect(kcha//'.FCHA', 'V V K8', ncha, ikf)
        call dismoi('PHENOMENE', modele, 'MODELE', repk=phenom)
        ctyp=phenom(1:4)
        in=0
        do i = 1, ncha
!           ON STOCKE LES CHARGES DONT LE TYPE CORRESPOND A CTYP
            call dismoi('TYPE_CHARGE', lcha(i), 'CHARGE', repk=k8b, arret='C',&
                        ier=ie)
            if ((ie.eq.0) .and. (ctyp.eq.k8b(1:4))) then
                zk8(icha+in)= lcha(i)(1:8)
                zk8(ikf+in) = fcha(i)(1:8)
                in=in+1
            endif
        end do
        ncha=in
!
    endif
!
    call jedema()
end subroutine
