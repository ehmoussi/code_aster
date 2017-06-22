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

subroutine tbajva(table, nbpara, nompar, vi, livi,&
                  vr, livr, vc, livc, vk,&
                  livk)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: nbpara, vi, livi(*)
    real(kind=8) :: vr, livr(*)
    complex(kind=8) :: vc, livc(*)
    character(len=*) :: table, nompar, vk, livk(*)
!      AJOUTER UNE LIGNE A UNE TABLE.
! ----------------------------------------------------------------------
! IN  : TABLE  : NOM DE LA STRUCTURE "TABLE".
! IN  : NBPARA : NOMBRE DE PARAMETRES DE NOMPAR
! IN  : NOMPAR : PARAMETRE POUR LEQUEL ON VEUT ECRIRE
! IN  : VI     : VALEUR POUR LE PARAMETRE "I"
! I/O : LIVI   : LISTE DES VALEURS POUR LES PARAMETRES "I"
! IN  : VR     : VALEUR POUR LE PARAMETRE "R"
! I/O : LIVR   : LISTE DES VALEURS POUR LES PARAMETRES "R"
! IN  : VC     : VALEUR POUR LE PARAMETRE "C"
! I/O : LIVC   : LISTE DES VALEURS POUR LES PARAMETRES "C"
! IN  : VK     : VALEUR POUR LE PARAMETRE "K"
! I/O : LIVK   : LISTE DES VALEURS POUR LES PARAMETRES "K"
! ----------------------------------------------------------------------
!
!
! ----------------------------------------------------------------------
!
    integer :: iret, nbcol
    integer ::  i, ki, kr, kc, kk
    character(len=19) :: nomtab
    character(len=24) :: type, nomcol
    character(len=24), pointer :: tblp(:) => null()
    integer, pointer :: tbnp(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    nomtab = ' '
    nomtab = table
    call jeexin(nomtab//'.TBBA', iret)
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_64')
    endif
    if (nomtab(18:19) .ne. '  ') then
        call utmess('F', 'UTILITAI4_68')
    endif
!
    call jeveuo(nomtab//'.TBLP', 'L', vk24=tblp)
    call jeveuo(nomtab//'.TBNP', 'L', vi=tbnp)
    nbcol = tbnp(1)
    ASSERT(nbcol.ne.0)
    ASSERT(nbcol.eq.nbpara)
!
    ki = 0
    kr = 0
    kc = 0
    kk = 0
    do 10 i = 1, nbcol
        nomcol = tblp(4*(i-1)+1)
        type = tblp(4*(i-1)+2)
        if (type(1:1) .eq. 'I') then
            ki = ki + 1
            if (nompar .eq. nomcol) then
                livi(ki) = vi
                goto 20
            endif
        else if (type(1:1).eq.'R') then
            kr = kr + 1
            if (nompar .eq. nomcol) then
                livr(kr) = vr
                goto 20
            endif
        else if (type(1:1).eq.'C') then
            kc = kc + 1
            if (nompar .eq. nomcol) then
                livc(kc) = vc
                goto 20
            endif
        else if (type(1:1).eq.'K') then
            kk = kk + 1
            if (nompar .eq. nomcol) then
                livk(kk) = vk
                goto 20
            endif
        endif
10  continue
    call utmess('F', 'TABLE0_1', sk=nompar)
20  continue
!
    call jedema()
!
end subroutine
