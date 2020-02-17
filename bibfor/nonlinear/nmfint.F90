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
subroutine nmfint(model         , cara_elem      ,&
                  ds_material   , ds_constitutive,&
                  list_func_acti, iter_newt      , ds_measure, ds_system,&
                  hval_incr     , hval_algo      ,&
                  ldccvg        , sddynz_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/merimo.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/utmess.h"
!
character(len=24), intent(in) :: model, cara_elem
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
integer, intent(in) :: list_func_acti(*)
integer, intent(in) :: iter_newt
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_System), intent(in) :: ds_system
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
integer, intent(out) :: ldccvg
character(len=*), optional, intent(in) :: sddynz_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute elementary vectors for internal forces by integration of behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! In  list_func_acti   : list of active functionnalities
! In  iter_newt        : index of current Newton iteration
! In  sddyna           : datastructure for dynamic
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_system        : datastructure for non-linear system management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! Out ldccvg           : indicator from integration of behaviour
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DE FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_xfem, l_macr_elem
    integer :: iter
    character(len=1) :: base
    character(len=16) :: option
    character(len=19) :: merigi, vefint, sddyna
    character(len=24) :: mate, varc_refe
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE11_25')
    endif
!
! - Initializations
!
    mate      = ds_material%field_mate
    varc_refe = ds_material%varc_refe
    iter      = iter_newt+1
    base      = 'V'
    option    = 'RAPH_MECA'
    ldccvg    = 0
    sddyna    = ' '
    if (present(sddynz_)) then
        sddyna = sddynz_
    endif
!
! - Active functionnalities
!
    l_xfem      = isfonc(list_func_acti, 'XFEM')
    l_macr_elem = isfonc(list_func_acti, 'MACR_ELEM_STAT')
!
! - Elementaries
!
    merigi = ds_system%merigi
    vefint = ds_system%vefint
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , 'Integrate')
    call nmtime(ds_measure, 'Launch', 'Integrate')
!
! - Computation
!
    call merimo(base           , l_xfem   , l_macr_elem,&
                model          , cara_elem, mate       , iter ,&
                ds_constitutive, varc_refe,&
                hval_incr      , hval_algo,&
                option         , merigi   ,vefint      ,&
                ldccvg         , sddyna)
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', 'Integrate')
    call nmrinc(ds_measure, 'Integrate')
!
end subroutine
