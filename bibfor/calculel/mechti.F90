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

subroutine mechti(noma, inst, deltat, theta, chtime)
!     CREE UNE CARTE D'INSTANT
!     ------------------------------------------------------------------
! IN  : NOMA   : NOM DU MAILLAGE
! IN  : TIME   : INSTANT DE CALCUL
! IN  : DELTAT : PAS DE TEMPS PRECEDENT L'INSTANT COURANT
! IN  : THETA  : COEFFICIENT DE LA THETA-METHODE EN THM
! OUT : CHTIME : NOM DE LA CARTE CREEE
!     ------------------------------------------------------------------
!
    implicit none
!
!     --- ARGUMENTS ---
#include "asterc/r8nnem.h"
#include "asterfort/mecact.h"
    real(kind=8) :: inst, deltat, theta
    character(len=*) :: noma
    character(len=24) :: chtime
!
!     --- VARIABLES LOCALES ---
    character(len=6) :: nompro
    parameter (nompro='MECHTI')
!
    real(kind=8) :: tps(6), rundf
    character(len=8) :: nomcmp(6)
!
    data nomcmp/'INST    ','DELTAT  ','THETA   ','KHI     ',&
     &     'R       ','RHO     '/
! DEB-------------------------------------------------------------------
!
    chtime = '&&'//nompro//'.CH_INST_R'
    tps(1) = inst
    tps(2) = deltat
    tps(3) = theta
!
    rundf = r8nnem()
    tps(4) = rundf
    tps(5) = rundf
    tps(6) = rundf
!
    call mecact('V', chtime, 'MAILLA', noma, 'INST_R',&
                ncmp=6, lnomcmp=nomcmp, vr=tps)
!
end subroutine
