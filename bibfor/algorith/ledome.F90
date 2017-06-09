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

subroutine ledome(option, nomo, materi, mate, carele)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/rcmfmc.h"
#include "asterfort/utmess.h"
    character(len=8) :: nomo
    character(len=24) :: mate, carele
    character(len=8) :: materi
    character(len=2) :: option
!
! ----------------------------------------------------------------------
!
! LECTURE DONNEES MECANIQUES
!
! ----------------------------------------------------------------------
!
! IN  OPTION : PRECISE SI MATERIAU/CARA_ELEM OBLIGATOIRES
!              ALARME L'UTILISATUER  EN CAS D'ABSENCE
! OUT NOMO   : MODELE
! OUT MATERI : CHAMP DE MATERIAU (NON CODE)
! OUT MATE   : MATERIAU CODE
! OUT CARELE : CARACTERISTIQUES ELEMENTAIRES
!
! ----------------------------------------------------------------------
!
    integer :: n
    character(len=8) :: repons
!
! ----------------------------------------------------------------------
!
    nomo = ' '
    mate = ' '
    carele = ' '
!
! --- RECUPERER LE MODELE
!
    call getvid(' ', 'MODELE', scal=nomo, nbret=n)
!
! --- RECUPERER LE MATERIAU
!
    call getvid(' ', 'CHAM_MATER', scal=materi, nbret=n)
    if (nomo .ne. ' ') then
        call dismoi('BESOIN_MATER', nomo, 'MODELE', repk=repons)
        if ((n.eq.0) .and. (repons(1:3).eq.'OUI') .and. (option(1:1) .eq.'O')) then
            call utmess('A', 'CALCULEL3_40')
        endif
    endif
!
! --- CREATION DE LA CARTE DU MATERIAU CODE
!
    if (n .ne. 0) then
        call rcmfmc(materi, mate)
    else
        mate = ' '
    endif
!
! --- RECUPERER LES CARACTERISTIQUES ELEMENTAIRES
!
    call getvid(' ', 'CARA_ELEM', scal=carele, nbret=n)
    if (nomo .ne. ' ') then
        call dismoi('EXI_RDM', nomo, 'MODELE', repk=repons)
        if ((n.eq.0) .and. (repons(1:3).eq.'OUI') .and. (option(1:1) .eq.'O')) then
            call utmess('A', 'CALCULEL3_39')
        endif
    endif
!
end subroutine
