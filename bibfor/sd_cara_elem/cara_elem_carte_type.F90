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

module cara_elem_carte_type
!
!
!   Définition des "user_type" utilisés que par AFFE_CARA_ELEM.
!
! --------------------------------------------------------------------------------------------------
!
!   cara_elem_carte_type      : Pour la gestion automatique des cartes
!       nom_carte   : nom de la carte.                          nomu//ACE_CARTE
!       adr_cmp     : adresse jeveux des composantes.           jeveut(nom_carte//'.NCMP')
!       adr_val     : adresse jeveux des valeurs.               jeveut(nom_carte//'.VALV')
!       nbr_cmp     : nombre de composantes.
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: jean-luc.flejou at edf.fr
!
    implicit none
!
    type cara_elem_carte
        integer             :: adr_cmp
        integer             :: adr_val
        integer             :: nbr_cmp
        character(len=19)   :: nom_carte
    end type cara_elem_carte
!
end module
