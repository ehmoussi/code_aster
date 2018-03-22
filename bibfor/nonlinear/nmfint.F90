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
subroutine nmfint(model          , cara_elem      ,&
                  ds_material    , ds_constitutive,&
                  list_func_acti , iter_newt      , sddyna, ds_measure,&
                  hval_incr      , hval_algo      ,&
                  vefint         , ldccvg   )
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
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
character(len=19), intent(in) :: sddyna
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(in) :: vefint
integer, intent(out) :: ldccvg
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
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  vefint           : elementary vectors for internal forces
! Out ldccvg           : indicator from integration of behaviour
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DE FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORST
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: tabret(0:10)
    integer :: iter
    character(len=1) :: base
    character(len=16) :: option
    character(len=19) :: k19bla
    character(len=24) :: mate, varc_refe
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
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
    k19bla    = ' '
    option    = 'RAPH_MECA'
    ldccvg    = 0
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init', 'Integrate')
    call nmtime(ds_measure, 'Launch', 'Integrate')
!
! - Computation
!
    call merimo(base           , model    , cara_elem     , mate  , varc_refe,&
                ds_constitutive, iter_newt, list_func_acti, sddyna,&
                hval_incr      , hval_algo, k19bla        , vefint, option   ,&
                tabret)
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', 'Integrate')
    call nmrinc(ds_measure, 'Integrate')
!
! - Return code
!
    if (tabret(0)) then
        if (tabret(4)) then
            ldccvg = 4
        else if (tabret(3)) then
            ldccvg = 3
        else if (tabret(2)) then
            ldccvg = 2
        else
            ldccvg = 1
        endif
        if (tabret(1)) then
            ldccvg = 1
        endif
    endif
!
end subroutine
