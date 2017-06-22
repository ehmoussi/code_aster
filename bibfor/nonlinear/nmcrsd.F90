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

subroutine nmcrsd(typesd, nomsd)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=*) :: typesd
    character(len=*) :: nomsd
!
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! CREATION D'UNE SD
!
! ----------------------------------------------------------------------
!
!
! IN  TYPESD :  TYPE DE LA SD
!               'POST_TRAITEMENT' - MODES VIBRATOIRES OU FLAMBAGE
!               'ENERGIE        ' - ENERGIES
! IN  NOMSD  : NOM DE LA SD
!
!
!
!
    integer :: zposti, zpostr, zpostk, zener
    parameter   (zposti=11,zpostr=8,zpostk=14,zener=6)
!
    integer :: ifm, niv
    character(len=24) :: sdinfi, sdinfr, sdinfk
    integer :: jpinfi, jpinfr, jpinfk, jener
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... CREATION SD'
    endif
!
! --- CREATION
!
    if (typesd .eq. 'POST_TRAITEMENT') then
        sdinfi = nomsd(1:19)//'.INFI'
        sdinfr = nomsd(1:19)//'.INFR'
        sdinfk = nomsd(1:19)//'.INFK'
        call wkvect(sdinfi, 'V V I  ', zposti, jpinfi)
        call wkvect(sdinfr, 'V V R  ', zpostr, jpinfr)
        call wkvect(sdinfk, 'V V K24', zpostk, jpinfk)
    else if (typesd.eq.'ENERGIE') then
! COMPOSANTES DE SDENER//'.VALE'
! WEXT : TRAVAIL DES EFFORTS EXTERIEURS
! ECIN : ENERGIE CINETIQUE
! WINT : ENERGIE DE DEFORMATION IRREVERSIBLE
! AMOR : ENERGIE DISSIPEE PAR AMORTISSEMENT
! LIAI : ENERGIE DISSIPEE PAR LES LIAISONS
! WSCH : ENERGIE DISSIPEE PAR LE SCHEMA
        call wkvect(nomsd(1:19)//'.VALE', 'V V R  ', zener, jener)
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
