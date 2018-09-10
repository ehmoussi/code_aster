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

subroutine gcharm(lfchar, cartei, nomfct, newfct, time,&
                  carteo)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/copisd.h"
#include "asterfort/fointe.h"
#include "asterfort/jedema.h"
#include "asterfort/jedupo.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    aster_logical :: lfchar
    character(len=8) :: nomfct, newfct
    real(kind=8) :: time
    character(len=19) :: cartei, carteo
!
! ----------------------------------------------------------------------
!
! ROUTINE CALC_G
!
! APPLIQUE LA FONCTION MULTIPLICATRICE SUR UN CHARGEMENT
!
! ----------------------------------------------------------------------
!
! IN  LFCHAR :  .TRUE.  SI LE CHARGEMENT EST 'FONCTION'
! IN  NOMFCT : NOM DE LA FONCTION MULTIPLICATRICE
! IN  TIME   : INSTANT
! I/O NEWFCT : FONCTION MULTIPLICATRICE MODIFIEE DANS LA CARTE DE SORTIE
!              PRODUIT DE LA FONC_MULT ET DE LA DEPENDANCE EVENTUELLE
!              VENUE D'AFFE_CHAR_MECA_F
! IN  CARTEI : CARTE DU CHARGEMENT AVANT LA PRISE EN COMPTE
!              DE LA FONCTION MULTIPLICATRICE
! OUT CARTEO : CARTE DU CHARGEMENT APRES LA PRISE EN COMPTE
!              DE LA FONCTION MULTIPLICATRICE
!
! ----------------------------------------------------------------------
!
    integer :: jvalin, jvalou
    integer :: nbvale, iret, in, k, i, nb, npt
    real(kind=8) :: const
    character(len=8) :: charge
    character(len=19) :: nch19
    character(len=24), pointer :: prol(:) => null()
    real(kind=8), pointer :: valf(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - VALEUR DE LA FONCTION
!
    call fointe('A', nomfct, 1, ['INST'], [time],&
                const, iret)
    charge = cartei(1:8)
!
! - ACCES AUX CARTES
!
    call jeveuo(cartei//'.VALE', 'L', jvalin)
    call jeveuo(carteo//'.VALE', 'E', jvalou)
    call jelira(cartei//'.VALE', 'LONMAX', nbvale)
!
! - 1. CHARGEMENT 'SCALAIRE'
!
    if (.not.lfchar) then
        do 10 in = 1, nbvale
            zr(jvalou+in-1) = const*zr(jvalin +in-1)
 10     continue
!
! - 2. CHARGEMENT 'FONCTION'
!
    else
        k=0
        do 20 in = 1, nbvale
            if (zk8(jvalin+in-1)(1:7) .ne. '&FOZERO' .and. zk8(jvalin+in-1)(1:7) .ne.&
                '       ' .and. zk8(jvalin+in-1)(1:6) .ne. 'GLOBAL') then
                k=k+1
                call codent(k, 'D0', newfct(8:8))
                call copisd('FONCTION', 'V', zk8(jvalin+in-1), newfct)
                nch19 = newfct
                call jeveuo(nch19//'.PROL', 'L', vk24=prol)
                if (prol(1)(1:8) .ne. 'INTERPRE') then
                    call jeveuo(nch19//'.VALE', 'E', vr=valf)
                    call jelira(nch19//'.VALE', 'LONMAX', nb)
                    npt=nb/2
                    do 30 i = 1, npt
                        valf(1+npt+i-1)=const*valf(1+npt+i-1)
 30                 continue
                    zk8(jvalou+in-1) = newfct
                else
                    call utmess('A', 'RUPTURE2_4', sk=charge)
                    call jedupo(cartei//'.VALE', 'V', carteo//'.VALE', .false._1)
                    goto 999
                endif
            endif
 20     continue
    endif
!
999 continue
    call jedema()
!
end subroutine
