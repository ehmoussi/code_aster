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

subroutine pmevdr(sddisc, tabinc, liccvg, itemax, conver,&
                  actite)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/nmacto.h"
#include "asterfort/nmevel.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    aster_logical :: itemax, conver
    character(len=19) :: sddisc, tabinc(*)
    integer :: liccvg(*), actite
!
! ----------------------------------------------------------------------
!
! ROUTINE SIMU_POINT_MAT
!
! VERIFICATION DES CRITERES DE DIVERGENCE DE TYPE EVENT-DRIVEN
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION
! IN  TABINC : TABLE INCREMENTS DES VARIABLES
! IN  ITEMAX : .TRUE. SI ITERATION MAXIMUM ATTEINTE
! IN  CONVER : .TRUE. SI CONVERGENCE REALISEE
! IN  LICCVG : CODES RETOURS D'ERREUR
!              (2) : INTEGRATION DE LA LOI DE COMPORTEMENT
!                  = 0 OK
!                  = 1 ECHEC DANS L'INTEGRATION : PAS DE RESULTATS
!                  = 3 SIZZ NON NUL (DEBORST) ON CONTINUE A ITERER
!                  = 1 MATRICE DE CONTACT SINGULIERE
!              (5) : MATRICE DU SYSTEME (MATASS)
!                  = 0 OK
!                  = 1 MATRICE SINGULIERE
!                  = 3 ON NE SAIT PAS SI SINGULIERE
! OUT ACTITE : BOUCLE NEWTON -> ACTION POUR LA SUITE
!     0 - NEWTON OK   - ON SORT
!     1 - NEWTON NOOK - IL FAUT FAIRE QUELQUE CHOSE
!     2 - NEWTON NCVG - ON CONTINUE NEWTON
!     3 - NEWTON STOP - TEMPS/USR1
!
!
!
!
    integer :: ifm, niv
    integer :: faccvg, ldccvg, numins
    aster_logical :: lerror, lsvimx, ldvres, linsta, lcritl, lresmx
    character(len=24) :: k24bla
    integer :: ievdac
!
! ----------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<SIMUPOINTMAT> EVALUATION DES EVENT-DRIVEN'
    endif
!
! --- INITIALISATIONS
!
    ldccvg = liccvg(2)
    faccvg = liccvg(5)
    lerror =(ldccvg.eq.1) .or. (faccvg.ne.0) .or. itemax
    ievdac = 0
    k24bla = ' '
    lsvimx = .false.
    ldvres = .false.
    linsta = .false.
    lcritl = .false.
    numins = -1
!
! --- NEWTON A CONVERGE ?
!
    if (conver) then
        actite = 0
    else
        actite = 2
    endif
!
! --- DETECTION DU PREMIER EVENEMENT DECLENCHE
!
    call nmevel(sddisc, numins, tabinc, 'NEWT', lsvimx,&
                ldvres, lresmx, linsta, lcritl, lerror, conver)
!
! --- UN EVENEMENT SE DECLENCHE
!
    call nmacto(sddisc, ievdac)
    if (ievdac .ne. 0) then
        actite = 1
    endif
!
end subroutine
