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

subroutine rcmo01(chmome, ima, ipt, vale)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: ima, ipt
    real(kind=8) :: vale(*)
    character(len=24) :: chmome
!
!     RECUPERATION DES CARACTERISTIQUES MATERIAU POUR UNE MAILLE DONNEE
!
! IN  : CHMOME : CHAM_ELEM DE MOMENT RESULTANT
! IN  : IMA    : NUMERO DE LA MAILLE
! IN  : IPT    : NUMERO DU NOEUD DE LA MAILLE
! OUT : VALE   : MOMENT RESULTANT
!                VALE(1) = MX
!                VALE(2) = MY
!                VALE(3) = MZ
!     ------------------------------------------------------------------
    character(len=24) :: valk
!
    integer ::   jcesl, nbcmp, decal, icmp, iad
    integer :: vali(2)
    real(kind=8), pointer :: cesv(:) => null()
    integer, pointer :: cesd(:) => null()
! DEB ------------------------------------------------------------------
    call jemarq()
!
! --- LE CHAMP MOMENT
!
    call jeveuo(chmome(1:19)//'.CESV', 'L', vr=cesv)
    call jeveuo(chmome(1:19)//'.CESD', 'L', vi=cesd)
    call jeveuo(chmome(1:19)//'.CESL', 'L', jcesl)
    nbcmp = cesd(2)
    decal = cesd(5+4*(ima-1)+4)
!
! --- LES VALEURS DES COMPOSANTES
!
    do 10 icmp = 1, 3
        iad = decal + (ipt-1)*nbcmp + icmp
        if (.not. zl(jcesl-1+iad)) then
            vali (1) = ima
            vali (2) = ipt
            valk = 'MOMENT'
            call utmess('F', 'POSTRCCM_18', sk=valk, ni=2, vali=vali)
        endif
        vale(icmp) = cesv(iad)
10  end do
!
    call jedema()
end subroutine
