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

subroutine irmase(nofimd, typsec, nbrcou, nbsect, nummai,&
                  sdcarm, nomase)
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8pi.h"
#include "asterfort/as_mficlo.h"
#include "asterfort/as_mfiope.h"
#include "asterfort/as_mmhcow.h"
#include "asterfort/as_msmcre.h"
#include "asterfort/as_msmnsm.h"
#include "asterfort/as_msmsmi.h"
#include "asterfort/assert.h"
#include "asterfort/cesexi.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=8) :: sdcarm
    character(len=*) :: nofimd, typsec, nomase
    integer :: nbrcou, nbsect, nummai
! person_in_charge: nicolas.sellenet at edf.fr
!
! --------------------------------------------------------------------------------------------------
!
!  IMPR_RESU - IMPRESSION DES MAILLAGES DE SECTION
!
! --------------------------------------------------------------------------------------------------
!
! IN  :
!   NOFIMD  K*   ENTIER LIE AU FICHIER MED OUVERT
!   TYPSEC  K*   TYPE DE DE SECTION (COQUE, TUYAU OU PMF)
!   NBRCOU  I    NOMBRE DE COUCHES (COQUE ET TUYAU)
!   NBSECT  I    NOMBRE DE TUYAU
!   NUMMAI  I    NUMERO DE LA MAILLE REFERENCE D'UNE PMF
!   SDCARM  K8   CARA_ELEM CONVERTIT EN CHAM_ELEM_S
!   NOMASE  K*   NOM MED DU MAILLAGE SECTION
!
! --------------------------------------------------------------------------------------------------
!
    integer :: idfimd, nbpoin, jcoopt, icouch, irayon
    integer :: edleaj, postmp, codret, edcart, jmasup, jcesd, ibid
    integer :: edfuin, ndim, nbmasu, imasup, edcar2, jcesl
    integer :: nbcmp, isp, icmp, iad
!
    parameter    (edleaj = 1)
    parameter    (edcart = 0)
    parameter    (edfuin = 0)
!
    character(len=8)   :: saux08
    character(len=16)  :: nocoor(3), uncoor(3), nocoo2(3), uncoo2(3)
    character(len=64)  :: nomasu
    character(len=200) :: desmed
!
    real(kind=8) :: delta, theta, dtheta, rayon
!
    aster_logical :: lmstro
    real(kind=8),     pointer :: cesv(:)     => null()
    character(len=8), pointer :: cesc(:)     => null()
!
    data nocoor  /'X               ', 'Y               ', 'Z               '/
    data uncoor  /'INCONNU         ', 'INCONNU         ', 'INCONNU         '/
!
! --------------------------------------------------------------------------------------------------
!
    if ((typsec.ne.'COQUE').and.(typsec.ne.'GRILLE').and. &
        (typsec.ne.'TUYAU').and.(typsec.ne.'PMF')) goto 9999
!
    desmed = ' '
    call as_mfiope(idfimd, nofimd, edleaj, codret)
    if (codret .ne. 0) then
        saux08='mfiope'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
!   RELECTURE DES ELEMENTS DE STRUCTURES DEJA PRESENTS
    nbmasu = 0
    call as_msmnsm(idfimd, nbmasu, codret)
    if (codret .ne. 0) then
        saux08='msmnsm'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
    lmstro = .false.
    if (nbmasu .ne. 0) then
        call wkvect('&&IRMASE.MAIL_SUPP', 'V V K80', nbmasu, jmasup)
        do imasup = 1, nbmasu
            call as_msmsmi(idfimd, imasup, nomasu, ndim, desmed,&
                           edcar2, nocoo2, uncoo2, codret)
            if (codret .ne. 0) then
                saux08='msmsmi'
                call utmess('F', 'DVP_97', sk=saux08, si=codret)
            endif
            if (nomasu .eq. nomase) lmstro = .true.
        enddo
        call jedetr('&&IRMASE.MAIL_SUPP')
        if (lmstro) goto 9999
    endif
!
    ndim = 0
    if (typsec .eq. 'COQUE') then
        ndim   = 1
        nbpoin = 3*nbrcou
        call wkvect('&&IRMASE.COOR_PTS', 'V V R', nbpoin, jcoopt)
        delta = 2.d0/nbrcou
        do icouch = 1, nbrcou
            ibid = jcoopt+(icouch-1)*3
            zr(ibid+2) = -1.0d0 + icouch*delta
            zr(ibid)   = zr(ibid+2) - delta
            zr(ibid+1) = 0.5d0*(zr(ibid+2)+zr(ibid))
        enddo
!
    else if (typsec .eq. 'GRILLE') then
        ndim   = 1
        nbpoin = 1
        call wkvect('&&IRMASE.COOR_PTS', 'V V R', nbpoin, jcoopt)
        zr(jcoopt) = 0.0d0
!
    else if (typsec .eq. 'TUYAU') then
!       SUPER IMPORTANT SUPER IMPORTANT SUPER IMPORTANT
!           La convention des angles de vrilles entre les poutres et tuyaux est différente
!           Il y a un repère indirect pour les tuyaux ==> c'est pas bien
!               - On décale les angles de 90°.
!               - Quand tout sera dans l'ordre, il faudra calculer correctement yy et zz
!
!       A FAIRE DANS : te0478  irmase
!
        ndim   = 2
        nbpoin = (2*nbsect+1)*(2*nbrcou+1)
        call wkvect('&&IRMASE.COOR_PTS', 'V V R', 2*nbpoin, jcoopt)
        postmp = 0
        dtheta = r8pi()/nbsect
        do icouch = 1 , 2*nbrcou+1
            rayon = 0.5d0 + 0.25d0*(icouch-1)/nbrcou
            do irayon = 1 , 2*nbsect+1
                theta = -(irayon-1)*dtheta - 0.50*r8pi()
                zr(jcoopt+postmp)   = rayon*cos(theta)
                zr(jcoopt+postmp+1) = rayon*sin(theta)
                postmp = postmp+2
            enddo
        enddo
!
    else if (typsec.eq.'PMF') then
        ndim = 2
        call jeveuo(sdcarm//'.CAFIBR    .CESC', 'L', vk8=cesc)
        call jeveuo(sdcarm//'.CAFIBR    .CESD', 'L', jcesd)
        call jeveuo(sdcarm//'.CAFIBR    .CESV', 'L', vr=cesv)
        call jeveuo(sdcarm//'.CAFIBR    .CESL', 'L', jcesl)
!
        ASSERT(zi(jcesd+5+4*(nummai-1)).eq.1)
        nbpoin = zi(jcesd+5+4*(nummai-1)+1)
        call wkvect('&&IRMASE.COOR_PTS', 'V V R', 2*nbpoin, jcoopt)
        nbcmp = zi(jcesd+5+4*(nummai-1)+2)
!       YG       ZG       AIRE     YP       ZP       GX       NUMGR
        ASSERT(nbcmp.eq.7)
        ASSERT(cesc(1).eq.'YG      '.and. cesc(2).eq.'ZG      ')
        ASSERT(cesc(3).eq.'AIRE    '.and. cesc(4).eq.'YP      ')
        ASSERT(cesc(5).eq.'ZP      '.and. cesc(6).eq.'GX      ')
        ASSERT(cesc(7).eq.'NUMGR   ')
!
        postmp = 0
        do isp = 1, nbpoin
            do icmp = 1, 2
                call cesexi('S', jcesd, jcesl, nummai, 1, isp, icmp, iad)
                zr(jcoopt+postmp) = cesv(iad)
                postmp = postmp+1
            enddo
        enddo
!
    endif
!
!   Définition du maillage support MED
    call as_msmcre(idfimd, nomase, ndim, desmed, edcart, nocoor, uncoor, codret)
    if (codret .ne. 0) then
        saux08='msmcre'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!   Définition des noeuds du maillage support MED
    call as_mmhcow(idfimd, nomase, zr(jcoopt), edfuin, nbpoin, codret)
    if (codret .ne. 0) then
        saux08='mmhcow'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
    call as_mficlo(idfimd, codret)
    if (codret .ne. 0) then
        saux08='mficlo'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
    call jedetr('&&IRMASE.COOR_PTS')
!
9999 continue
!
end subroutine
