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

module cara_elem_info_type
!
!
!   Définition des "user_type" utilisés que par AFFE_CARA_ELEM.
!
! --------------------------------------------------------------------------------------------------
!
!   cara_elem_info  : Variable globale définit pour tout AFFE_CARA_ELEM
!       nomu        : nom du concept en sortie de la commande.  getres(nomu , x , x )
!       concept     : nom du concept résultat.                  getres( x , concept , x )
!       commande    : nom de la commande.                       getres( x , x , commande )
!       modele      : nom du modèle.
!       maillage    : nom du maillage.
!       nbnoeu      : nombre de noeud du maillage.
!       nbmail      : nombre de maille du maillage.
!       dimmod      : dimension topologique du modèle.          dismoi('DIM_GEOM' sur 'MODELE')
!       ivr         : Pour faire des vérifications de cohérences et des impressions
!           ivr(1)=1    : vérification MAILLES
!           ivr(2)      : libre
!           ivr(3)=niv  : niveau d'impression
!           ivr(4)=ifm  : unité d'impression
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: jean-luc.flejou at edf.fr
!
    implicit none
!
    type cara_elem_info
        character(len= 8)   :: nomu
        character(len=16)   :: concept
        character(len=16)   :: commande
        character(len= 8)   :: modele
        character(len= 8)   :: maillage
        integer             :: nbmail
        integer             :: nbnoeu
        integer             :: dimmod
        integer             :: ivr(4)
    end type cara_elem_info
!
end module
