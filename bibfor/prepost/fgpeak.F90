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

subroutine fgpeak(nomfon, pseuil, coemul, nbpoin, valpoi)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: nomfon
    real(kind=8) :: pseuil, valpoi(*), coemul
    integer :: nbpoin
!     EXTRACTION DES PICS D'UNE FONCTION
!     ------------------------------------------------------------------
! IN  NOMFOM : K8  : NOM DE LA FONCTION
! IN  PSEUIL : R   : SEUIL DE DETECTION DES PICS
! OUT NBPOIN : I   : NOMBRE DE PICS DETECTES
! OUT VALPOI : R   : TABLEAU DES VALEURS DES PICS
!     ------------------------------------------------------------------
!
    character(len=32) :: fvale
    integer :: ifonc, pass, sortie
    real(kind=8) :: max, min, valeur
!
!-----------------------------------------------------------------------
    integer :: i, nbpts
!-----------------------------------------------------------------------
    call jemarq()
!
    fvale = nomfon//'           .VALE       '
    call jelira(fvale, 'LONMAX', nbpts)
    call jeveuo(fvale, 'L', ifonc)
!
!     -------  LE PREMIER POINT EST UN PIC ------
!
    nbpoin = 1
    valpoi(nbpoin) = zr(ifonc+nbpts/2+1-1)*coemul
    max = valpoi (nbpoin)
    min = valpoi (nbpoin)
    pass = 0
    sortie = 2
!
!     -------  RECHERCHE DES PICS INTERMEDIAIRES  -----
!
    do 10 i = 2, nbpts/2
        valeur = zr(ifonc+nbpts/2+i-1)*coemul
        if (max .lt. valeur) then
            max = valeur
        endif
        if (min .gt. valeur) then
            min = valeur
        endif
        if (pass .eq. 0) then
            if ((valeur-min) .gt. pseuil) then
                sortie = 1
                pass = 1
            endif
            if ((max-valeur) .gt. pseuil) then
                sortie = 0
                pass = 1
            endif
        endif
        if ((sortie.eq.1) .and. (max-valeur) .gt. pseuil) then
            nbpoin = nbpoin + 1
            valpoi(nbpoin) = max
            min = valeur
            sortie = 0
        endif
        if ((sortie.eq.0) .and. (valeur-min) .gt. pseuil) then
            nbpoin = nbpoin + 1
            valpoi(nbpoin) = min
            max = valeur
            sortie = 1
        endif
10  end do
!
    if (sortie .eq. 0) then
        nbpoin = nbpoin + 1
        valpoi (nbpoin) = min
    endif
    if (sortie .eq. 1) then
        nbpoin = nbpoin + 1
        valpoi (nbpoin) = max
    endif
!
    call jedema()
end subroutine
