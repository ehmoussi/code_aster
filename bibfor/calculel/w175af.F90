! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    integer :: n14, n15, n16, n17, n18, n19, n20, n21, n22
    integer ::   jmail, iocc, nbmail
    real(kind=8) :: valrcb, valrco
    character(len=8) :: k8b, typmcl(2), noma, typcb, clacier, uc, compress
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
    ASSERT(ncmpmx.eq.22)
    ncmp(1) = 'TYPCOMB'
    ncmp(2) = 'CODIF'
    ncmp(3) = 'COMPRESS'
    ncmp(4) = 'CEQUI'
    ncmp(5) = 'ENROBS'
    ncmp(6) = 'ENROBI'
    ncmp(7) = 'SIGMACI'
    ncmp(8) = 'SIGMBET'
    ncmp(9) = 'ALPHACC'
    ncmp(10)= 'GAMMAS'
    ncmp(11)= 'GAMMAC'
    ncmp(12)= 'FACIER'
    ncmp(13)= 'FBETON'
    ncmp(14)= 'CLACIER'
    ncmp(15)= 'UC'
    ncmp(16)= 'RHOACIER'
    ncmp(17)= 'AREINF'
    ncmp(18)= 'ASHEAR'
    ncmp(19)= 'ASTIRR'
    ncmp(20)= 'RHOCRIT'
    ncmp(21)= 'DATCRIT'
    ncmp(22)= 'LCRIT'
!
!     2. MOTS CLES GLOBAUX :
!     ----------------------
!     2.1 TYPE_COMB :
    call getvtx(' ', 'TYPE_COMB', scal=typcb, nbret=n1)
    if (typcb.eq.'ELU') valrcb = 0.d0
    if (typcb.eq.'ELS') valrcb = 1.d0
    valv(1) = valrcb
!
!     2.2 CODIFICATION :
    call getvtx(' ', 'CODIFICATION', scal=typco, nbret=n2)
    if (typco.eq.'BAEL91') valrco = 1.d0
    if (typco.eq.'EC2') valrco = 2.d0
    valv(2) = valrco
!
!
!     3- BOUCLE SUR LES OCCURENCES DU MOT CLE AFFE
!     --------------------------------------------
    do iocc = 1, nocc
!
        if (typco.eq.'BAEL91') then
!           RECUPERATION DES MOTS CLES POUR CODIFICATION = 'BAEL91'
            call getvr8('AFFE', 'N', iocc=iocc, scal=valv(4), nbret=n4)
            call getvr8('AFFE', 'C_SUP', iocc=iocc, scal=valv(5), nbret=n5)
            call getvr8('AFFE', 'C_INF', iocc=iocc, scal=valv(6), nbret=n6)
            call getvr8('AFFE', 'SIGS_ELS', iocc=iocc, scal=valv(7), nbret=n7)
            call getvr8('AFFE', 'SIGC_ELS', iocc=iocc, scal=valv(8), nbret=n8)
            call getvr8('AFFE', 'ALPHA_CC', iocc=iocc, scal=valv(9), nbret=n9)
            call getvr8('AFFE', 'GAMMA_S', iocc=iocc, scal=valv(10), nbret=n10)
            call getvr8('AFFE', 'GAMMA_C', iocc=iocc, scal=valv(11), nbret=n11)
            call getvr8('AFFE', 'FE', iocc=iocc, scal=valv(12), nbret=n12)
            call getvr8('AFFE', 'FCJ', iocc=iocc, scal=valv(13), nbret=n13)
            call getvr8('AFFE', 'RHO_ACIER', iocc=iocc, scal=valv(16), nbret=n16)
            call getvr8('AFFE', 'ALPHA_REINF', iocc=iocc, scal=valv(17), nbret=n17)
            call getvr8('AFFE', 'ALPHA_SHEAR', iocc=iocc, scal=valv(18), nbret=n18)
            call getvr8('AFFE', 'ALPHA_STIRRUPS', iocc=iocc, scal=valv(19), nbret=n19)
            call getvr8('AFFE', 'RHO_CRIT', iocc=iocc, scal=valv(20), nbret=n20)
            call getvr8('AFFE', 'DNSTRA_CRIT', iocc=iocc, scal=valv(21), nbret=n21)
            call getvr8('AFFE', 'L_CRIT', iocc=iocc, scal=valv(22), nbret=n22)
        else if (typco.eq.'EC2') then
!           RECUPERATION DES MOTS CLES POUR CODIFICATION = 'EC2'
            call getvtx('AFFE', 'UTIL_COMPR', iocc=iocc, scal=compress, nbret=n3)
            if (compress.eq.'NON') valv(3) = 0.d0
            if (compress.eq.'OUI') valv(3) = 1.d0
            call getvr8('AFFE', 'ALPHA_E', iocc=iocc, scal=valv(4), nbret=n4)
            call getvr8('AFFE', 'C_SUP', iocc=iocc, scal=valv(5), nbret=n5)
            call getvr8('AFFE', 'C_INF', iocc=iocc, scal=valv(6), nbret=n6)
            call getvr8('AFFE', 'SIGS_ELS', iocc=iocc, scal=valv(7), nbret=n7)
            call getvr8('AFFE', 'SIGC_ELS', iocc=iocc, scal=valv(8), nbret=n8)
            call getvr8('AFFE', 'ALPHA_CC', iocc=iocc, scal=valv(9), nbret=n9)
            call getvr8('AFFE', 'GAMMA_S', iocc=iocc, scal=valv(10), nbret=n10)
            call getvr8('AFFE', 'GAMMA_C', iocc=iocc, scal=valv(11), nbret=n11)
            call getvr8('AFFE', 'FYK', iocc=iocc, scal=valv(12), nbret=n12)
            call getvr8('AFFE', 'FCK', iocc=iocc, scal=valv(13), nbret=n13)
            call getvtx('AFFE', 'CLASSE_ACIER', iocc=iocc, scal=clacier, nbret=n14)
            if (clacier.eq.'A') valv(14) = 0.d0
            if (clacier.eq.'B') valv(14) = 1.d0
            if (clacier.eq.'C') valv(14) = 2.d0
            call getvtx('AFFE', 'UNITE_CONTRAINTE', iocc=iocc, scal=uc, nbret=n15)
            if (uc.eq.'Pa') valv(15) = 0.d0
            if (uc.eq.'MPa') valv(15) = 1.d0
            call getvr8('AFFE', 'RHO_ACIER', iocc=iocc, scal=valv(16), nbret=n16)
            call getvr8('AFFE', 'ALPHA_REINF', iocc=iocc, scal=valv(17), nbret=n17)
            call getvr8('AFFE', 'ALPHA_SHEAR', iocc=iocc, scal=valv(18), nbret=n18)
            call getvr8('AFFE', 'ALPHA_STIRRUPS', iocc=iocc, scal=valv(19), nbret=n19)
            call getvr8('AFFE', 'RHO_CRIT', iocc=iocc, scal=valv(20), nbret=n20)
            call getvr8('AFFE', 'DNSTRA_CRIT', iocc=iocc, scal=valv(21), nbret=n21)
            call getvr8('AFFE', 'L_CRIT', iocc=iocc, scal=valv(22), nbret=n22)
            endif
!
!       VERIFICATION DE LA COHERENCE DES PARAMETRES
        if (valv(16).lt.0.d0) then
!           MASSE VOLUMIQUE NEGATIVE
            call utmess('I', 'CALCULEL_89')
        endif
!
        if (typcb.eq.'ELU') then
!           MOTS-CLE OBLIGATOIRES POUR UN CALCUL A L'ELU
            if (n10.eq.0 .or. n11.eq.0 .or. n12.eq.0 .or. n13.eq.0) then
                call utmess('F', 'CALCULEL_74')
            endif
        else if (typcb.eq.'ELS') then
!           MOTS-CLE OBLIGATOIRES POUR UN CALCUL A L'ELS
            if (n4.eq.0 .or. n7.eq.0 .or. n8.eq.0) then
                call utmess('F', 'CALCULEL_82')
            endif
            if (typco.eq.'EC2' .and. n13.eq.0) then
                call utmess('F', 'CALCULEL_82')
            endif
            if (typco.eq.'BAEL91') then
!               MESSAGE D'INFORMATION : PAS DE CALCUL DES ACIERS
!               TRANSVERSAUX POUR LA CODIFICATION BAEL91
                call utmess('I', 'CALCULEL_80')
            endif
        endif
!
        call getvtx('AFFE', 'TOUT', iocc=iocc, scal=k8b, nbret=nbtou)
        if (nbtou .ne. 0) then
            call nocart(chfer1, 1, ncmpmx)
!
        else
            call reliem(' ', noma, 'NU_MAILLE', 'AFFE', iocc, &
                        2, motcls, typmcl, mesmai, nbmail)
            call jeveuo(mesmai, 'L', jmail)
            call nocart(chfer1, 3, ncmpmx, mode='NUM', nma=nbmail, &
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
