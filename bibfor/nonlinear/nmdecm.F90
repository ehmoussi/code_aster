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

subroutine nmdecm(sddisc, i_event_acti, nomlis, instam, deltat,&
                  nbrpas, dtmin       , retdec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "asterc/r8gaem.h"
#include "asterfort/assert.h"
#include "asterfort/nmdecc.h"
#include "asterfort/utdidt.h"
    integer :: i_event_acti
    character(len=19) :: sddisc
    character(len=24) :: nomlis
    integer :: nbrpas
    real(kind=8) :: instam, deltat, dtmin
    integer :: retdec
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (GESTION DES EVENEMENTS - DECOUPE)
!
! DECOUPE DU PAS DE TEMPS - CAS MANUEL
!
! ----------------------------------------------------------------------
!
!
! In  sddisc           : datastructure for time discretization
! In  i_event_acti     : index of active event
! IN  NOMLIS : NOM DE LA LISTE DES INSTANTS A AJOUTER
! IN  INSTAM : INSTANT AU DEBUT
! IN  DELTAT : INCREMENT DE TEMPS COURANT
! IN  TYPDEC : TYPE DE DECOUPE
!     'SUBD' - SUBDIVISION PAR UN NOMBRE DE PAS DONNE
!     'DELT' - SUBDIVISION PAR UN INCREMENT DONNE
! OUT NBRPAS : NOMBRE DE PAS DE TEMPS
! OUT DTMIN  : INTERVALLE DE TEMPS MINIMAL SUR LA LISTE CREEE
! OUT RETDEC : CODE RETOUR DECOUPE
!     0 - ECHEC DE LA DECOUPE
!     1 - ON A DECOUPE
!     2 - PAS DE DECOUPE
!
!
!
!
    real(kind=8) :: ratio, deltac
    character(len=16) :: optdec
    character(len=4) :: typdec
!
! ----------------------------------------------------------------------
!
    dtmin = r8gaem()
    retdec = 0
    ratio = 1.d0
    nbrpas = -1
    deltac = -1.d0
    optdec = 'UNIFORME'
    typdec = 'SUBD'
!
! --- DONNEES
!
    if (typdec .eq. 'SUBD') then
        call utdidt('L', sddisc, 'ECHE', 'SUBD_PAS', index_ = i_event_acti, &
                    vali_ = nbrpas)
    else
        ASSERT(.false.)
    endif
!
! --- CONSTRUCTION DE LA LISTE DES INSTANTS
!
    call nmdecc(nomlis, .true._1, optdec, deltat, instam,&
                ratio, typdec, nbrpas, deltac, dtmin,&
                retdec)
!
end subroutine
