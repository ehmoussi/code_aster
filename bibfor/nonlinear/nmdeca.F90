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

subroutine nmdeca(sddisc, iterat, ievdac, nomlis, instam,&
                  deltat, nbrpas, dtmin, ldcext, durdec,&
                  retdec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmdecc.h"
#include "asterfort/nmdecp.h"
    character(len=19) :: sddisc
    character(len=24) :: nomlis
    integer :: nbrpas
    integer :: ievdac, iterat, retdec
    real(kind=8) :: instam, deltat, dtmin, durdec
    aster_logical :: ldcext
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! DECOUPE DU PAS DE TEMPS - CAS AUTOMATIQUE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  ITERAT : NUMERO D'ITERATION DE NEWTON
! IN  NOMLIS : NOM DE LA LISTE DES INSTANTS A AJOUTER
! IN  IEVDAC : INDICE DE L'EVENEMENT ACTIF
! IN  INSTAM : INSTANT AU DEBUT
! IN  DELTAT : INCREMENT DE TEMPS COURANT
! OUT LDCEXT : .TRUE. SI ON DOIT CONTINUER LA DECOUPE
! OUT NBRPAS : NOMBRE DE PAS DE TEMPS
! OUT DTMIN  : INTERVALLE DE TEMPS MINIMAL SUR LA LISTE CREEE
! OUT RETDEC : CODE RETOUR DECOUPE
!     0 - ECHEC DE LA DECOUPE
!     1 - ON A DECOUPE
!     2 - PAS DE DECOUPE
! OUT DURDEC : DUREEE DE LA DECOUPE APRES (SI LDCEXT =.TRUE.)
!
!
!
!
    real(kind=8) :: ratio, deltac
    character(len=4) :: typdec
    character(len=16) :: optdec
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    dtmin = r8gaem()
    retdec = 0
    optdec = ' '
    ratio = -1.d0
    nbrpas = -1
    deltac = -1.d0
    typdec = ' '
    ldcext = .false.
    durdec = -1.d0
!
! --- PARAMETRES DE LA DECOUPE AUTOMATIQUE
!
    call nmdecp(sddisc, iterat, ievdac, typdec, nbrpas,&
                deltac, ratio, optdec, ldcext, durdec,&
                retdec)
!
! --- PAS DE DECOUPE: ON SORT
!
    if (retdec .ne. 1) goto 999
!
! --- CONSTRUCTION DE LA LISTE DES INSTANTS
!
    call nmdecc(nomlis, .true._1, optdec, deltat, instam,&
                ratio, typdec, nbrpas, deltac, dtmin,&
                retdec)
!
    if (retdec .eq. 1) then
        ASSERT(nbrpas.gt.0)
        ASSERT(ratio.gt.0.d0)
    endif
!
! --- PAS DE DECOUPE
!
    if (nbrpas .eq. 1) retdec = 2
!
999 continue
!
    call jedema()
end subroutine
