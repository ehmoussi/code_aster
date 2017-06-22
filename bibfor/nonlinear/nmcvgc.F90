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

subroutine nmcvgc(sddisc, sderro, numins, fonact)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmeceb.h"
#include "asterfort/nmerge.h"
#include "asterfort/nmevcv.h"
#include "asterfort/nmfinp.h"
#include "asterfort/nmleeb.h"
    integer :: fonact(*)
    character(len=19) :: sddisc
    integer :: numins
    character(len=24) :: sderro
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ETAT DE LA CONVERGENCE DU CALCUL
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SDERRO : SD GESTION DES ERREURS
! IN  NUMINS : NUMERO D'INSTANT
! IN  FONACT : FONCTIONNALITES ACTIVEES
!
!
!
!
    character(len=4) :: etinst, etcalc
    aster_logical :: lstop, mtcpup
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ETAT DE LA BOUCLE DES INSTANTS
!
    call nmleeb(sderro, 'INST', etinst)
    call nmerge(sderro, 'ERRE_TIMP', mtcpup)
!
! --- SI PAS DE CONVERGENCE INSTANT -> TRANSFERT ETAT DE LA BOUCLE
!
    if (etinst .ne. 'CONV') then
        if (etinst .eq. 'STOP') then
            call nmeceb(sderro, 'CALC', 'STOP')
        else if (etinst.eq.'ERRE') then
            call nmeceb(sderro, 'CALC', 'ERRE')
        else
            ASSERT(.false.)
        endif
    else
        call nmevcv(sderro, fonact, 'CALC')
    endif
!
    call nmleeb(sderro, 'CALC', etcalc)
!
! --- ERREUR -> ON NE PEUT RIEN FAIRE
!
    if (etcalc .eq. 'ERRE') goto 99
!
! --- ERREUR FATALE -> SI TEMPS CPU SUR LE PAS, ON ATTEND DE VOIR SI
! --- ON EST AU DERNIER PAS
!
    if (etcalc .eq. 'STOP') then
        if (.not.mtcpup) goto 99
    endif
!
! --- CONVERGENCE DU CALCUL: DERNIER PAS !
!
    call nmfinp(sddisc, numins, lstop)
    if (lstop) then
        call nmeceb(sderro, 'CALC', 'CONV')
    endif
!
 99 continue
!
    call jedema()
end subroutine
