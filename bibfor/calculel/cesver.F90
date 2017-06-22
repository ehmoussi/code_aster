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

subroutine cesver(cesz)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cesexi.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    character(len=*) :: cesz
! ---------------------------------------------------------------------
! BUT: FAIRE DES VERIFICATIONS SUR UN CHAM_ELEM_S
!      (=> IMPRIMER SUR LE FICHIER .MESS DES INFORMATIONS)
! ---------------------------------------------------------------------
!     ARGUMENTS:
! CESZ   IN/JXIN  K19 : SD CHAM_ELEM_S A VERIFIER
!
! REMARQUES :
!  * POUR L'INSTANT ON FAIT LES VERIFICATIONS SUIVANTES :
!     * SI CES / ELNO  OU CES / ELGA  :
!         SI L'ECART DES VALEURS D'UNE MAILLE (SUR SES POINTS)
!         EST > 10% DU MAX DU CHAMP
!         => MESSAGE POUR DIRE QUE LA DISCRETISATION EST TROP GROSSIERE
!     * SINON : RIEN !
!  * ON NE TRAITE QUE LES CHAMPS REELS OU COMPLEXES
!  * POUR LES CHAMPS COMPLEXES, ON NE REGARDE QUE LA PARTIE REELLE
!  * POUR LES CHAMPS A SOUS-POINTS, ON NE REGARDE QUE LE SOUS-POINT 1
!
!-----------------------------------------------------------------------
!
!     ------------------------------------------------------------------
    integer :: jcesd, jcesv, jcesl, iad
    integer :: nbma, ima, ncmp, ipt, isp, nbpt, icmp, ima1
    character(len=24) :: valk(3)
    character(len=8) :: ma, nomgd, nomma, typces
    character(len=3) :: tsca
    character(len=19) :: ces
    real(kind=8) :: rmi1, rma1, rmi2, rma2, rdisp, rdispx, r1, rmax, valr(3)
    aster_logical :: lexima
    character(len=8), pointer :: cesk(:) => null()
    character(len=8), pointer :: cesc(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    ces = cesz
!
    call jeveuo(ces//'.CESK', 'L', vk8=cesk)
    call jeveuo(ces//'.CESD', 'L', jcesd)
    call jeveuo(ces//'.CESC', 'L', vk8=cesc)
    call jeveuo(ces//'.CESV', 'L', jcesv)
    call jeveuo(ces//'.CESL', 'L', jcesl)
!
    ma = cesk(1)
    nomgd = cesk(2)
    typces = cesk(3)
    nbma = zi(jcesd-1+1)
    ncmp = zi(jcesd-1+2)
!
!
!     -- ON NE TRAITE QUE LES CHAMPS ELNO OU ELGA :
    if (typces .eq. 'ELNO' .or. typces .eq. 'ELGA') then
    else
        goto 999
    endif
!
!
!     -- ON NE TRAITE QUE LES CHAMPS R OU C :
!        POUR LES CHAMPS COMPLEXES, ON NE S'INTERESSE QU'A LA
!        PARTIE REELLE.
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk=tsca)
    if (tsca .eq. 'R' .or. tsca .eq. 'C') then
    else
        goto 999
    endif
!
!
!
!     1- PARCOURS DES VALEURS DU CHAMP :
!     ----------------------------------
    do icmp = 1, ncmp
        rmi2=1.d200
        rma2=-1.d200
        rdispx=0.d0
        do ima = 1, nbma
            nbpt = zi(jcesd-1+5+4* (ima-1)+1)
            lexima=.false.
!         -- ON NE REGARDE QUE LE 1ER SOUS-POINT :
            do isp = 1, 1
                rmi1=1.d200
                rma1=-1.d200
                do ipt = 1, nbpt
                    call cesexi('C', jcesd, jcesl, ima, ipt,&
                                isp, icmp, iad)
                    if (iad .le. 0) goto 60
                    lexima=.true.
!
                    if (tsca .eq. 'R') then
                        r1=zr(jcesv-1+iad)
                    else if (tsca.eq.'C') then
                        r1=dble(zc(jcesv-1+iad))
                    endif
                    rmi1=min(rmi1,r1)
                    rma1=max(rma1,r1)
                    rmi2=min(rmi2,r1)
                    rma2=max(rma2,r1)
 60                 continue
                end do
                if (lexima) then
                    rdisp=rma1-rmi1
                else
                    rdisp=0.d0
                endif
                if (rdisp .gt. rdispx) then
                    rdispx=rdisp
                    ima1=ima
                endif
            end do
        end do
!
        rmax=max(abs(rmi2),abs(rma2))
        if (rdispx .gt. 0.1d0*rmax) then
            valr(1)=rdispx
            valr(2)=rmax
            valr(3)=100.d0*rdispx/rmax
            call jenuno(jexnum(ma//'.NOMMAI', ima1), nomma)
            valk(1)=nomma
            valk(2)=cesc(icmp)
            valk(3)=nomgd
            call utmess('A', 'CALCULEL_26', nk=3, valk=valk, nr=3,&
                        valr=valr)
        endif
!
    end do
!
!
999 continue
    call jedema()
end subroutine
