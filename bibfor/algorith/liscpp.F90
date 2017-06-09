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

subroutine liscpp(lischa, ichar, phase, npuis)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lisnnb.h"
    character(len=19) :: lischa
    integer :: ichar
    real(kind=8) :: phase
    integer :: npuis
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE LA PHASE ET LA PUISSANCE POUR UNE FONCTION
! MULTIPLICATRICE COMPLEXE
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : NOM DE LA SD LISTE_CHARGES
! IN  ICHAR  : INDICE DE LA CHARGE
! OUT PHASE  : PHASE POUR LES FONCTIONS MULTIPLICATRICES COMPLEXES
! OUT NPUIS  : PUISSANCE POUR LES FONCTIONS MULTIPLICATRICES COMPLEXES
!
!
!
!
    character(len=24) :: valfon
    integer :: jvfon
    integer :: nbchar
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    phase = 0.d0
    npuis = 0
    call lisnnb(lischa, nbchar)
!
    if (nbchar .ne. 0) then
        valfon = lischa(1:19)//'.VFON'
        call jeveuo(valfon, 'L', jvfon)
        phase = zr(jvfon-1+2*(ichar-1)+1)
        npuis = nint(zr(jvfon-1+2*(ichar-1)+2))
    endif
!
    call jedema()
end subroutine
