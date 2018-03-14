! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine cucpma(deficu, resocu, neq, nbliai, numedd, matrcf)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/cumata.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: neq, nbliai
    character(len=24) :: deficu, resocu
    character(len=14) :: numedd
    character(len=19) :: matrcf
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION - PENALISATION)
!
! CALCUL DE LA MATRICE DE CONTACT PENALISEE GLOBALE [E_N*AT*A]
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  NBLIAI : NOMBRE DE LIAISONS DE CONTACT
! IN  NEQ    : NOMBRE D'EQUATIONS
! IN  NUMEDD : NOM DU NUME_DDL GLOBAL
! OUT MATRCF : MATRICE DE CONTACT RESULTANTE
!
!
!
!
    integer :: nmult
    character(len=24) :: enat
    character(len=14) :: numecf
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    enat = resocu(1:14)//'.ENAT'
!
! --- CONSTRUCTION NOUVELLE MATRICE
!
    numecf = '&&CFCPMA.NUFR'
    nmult = 1
    call cumata(deficu, resocu, neq, nbliai, nmult, numedd,&
                enat, numecf, matrcf)
!
    call jedema()
!
end subroutine
