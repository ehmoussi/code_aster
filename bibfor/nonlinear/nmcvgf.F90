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

subroutine nmcvgf(sddisc, sderro, valinc, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/nmacto.h"
#include "asterfort/nmeceb.h"
#include "asterfort/nmevev.h"
#include "asterfort/nmleeb.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    character(len=19), intent(in) :: valinc(*)
    character(len=24), intent(in) :: sderro
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ETAT DE LA CONVERGENCE POINT FIXE
!
! ----------------------------------------------------------------------
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SDERRO : SD GESTION DES ERREURS
! IN  VALINC : VARIABLE CHAPEAU INCREMENTS DES VARIABLES
! In  ds_contact       : datastructure for contact management
!
    integer :: ievdac, nume_inst
    character(len=4) :: etnewt, etfixe
!
! ----------------------------------------------------------------------
!
    nume_inst = -1
!
! --- ETAT DE LA BOUCLE DE NEWTON
!
    call nmleeb(sderro, 'NEWT', etnewt)
!
! --- SI PAS DE CONVERGENCE DE NEWTON -> TRANSFERT ETAT DE LA BOUCLE
!
    if (etnewt .ne. 'CONV') then
        if (etnewt .eq. 'STOP') then
            call nmeceb(sderro, 'FIXE', 'STOP')
        else if (etnewt.eq.'ERRE') then
            call nmeceb(sderro, 'FIXE', 'ERRE')
        else
            ASSERT(.false.)
        endif
        goto 99
    endif
!
! --- ETAT DE LA BOUCLE DE POINT FIXE
!
    call nmleeb(sderro, 'FIXE', etfixe)
!
! --- ERREUR FATALE -> ON NE PEUT RIEN FAIRE
!
    if (etfixe .eq. 'STOP') then
        goto 99
    endif
!
! --- DETECTION DU PREMIER EVENEMENT DECLENCHE
!
    call nmevev(sddisc, nume_inst, valinc, sderro, ds_contact,&
                'FIXE')
!
! --- UN EVENEMENT SE DECLENCHE
!
    call nmacto(sddisc, ievdac)
    if (ievdac .gt. 0) then
        call nmeceb(sderro, 'FIXE', 'EVEN')
    endif
!
99  continue
!
end subroutine
