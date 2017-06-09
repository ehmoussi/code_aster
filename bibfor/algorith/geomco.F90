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

subroutine geomco(noma, ds_contact, depplu)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/infdbg.h"
#include "asterfort/vtgpld.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8) :: noma
    type(NL_DS_Contact), intent(in) :: ds_contact
    character(len=19) :: depplu
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - APPARIEMENT)
!
! REACTUALISATION DE LA GEOMETRIE
!
! ----------------------------------------------------------------------
!
! IN  NOMA   : NOM DU MAILLAGE
! In  ds_contact       : datastructure for contact management
! IN  DEPPLU : CHAMP DE DEPLACEMENTS A L'ITERATION DE NEWTON PRECEDENTE
!
    character(len=19) :: oldgeo, newgeo
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> ...... REACTUALISATION DE LA GEOMETRIE'
    endif
!
    oldgeo = noma(1:8)//'.COORDO'
    newgeo = ds_contact%sdcont_solv(1:14)//'.NEWG'
    call vtgpld('CUMU', oldgeo, 1.d0, depplu, 'V',&
                newgeo)
!
end subroutine
