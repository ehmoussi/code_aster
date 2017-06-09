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

subroutine ndxcvg(sddisc, sderro, valinc)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmacto.h"
#include "asterfort/nmeceb.h"
#include "asterfort/nmevel.h"
#include "asterfort/nmltev.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19) :: sddisc, valinc(*)
    character(len=24) :: sderro
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! VERIFICATION DES CRITERES D'ARRET - CAS EXPLICITE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SDERRO : GESTION DES ERREURS
! IN  VALINC : VARIABLE CHAPEAU INCREMENTS DES VARIABLES
!
!
!
!
    integer :: ifm, niv
    integer :: ievdac, numins
    aster_logical :: lerrne, lerrst
    aster_logical :: lsvimx, ldvres, linsta, lcritl, conver, lresmx
!
! ----------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> EVALUATION DE LA CONVERGENCE'
    endif
!
! --- PAR DEFINITION LES RESIDUS ET NEWTON SONT TOUJOURS CONVERGES
!
    call nmeceb(sderro, 'RESI', 'CONV')
    call nmeceb(sderro, 'NEWT', 'CONV')
!
! --- INITIALISATIONS
!
    lsvimx = .false.
    ldvres = .false.
    linsta = .false.
    lcritl = .false.
    conver = .true.
    numins = -1
    call nmltev(sderro, 'ERRI', 'NEWT', lerrne)
    call nmltev(sderro, 'ERRI', 'CALC', lerrst)
!
! --- ERREUR FATALE
!
    if (lerrst) then
        call nmeceb(sderro, 'NEWT', 'STOP')
    endif
!
! --- ERREUR NON FATALE
!
    if (lerrne) then
        call nmeceb(sderro, 'NEWT', 'ERRE')
    endif
!
! --- VERIFICATION DU DECLENCHEMENT DES EVENT-DRIVEN
!
    call nmevel(sddisc, numins, valinc,&
                'NEWT', lsvimx, ldvres, lresmx, linsta, lcritl,&
                lerrne, conver)
!
! --- UN EVENEMENT SE DECLENCHE
!
    call nmacto(sddisc, ievdac)
    if (ievdac .gt. 0) call nmeceb(sderro, 'NEWT', 'EVEN')
!
end subroutine
