! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine tbexve(nomta, para, nomobj, basobj_, nbval_,&
                  typval_)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=*) :: nomta, para, nomobj
character(len=*), optional, intent(in) :: basobj_
integer, optional, intent(out) :: nbval_
character(len=*), optional, intent(out) :: typval_
!
! --------------------------------------------------------------------------------------------------
!
!      LECTURE DE TOUTES LES VALEURS D'UNE COLONNE D'UNE TABLE
!
! --------------------------------------------------------------------------------------------------
!
! IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE".
! IN  : PARA   : PARAMETRE DESIGNANT LA COLONNE A EXTRAIRE
! IN  : NOMOBJ : NOM DE L'OBJET JEVEUX CONTENANT LES VALEURS
! IN  : BASOBJ : BASE SUR LAQUELLE ON CREE LE VECTEUR
! OUT : NBVAL  : NOMBRE DE VALEURS EXTRAITES
! OUT : TYPVAL : TYPE JEVEUX DES VALEURS EXTRAITES
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nbpara, nblign,   ipar
    integer :: i, iv, jvale, jvall, kvale, nbval
    character(len=1) :: base
    character(len=4) :: type
    character(len=19) :: nomtab
    character(len=24) :: nomjv, nomjvl, inpar, jnpar
    character(len=24) :: valk
    integer, pointer :: tbnp(:) => null()
    character(len=24), pointer :: tblp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    nomtab = nomta
    base = 'V'
    if (present(basobj_)) then
        base = basobj_(1:1)
    endif
    inpar = para
!
!     --- VERIFICATION DE LA BASE ---
!
    ASSERT(base.eq.'V' .or. base.eq.'G')
!
!     --- VERIFICATION DE LA TABLE ---
!
    call jeexin(nomtab//'.TBBA', iret)
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_64')
    endif
!
    call jeveuo(nomtab//'.TBNP', 'L', vi=tbnp)
    nbpara = tbnp(1)
    nblign = tbnp(2)
    if (nbpara .eq. 0) then
        call utmess('F', 'UTILITAI4_65')
    endif
    if (nblign .eq. 0) then
        call utmess('F', 'UTILITAI4_76')
    endif
!
!     --- VERIFICATION QUE LE PARAMETRE EXISTE DANS LA TABLE ---
!
    call jeveuo(nomtab//'.TBLP', 'L', vk24=tblp)
    do ipar = 1, nbpara
        jnpar = tblp(1+4*(ipar-1))
        if (inpar .eq. jnpar) goto 12
    end do
    valk = inpar
    call utmess('F', 'UTILITAI6_89', sk=valk)
12  continue
!
    type   = tblp(1+4*(ipar-1)+1)(1:4)
    nomjv  = tblp(1+4*(ipar-1)+2)
    nomjvl = tblp(1+4*(ipar-1)+3)
!
    call jeveuo(nomjv, 'L', jvale)
    call jeveuo(nomjvl, 'L', jvall)
    nbval = 0
    do i = 1, nblign
        if (zi(jvall+i-1) .eq. 1) nbval = nbval + 1
    end do
!
    iv = 0
    if (type(1:1) .eq. 'I') then
        call wkvect(nomobj, base//' V I', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zi(kvale+iv-1) = zi(jvale+i-1)
            endif
        end do
!
    else if (type(1:1) .eq. 'R') then
        call wkvect(nomobj, base//' V R', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zr(kvale+iv-1) = zr(jvale+i-1)
            endif
        end do
!
    else if (type(1:1) .eq. 'C') then
        call wkvect(nomobj, base//' V C', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zc(kvale+iv-1) = zc(jvale+i-1)
            endif
        end do
!
    else if (type(1:3) .eq. 'K80') then
        call wkvect(nomobj, base//' V K80', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zk80(kvale+iv-1) = zk80(jvale+i-1)
            endif
        end do
!
    else if (type(1:3) .eq. 'K32') then
        call wkvect(nomobj, base//' V K32', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zk32(kvale+iv-1) = zk32(jvale+i-1)
            endif
        end do
!
    else if (type(1:3) .eq. 'K24') then
        call wkvect(nomobj, base//' V K24', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zk24(kvale+iv-1) = zk24(jvale+i-1)
            endif
        end do
!
    else if (type(1:3) .eq. 'K16') then
        call wkvect(nomobj, base//' V K16', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zk16(kvale+iv-1) = zk16(jvale+i-1)
            endif
        end do
!
    else if (type(1:2) .eq. 'K8') then
        call wkvect(nomobj, base//' V K8', nbval, kvale)
        do i = 1, nblign
            if (zi(jvall+i-1) .eq. 1) then
                iv = iv + 1
                zk8(kvale+iv-1) = zk8(jvale+i-1)
            endif
        end do
    endif
!
    if (present(typval_)) then
        typval_ = type
    endif
    if (present(nbval_)) then
        nbval_ = iv
    endif
    call jeecra(nomobj, 'LONUTI', iv)
!
    call jedema()
end subroutine
