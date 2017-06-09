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

subroutine zbroot(mem, rhonew, echec)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterc/r8prem.h"
    real(kind=8) :: mem(2, *), rhonew
    aster_logical :: echec
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECH. LINE. - METHODE MIXTE)
!
! RESOLUTION F(X) = 0 : ITERATION COURANTE
!
! ----------------------------------------------------------------------
!
!
!  IN  MEM   : COUPLES (X,F) ANTERIEURS
!  OUT ECHEC : .TRUE. SI LA RECHERCHE DE RACINE A ECHOUE
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
    real(kind=8) :: x0, x1, f0, f1, p0, p1
!
! ----------------------------------------------------------------------
!
    echec = .false.
!
    if (nbcpl .ge. 2) then
        x1 = mem(1,1)
        x0 = mem(1,2)
        f1 = mem(2,1)
        f0 = mem(2,2)
        if (abs(f1) .ge. abs(f0)) then
! -- EN CAS DE NON PERTINENCE DES ITERES : DICHOTOMIE
            rhonew = 0.5d0 * (rhoneg + rhopos)
            goto 9999
        else
! -- INTERPOLATION LINEAIRE
            if (abs(x1-x0) .lt. r8prem()) then
                echec = .true.
                goto 9999
            endif
            p1 = (f1-f0)/(x1-x0)
            p0 = f0 - p1*x0
!
            if (abs(p1) .le. abs(f0)/(rhopos+x0)) then
                rhonew = 0.5d0 * (rhoneg + rhopos)
            else
                rhonew = -p0/p1
            endif
        endif
!      DO 5000 I = 1,NBCPL
!        WRITE (6,5010) I,MEM(1,I),MEM(2,I)
! 5000 CONTINUE
! 5010 FORMAT('RL DBG : ',I4,2X,G22.15,2X,G22.15)
!
    endif
!
9999 continue
!
!
end subroutine
