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
subroutine nmasco(fonact, veasse, cncont)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmchex.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
integer :: fonact(*)
character(len=19) :: veasse(*)
character(len=19) :: cncont
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! CONSTRUCTION DU VECTEUR DES FORCES VARIABLES LIEES AU CONTACT
!
! ----------------------------------------------------------------------
!
! IN  FONACT : FONCTIONNALITES ACTIVEES (VOIR NMFONC)
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNCONT : VECT_ASSE DES CONTRIBUTIONS DE CONTACT/FROTTEMENT (C/F)
!               C/F METHODE CONTINUE
!               C/F METHODE XFEM
!               C/F METHODE XFEM GRDS GLIS.
!               F   METHODE DISCRETE
!
!
!
!
    aster_logical :: leltc, leltf, lallv
    integer :: nb_vect, i_vect
    character(len=19) :: vect(20)
    real(kind=8) :: coef(20)
    character(len=19) :: cneltc, cneltf
!
! ----------------------------------------------------------------------
!
    nb_vect = 0
    call vtzero(cncont)
!
! --- FONCTIONNALITES ACTIVEES
!
    leltc = isfonc(fonact,'ELT_CONTACT')
    leltf = isfonc(fonact,'ELT_FROTTEMENT')
    lallv = isfonc(fonact,'CONT_ALL_VERIF' )
!
! --- FORCES DES ELEMENTS DE CONTACT (XFEM+CONTINUE)
!
    if (leltc .and. (.not.lallv)) then
        call nmchex(veasse, 'VEASSE', 'CNELTC', cneltc)
        nb_vect = nb_vect + 1
        coef(nb_vect) = 1.d0
        vect(nb_vect) = cneltc
    endif
    if (leltf .and. (.not.lallv)) then
        call nmchex(veasse, 'VEASSE', 'CNELTF', cneltf)
        nb_vect = nb_vect + 1
        coef(nb_vect) = 1.d0
        vect(nb_vect) = cneltf
    endif
!
! --- VECTEUR RESULTANT
!
    do i_vect = 1, nb_vect
        call vtaxpy(coef(i_vect), vect(i_vect), cncont)
    end do
!
end subroutine
