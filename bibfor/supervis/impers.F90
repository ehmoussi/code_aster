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

subroutine impers()
    implicit   none
!
!  EN CAS D ERREUR <S> NON TRAPPEE PAR L UTILISATEUR DANS SON FICHIER
!  DE COMMANDE : LE SUPERVISEUR LA RECUPERE DANS E_JDC
!  ON DOIT ECRIRE LA CHAINE DE CARACTERE <S> DANS LE FICHIER D ERREUR
!  POUR QUE L AGLA LA RECUPERE BIEN
!
! ----------------------------------------------------------------------
!
#include "asterfort/iunifi.h"
    integer :: iunerr
!
    iunerr = iunifi('ERREUR')
    if (iunerr .gt. 0) write(iunerr,* ) '<S> ERREUR UTILISATEUR RECUPEREE PAR LE SUPERVISEUR'
!
end subroutine
