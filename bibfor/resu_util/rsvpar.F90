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

subroutine rsvpar(nomsd, iordr, nompar, ipar, rpar,&
                  kpar, ier)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsnopa.h"
    integer :: iordr, ipar, ier
    real(kind=8) :: rpar
    character(len=*) :: nomsd, nompar, kpar
!      VERIFICATION DE L'EXISTANCE D'UN NOM DE PARAMETRE ET DE
!      SA VALEUR DANS UN RESULTAT COMPOSE
! ----------------------------------------------------------------------
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT".
! IN  : IORDR  : NUMERO D'ORDRE A TRAITER.
! IN  : NOMPAR : NOM DU PARAMETRE A VERIFIER.
! IN  : IPAR   : VALEUR DU PARAMETRE ( TYPE INTEGER )
! IN  : RPAR   : VALEUR DU PARAMETRE ( TYPE REAL )
! IN  : KPAR   : VALEUR DU PARAMETRE ( TYPE CHARACTER )
! OUT : IER    : = 0    CE N'EST PAS UN PARAMETRE DU "RESULTAT".
!              : = 110  LA VALEUR DU PARAMETRE N'EST PAS CORRECTE.
!              : = 100  LA VALEUR DU PARAMETRE EST CORRECTE.
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: ipa, nbpar, nbacc
    character(len=3) :: ctype
!
!-----------------------------------------------------------------------
    integer :: jadr
    character(len=16), pointer :: noms_para(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    ier = 0
!
    call rsnopa(nomsd, 1, '&&RSVPAR.NOMS_PARA', nbacc, nbpar)
    call jeveuo('&&RSVPAR.NOMS_PARA', 'L', vk16=noms_para)
    do ipa = 1, nbpar
        if (nompar .eq. noms_para(ipa)) then
            goto 12
        endif
    end do
    goto 999
!
12  continue
    ier = 110
    call rsadpa(nomsd, 'L', 1, nompar, iordr,&
                1, sjv=jadr, styp=ctype, istop=0)
    if (ctype(1:1) .eq. 'I') then
        if (zi(jadr) .eq. ipar) ier = 100
    else if (ctype(1:1).eq.'R') then
        if (zr(jadr) .eq. rpar) ier = 100
    else if (ctype(1:3).eq.'K80') then
        if (zk80(jadr) .eq. kpar) ier = 100
    else if (ctype(1:3).eq.'K32') then
        if (zk32(jadr) .eq. kpar) ier = 100
    else if (ctype(1:3).eq.'K24') then
        if (zk24(jadr) .eq. kpar) ier = 100
    else if (ctype(1:3).eq.'K16') then
        if (zk16(jadr) .eq. kpar) ier = 100
    else if (ctype(1:2).eq.'K8') then
        if (zk8(jadr) .eq. kpar) ier = 100
    endif
!
999 continue
    call jedetr('&&RSVPAR.NOMS_PARA')
    call jedema()
end subroutine
