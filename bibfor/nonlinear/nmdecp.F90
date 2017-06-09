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

subroutine nmdecp(sddisc, iterat, i_event_acti, typdec, nbrpas,&
                  deltac, ratio , optdec      , ldcext, durdec,&
                  retdec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nmdcae.h"
#include "asterfort/nmdcco.h"
#include "asterfort/utdidt.h"
    character(len=19) :: sddisc
    integer :: i_event_acti, iterat, retdec
    integer :: nbrpas
    aster_logical :: ldcext
    real(kind=8) :: ratio, deltac, durdec
    character(len=4) :: typdec
    character(len=16) :: optdec
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! PARAMETRES DE DECOUPE
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! In  i_event_acti     : index of active event
! OUT RATIO  : RATIO DU PREMIER PAS DE TEMPS
! OUT TYPDEC : TYPE DE DECOUPE
!              'SUBD' - SUBDIVISION PAR UN NOMBRE DE PAS DONNE
!              'DELT' - SUBDIVISION PAR UN INCREMENT DONNE
! OUT NBRPAS : NOMBRE DE PAS DE TEMPS
! OUT DELTAC : INCREMENT DE TEMPS CIBLE
! OUT OPTDEC : OPTION DE DECOUPE
!     'UNIFORME'   - DECOUPE REGULIERE ET UNIFORME
!     'PROGRESSIF' - DECOUPE EN DEUX ZONES, UN PAS LONG+ UNE SERIE
!                    DE PAS UNIFORMES
!     'DEGRESSIF'  - DECOUPE EN DEUX ZONES, UNE SERIE DE PAS
!                    UNIFORMES + UN PAS LONG
! OUT RETDEC : CODE RETOUR DECOUPE
!     0 - ECHEC DE LA DECOUPE
!     1 - ON A DECOUPE
!     2 - PAS DE DECOUPE
! OUT LDCEXT : .TRUE. SI ON DOIT CONTINUER LA DECOUPE
! OUT DURDEC : DUREEE DE LA DECOUPE APRES (SI LDCEXT =.TRUE.)
!
!
!
!
    character(len=16) :: subaut
!
! ----------------------------------------------------------------------
!
    retdec = 0
    optdec = ' '
    ratio = 0.d0
    nbrpas = -1
    deltac = -1.d0
    typdec = ' '
    optdec = ' '
    ldcext = .false.
    durdec = -1.d0
!
! --- TYPE DE DECOUPAGE AUTO
!
    call utdidt('L', sddisc, 'ECHE', 'SUBD_METHODE_AUTO', index_ = i_event_acti, &
                valk_ = subaut)
!
! --- PARAMETRES SUIVANT DECOUPE
!
    if (subaut .eq. 'EXTRAPOLE') then
        call nmdcae(sddisc, iterat, typdec, nbrpas, ratio,&
                    optdec, retdec)
    else if (subaut.eq.'COLLISION') then
        call nmdcco(sddisc, i_event_acti, typdec, nbrpas, deltac,&
                    ratio, optdec, retdec, ldcext, durdec)
    else
        ASSERT(.false.)
    endif
!
end subroutine
