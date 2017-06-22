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

subroutine nmchcc(list_func_acti, nb_matr    , list_matr_type, list_calc_opti, list_asse_opti,&
                  list_l_asse   , list_l_calc)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmcmat.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: list_func_acti(*)
    integer, intent(inout) :: nb_matr
    character(len=6), intent(inout)  :: list_matr_type(20)
    character(len=16), intent(inout) :: list_calc_opti(20)
    character(len=16), intent(inout) :: list_asse_opti(20)
    aster_logical, intent(inout) :: list_l_asse(20)
    aster_logical, intent(inout) :: list_l_calc(20)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! MATR_ELEM CONTACT/XFEM
!
! ----------------------------------------------------------------------
!
!
! IN  FONACT : FONCTIONNALITES ACTIVEES
! I/O NBMATR : NOMBRE DE MATR_ELEM DANS LA LISTE
! I/O LTYPMA : LISTE DES NOMS DES MATR_ELEM
! I/O LOPTME : LISTE DES OPTIONS DES MATR_ELEM
! I/O LOPTMA : LISTE DES OPTIONS DES MATR_ASSE
! I/O LCALME : SI MATR_ELEM A CALCULER
! I/O LASSME : SI MATR_ELEM A ASSEMBLER
!
! ----------------------------------------------------------------------
!
    aster_logical :: leltc, leltf, lxthm
!
! ----------------------------------------------------------------------
!
    leltc = isfonc(list_func_acti,'ELT_CONTACT')
    leltf = isfonc(list_func_acti,'ELT_FROTTEMENT')
    lxthm = isfonc(list_func_acti,'THM')
!
! --- ELEMENTS DE CONTACT (XFEM+CONTINU)
!
    if (leltc) then
        call nmcmat('MEELTC', ' ', ' ', .true._1,&
                    .false._1, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                    list_l_calc, list_l_asse)
    endif
!
! --- ELEMENTS DE FROTTEMENT (XFEM+CONTINU)
!
    if (leltf.and.(.not.lxthm)) then
        call nmcmat('MEELTF', ' ', ' ', .true._1,&
                    .false._1, nb_matr, list_matr_type, list_calc_opti, list_asse_opti,&
                    list_l_calc, list_l_asse)
    endif
!
end subroutine
