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

subroutine hujcvx(mod, nmat, materf, vinf, deps,&
                  sigd, sigf, seuil, iret)
! person_in_charge: alexandre.foucault at edf.fr
    implicit none
!   ------------------------------------------------------------------
!   DEFINITION DU DOMAINE POTENTIEL DES MECANISMES ACTIFS
!   IN  MOD    :  MODELISATION
!       NMAT   :  DIMENSION TABLEAU DONNEES MATERIAU
!       MATERF :  COEFFICIENTS MATERIAU A T+DT
!       VINF   :  VARIABLES INTERNES  A T+DT
!       DEPS   :  INCREMENT DE DEFORMATION
!       SIGD   :  CONTRAINTE A T
!       SIGF   :  CONTRAINTE A T+DT  (ELAS)
!
!   OUT VINF   :  VARIABLES INTERNES MODIFIEES PAR LES NOUVEAUX
!                 MECANISMES
!       SEUIL  :  POSITIF SI PLASTICITE A PRENDRE EN COMPTE
!       IRET   :  CODE RETOUR
!   ------------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/hujpot.h"
    integer :: iret, nmat
    real(kind=8) :: materf(nmat, 2), vinf(*), deps(6), sigd(6), sigf(6)
    real(kind=8) :: seuil
    character(len=8) :: mod
!
    integer :: i
    aster_logical :: rdctps
    character(len=7) :: etatf
    real(kind=8) :: un, bid66(6, 6), zero, somme, matert(22, 2)
!
    parameter     ( zero = 0.d0 )
    parameter     ( un   = 1.d0 )
! ======================================================================
! --- INTIALISATION ETATF
    etatf = 'ELASTIC'
!
! --- CONTROLE DE LA NORME DE DEFORMATION
    somme = zero
    do i = 1, 6
        somme = somme + abs(deps(i))
    end do
    if (somme .lt. r8prem()) goto 999
!
    do i = 1, 22
        matert(i,1) = materf(i,1)
        matert(i,2) = materf(i,2)
    end do
!
! --- DEFINITION DU DOMAINE POTENTIEL DES MECANISMES ACTIFS
    call hujpot(mod, matert, vinf, deps, sigd,&
                sigf, etatf, rdctps, iret, .true._1)
!
! --- SI ETATF = 'ELASTIC' --> SEUIL < 0
!
999 continue
    if(etatf.eq.'ELASTIC')seuil = - un
!
!
end subroutine
