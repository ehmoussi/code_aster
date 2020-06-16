! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine asmari(ds_system, hval_meelem, list_load, matr_rigi)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/asmatr.h"
#include "asterfort/assert.h"
#include "asterfort/nmchex.h"
#include "asterfort/jeexin.h"
#include "asterfort/matr_asse_syme.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
!
type(NL_DS_System), intent(in) :: ds_system
character(len=19), intent(in) :: hval_meelem(*)
character(len=19), intent(in) :: list_load, matr_rigi
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Computation
!
! Assembling rigidity matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_system        : datastructure for non-linear system management
! In  hval_meelem      : hat variable for elementary matrixes
! In  list_load        : name of datastructure for list of loads
! In  matr_rigi        : name of assembled rigidity matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_matr_elem, iexi
    character(len=19) :: mediri, meeltc
    character(len=19) :: list_matr_elem(8)
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_70')
    endif
    nb_matr_elem = 0
!
! - Rigidity MATR_ELEM
!
    nb_matr_elem = nb_matr_elem + 1
    list_matr_elem(nb_matr_elem) = ds_system%merigi
!
! - Boundary conditions MATR_ELEM
!
    call nmchex(hval_meelem, 'MEELEM', 'MEDIRI', mediri)
    nb_matr_elem = nb_matr_elem + 1
    list_matr_elem(nb_matr_elem) = mediri
!
! - Contact/friction MATR_ELEM
!
    if (ds_system%l_rigi_cont) then
        call nmchex(hval_meelem, 'MEELEM', 'MEELTC', meeltc)
        call jeexin(meeltc//'.RERR', iexi)
        if (iexi.ne.0) then
            nb_matr_elem = nb_matr_elem + 1
            list_matr_elem(nb_matr_elem) = meeltc
        end if
    endif
!
! - Assembly MATR_ELEM
!
    ASSERT(nb_matr_elem .le. 8)
    call asmatr(nb_matr_elem, list_matr_elem, ' ', ds_system%nume_dof,&
                list_load   , 'ZERO'        , 'V',&
                1           , matr_rigi)
!
! - Symmetry of rigidity matrix
!
    if (ds_system%l_rigi_syme) then
        call matr_asse_syme(matr_rigi)
    endif
!
end subroutine
