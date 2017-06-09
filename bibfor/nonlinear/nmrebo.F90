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

subroutine nmrebo(f, mem, sens, rho, rhoopt,&
                  ldcopt, ldccvg, fopt, fcvg, opt,&
                  act, rhomin, rhomax, rhoexm, rhoexp,&
                  stite, echec)
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/zbinte.h"
#include "asterfort/zbiter.h"
    real(kind=8) :: mem(2, *), sens
    real(kind=8) :: rho, rhoopt
    aster_logical :: echec, stite
    integer :: ldcopt, ldccvg
    real(kind=8) :: f, fopt, fcvg
    integer :: opt, act
    real(kind=8) :: rhomin, rhomax, rhoexm, rhoexp
!
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
!
! RECHERCHE LINEAIRE AVEC LA METHODE MIXTE: BORNES + UNIDIRECTIONNEL
!
! ----------------------------------------------------------------------
!
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
    real(kind=8) :: rhonew
!
! ----------------------------------------------------------------------
!
    stite = .false.
    echec = .false.
    call zbiter(sens*rho, sens*f, rhoopt, fopt, mem,&
                rhonew, echec)
!
! --- GESTION DES BORNES
!
    call zbinte(rhonew, rhomin, rhomax, rhoexm, rhoexp)
    call zbinte(rhoopt, rhomin, rhomax, rhoexm, rhoexp)
!
! --- PRISE EN COMPTE D'UN RESIDU OPTIMAL SI NECESSAIRE
!
    if (lopti) then
        ldcopt = ldccvg
        opt = act
        act = 3 - act
        if (abs(fopt) .lt. fcvg) then
            stite = .true.
        endif
    endif
!
    rho = rhonew * sens
!
end subroutine
