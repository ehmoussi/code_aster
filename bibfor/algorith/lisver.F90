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

subroutine lisver(lischa)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisico.h"
#include "asterfort/lislch.h"
#include "asterfort/lislco.h"
#include "asterfort/lislta.h"
#include "asterfort/lisnnb.h"
#include "asterfort/utmess.h"
    character(len=19) :: lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! VERIFICATIONS DIVERSES SUR LES TYPES DE CHARGES
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
!
!
!
!
    integer :: ichar, nbchar
    character(len=8) :: charge
    integer :: genrec
    character(len=16) :: typapp
    aster_logical :: lelim, ldual, levoc
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- NOMBRE DE CHARGES
!
    call lisnnb(lischa, nbchar)
    if (nbchar .eq. 0) goto 999
!
! --- BOUCLE SUR LES CHARGES
!
    do 10 ichar = 1, nbchar
!
! ----- NOM DE LA CHARGE
!
        call lislch(lischa, ichar, charge)
!
! ----- CODE DU GENRE DE LA CHARGE
!
        call lislco(lischa, ichar, genrec)
!
! ----- IDENTIFICATION DES GENRES ACTIFS DANS LA CHARGE
!
        lelim = lisico('DIRI_ELIM',genrec)
        ldual = lisico('DIRI_DUAL',genrec)
        levoc = lisico('EVOL_CHAR',genrec)
!
! ----- TYPE D'APPLICATION DE LA CHARGE
!
        call lislta(lischa, ichar, typapp)
!
! ----- RESTRICTIONS SUR AFFE_CHAR_CINE
!
        if (lelim) then
            if (typapp .eq. 'SUIV') then
                call utmess('F', 'CHARGES5_7', sk=charge)
            endif
            if (typapp .eq. 'DIDI') then
                call utmess('F', 'CHARGES5_8', sk=charge)
            endif
            if (typapp .eq. 'FIXE_PILO') then
                call utmess('F', 'CHARGES5_9', sk=charge)
            endif
        endif
!
! ----- RESTRICTIONS SUR AFFE_CHAR_MECA/DIRICHLET
!
        if (ldual) then
            if (typapp .eq. 'SUIV') then
                call utmess('F', 'CHARGES5_10', sk=charge)
            endif
        endif
!
! ----- RESTRICTIONS SUR EVOL_CHAR
!
        if (levoc) then
            if (typapp .eq. 'FIXE_PILO') then
                call utmess('F', 'CHARGES5_11', sk=charge)
            endif
        endif
!
 10 continue
!
999 continue
!
    call jedema()
end subroutine
