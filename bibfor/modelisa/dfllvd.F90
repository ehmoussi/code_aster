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

function dfllvd(vect)
!
!
    implicit none
    integer :: dfllvd
#include "asterfort/assert.h"
    character(len=5) :: vect
!
! ----------------------------------------------------------------------
!
! ROUTINE GESTION LISTE INSTANTS
!
! RETOURNE LA LONGUEUR FIXE DES VECTEURS DE LA SD SDCONT
!
! ----------------------------------------------------------------------
!
!
! IN  VECT   : NOM DU VECTEUR DONT ON VEUT LA DIMENSION
!
! /!\ PENSER A MODIFIE SD_LIST_INST.PY (POUR SD_VERI)
!
! ----------------------------------------------------------------------
!
    integer :: llinr
    parameter   (llinr=11)
    integer :: leevr, leevk, lesur
    parameter   (leevr=7,leevk=3,lesur=10)
    integer :: laevr, laevk, latpr, latpk
    parameter   (laevr=6,laevk=1,latpr=6,latpk=4)
!
! ----------------------------------------------------------------------
!
!
    if (vect .eq. 'LLINR') then
        dfllvd = llinr
    else if (vect.eq.'LEEVR') then
        dfllvd = leevr
    else if (vect.eq.'LEEVK') then
        dfllvd = leevk
    else if (vect.eq.'LESUR') then
        dfllvd = lesur
    else if (vect.eq.'LAEVR') then
        dfllvd = laevr
    else if (vect.eq.'LAEVK') then
        dfllvd = laevk
    else if (vect.eq.'LATPR') then
        dfllvd = latpr
    else if (vect.eq.'LATPK') then
        dfllvd = latpk
    else
        ASSERT(.false.)
    endif
!
end function
