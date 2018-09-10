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
subroutine nmctcd(list_func_acti, ds_contact, nume_dof)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmchex.h"
#include "asterfort/cffoco.h"
#include "asterfort/cffofr.h"
#include "asterfort/cufoco.h"
!
integer, intent(in) :: list_func_acti(*)
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=24), intent(in) :: nume_dof
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Compute
!
! Compute vectors for DISCRETE contact
!
! --------------------------------------------------------------------------------------------------
!
! In  list_func_acti   : list of active functionnalities
! In  nume_dof         : name of numbering (NUME_DDL)
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_unil, l_cont_disc, l_frot_disc, l_all_verif
    aster_logical :: l_cont_pena
    character(len=24) :: vect_asse
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! - Active functionnalites
!
    l_cont_disc = isfonc(list_func_acti        , 'CONT_DISCRET')
    l_frot_disc = isfonc(list_func_acti        , 'FROT_DISCRET')
    l_cont_pena = cfdisl(ds_contact%sdcont_defi, 'CONT_PENA')
    l_unil      = isfonc(list_func_acti        , 'LIAISON_UNILATER')
    l_all_verif = cfdisl(ds_contact%sdcont_defi, 'ALL_VERIF')
    if (.not.l_all_verif) then
!
! ----- Print
!
        if (niv .ge. 2) then
            write (ifm,*) '<MECANONLINE> ...... CALCUL FORCES CONTACT'
        endif
!
! ----- Contact (DISCRETE) forces
!
        if (l_cont_disc) then
            vect_asse = ds_contact%cnctdc
            call cffoco(nume_dof, ds_contact%sdcont_solv, vect_asse)
        endif
!
! ----- Friction (DISCRETE) forces
!
        if ((l_frot_disc) .or. (l_cont_pena)) then
            vect_asse = ds_contact%cnctdf
            call cffofr(nume_dof, ds_contact%sdcont_solv, vect_asse)
        endif
!
! ----- Unilateral conditions (DISCRETE) forces
!
        if (l_unil) then
            vect_asse = ds_contact%cnunil
            call cufoco(nume_dof, ds_contact%sdunil_solv, vect_asse)
        endif
    endif
!
end subroutine
