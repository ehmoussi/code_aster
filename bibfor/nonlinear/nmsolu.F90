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

subroutine nmsolu(sddyna, solalg)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmincr.h"
    character(len=19) :: sddyna
    character(len=19) :: solalg(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! CONVERSION RESULTAT dU VENANT DE K.dU = F SUIVANT SCHEMAS
!
! ----------------------------------------------------------------------
!
!
! IN  SDDYNA : SD DYNAMIQUE
! OUT SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
!
!
!
!
    aster_logical :: lstat, ldyna
    real(kind=8) :: coedep, coevit, coeacc
    character(len=19) :: deppr1, deppr2
    character(len=19) :: vitpr1, vitpr2
    character(len=19) :: accpr1, accpr2
    character(len=19) :: depso1, depso2
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
        write (ifm,*) '<MECANONLINE> CONVERSION DES INCREMENTS '//&
        'SUIVANT SCHEMA'
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    lstat = ndynlo(sddyna,'STATIQUE')
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
!
! --- COEFFICIENTS POUR CHANGER INCREMENT
!
    if (lstat) then
        coedep = 1.d0
        coevit = 0.d0
        coeacc = 0.d0
    else if (ldyna) then
        coedep = ndynre(sddyna,'COEF_DEPL')
        coevit = ndynre(sddyna,'COEF_VITE')
        coeacc = ndynre(sddyna,'COEF_ACCE')
    else
        ASSERT(.false.)
    endif
!
! --- NOM DES INCREMENTS SOLUTIONS
!
    call nmchex(solalg, 'SOLALG', 'DEPPR1', deppr1)
    call nmchex(solalg, 'SOLALG', 'DEPPR2', deppr2)
    call nmchex(solalg, 'SOLALG', 'VITPR1', vitpr1)
    call nmchex(solalg, 'SOLALG', 'VITPR2', vitpr2)
    call nmchex(solalg, 'SOLALG', 'ACCPR1', accpr1)
    call nmchex(solalg, 'SOLALG', 'ACCPR2', accpr2)
    call nmchex(solalg, 'SOLALG', 'DEPSO1', depso1)
    call nmchex(solalg, 'SOLALG', 'DEPSO2', depso2)
!
! --- CONVERSION DES INCREMENTS
!
    call nmincr(sddyna, depso1, coedep, coevit, coeacc,&
                deppr1, vitpr1, accpr1)
    call nmincr(sddyna, depso2, coedep, coevit, coeacc,&
                deppr2, vitpr2, accpr2)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> INCR. DEPL. SOLU. (1) : '
        call nmdebg('VECT', deppr1, ifm)
        write (ifm,*) '<MECANONLINE> INCR. DEPL. SOLU. (2) : '
        call nmdebg('VECT', deppr2, ifm)
        if (ldyna) then
            write (ifm,*) '<MECANONLINE> INCR. VITE. SOLU. (1) : '
            call nmdebg('VECT', vitpr1, ifm)
            write (ifm,*) '<MECANONLINE> INCR. VITE. SOLU. (2) : '
            call nmdebg('VECT', vitpr2, ifm)
            write (ifm,*) '<MECANONLINE> INCR. ACCE. SOLU. (1) : '
            call nmdebg('VECT', accpr1, ifm)
            write (ifm,*) '<MECANONLINE> INCR. ACCE. SOLU. (2) : '
            call nmdebg('VECT', accpr2, ifm)
        endif
    endif
!
    call jedema()
end subroutine
