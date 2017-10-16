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

subroutine nmcrer(carcri, sdcriq)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/getvtx.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/Behaviour_type.h"
    character(len=24) :: sdcriq, carcri
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (SD CRITERE QUALITE)
!
! CREATION DE LA SD
!
! ----------------------------------------------------------------------
!
!
! IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
! OUT SDCRIQ : SD CRITERE QUALITE
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    integer ::  ibid
    character(len=24) :: errthm
    integer :: jerrt
    character(len=16) :: motfac, chaine
    real(kind=8) :: theta
    real(kind=8), pointer :: valv(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... LECTURE CALCUL ERREUR'
    endif
!
! --- INITIALISATIONS
!
    motfac = 'CRIT_QUALITE'
!
! --- VALEUR DE THETA
!
    call jeveuo(carcri(1:19)//'.VALV', 'L', vr=valv)
    theta = valv(PARM_THETA_THM)
!
! --- ERREUR EN TEMPS (THM)
!
    chaine='NON'
    call getvtx(motfac, 'ERRE_TEMPS_THM', iocc=1, scal=chaine, nbret=ibid)
    if (chaine .eq. 'OUI') then
        errthm = sdcriq(1:19)//'.ERRT'
        call wkvect(errthm, 'V V R', 3, jerrt)
        zr(jerrt-1+3) = theta
    endif
!
    call jedema()
end subroutine
