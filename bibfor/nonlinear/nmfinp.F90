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

subroutine nmfinp(sddisc, numins, lstop)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/didern.h"
#include "asterfort/diinst.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmjalo.h"
#include "asterfort/utdidt.h"
    character(len=19) :: sddisc
    integer :: numins
    aster_logical :: lstop
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! FIN DU TRANSITOIRE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  NUMINS : NUMERO D'INSTANT
! IN  LSTOP  : .TRUE. SI DERNIER INSTANT DE LA LISTE
!
!
!
    real(kind=8) :: prec, jalon
    real(kind=8) :: inst
    character(len=16) :: metlis
!
! ----------------------------------------------------------------------
!
    lstop = .false.
    inst = diinst(sddisc,numins)
!
! --- PRECISION SUR LES INSTANTS
! --- (LIEE A CELLE DE VAL_MIN DE PAS_MINI DANS DEFI_LIST_INST.CAPY)
!
    prec = 1.d-12
!
! --- METHODE DE GESTION DE LA LISTE D'INSTANTS
!
    call utdidt('L', sddisc, 'LIST', 'METHODE',&
                valk_ = metlis)
!
! --- CONVERGENCE DU CALCUL: DERNIER PAS !
!
    if (didern(sddisc,numins)) lstop = .true.
!
! --- CONVERGENCE DU CALCUL: CAS LISTE AUTOMATIQUE
!
    if (metlis .eq. 'AUTO') then
        call nmjalo(sddisc, inst, prec, jalon)
        if (jalon .eq. r8vide()) lstop = .true.
    endif
!
end subroutine
