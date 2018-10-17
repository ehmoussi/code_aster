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
subroutine nmfocc(phase      , model     , ds_material, nume_dof , list_func_acti ,&
                  ds_contact , ds_measure, hval_algo  , hval_incr, ds_constitutive)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assvec.h"
#include "asterfort/cfdisl.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/lccsst.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nmelcv.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/nmvcex.h"
#include "asterfort/vtaxpy.h"
!
character(len=10), intent(in) :: phase
character(len=24), intent(in) :: model
type(NL_DS_Material), intent(in) :: ds_material
character(len=24), intent(in) :: nume_dof
integer, intent(in) :: list_func_acti(*)
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: hval_algo(*)
character(len=19), intent(in) :: hval_incr(*)
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algo
!
! Continue/XFEM/LAC methods - Compute second member
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase
!               'PREDICTION' - PHASE DE PREDICTION
!               'CONVERGENC' - PHASE DE CONVERGENCE
!               'CORRECTION' - PHASE DE CORRECTION
! In  model            : name of model
! In  ds_material      : datastructure for material parameters
! In  nume_dof         : name of numbering (NUME_DDL)
! In  list_func_acti   : list of active functionnalities
! In  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  ds_constitutive  : datastructure for constitutive laws management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_cont_elem, l_fric, l_all_verif, l_newt_cont, l_newt_geom, l_cont_lac
    aster_logical :: l_xthm
    character(len=8) :: mesh
    character(len=19) :: vect_elem_cont, vect_elem_frot
    character(len=19) :: vect_asse_frot, vect_asse_cont
    character(len=19) :: disp_prev, disp_cumu_inst, disp_newt_curr, vite_prev, acce_prev, vite_curr
    character(len=19) :: varc_prev, varc_curr, time_prev, time_curr
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> CALCUL DU SECOND MEMBRE'
    endif
!
! - Active functionnalities
!
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
    l_cont_elem = isfonc(list_func_acti,'ELT_CONTACT')
    l_fric      = cfdisl(ds_contact%sdcont_defi, 'FROTTEMENT')
    l_all_verif = isfonc(list_func_acti,'CONT_ALL_VERIF')
    l_newt_cont = isfonc(list_func_acti,'CONT_NEWTON')
    l_newt_geom = isfonc(list_func_acti,'GEOM_NEWTON')
    l_cont_lac  = isfonc(list_func_acti,'CONT_LAC')
    l_xthm      = isfonc(list_func_acti,'CONT_XFEM_THM')
!
! - Get fields
!
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'VITMOI', vite_prev)
    call nmchex(hval_incr, 'VALINC', 'ACCMOI', acce_prev)
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst)
    call nmchex(hval_algo, 'SOLALG', 'DDEPLA', disp_newt_curr)
    vect_elem_cont = ds_contact%veeltc
    vect_elem_frot = ds_contact%veeltf
    vect_asse_cont = ds_contact%cneltc
    vect_asse_frot = ds_contact%cneltf
    call nmchex(hval_incr, 'VALINC', 'COMMOI', varc_prev)
    call nmchex(hval_incr, 'VALINC', 'COMPLU', varc_curr)
    call nmvcex('INST', varc_prev, time_prev)
    call nmvcex('INST', varc_curr, time_curr)
!
! - Generalized Newton: contact status evaluate before
!
    if ((phase.eq.'CONVERGENC') .and. (l_newt_cont .or. l_newt_geom)) then
        goto 999
    endif
!
! - Compute contact forces
!
    if (l_cont_elem .and. (.not.l_all_verif) .and. &
        ((.not.l_cont_lac) .or. ds_contact%nb_cont_pair.ne.0)) then
        call nmtime(ds_measure, 'Init'  , 'Cont_Elem')
        call nmtime(ds_measure, 'Launch', 'Cont_Elem')
        call nmelcv(mesh          , model    , ds_material, ds_contact    ,&
                    disp_prev     , vite_prev, acce_prev, vite_curr, disp_cumu_inst,&
                    disp_newt_curr, vect_elem_cont, time_prev, time_curr, ds_constitutive)
        call assvec('V', vect_asse_cont, 1, vect_elem_cont, [1.d0],&
                    nume_dof, ' ', 'ZERO', 1)
        call nmtime(ds_measure, 'Stop', 'Cont_Elem')
        call nmrinc(ds_measure, 'Cont_Elem')
        if (niv .eq. 2) then
            call nmdebg('VECT', vect_asse_cont, ifm)
        endif
    endif
!
! - Compute friction forces
!
    !if (l_fric .and. (.not.l_all_verif) .and. (.not.l_xthm)) then
    !    call nmtime(ds_measure, 'Init'  , 'Cont_Elem')
    !    call nmtime(ds_measure, 'Launch', 'Cont_Elem')
    !    call nmelcv('FROT'        , mesh     , model    , ds_material, ds_contact    ,&
    !                disp_prev     , vite_prev, acce_prev, vite_curr, disp_cumu_inst,&
    !                disp_newt_curr, vect_elem_frot, time_prev, time_curr, ds_constitutive)
    !    call assvec('V', vect_asse_frot, 1, vect_elem_frot, [1.d0],&
    !                nume_dof, ' ', 'ZERO', 1)
    !    call nmtime(ds_measure, 'Stop', 'Cont_Elem')
    !    call nmrinc(ds_measure, 'Cont_Elem')
    !    if (niv .eq. 2) then
    !        call nmdebg('VECT', vect_asse_frot, ifm)
    !    endif
    !endif
!
! - Special post-treatment for LAC contact method
!
    if (l_cont_lac) then
        call lccsst(ds_contact, vect_asse_cont)
    end if
!
999 continue
!
end subroutine
