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

subroutine indent(i, ddls, ddlm, nnos, idec)
    implicit   none
    integer :: i, ddls, ddlm, nnos, idec
!
!.......................................................................
!
!         CALCUL DU SAUT DE DDL LORSQUE LE NOMBRE DE DDL EST DIFFERENT
!              SUR LES NOEUDS SOMMETS ET LES NOEUDS MILIEUX
!
!  ENTREES
!
!  DDLS    : NOMBRE DE DDL SUR NOEUDS SOMMETS
!  DDLM    : NOMBRE DE DDL SUR NOEUDS MILIEU
!  NNOS    : NOMBRE DE NOEUDS SOMMETS DE L'ELEMENT
!
!  SORTIE
!  IN      : SAUT DE DDL
!......................................................................
!
    if (i .le. nnos) then
        idec=ddls*(i-1)
    else
        idec=ddls*nnos+ddlm*(i-nnos-1)
    endif
end subroutine
