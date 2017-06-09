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

subroutine zbiter(rho, f, rhoopt, fopt, mem,&
                  rhonew, echec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/zbarch.h"
#include "asterfort/zbborn.h"
#include "asterfort/zbopti.h"
#include "asterfort/zbproj.h"
#include "asterfort/zbroot.h"
    real(kind=8) :: mem(2, *)
    real(kind=8) :: rho, rhoopt, rhonew
    real(kind=8) :: f, fopt
    aster_logical :: echec
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
!
! RESOLUTION F(RHO) = 0 : ITERATION COURANTE
!
! ----------------------------------------------------------------------
!
!  IN  RHO    : SOLUTION COURANTE
!  IN  F      : VALEUR DE LA FONCTION EN RHO
!  I/O MEM    : COUPLES (RHO,F) ARCHIVES - GESTION INTERNE PAR ZEITER
!  I/O RHOOPT : VALEUR OPTIMALE DU RHO
!  I/O FOPT   : VALEUR OPTIMALE DE LA FONCTIONNELLE
!  OUT RHONEW : NOUVEL ITERE
!  OUT ECHEC  : .TRUE. SI LA RECHERCHE A ECHOUE
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: rhoneg, rhopos
    real(kind=8) :: parmul, fneg, fpos
    integer :: dimcpl, nbcpl
    aster_logical :: bpos, lopti
    common /zbpar/ rhoneg,rhopos,&
     &               parmul,fneg  ,fpos  ,&
     &               dimcpl,nbcpl ,bpos  ,lopti
!
! ----------------------------------------------------------------------
!
    echec = .false.
!
! --- ARCHIVAGE DU NOUVEAU COUPLE (RHO,F)
!
    call zbarch(rho, f, mem)
!
! --- ACTUALISATION DES BORNES FLOTTANTES
!
    call zbborn(rho, f)
!
! --- DETECTION S'IL S'AGIT DE LA SOLUTION OPTIMALE JUSQU'A PRESENT
!
    call zbopti(rho, f, rhoopt, fopt)
!
! --- RECHERCHE DE LA BORNE MAX
!
    if (bpos) then
        call zbroot(mem, rhonew, echec)
        if (echec) goto 999
    else
        rhonew = rho * parmul
    endif
!
! --- PROJECTION DE LA NOUVELLE SOLUTION SUR LES BORNES
!
    call zbproj(rhonew, echec)
!
999 continue
!
end subroutine
