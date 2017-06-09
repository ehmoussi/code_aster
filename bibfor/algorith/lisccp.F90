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

subroutine lisccp(phenom, lischa)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisico.h"
#include "asterfort/lislch.h"
#include "asterfort/lislco.h"
#include "asterfort/lisnnb.h"
#include "asterfort/utmess.h"
    character(len=16) :: phenom
    character(len=19) :: lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! VERIFICATION COMPATIBILITE CHARGE/PHENOMENE
!
! ----------------------------------------------------------------------
!
!
! IN  PHENOM : TYPE DE PHENOMENE (MECANIQUE, THERMIQUE, ACOUSTIQUE)
! IN  LISCHA : SD LISTE DES CHARGES
!
! ----------------------------------------------------------------------
!
    integer :: ichar, nbchar
    integer :: genrec
    character(len=8) :: phecha, charge
    aster_logical :: lok
    aster_logical :: lveac, lveag, lveas
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - NOMBRE DE CHARGES
!
    call lisnnb(lischa, nbchar)
    if (nbchar .eq. 0) goto 999
!
! - BOUCLE SUR LES CHARGES
!
    do ichar = 1, nbchar
        lok = .false.
!
! ----- CODE DU GENRE DE LA CHARGE
!
        call lislco(lischa, ichar, genrec)
        lveac = lisico('VECT_ASSE_CHAR',genrec)
        lveag = lisico('VECT_ASSE_GENE',genrec)
        lveas = lisico('VECT_ASSE' ,genrec)
!
! ----- PHENOMENE DE LA CHARGE
!
        if (lveac .or. lveas .or. lveag) then
            phecha = ' '
        else
            call lislch(lischa, ichar, charge)
            call dismoi('TYPE_CHARGE', charge, 'CHARGE', repk=phecha)
        endif
!
        if (phenom .eq. 'MECANIQUE') then
            if ((phecha(1:4).eq.'MECA') .or. (phecha(1:4).eq.'CIME') .or.&
                (lveac.or.lveas.or.lveag)) then
                lok = .true.
            endif
        else if (phenom.eq.'THERMIQUE') then
            if ((phecha(1:4).eq.'THER') .or. (phecha(1:4).eq.'CITH')) then
                lok = .true.
            endif
        else if (phenom.eq.'ACOUSTIQUE') then
            if ((phecha(1:4).eq.'ACOU') .or. (phecha(1:4).eq.'CIAC')) then
                lok = .true.
            endif
        else
            ASSERT(.false.)
        endif
!
        if (.not.lok) then
            call utmess('F', 'CHARGES5_4', sk=charge)
        endif
    end do
!
999 continue
!
    call jedema()
end subroutine
