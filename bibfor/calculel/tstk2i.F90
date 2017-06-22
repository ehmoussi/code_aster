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

function tstk2i(nlong, chaine)
! aslint: disable=
    implicit none
    integer :: tstk2i, nlong
    character(len=*) :: chaine
!
! ----------------------------------------------------------------------
! BUT : TRANSFORMER UNE CHAINE DE CARACTERES EN 1 ENTIER DE FACON
!       INDEPENDANTE DE LA PLATEFORME (UTILISATION DE ICHAR).
!       CET ENTIER PEUT ALORS ETRE ADDITIONNE POUR FAIRE LE RESUME
!       D'UN VECTEUR DE CHAINES
!
! IN: NLONG   I  : LONGUEUR DE LA CHAINE
! IN: CHAINE  K* : CHAINE A CONVERTIR EN ENTIER
! ----------------------------------------------------------------------
    integer :: ival, k
    ival=0
    do 1, k=1,nlong
    ival = ival+ichar(chaine(k:k))
    1 end do
    tstk2i=ival
end function
