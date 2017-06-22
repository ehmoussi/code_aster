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

subroutine recugd(caelem, nomcmp, valres, nbgd, iassef,&
                  iassmx)
    implicit none
!
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisdg.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
    integer :: nbgd, iassef, iassmx
    real(kind=8) :: valres(nbgd*iassef)
    character(len=8) :: nomcmp(nbgd)
    character(len=19) :: caelem
!
!     PERMET D'EXTRAIRE D'UNE STRUCTURE "CARTE", LES VALEURS DES
!     COMPOSANTES POUR CHAQUE ASSOCIATION.
!-----------------------------------------------------------------------
! IN : CAELEM  : NOM DE LA CARTE.
! IN : NOMCMP  : NOM DES COMPOSANTES DE LA GRANDEUR RECHERCHEE
!                VECTEUR DE LONG. NBGD
! IN  : NBGD   : NOMBRE DE COMPOSANTES RECHERCHEES.
! IN  : IASSEF : NOMBRE D'ASSOCIATIONS DE LA STRUCTURE CARTE.
! IN  : IASSMX : NOMBRE MAX. D'ASSOCIATIONS DE LA STRUCTURE CARTE.
! OUT : VALRES : VALEURS DES COMPOSANTES.
!-----------------------------------------------------------------------
!
!
    integer :: icard, icarv, icmp, icode, nbec
    integer :: ii, irang, iranv, jj, ll, nbcmp
!
!
    character(len=24) :: carav, carad
    character(len=32) :: kexnom
!
!-----------------------------------------------------------------------
    call jemarq()
!
    carav = caelem(1:19)//'.VALE'
    carad = caelem(1:19)//'.DESC'
    call jeveuo(carav, 'L', icarv)
    call jeveuo(carad, 'L', icard)
!
    kexnom = jexnom('&CATA.GD.NOMCMP','CAGEPO')
    call jelira(kexnom, 'LONMAX', nbcmp)
    call jeveuo(kexnom, 'L', icmp)
!     NOMBRE D'ENTIERS CODES DANS LA CARTE
    call dismoi('NB_EC', 'CAGEPO', 'GRANDEUR', repi=nbec)
!     TOUTES LES COMPOSANTES DOIVENT ETRE DANS LA GRANDEUR
    do jj = 1, nbgd
        irang = indik8( zk8(icmp) , nomcmp(jj) , 1 , nbcmp )
        if (irang .eq. 0) then
            call utmess('E', 'UTILITAI4_8', sk=nomcmp(jj))
        endif
    end do
!
    do ii = 1, iassef
        icode = zi(icard-1+3+2*iassmx+nbec*(ii-1)+1)
!
        do jj = 1, nbgd
!           RANG DANS LA GRANDEUR
            irang = indik8( zk8(icmp) , nomcmp(jj) , 1 , nbcmp )
!           RANG DANS LA CARTE
            iranv = 0
            do ll = 1, irang
                if (exisdg([icode],ll)) iranv = iranv + 1
            end do
!           ON MET A ZERO SI INEXISTANT
            if (iranv .eq. 0) then
                valres(nbgd*(ii-1)+jj) = 0.0d0
            else
                valres(nbgd*(ii-1)+jj) = zr(icarv-1+nbcmp*(ii-1)+ iranv)
            endif
        end do
    end do
!
    call jedema()
end subroutine
