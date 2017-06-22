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

subroutine rsutrg(nomsd, iordr, irang, nbordr)
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: iordr, irang
    character(len=*) :: nomsd
! person_in_charge: jacques.pellet at edf.fr
!      CORRESPONDANCE NUMERO D'ORDRE UTILISATEUR (IORDR) AVEC LE
!      NUMERO DE RANGEMENT (IRANG).
! ----------------------------------------------------------------------
! IN  : NOMSD  : NOM DE LA STRUCTURE "RESULTAT"
! IN  : IORDR  : NUMERO D'ORDRE UTILISATEUR.
! OUT : IRANG  : NUMERO DE RANGEMENT.
!        = 0 , LE NUMERO D'ORDRE N'EXISTE PAS ENCORE DANS L'OBJET .ORDR
! OUT : NBORDR : NOMBRE DE NUMEROS DE RANGEMENT UTILISES DANS NOMSD
! ----------------------------------------------------------------------
!
    character(len=19) :: nomd2
    integer :: nbordr,  i, debut, milieu, fin, diff, maxit
    integer, pointer :: ordr(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
    irang = -1
    nomd2 = nomsd
!
!     --- RECUPERATION DU .ORDR :
    call jelira(nomd2//'.ORDR', 'LONUTI', nbordr)
    if (nbordr .eq. 0) then
        irang = 0
        goto 999
    endif
    call jeveuo(nomd2//'.ORDR', 'L', vi=ordr)
!
!     --- ON REGARDE SI .ORDR(K)==K POUR EVITER UNE RECHERCHE
    if ((iordr.ge.1) .and. (iordr.le.nbordr)) then
        if (ordr(iordr) .eq. iordr) then
            irang = iordr
            goto 999
        endif
    endif
!
!     --- ON REGARDE SI .ORDR(K+1)==K POUR EVITER UNE RECHERCHE
    if ((iordr.ge.0) .and. (iordr.le.nbordr-1)) then
        if (ordr(iordr+1) .eq. iordr) then
            irang = iordr + 1
            goto 999
        endif
    endif
!
!
!     --- S'IL N'Y A QU'UN NUMERO D'ORDRE C'EST FACILE :
    if (nbordr .eq. 1) then
        if (ordr(1) .eq. iordr) then
            irang = 1
        else
            irang = 0
        endif
        goto 999
    endif
!
!
!     --- RECHERCHE DU NUMERO DE RANGEMENT (DICHOTOMIE)
!         LA DICHOTOMIE N'EST POSSIBLE QUE PARCE QUE
!         LES NUMEROS D'ORDRE SONT CROISSANTS DANS .ORDR
    irang=0
    debut = 0
    fin = nbordr-1
    maxit = int(1+log(1.d0*nbordr+1.d0)/log(2.d0))
    do i = 1, maxit
        diff = (fin-debut)/2
        milieu = debut+diff
        if (ordr(milieu+1) .eq. iordr) then
            irang = milieu+1
            goto 999
        else if (ordr(milieu+1).gt.iordr) then
            fin = milieu-1
        else
            debut = milieu+1
        endif
        if (debut .ge. fin) then
            diff = (fin-debut)/2
            milieu = debut+diff
            if (ordr(milieu+1) .eq. iordr) irang = milieu+1
            goto 999
        endif
    end do
    ASSERT(.false.)
!
999 continue
    ASSERT(irang.ge.0)
    call jedema()
end subroutine
