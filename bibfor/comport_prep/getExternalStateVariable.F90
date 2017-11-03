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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine getExternalStateVariable(rela_comp    , comp_code_py   ,&
                                    l_mfront_offi, l_mfront_proto ,&
                                    cptr_nbvarext, cptr_namevarext,&
                                    jvariexte)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/iscode.h"
#include "asterfort/Behaviour_type.h"
#include "asterc/mfront_get_external_state_variable.h"
#include "asterc/lcinfo.h"
#include "asterc/lcextevari.h"
!
aster_logical, intent(in) :: l_mfront_offi
aster_logical, intent(in) :: l_mfront_proto
character(len=16), intent(in) :: rela_comp
character(len=16), intent(in) :: comp_code_py
integer, intent(in) :: cptr_nbvarext
integer, intent(in) :: cptr_namevarext
integer, intent(out) :: jvariexte
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get external states variables
!
! --------------------------------------------------------------------------------------------------
!
! In  l_mfront_proto   : .true. if MFront prototype
! In  l_mfront_offi    : .true. if MFront official
! In  rela_comp        : RELATION comportment
! In  cptr_nbvarext    : pointer to number of external state variable
! In  cptr_namevarext  : pointer to name of external state variable
! Out jvariexte        : coded integer for external state variable
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_exte, i_exte, idummy1, idummy2, i_exte_list
    integer, parameter :: nb_exte_list = 30
    character(len=8) :: name_exte(8)
    integer :: variextecode(1)
    integer :: tabcod(30)
    character(len=16), parameter :: name_varc(nb_exte_list)  = (/'ELTSIZE1','ELTSIZE2','COORGA  ',&
                                                                 'GRADVELO','HYGR    ','NEUT1   ',&
                                                                 'NEUT2   ','TEMP    ','DTX     ',&
                                                                 'DTY     ','DTZ     ','X       ',&
                                                                 'Y       ','Z       ','SECH    ',&
                                                                 'HYDR    ','CORR    ','IRRA    ',&
                                                                 'EPSAXX  ','EPSAYY  ','EPSAZZ  ',&
                                                                 'EPSAXY  ','EPSAXZ  ','EPSAYZ  ',&
                                                                 'PFERRITE','PPERLITE','PBAINITE',&
                                                                 'PMARTENS','ALPHPUR ','ALPHBET '/)
    aster_logical, parameter :: l_allow_mfront(nb_exte_list) = (/.true.    ,.false.   ,.false.   ,&
                                                                 .false.   ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    ,&
                                                                 .true.    ,.true.    ,.true.    /)
!
! --------------------------------------------------------------------------------------------------
!
    jvariexte    = 0
    nb_exte      = 0
    name_exte(:) = ' '
!
! - Get external state variable
!
    if (l_mfront_proto .or. l_mfront_offi) then
        call mfront_get_external_state_variable(cptr_nbvarext, cptr_namevarext,&
                                                name_exte    , nb_exte)
    else
        call lcinfo(comp_code_py, idummy1, idummy2, nb_exte)
        call lcextevari(comp_code_py, nb_exte, name_exte)
    endif
! 
! - Print
!
    if (nb_exte .gt. 0) then
        call utmess('I', 'COMPOR4_21', si = nb_exte, sk = rela_comp)
        do i_exte = 1, nb_exte
            call utmess('I', 'COMPOR4_22', si = i_exte, sk = name_exte(i_exte))
        end do 
    endif
!
! - Coding
!
    tabcod(1:30) = 0
    do i_exte = 1, nb_exte
        do i_exte_list = 1, nb_exte_list
            if (name_exte(i_exte) .eq. name_varc(i_exte_list)) then
                tabcod(i_exte_list) = 1
                if (.not. l_allow_mfront(i_exte_list) .and.&
                    (l_mfront_proto .or. l_mfront_offi)) then
                    call utmess('I', 'COMPOR2_25', sk = name_exte(i_exte))
                    tabcod(i_exte_list) = 0
                endif
            endif
        end do
    end do 
    call iscode(tabcod, variextecode(1), 30)
    jvariexte = variextecode(1)
!
end subroutine
