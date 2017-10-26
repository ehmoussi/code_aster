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

function sdeiso(vect)
! person_in_charge: olivier.boiteau at edf.fr
!
    implicit none
    integer :: sdeiso
#include "asterfort/assert.h"
    character(len=5) :: vect
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE POUR LES SOLVEURS MODAUX
!
! RETOURNE LA LONGUEUR FIXE DES VECTEURS DE LA SD EIGENSOLVER
!
! ----------------------------------------------------------------------
!
!
! IN  VECT   : NOM DU VECTEUR DONT ON VEUT LA DIMENSION
!
!  .
! /!\ PENSER A MODIFIER SD_EIGENSOLVER.PY (POUR SD_VERI)
! ---
!
! ----------------------------------------------------------------------
!
    integer :: zslvk, zslvr, zslvi
    parameter (zslvk=20,zslvr=15 ,zslvi=15)
!
! ----------------------------------------------------------------------
!
!
    if (vect .eq. 'ZSLVK') then
        sdeiso = zslvk
    else if (vect.eq.'ZSLVR') then
        sdeiso = zslvr
    else if (vect.eq.'ZSLVI') then
        sdeiso = zslvi
    else
        ASSERT(.false.)
    endif
!
end function
