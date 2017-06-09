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

subroutine rvinfo(ifm, iocc, i1, i2, c,&
                  sdchef)
    implicit   none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    integer :: ifm, iocc, i1, i2
    character(len=1) :: c
    character(len=16) :: sdchef
!     AFFICHAGE INFO SUR LE POST COURRANT
!     ------------------------------------------------------------------
! IN  SDCHEF : K : SD DES CHAMPS EFFECTIF
! IN  C      : K : INDICATEUR D' ERREUR
! IN  IOCC   : I : INDICE OCCURENCE
! IN  I1,I2  : I : REPERAGE CHAMPS
!     ------------------------------------------------------------------
!
!
    integer :: adrval, vali, adracc
    real(kind=8) :: valr
    character(len=8) :: acces
    character(len=24) :: nomval, nomacc
!
!=======================================================================
!
    call jemarq()
    nomval = sdchef//'.VALACCE'
    nomacc = sdchef//'.TYPACCE'
    if (c .eq. 'R') then
        call jeveuo(jexnum(nomacc, iocc), 'L', adracc)
        call jeveuo(jexnum(nomval, iocc), 'L', adrval)
        acces = zk8(adracc + i1-1)
    else
        call jeveuo(nomval, 'L', adrval)
        call jeveuo(nomacc, 'L', adracc)
        acces = zk8(adracc)
    endif
!
    write(ifm,*)
    write(ifm,*)'--- POST_TRAITEMENT NUMERO : ',iocc,&
     &            ' - CHAMP NUMERO           : ',i2
    if ((acces(1:1).eq.'O') .or. (acces(1:1).eq.'M')) then
        vali = zi(adrval + i1-1)
        if (acces(1:1) .eq. 'O') then
            write(ifm,*)' NUME_ORDRE           : ',vali
        else
            write(ifm,*)' NUME_MODE            : ',vali
        endif
    else if ((acces(1:1).eq.'F') .or. (acces(1:1).eq.'I')) then
        valr = zr(adrval + i1-1)
        if (acces(1:1) .eq. 'I') then
            write(ifm,*)' INSTANT                : ',valr
        else
            write(ifm,*)' FREQUENCE              : ',valr
        endif
    else
    endif
!
    if (c .eq. 'E') write(ifm,*)' CHAMP INEXISTANT '
!
    call jedema()
end subroutine
