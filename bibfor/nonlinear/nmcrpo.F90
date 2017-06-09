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

subroutine nmcrpo(nomsd, nume, inst, lselec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmcrit.h"
    character(len=19) :: nomsd
    real(kind=8) :: inst
    integer :: nume
    aster_logical :: lselec
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (UTILITAIRE - SELEC. INST.)
!
! L'INSTANT CHOISI DE VALEUR <INST> ET D'ORDRE <NUME> EST-IL
! SELECTIONNE DANS LA LISTE D'INSTANTS OU PAR UN PAS
! DE FREQUENCE DONNE ?
!
! ----------------------------------------------------------------------
!
!
! IN  NOMSD  : NOM DE LA SD
! IN  INST   : INSTANT COURANT
! IN  NUME   : ORDRE DE L'INSTANT COURANT
! OUT LSELEC : .TRUE. SI INSANT SELECTIONNE
!
!
!
!
    real(kind=8) :: tole, tolr
    integer :: nbinst, freq
    character(len=24) :: sdinfl
    integer :: jinfl
    character(len=4) :: typsel
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    lselec = .false.
    typsel = 'NONE'
!
! --- ACCES A LA SD
!
    sdinfl = nomsd(1:19)//'.INFL'
    call jeveuo(sdinfl, 'L', jinfl)
!
! --- INFORMATIONS
!
    freq = nint(zr(jinfl-1+1))
    tole = zr(jinfl-1+2)
    nbinst = nint(zr(jinfl-1+3))
    if (tole .gt. 0.d0) then
        tolr = abs(inst)*tole
    else
        tolr = abs(tole)
    endif
!
! --- TYPE DE SELECTION (INSTANT OU FREQUENCE)
!
    if (freq .eq. 0) then
        typsel = 'INST'
    else
        typsel = 'FREQ'
    endif
!
! --- RECHERCHE
!
    call nmcrit(nomsd, nbinst, typsel, nume, inst,&
                freq, tolr, lselec)
!
!
    call jedema()
!
end subroutine
