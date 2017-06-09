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

subroutine tbacce(nomta, numeli, para, mode, vi,&
                  vr, vc, vk)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
    integer :: numeli, vi
    real(kind=8) :: vr
    complex(kind=8) :: vc
    character(len=*) :: nomta, para, mode, vk
! ----------------------------------------------------------------------
! person_in_charge: mathieu.courtois at edf.fr
!      ACCES A UNE CELLULE D'UNE LIGNE DE LA TABLE
!         EN MODE LECTURE , LE V. EST EN SORTIE
!         EN MODE ECRITURE, LE V. EST EN DONNEE
! ----------------------------------------------------------------------
! IN     : NOMTA  : NOM DE LA STRUCTURE "TABLE".
! IN     : NUMELI : NUMERO DE LA LIGNE
! IN     : PARA   : PARAMETRE
! IN     : MODE   : ACCES EN MODE ECRITURE 'E' OU LECTURE 'L'
! IN/OUT : VI     : VALEUR POUR LE PARAMETRE "I"
! IN/OUT : VR     : VALEUR POUR LE PARAMETRE "R"
! IN/OUT : VC     : VALEUR POUR LE PARAMETRE "C"
! IN/OUT : VK     : VALEUR POUR LE PARAMETRE "K"
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: iret, nbpara, nblign,   j, jvale, jvall
    character(len=1) :: modacc
    character(len=4) :: type
    character(len=19) :: nomtab
    character(len=24) :: nomjv, nomjvl, inpar
    character(len=24) :: valk
    character(len=24), pointer :: tblp(:) => null()
    integer, pointer :: tbnp(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
!
    modacc = mode
    if (modacc .eq. 'L') then
    else if (modacc .eq. 'E') then
    else
        call utmess('F', 'UTILITAI4_63', sk=modacc)
    endif
!
    nomtab = nomta
    call jeexin(nomtab//'.TBBA', iret)
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_64')
    endif
!
    call jeveuo(nomtab//'.TBNP', 'E', vi=tbnp)
    nbpara = tbnp(1)
    nblign = tbnp(2)
    if (nbpara .eq. 0) then
        call utmess('F', 'UTILITAI4_65')
    endif
    if (nblign .eq. 0) then
        call utmess('F', 'UTILITAI4_66')
    endif
    if (numeli .gt. nblign) then
        call utmess('F', 'UTILITAI4_67')
    endif
!
    call jeveuo(nomtab//'.TBLP', 'L', vk24=tblp)
!
!     --- VERIFICATION QUE LE PARAMETRE EXISTE DANS LA TABLE ---
!
    inpar = para
    do 10 j = 1, nbpara
        if (inpar .eq. tblp(1+4*(j-1))) goto 12
10  end do
    valk = inpar
    call utmess('F', 'UTILITAI6_89', sk=valk)
12  continue
!
    type = tblp(1+4*(j-1)+1)
    nomjv = tblp(1+4*(j-1)+2)
    nomjvl = tblp(1+4*(j-1)+3)
!
    call jeveuo(nomjv, modacc, jvale)
    call jeveuo(nomjvl, modacc, jvall)
!
    if (type(1:1) .eq. 'I') then
        if (modacc .eq. 'L') then
            vi = zi(jvale+numeli-1)
        else
            zi(jvale+numeli-1) = vi
            zi(jvall+numeli-1) = 1
        endif
!
    else if (type(1:1) .eq. 'R') then
        if (modacc .eq. 'L') then
            vr = zr(jvale+numeli-1)
        else
            zr(jvale+numeli-1) = vr
            zi(jvall+numeli-1) = 1
        endif
!
    else if (type(1:1) .eq. 'C') then
        if (modacc .eq. 'L') then
            vc = zc(jvale+numeli-1)
        else
            zc(jvale+numeli-1) = vc
            zi(jvall+numeli-1) = 1
        endif
!
    else if (type(1:3) .eq. 'K80') then
        if (modacc .eq. 'L') then
            vk = zk80(jvale+numeli-1)
        else
            zk80(jvale+numeli-1) = vk
            zi (jvall+numeli-1) = 1
        endif
!
    else if (type(1:3) .eq. 'K32') then
        if (modacc .eq. 'L') then
            vk = zk32(jvale+numeli-1)
        else
            zk32(jvale+numeli-1) = vk
            zi (jvall+numeli-1) = 1
        endif
!
    else if (type(1:3) .eq. 'K24') then
        if (modacc .eq. 'L') then
            vk = zk24(jvale+numeli-1)
        else
            zk24(jvale+numeli-1) = vk
            zi (jvall+numeli-1) = 1
        endif
!
    else if (type(1:3) .eq. 'K16') then
        if (modacc .eq. 'L') then
            vk = zk16(jvale+numeli-1)
        else
            zk16(jvale+numeli-1) = vk
            zi (jvall+numeli-1) = 1
        endif
!
    else if (type(1:2) .eq. 'K8') then
        if (modacc .eq. 'L') then
            vk = zk8(jvale+numeli-1)
        else
            zk8(jvale+numeli-1) = vk
            zi (jvall+numeli-1) = 1
        endif
    endif
!
    call jedema()
end subroutine
