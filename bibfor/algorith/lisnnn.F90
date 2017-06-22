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

subroutine lisnnn(motfac, iexci, charge)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
!
    character(len=16) :: motfac
    integer :: iexci
    character(len=8) :: charge
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! LECTURE DU NOM DE LA CHARGE (PROVENANT DE AFFE_CHAR_*)
!
! ----------------------------------------------------------------------
!
!
! IN  MOTFAC : MOT-CLEF FACTEUR DES EXCITATIONS
! IN  IEXCI  : OCCURRENCE DE L'EXCITATION
! OUT CHARGE : NOM DE LA CHARGE (OU DU VECT_ASSE[_GENE])
!
! ----------------------------------------------------------------------
!
    integer :: nval
    integer :: eximve, eximvg
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    charge = ' '
!
! --- CHARGE SPECIFIQUE VECT_ASSE
!
    eximve = getexm(motfac,'VECT_ASSE')
    if (eximve .eq. 1) then
        call getvid(motfac, 'VECT_ASSE', iocc=iexci, scal=charge, nbret=nval)
        ASSERT(nval.ge.0)
    endif
!
! --- CHARGE SPECIFIQUE VECT_ASSE_GENE
!
    eximvg = getexm(motfac,'VECT_ASSE_GENE')
    if (eximvg .eq. 1) then
        call getvid(motfac, 'VECT_ASSE_GENE', iocc=iexci, scal=charge, nbret=nval)
        ASSERT(nval.ge.0)
    endif
!
! --- CHARGE STANDARD
!
    call getvid(motfac, 'CHARGE', iocc=iexci, scal=charge, nbret=nval)
    ASSERT(nval.ge.0)
!
    call jedema()
end subroutine
