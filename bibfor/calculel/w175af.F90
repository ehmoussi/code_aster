! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine w175af(modele, chfer1)
    implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/nocart.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: modele
    character(len=19) :: chfer1
!
! BUT : CREER LE CHAMP DE DONNEES POUR CALC_FERRAILLAGE
!
!-----------------------------------------------------------------------
    integer :: gd, nocc, ncmpmx, nbtou
    integer :: n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13
    integer :: n14, n15, n16
    integer ::   jmail, iocc, nbmail
    real(kind=8) :: valrcb, valrco
    character(len=8) :: k8b, typmcl(2), noma, typcb, clacier, uc
    character(len=16) :: motcls(2), typco
    character(len=24) :: mesmai
    character(len=8), pointer :: ncmp(:) => null()
    real(kind=8), pointer :: valv(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    call dismoi('NOM_MAILLA', modele, 'MODELE', repk=noma)
    ASSERT(noma.ne.' ')
!
    call getfac('AFFE', nocc)
!
    mesmai = '&&W175AF.MES_MAILLES'
    motcls(1) = 'GROUP_MA'
    motcls(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
!     1- ALLOCATION DU CHAMP CHFER1 (CARTE)
!     --------------------------------------------
    call alcart('V', chfer1, noma, 'FER1_R')
    call jeveuo(chfer1//'.NCMP', 'E', vk8=ncmp)
    call jeveuo(chfer1//'.VALV', 'E', vr=valv)
!
    call jenonu(jexnom('&CATA.GD.NOMGD', 'FER1_R'), gd)
    call jelira(jexnum('&CATA.GD.NOMCMP', gd), 'LONMAX', ncmpmx)
!
    ASSERT(ncmpmx.eq.16)
    ncmp(1) = 'TYPCOMB'
    ncmp(2) = 'CODIF'
    ncmp(3) = 'ES'
    ncmp(4) = 'CEQUI'
    ncmp(5) = 'ENROBS'
    ncmp(6) = 'ENROBI'
    ncmp(7) = 'SIGMACI'
    ncmp(8) = 'SIGMBET'
    ncmp(9) = 'COEFF1'
    ncmp(10)= 'COEFF2'
    ncmp(11)= 'GAMMAS'
    ncmp(12)= 'GAMMAC'
    ncmp(13)= 'FACIER'
    ncmp(14)= 'FBETON'
    ncmp(15)= 'CLACIER'
    ncmp(16)= 'UC'
!
!     2. MOTS CLES GLOBAUX :
!     ----------------------
!     2.1 TYPE_COMB :
    call getvtx(' ', 'TYPE_COMB', scal=typcb, nbret=n1)
    if (typcb.eq.'ELU') valrcb = 0.d0
    if (typcb.eq.'ELS') valrcb = 1.d0
    valv(1)=valrcb
!
!     2.2 CODIFICATION :
    call getvtx(' ', 'CODIFICATION', scal=typco, nbret=n2)
    if (typco.eq.'UTILISATEUR') valrco = 0.d0
    if (typco.eq.'BAEL91') valrco = 1.d0
    if (typco.eq.'EC2') valrco = 2.d0
    valv(2)=valrco
!
!
!     3- BOUCLE SUR LES OCCURENCES DU MOT CLE AFFE
!     --------------------------------------------
    do iocc = 1, nocc
!
        if (typco.eq.'UTILISATEUR') then
!       RECUPERATION DES MOTS CLES POUR CODIFICATION = 'UTILISATEUR'
        call getvr8('AFFE', 'ES', iocc=iocc, scal=valv(3), nbret=n3)
        call getvr8('AFFE', 'CEQUI', iocc=iocc, scal=valv(4), nbret=n4)
        call getvr8('AFFE', 'ENROBG', iocc=iocc, scal=valv(6), nbret=n6)
        valv(5) = valv(6)
        call getvr8('AFFE', 'SIGM_ACIER', iocc=iocc, scal=valv(7), nbret=n7)
        call getvr8('AFFE', 'SIGM_BETON', iocc=iocc, scal=valv(8), nbret=n8)
        call getvr8('AFFE', 'PIVA', iocc=iocc, scal=valv(9), nbret=n9)
        call getvr8('AFFE', 'PIVB', iocc=iocc, scal=valv(10), nbret=n10)
        else if (typco.eq.'BAEL91') then
!       RECUPERATION DES MOTS CLES POUR CODIFICATION = 'BAEL91'
        call getvr8('AFFE', 'E_S', iocc=iocc, scal=valv(3), nbret=n3)
        call getvr8('AFFE', 'N', iocc=iocc, scal=valv(4), nbret=n4)
        call getvr8('AFFE', 'C_SUP', iocc=iocc, scal=valv(5), nbret=n5)
        call getvr8('AFFE', 'C_INF', iocc=iocc, scal=valv(6), nbret=n6)
        call getvr8('AFFE', 'SIGS_ELS', iocc=iocc, scal=valv(7), nbret=n7)
        call getvr8('AFFE', 'SIGC_ELS', iocc=iocc, scal=valv(8), nbret=n8)
        call getvr8('AFFE', 'ALPHA_CC', iocc=iocc, scal=valv(9), nbret=n9)
        call getvr8('AFFE', 'GAMMA_S', iocc=iocc, scal=valv(11), nbret=n11)
        call getvr8('AFFE', 'GAMMA_C', iocc=iocc, scal=valv(12), nbret=n12)
        call getvr8('AFFE', 'FE', iocc=iocc, scal=valv(13), nbret=n13)
        call getvr8('AFFE', 'FCJ', iocc=iocc, scal=valv(14), nbret=n14)
        else if (typco.eq.'EC2') then
!       RECUPERATION DES MOTS CLES POUR CODIFICATION = 'EC2'
        call getvr8('AFFE', 'E_S', iocc=iocc, scal=valv(3), nbret=n3)
        call getvr8('AFFE', 'ALPHA_E', iocc=iocc, scal=valv(4), nbret=n4)
        call getvr8('AFFE', 'C_SUP', iocc=iocc, scal=valv(5), nbret=n5)
        call getvr8('AFFE', 'C_INF', iocc=iocc, scal=valv(6), nbret=n6)
        call getvr8('AFFE', 'SIGS_ELS', iocc=iocc, scal=valv(7), nbret=n7)
        call getvr8('AFFE', 'SIGC_ELS', iocc=iocc, scal=valv(8), nbret=n8)
        call getvr8('AFFE', 'ALPHA_CC', iocc=iocc, scal=valv(9), nbret=n9)
        call getvr8('AFFE', 'GAMMA_S', iocc=iocc, scal=valv(11), nbret=n11)
        call getvr8('AFFE', 'GAMMA_C', iocc=iocc, scal=valv(12), nbret=n12)
        call getvr8('AFFE', 'FYK', iocc=iocc, scal=valv(13), nbret=n13)
        call getvr8('AFFE', 'FCK', iocc=iocc, scal=valv(14), nbret=n14)
        call getvtx('AFFE', 'CLASSE_ACIER', iocc=iocc, scal=clacier, nbret=n15)
        if (clacier.eq.'A') valv(15) = 0.d0
        if (clacier.eq.'B') valv(15) = 1.d0
        if (clacier.eq.'C') valv(15) = 2.d0
        call getvtx('AFFE', 'UNITE_CONTRAINTE', iocc=iocc, scal=uc, nbret=n16)
        if (uc.eq.'Pa') valv(16) = 0.d0
        if (uc.eq.'MPa') valv(16) = 1.d0
        endif
!
!       VERIFICATION DE LA COHERENCE DES PARAMETRES
        if (typco.eq.'UTILISATEUR') then
!           REGLES SUR LES MOTS CLE POUR CODIFICATION = UTILISATEUR
            if (typcb.eq.'ELU') then
                if (n3.eq.0 .or. n9.eq.0 .or. n10.eq.0 .or. valv(3).le.0) then
                    call utmess('F', 'CALCULEL_73')
                endif
            else
                if (n4.eq.0) then
                    call utmess('F', 'CALCULEL_73')
                endif
            endif
        endif
        if (typco.eq.'BAEL91') then
!           REGLES SUR LES MOTS CLE POUR CODIFICATION =  BAEL91
            if (typcb.eq.'ELU') then
                if (n3.eq.0 .or. n11.eq.0 .or. n12.eq.0 .or. &
                    n13.eq.0 .or. n14.eq.0 .or. valv(3).le.0) then
                    call utmess('F', 'CALCULEL_74')
                endif
            else
                if (n4.eq.0 .or. n7.eq.0 .or. n8.eq.0) then
                    call utmess('F', 'CALCULEL_74')
                endif
            endif
        endif
        if (typco.eq.'EC2') then
!           REGLES SUR LES MOTS CLE POUR CODIFICATION =  EC2
            if (typcb .eq. 'ELU') then
                if (n3.eq.0  .or. n11.eq.0 .or. n12.eq.0 .or. &
                    n13.eq.0 .or. n14.eq.0 .or. valv(3).le.0) then
                    call utmess('F', 'CALCULEL_82')
                endif
            else
                if (n4.eq.0 .or. n7.eq.0 .or. n8.eq.0) then
                    call utmess('F', 'CALCULEL_82')
                endif
            endif
        endif
!
        call getvtx('AFFE', 'TOUT', iocc=iocc, scal=k8b, nbret=nbtou)
        if (nbtou .ne. 0) then
            call nocart(chfer1, 1, ncmpmx)
!
        else
            call reliem(' ', noma, 'NU_MAILLE', 'AFFE', iocc,&
                        2, motcls, typmcl, mesmai, nbmail)
            call jeveuo(mesmai, 'L', jmail)
            call nocart(chfer1, 3, ncmpmx, mode='NUM', nma=nbmail,&
                        limanu=zi(jmail))
            call jedetr(mesmai)
        endif
    end do
!
    call jedetr(chfer1//'.NCMP')
    call jedetr(chfer1//'.VALV')
!
    call jedema()
end subroutine
