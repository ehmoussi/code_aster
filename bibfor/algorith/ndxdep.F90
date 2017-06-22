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

subroutine ndxdep(numedd, fonact, numins, sddisc, sddyna,&
                  sdnume, valinc, solalg, veasse)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/copisd.h"
#include "asterfort/diinst.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmfext.h"
#include "asterfort/nmmajc.h"
#include "asterfort/nmsolu.h"
    integer :: fonact(*)
    integer :: numins
    character(len=19) :: sddisc, sdnume, sddyna
    character(len=24) :: numedd
    character(len=19) :: veasse(*)
    character(len=19) :: solalg(*), valinc(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! CALCUL DE L'INCREMENT DE DEPLACEMENT A PARTIR DE(S) DIRECTION(S)
! DE DESCENTE
!
! CAS EXPLICITE
!
! ----------------------------------------------------------------------
!
!
! IN  NUMEDD : NUME_DDL
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  NUMINS : NUMERO D'INSTANT
! IN  SDNUME : SD NUMEROTATION
! IN  SDDISC : SD DISCRETISATION
! IN  SDDYNA : SD DYNAMIQUE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
!
!
!
!
    real(kind=8) :: instam, instap, deltat
    character(len=19) :: cnfext
    character(len=19) :: ddepla, deppr1
    character(len=19) :: dvitla, vitpr1
    character(len=19) :: daccla, accpr1
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> CORRECTION INCR. DEPL.'
    endif
!
! --- DECOMPACTION VARIABLES CHAPEAUX
!
    call nmchex(solalg, 'SOLALG', 'DDEPLA', ddepla)
    call nmchex(solalg, 'SOLALG', 'DEPPR1', deppr1)
    call nmchex(solalg, 'SOLALG', 'DVITLA', dvitla)
    call nmchex(solalg, 'SOLALG', 'VITPR1', vitpr1)
    call nmchex(solalg, 'SOLALG', 'DACCLA', daccla)
    call nmchex(solalg, 'SOLALG', 'ACCPR1', accpr1)
!
! --- INITIALISATIONS
!
    instam = diinst(sddisc,numins-1)
    instap = diinst(sddisc,numins)
    deltat = instap - instam
!
! --- CALCUL DE LA RESULTANTE DES EFFORTS EXTERIEURS
!
    call nmchex(veasse, 'VEASSE', 'CNFEXT', cnfext)
    call nmfext(0.d0, fonact, sddyna, veasse, cnfext)
!
! --- CONVERSION RESULTAT dU VENANT DE K.dU = F SUIVANT SCHEMAS
!
    call nmsolu(sddyna, solalg)
!
! --- AJUSTEMENT DE LA DIRECTION DE DESCENTE (AVEC ETA, RHO ET OFFSET)
!
    call copisd('CHAMP_GD', 'V', deppr1, ddepla)
    call copisd('CHAMP_GD', 'V', vitpr1, dvitla)
    call copisd('CHAMP_GD', 'V', accpr1, daccla)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... DEPL. PRED. (1) : '
        call nmdebg('VECT', deppr1, ifm)
        write (ifm,*) '<MECANONLINE> ... DEPL. SOLU.     : '
        call nmdebg('VECT', ddepla, ifm)
        write (ifm,*) '<MECANONLINE> ... VITE. PRED. (1) : '
        call nmdebg('VECT', vitpr1, ifm)
        write (ifm,*) '<MECANONLINE> ... VITE. SOLU.     : '
        call nmdebg('VECT', dvitla, ifm)
        write (ifm,*) '<MECANONLINE> ... ACCE. PRED. (1) : '
        call nmdebg('VECT', accpr1, ifm)
        write (ifm,*) '<MECANONLINE> ... ACCE. SOLU.     : '
        call nmdebg('VECT', daccla, ifm)
    endif
!
! --- ACTUALISATION DES CHAMPS SOLUTIONS
!
    call nmmajc(fonact, sddyna, sdnume, deltat, numedd,&
                valinc, solalg)
!
    call jedema()
end subroutine
