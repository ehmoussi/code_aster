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

subroutine setBehaviourValue(rela_comp, defo_comp   , type_comp, type_cpla,&
                             mult_comp, post_iter   , kit_comp ,&
                             nb_vari  , nb_vari_comp, nume_comp,&
                             l_compor_, v_compor_)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/comp_meca_l.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: rela_comp
    character(len=16), intent(in) :: defo_comp
    character(len=16), intent(in) :: type_comp
    character(len=16), intent(in) :: type_cpla
    character(len=16), intent(in) :: mult_comp
    character(len=16), intent(in) :: post_iter
    character(len=16), intent(in) :: kit_comp(4)
    integer, intent(in)  :: nb_vari
    integer, intent(in)  :: nb_vari_comp(4)
    integer, intent(in)  :: nume_comp(4)
    character(len=16), intent(out), optional :: l_compor_(:)
    character(len=16), intent(out), optional, pointer :: v_compor_(:)
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Save informations in COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  rela_comp        : RELATION comportment
! In  defo_comp        : DEFORMATION comportment
! In  type_comp        : type of comportment (INCR/ELAS)
! In  type_cpla        : plane stress method
! In  mult_comp        : multi-comportment (DEFI_COMPOR for PMF)
! In  post_iter        : type of post_treatment POST_ITER
! In  kit_comp         : KIT comportment
! In  nb_vari          : number of internal variables
! In  nb_vari_comp     : number of internal variables for KIT
! In  nume_comp        : index (lcxxxx)
! In  l_compor         : liste of components for <CARTE> COMPOR - (SIMU_POIN_MAT)
! In  v_compor         : liste of components for <CARTE> COMPOR - (*_NON_LINE)
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_pmf
!
! --------------------------------------------------------------------------------------------------
!
    call comp_meca_l(rela_comp, 'PMF'    , l_pmf)
!
    if (present(v_compor_)) then
        v_compor_(1:NB_COMP_MAXI) = 'VIDE'
        v_compor_(NAME) = rela_comp
        write (v_compor_(NVAR),'(I16)') nb_vari
        v_compor_(DEFO) = defo_comp
        v_compor_(INCRELAS) = type_comp
        v_compor_(PLANESTRESS) = type_cpla
        if (.not.l_pmf) then
            write (v_compor_(NUME),'(I16)') nume_comp(1)
        endif
        v_compor_(MULTCOMP) = mult_comp
        v_compor_(8) = kit_comp(1)
        v_compor_(9) = kit_comp(2)
        v_compor_(10) = kit_comp(3)
        v_compor_(11) = kit_comp(4)
        v_compor_(POSTITER) = post_iter
        write (v_compor_(15),'(I16)') nume_comp(2)
        write (v_compor_(16),'(I16)') nume_comp(3)
        write (v_compor_(17),'(I16)') nb_vari_comp(1)
        write (v_compor_(18),'(I16)') nb_vari_comp(2)
        write (v_compor_(19),'(I16)') nb_vari_comp(3)
        write (v_compor_(20),'(I16)') nb_vari_comp(4)
    elseif (present(l_compor_)) then
        l_compor_(1:NB_COMP_MAXI) = 'VIDE'
        l_compor_(NAME) = rela_comp
        write (l_compor_(NVAR),'(I16)') nb_vari
        l_compor_(DEFO) = defo_comp
        l_compor_(INCRELAS) = type_comp
        l_compor_(PLANESTRESS) = type_cpla
        if (.not.l_pmf) then
            write (l_compor_(NUME),'(I16)') nume_comp(1)
        endif
        l_compor_(MULTCOMP) = mult_comp
        l_compor_(8) = kit_comp(1)
        l_compor_(9) = kit_comp(2)
        l_compor_(10) = kit_comp(3)
        l_compor_(11) = kit_comp(4)
        l_compor_(POSTITER) = post_iter
        write (l_compor_(15),'(I16)') nume_comp(2)
        write (l_compor_(16),'(I16)') nume_comp(3)
        write (l_compor_(17),'(I16)') nb_vari_comp(1)
        write (l_compor_(18),'(I16)') nb_vari_comp(2)
        write (l_compor_(19),'(I16)') nb_vari_comp(3)
        write (l_compor_(20),'(I16)') nb_vari_comp(4)
    endif
!
end subroutine
