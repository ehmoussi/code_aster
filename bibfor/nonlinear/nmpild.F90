! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmpild(numedd, sddyna, solalg, eta, rho,&
                  offset)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmpilk.h"
#include "asterfort/utmess.h"
!
character(len=24) :: numedd
character(len=19) :: solalg(*), sddyna
real(kind=8) :: eta, rho, offset
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! AJUSTEMENT DE LA DIRECTION DE DESCENTE
!
! ----------------------------------------------------------------------
!
! IN  NUMEDD : NOM DU NUME_DDL
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  SDDYNA : SD DYNAMIQUE
! IN  ETA    : PARAMETRE DE PILOTAGE
! IN  RHO    : PARAMETRE DE RECHERCHE LINEAIRE
! IN  OFFSET : DECALAGE DU PARMAETRE DE PILOTAGE
!
! ----------------------------------------------------------------------
!
    integer :: neq
    character(len=19) :: ddepla, deppr1, deppr2
    character(len=19) :: dvitla, vitpr1, vitpr2
    character(len=19) :: daccla, accpr1, accpr2
    aster_logical :: ldyna
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_49')
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    ldyna = ndynlo(sddyna,'DYNAMIQUE')

    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
!
! --- DECOMPACTION VARIABLES CHAPEAUX
!
    call nmchex(solalg, 'SOLALG', 'DDEPLA', ddepla)
    call nmchex(solalg, 'SOLALG', 'DEPPR1', deppr1)
    call nmchex(solalg, 'SOLALG', 'DEPPR2', deppr2)
    call nmchex(solalg, 'SOLALG', 'DVITLA', dvitla)
    call nmchex(solalg, 'SOLALG', 'VITPR1', vitpr1)
    call nmchex(solalg, 'SOLALG', 'VITPR2', vitpr2)
    call nmchex(solalg, 'SOLALG', 'DACCLA', daccla)
    call nmchex(solalg, 'SOLALG', 'ACCPR1', accpr1)
    call nmchex(solalg, 'SOLALG', 'ACCPR2', accpr2)
!
! --- CALCUL DE LA DIRECTION DE DESCENTE
!
    call nmpilk(deppr1, deppr2, ddepla, neq, eta,&
                rho, offset)
    if (ldyna) then
        call nmpilk(vitpr1, vitpr2, dvitla, neq, eta,&
                    rho, offset)
        call nmpilk(accpr1, accpr2, daccla, neq, eta,&
                    rho, offset)
    endif
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_50', sr=rho)
        call utmess('I', 'MECANONLINE13_51', sr=eta)
        call utmess('I', 'MECANONLINE13_52', sr=offset)
        call utmess('I', 'MECANONLINE13_46')
        call nmdebg('VECT', deppr1, ifm)
        call nmdebg('VECT', deppr2, ifm)
        call utmess('I', 'MECANONLINE13_53')
        call nmdebg('VECT', ddepla, ifm)
        if (ldyna) then
            call utmess('I', 'MECANONLINE13_47')
            call nmdebg('VECT', vitpr1, ifm)
            call nmdebg('VECT', vitpr2, ifm)
            call utmess('I', 'MECANONLINE13_54')
            call nmdebg('VECT', dvitla, ifm)
            call utmess('I', 'MECANONLINE13_48')
            call nmdebg('VECT', accpr1, ifm)
            call nmdebg('VECT', accpr2, ifm)
            call utmess('I', 'MECANONLINE13_55')
            call nmdebg('VECT', daccla, ifm)
        endif
    endif
!
    call jedema()
end subroutine
