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
subroutine nmctcc(mesh      , model_    , ds_material, nume_inst, &
                  sderro    ,  sddisc, hval_incr, hval_algo,&
                  ds_contact, ds_constitutive   , list_func_acti)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/infdbg.h"
#include "asterfort/mmbouc.h"
#include "asterfort/mm_cycl_flip.h"
#include "asterfort/mmstat.h"
#include "asterfort/nmcrel.h"
#include "asterfort/nmimck.h"
#include "asterfort/utmess.h"
#include "asterfort/xmmbca.h"
#include "asterfort/xmtbca.h"
#include "asterfort/nmchex.h"
!
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: model_
type(NL_DS_Material), intent(in) :: ds_material
integer, intent(in) :: nume_inst
character(len=24), intent(in) :: sderro
character(len=19), intent(in) :: sddisc
character(len=19), intent(in) :: hval_incr(*)
character(len=19), intent(in) :: hval_algo(*)
type(NL_DS_Contact), intent(inout) :: ds_contact
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
integer, intent(in) :: list_func_acti(*)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue methods - Evaluate convergence for contact loop
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  ds_material      : datastructure for material parameters
! In  nume_inst        : index of current time step
! In  sderro           : datastructure for errors during algorithm
! In  sddisc           : datastructure for time discretization
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! IO  ds_contact       : datastructure for contact management
! In  list_func_acti   : list of active functionnalities
! In  ds_constitutive  : datastructure for constitutive laws management
! Out loop_cont_conv   : .true. if contact loop converged
! Out loop_cont_node   : number of contact state changing
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_cont_xfem_gg, l_cont_cont, l_cont_xfem, l_frot, l_erro_cont
    integer :: nb_cont_poin, iter_cont_mult, iter_cont_maxi
    integer :: loop_cont_count
    character(len=8) :: model
    real(kind=8) :: loop_cont_vale
    integer :: iter_newt
    aster_logical :: cycl_flip, loop_cont_conv
    character(len=19) :: disp_curr, disp_cumu_inst
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ALGORITHME DES CONTRAINTES ACTIVES'
    endif
!
! - Initializations
!
    model          = model_(1:8)
    loop_cont_conv = ASTER_FALSE
    loop_cont_vale = 0.d0
    l_erro_cont    = ASTER_FALSE
    iter_newt      = -1
!
! - Get contact parameters
!
    l_cont_cont    = cfdisl(ds_contact%sdcont_defi, 'FORMUL_CONTINUE')
    l_cont_xfem    = cfdisl(ds_contact%sdcont_defi, 'FORMUL_XFEM')
    l_frot         = cfdisl(ds_contact%sdcont_defi, 'FROTTEMENT')
    l_cont_xfem_gg = cfdisl(ds_contact%sdcont_defi, 'CONT_XFEM_GG')
    nb_cont_poin   = cfdisi(ds_contact%sdcont_defi, 'NTPC')
    iter_cont_mult = cfdisi(ds_contact%sdcont_defi, 'ITER_CONT_MULT')
!
! - Get hat variables
!
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst)
!
! - Compute convergence criterion
! 
    !on laisse ITER_CONT_MULT pour XFEM
    if (l_cont_xfem .or. l_cont_xfem_gg) then 
        if (iter_cont_mult .eq. -1) then
            iter_cont_maxi = cfdisi(ds_contact%sdcont_defi, 'ITER_CONT_MAXI')
        else
            iter_cont_maxi = iter_cont_mult*nb_cont_poin
        endif
    else 
        iter_cont_maxi = cfdisi(ds_contact%sdcont_defi, 'ITER_CONT_MAXI')
    endif
!
! - Management of contact loop
!
    call mmbouc(ds_contact, 'Cont', 'Set_Vale' , loop_vale_ = loop_cont_vale)
    if (l_cont_xfem) then
        if (l_cont_xfem_gg) then
            call xmtbca(mesh, hval_incr, ds_material, ds_contact)
        else
            call xmmbca(mesh, model, ds_material, hval_incr, ds_contact, ds_constitutive,&
                        list_func_acti)
        endif
    else if (l_cont_cont) then
        call mmstat(mesh  , iter_newt, nume_inst     , &
                    sddisc, disp_curr, disp_cumu_inst, ds_contact)
    else
        ASSERT(.false.)
    endif
!
! - State of contact loop
!
    call mmbouc(ds_contact, 'Cont', 'Read_Counter'  , loop_cont_count)
    call mmbouc(ds_contact, 'Cont', 'Is_Convergence', loop_state_ = loop_cont_conv)
    call mmbouc(ds_contact, 'Cont', 'Get_Vale' , loop_vale_ = loop_cont_vale)
!
! - Flip-flop: forced convergence
!
    if (l_cont_cont) then
        call mm_cycl_flip(ds_contact, cycl_flip)
        if (cycl_flip) then
            if ((ds_contact%resi_pressure .lt. 1.d-4*ds_contact%cont_pressure&
                 .and. loop_cont_count .ge. 2) .and. .not. loop_cont_conv)  &
            call mmbouc(ds_contact, 'Cont', 'Set_Convergence')
        endif
    endif
    call mmbouc(ds_contact, 'Cont', 'Is_Convergence', loop_state_ = loop_cont_conv)
!
! - Convergence of contact loop
!
    if ((.not.loop_cont_conv) .and. (loop_cont_count .eq. iter_cont_maxi)) then
        if (l_frot .and. l_cont_xfem) then
! --------- XFEM+friction: forced convergence
            call utmess('A', 'CONTACT3_86')
            call mmbouc(ds_contact, 'Cont', 'Set_Convergence')
        else
            l_erro_cont    = .true.
            loop_cont_conv = .false.
        endif
    endif
!
! - Error management
!
    call nmcrel(sderro, 'ERRE_CTCC', l_erro_cont)
    if (loop_cont_conv) then
        call nmcrel(sderro, 'DIVE_FIXC', .false._1)
    else
        call nmcrel(sderro, 'DIVE_FIXC', .true._1)
    endif
!
end subroutine
