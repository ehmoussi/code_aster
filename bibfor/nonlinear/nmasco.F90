! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmasco(cncont, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
character(len=19) :: cncont
type(NL_DS_Contact), intent(in) :: ds_contact
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! CONSTRUCTION DU VECTEUR DES FORCES VARIABLES LIEES AU CONTACT
!
! ----------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! OUT CNCONT : VECT_ASSE DES CONTRIBUTIONS DE CONTACT/FROTTEMENT (C/F)
!               C/F METHODE CONTINUE
!               C/F METHODE XFEM
!               C/F METHODE XFEM GRDS GLIS.
!               F   METHODE DISCRETE
!
!
!
!
    integer :: nb_vect, i_vect
    character(len=19) :: vect(20)
    real(kind=8) :: coef(20)
!
! ----------------------------------------------------------------------
!
    nb_vect = 0
    call vtzero(cncont)
!
! --- FORCES DES ELEMENTS DE CONTACT (XFEM+CONTINUE)
!
    if (ds_contact%l_cneltc) then
        nb_vect = nb_vect + 1
        coef(nb_vect) = 1.d0
        vect(nb_vect) = ds_contact%cneltc
    endif
    if (ds_contact%l_cneltf) then
        nb_vect = nb_vect + 1
        coef(nb_vect) = 1.d0
        vect(nb_vect) = ds_contact%cneltf
    endif
!
! --- VECTEUR RESULTANT
!
    do i_vect = 1, nb_vect
        call vtaxpy(coef(i_vect), vect(i_vect), cncont)
    end do
!
end subroutine
