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

subroutine liscn2(lisold, nbchar, ichar, typapp)
!
    implicit     none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
!
    character(len=19) :: lisold
    character(len=16) :: typapp
    integer :: ichar, nbchar
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! CONVERTISSEUR ANCIENNE LISTE_CHARGES -> NOUVELLE LISTE_CHARGES
!
! TYPE D'APPLICATION
!
! ----------------------------------------------------------------------
!
!
! IN  TYPAPP : TYPE D'APPLICATION DE LA CHARGE
!              FIXE_CSTE
!              FIXE_PILO
!              SUIV
!              DIDI
!
! ----------------------------------------------------------------------
!
    character(len=24) :: infcha
    integer :: jinfch
    integer :: iinf1, iinf2, iinf3
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES ANCIENNE SD
!
    infcha = lisold(1:19)//'.INFC'
    call jeveuo(infcha, 'L', jinfch)
!
! --- INITIALISATIONS
!
    typapp = 'FIXE_CSTE'
!
    iinf1 = zi(jinfch+ichar)
    if ((iinf1.eq.5) .or. (iinf1.eq.6)) then
        typapp = 'FIXE_PILO'
    endif
!
    iinf2 = zi(jinfch+3*nbchar+2+ichar)
    if ((iinf2.eq.1)) then
        typapp = 'DIDI'
    endif
!
    iinf3 = zi(jinfch+nbchar+ichar)
    if ((iinf3.eq.5)) then
        typapp = 'FIXE_PILO'
    endif
    if ((iinf3.eq.4)) then
        typapp = 'SUIV'
    endif
!
    call jedema()
end subroutine
