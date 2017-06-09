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

subroutine listap(motfac, iexci, typapp)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
    character(len=16) :: motfac
    integer :: iexci
    character(len=16) :: typapp
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! TYPE D'APPLICATION DE LA CHARGE
!
! ----------------------------------------------------------------------
!
!
! IN  MOTFAC : MOT-CLEF FACTEUR
! IN  IEXCI  : OCCURRENCE DU MOT-CLEF FACTEUR
! IN  TYPAPP : TYPE D'APPLICATION DE LA CHARGE
!              FIXE_CSTE
!              FIXE_PILO
!              SUIV
!              DIDI
!
! ----------------------------------------------------------------------
!
    integer :: eximc
    integer :: n
!
! ----------------------------------------------------------------------
!
    eximc = getexm(motfac,'TYPE_CHARGE')
!
    if (eximc .eq. 1) then
        call getvtx(motfac, 'TYPE_CHARGE', iocc=iexci, scal=typapp, nbret=n)
        ASSERT(n.eq.1)
    else
        typapp = 'FIXE_CSTE'
    endif
!
end subroutine
