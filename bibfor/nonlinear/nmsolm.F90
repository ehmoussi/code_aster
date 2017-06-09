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

subroutine nmsolm(sddyna, solalg)
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
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
    character(len=19) :: sddyna
    character(len=19) :: solalg(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! CONVERSION RESULTAT dU VENANT DE K.dU = F APRES CONTACT
! SUIVANT SCHEMAS
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
    aster_logical :: ldepl, lvite, lacce
    real(kind=8) :: coevit, coeacc
    character(len=19) :: ddepla, dvitla, daccla
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
        write (ifm,*) '<MECANONLINE> CONVERSION DES INCREMENTS APRES '//&
     &                'CORRECTION DU CONTACT '
    endif
!
! --- FONCTIONNALITES ACTIVEES
!
    lstat = ndynlo(sddyna,'STATIQUE')
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
!
! --- TYPE DE FORMULATION SCHEMA DYNAMIQUE GENERAL
!
    if (ldyna) then
        ldepl = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.1
        lvite = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.2
        lacce = ndynin(sddyna,'FORMUL_DYNAMIQUE').eq.3
    endif
!
! --- DECOMPACTION VARIABLES CHAPEAUX
!
    call nmchex(solalg, 'SOLALG', 'DDEPLA', ddepla)
    call nmchex(solalg, 'SOLALG', 'DVITLA', dvitla)
    call nmchex(solalg, 'SOLALG', 'DACCLA', daccla)
!
! --- COEFFICIENTS POUR CHANGER INCREMENT
!
    if (lstat) then
        goto 999
    else if (ldyna) then
        coevit = ndynre(sddyna,'COEF_VITE')
        coeacc = ndynre(sddyna,'COEF_ACCE')
    else
        ASSERT(.false.)
    endif
!
! --- RE-CALCUL DES INCREMENTS
!
    if (ldepl) then
        call vtzero(dvitla)
        call vtzero(daccla)
        call vtaxpy(coevit, ddepla, dvitla)
        call vtaxpy(coeacc, ddepla, daccla)
    else if (lvite) then
        ASSERT(.false.)
!
!
    else if (lacce) then
        ASSERT(.false.)
!
!
    else
        ASSERT(.false.)
    endif
!
! --- AFFICHAGE
!
999 continue
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... DEPL. SOLU.     : '
        call nmdebg('VECT', ddepla, ifm)
        if (ldyna) then
            write (ifm,*) '<MECANONLINE> ... VITE. SOLU.     : '
            call nmdebg('VECT', dvitla, ifm)
            write (ifm,*) '<MECANONLINE> ... ACCE. SOLU.     : '
            call nmdebg('VECT', daccla, ifm)
        endif
    endif
!
    call jedema()
end subroutine
