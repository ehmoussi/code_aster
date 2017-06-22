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

subroutine dfdevn(action, submet, pasmin, nbrpas, niveau)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    real(kind=8) :: pasmin
    character(len=16) :: action
    character(len=16) :: submet
    integer :: nbrpas, niveau
!
! ----------------------------------------------------------------------
!
! ROUTINE GESTION LISTE INSTANTS
!
! VALEURS PAR DEFAUT POUR ACTION = DECOUPE MANUELLE
!
! ----------------------------------------------------------------------
!
!
! OUT ACTION : NOM DE L'ACTION
! OUT SUBMET : TYPE DE SUBDIVISION
! OUT PASMIN : VALEUR DE SUBD_PAS_MINI
! OUT NBRPAS : VALEUR DE SUBD_PAS
! OUT NIVEAU : VALEUR DE SUBD_NIVEAU
!
! ----------------------------------------------------------------------
!
    action = 'DECOUPE'
    submet = 'MANUEL'
    niveau = 3
    nbrpas = 4
    pasmin = 1.d-12
!
end subroutine
