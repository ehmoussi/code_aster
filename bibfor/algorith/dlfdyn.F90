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

subroutine dlfdyn(rigid, amort, lamort, neq, d0,&
                  v0, f, f0)
    implicit none
#include "asterf_types.h"
#include "asterfort/mrmult.h"
#include "blas/daxpy.h"
    real(kind=8) :: d0(*), v0(*), f(*), f0(*)
    integer :: rigid, amort, neq
    aster_logical :: lamort
!
!   BUT :      CALCUL DU VECTEUR FORCE DYNAMIQUE
!
!              F  = F   -  K D0 - C V0
!  ======
!
!   INPUT:
!   ---> RIGID   : POINTEUR DE LA MATRICE RIGIDITE
!   ---> AMORT   : POINTEUR DE LA MATRICE AMORTISSEMENT
!   ---> LAMORT  : VARIABLE LOGIQUE
!                     .TRUE. SI IL Y A UNE MATRICE AMORTISSEMENT
!                     .FALSE. SINON
!   ---> NEQ   : NOMBRE D'EQUATIONS (D.D.L. ACTIFS)
!   ---> D0    : VECTEUR DEPLACEMENT INITIAL (NEQ)
!   ---> V0    : VECTEUR VITESSE INITIAL  (NEQ)
!   ---> F0    : VECTEUR REEL DE TRAVAIL  (NEQ)
!
!   VAR   :
!   <--> F     : VECTEUR FORCE EXTERIEURE ENTREE (NEQ)
!                VECTEUR FORCE DYNAMIQUE SORTIE (NEQ)
!
!----------------------------------------------------------------------
    real(kind=8) :: mun
!
    mun = -1.d0
    call mrmult('ZERO', rigid, d0, f0, 1,&
                .true._1)
    call daxpy(neq, mun, f0, 1, f,&
               1)
    if (lamort) then
        call mrmult('ZERO', amort, v0, f0, 1,&
                    .true._1)
        call daxpy(neq, mun, f0, 1, f,&
                   1)
    endif
end subroutine
