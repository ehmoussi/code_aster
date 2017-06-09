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

function xxmmvd(vect)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
    integer :: xxmmvd
#include "asterf_types.h"
#include "asterfort/assert.h"
    character(len=5) :: vect
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (UTILITAIRE)
!
! RETOURNE LA LONGUEUR FIXE DES VECTEURS DE LA SD SDXFEM
!
! ----------------------------------------------------------------------
!
!
! IN  VECT   : NOM DU VECTEUR DONT ON VEUT LA DIMENSION
!
! ----------------------------------------------------------------------
!
    integer :: zxcar
    parameter (zxcar=12)
    integer :: zxbas, zxedg
    parameter (zxbas=14,zxedg=25)
    integer :: zxain
    parameter (zxain=5)
    aster_logical :: lvect
!
! ----------------------------------------------------------------------
!
    lvect=.false.
    if (vect .eq. 'ZXCAR') then
        xxmmvd = zxcar
    else if (vect.eq.'ZXBAS') then
        xxmmvd = zxbas
    else if (vect.eq.'ZXEDG') then
        xxmmvd = zxedg
    else if (vect.eq.'ZXAIN') then
        xxmmvd = zxain
    else
        ASSERT(lvect)
    endif
!
end function
