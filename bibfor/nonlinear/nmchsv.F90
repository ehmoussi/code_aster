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
subroutine nmchsv(fonact, veasse, sddyna, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/copisd.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynkk.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
!
integer :: fonact(*)
character(len=19) :: sddyna
character(len=19) :: veasse(*)
type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (DYNAMIQUE - ALGORITHME)
!
! SAUVEGARDE DES VECTEURS SECONDS MEMBRES ET EFFORTS INTERIEURS
!
! ----------------------------------------------------------------------
!
!
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  SDDYNA : SD DYNAMIQUE
! In  ds_contact       : datastructure for contact management
!
!
!
    character(len=19) :: olfedo, olfsdo, oldido, oldidi, olfint
    character(len=19) :: olondp, ollapl, olcine, olviss, olsstf
    character(len=19) :: cnfedo, cnfsdo, cndido, cndidi, cnfint
    character(len=19) :: cnondp, cnlapl, cncine, cnviss, cnsstf
    character(len=19) :: olsstr, cnsstr
    character(len=19) :: oleltc, oleltf
    aster_logical :: londe, llapl, ldidi, lviss, lsstf, l_macr
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- FONCTIONNALITES ACTIVEES
!
    londe  = ndynlo(sddyna,'ONDE_PLANE')
    lviss  = ndynlo(sddyna,'VECT_ISS')
    lsstf  = isfonc(fonact,'SOUS_STRUC')
    llapl  = isfonc(fonact,'LAPLACE')
    ldidi  = isfonc(fonact,'DIDI')
    l_macr = isfonc(fonact,'MACR_ELEM_STAT')
!
! --- NOM DES CHAMPS PAS PRECEDENT
!
    call ndynkk(sddyna, 'OLDP_CNFEDO', olfedo)
    call ndynkk(sddyna, 'OLDP_CNFSDO', olfsdo)
    call ndynkk(sddyna, 'OLDP_CNDIDO', oldido)
    call ndynkk(sddyna, 'OLDP_CNDIDI', oldidi)
    call ndynkk(sddyna, 'OLDP_CNFINT', olfint)
    call ndynkk(sddyna, 'OLDP_CNONDP', olondp)
    call ndynkk(sddyna, 'OLDP_CNLAPL', ollapl)
    call ndynkk(sddyna, 'OLDP_CNCINE', olcine)
    call ndynkk(sddyna, 'OLDP_CNVISS', olviss)
    call ndynkk(sddyna, 'OLDP_CNSSTF', olsstf)
    call ndynkk(sddyna, 'OLDP_CNSSTR', olsstr)
    call ndynkk(sddyna, 'OLDP_CNELTC', oleltc)
    call ndynkk(sddyna, 'OLDP_CNELTF', oleltf)
!
! --- NOM DES CHAMPS PAS COURANT
!
    call nmchex(veasse, 'VEASSE', 'CNFEDO', cnfedo)
    call nmchex(veasse, 'VEASSE', 'CNFSDO', cnfsdo)
    call nmchex(veasse, 'VEASSE', 'CNDIDO', cndido)
    call nmchex(veasse, 'VEASSE', 'CNDIDI', cndidi)
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
    call nmchex(veasse, 'VEASSE', 'CNONDP', cnondp)
    call nmchex(veasse, 'VEASSE', 'CNLAPL', cnlapl)
    call nmchex(veasse, 'VEASSE', 'CNCINE', cncine)
    call nmchex(veasse, 'VEASSE', 'CNVISS', cnviss)
    call nmchex(veasse, 'VEASSE', 'CNSSTF', cnsstf)
    call nmchex(veasse, 'VEASSE', 'CNSSTR', cnsstr)
!
! --- RECOPIE DES CHAMPS
!
    call copisd('CHAMP_GD', 'V', cnfint, olfint)
    call copisd('CHAMP_GD', 'V', cnfedo, olfedo)
    call copisd('CHAMP_GD', 'V', cnfsdo, olfsdo)
    call copisd('CHAMP_GD', 'V', cndido, oldido)
    call copisd('CHAMP_GD', 'V', cncine, olcine)
    if (londe) then
        call copisd('CHAMP_GD', 'V', cnondp, olondp)
    endif
    if (ldidi) then
        call copisd('CHAMP_GD', 'V', cndidi, oldidi)
    endif
    if (llapl) then
        call copisd('CHAMP_GD', 'V', cnlapl, ollapl)
    endif
    if (lviss) then
        call copisd('CHAMP_GD', 'V', cnviss, olviss)
    endif
    if (lsstf) then
        call copisd('CHAMP_GD', 'V', cnsstf, olsstf)
    endif
    if (l_macr) then
        call copisd('CHAMP_GD', 'V', cnsstr, olsstr)
    endif
    if (ds_contact%l_cneltc) then
        call copisd('CHAMP_GD', 'V', ds_contact%cneltc, oleltc)
    endif
    if (ds_contact%l_cneltf) then
        call copisd('CHAMP_GD', 'V', ds_contact%cneltf, oleltf)
    endif
!
    call jedema()
end subroutine
