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

function in_liste_entier(val,liste,indx)
!
!
! --------------------------------------------------------------------------------------------------
!
!     si 'val' est dans 'liste' ==> retourne true
!
!     si indx présent ==> index de la valeur dans la liste
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: jean-luc.flejou at edf.fr
!
    implicit none
    integer :: val, liste(:)
    integer,intent(out),optional :: indx
    logical :: in_liste_entier
! --------------------------------------------------------------------------------------------------
    integer :: ii,indx0
! --------------------------------------------------------------------------------------------------
    in_liste_entier = .false.
    indx0 = 0
!
    if ( present(indx) ) then
        indx=indx0
    endif
    do ii = lbound(liste,1), ubound(liste,1)
        indx0 = indx0 + 1
        if ( val.eq.liste(ii) ) then
            in_liste_entier = .true.
            if ( present(indx) ) then
                indx=indx0
            endif
            exit
        endif
    enddo
end
