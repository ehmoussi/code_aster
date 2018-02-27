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
subroutine nmelcv(phase    , mesh     , model    , ds_material, ds_contact    ,&
                  disp_prev, vite_prev, acce_prev, vite_curr      , disp_cumu_inst,&
                  disp_newt_curr,vect_elem, time_prev, time_curr, ds_constitutive)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/cfdisl.h"
#include "asterfort/detrsd.h"
#include "asterfort/infdbg.h"
#include "asterfort/inical.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmelco_prep.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
!
character(len=4), intent(in) :: phase
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: model
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: disp_prev
character(len=19), intent(in) :: vite_prev
character(len=19), intent(in) :: acce_prev
character(len=19), intent(in) :: vite_curr
character(len=19), intent(in) :: disp_cumu_inst
character(len=19), intent(in) :: disp_newt_curr
character(len=19), intent(out) :: vect_elem
character(len=19), intent(in) :: time_prev
character(len=19), intent(in) :: time_curr
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue/XFEM/LAC methods - Compute elementary vectors for contact
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : phase (contact or friction)
! In  mesh             : name of mesh
! In  model            : name of model
! In  ds_material      : datastructure for material parameters
! In  ds_contact       : datastructure for contact management
! In  disp_prev        : displacement at beginning of current time
! In  vite_prev        : speed at beginning of current time
! In  vite_curr        : speed at current time
! In  acce_prev        : acceleration at beginning of current time
! In  disp_cumu_inst   : displacement increment from beginning of current time
! In  time_prev        : previous time
! In  time_curr        : current time
! In  ds_constitutive  : datastructure for constitutive laws management
! Out vect_elem        : elementary vectors
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nbout = 3
    integer, parameter :: nbin  = 36
    character(len=8) :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchout(nbout), lchin(nbin)
    character(len=1) :: base
    character(len=19) :: ligrel
    character(len=16) :: option
    aster_logical :: l_cont_cont, l_cont_xfem, l_cont_xfem_gg, l_cont_lac
    aster_logical :: l_all_verif
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infdbg('CONTACT', ifm, niv)
!
! - Initializations
!
    base = 'V'
!
! - Get contact parameters
!
    l_cont_cont    = cfdisl(ds_contact%sdcont_defi,'FORMUL_CONTINUE')
    l_cont_xfem    = cfdisl(ds_contact%sdcont_defi,'FORMUL_XFEM')
    l_cont_lac     = cfdisl(ds_contact%sdcont_defi,'FORMUL_LAC')
    l_cont_xfem_gg = cfdisl(ds_contact%sdcont_defi,'CONT_XFEM_GG')
    l_all_verif    = cfdisl(ds_contact%sdcont_defi,'ALL_VERIF')
!
! --- TYPE DE CONTACT
!
    if (.not.l_all_verif .and. ((.not.l_cont_lac) .or. ds_contact%nb_cont_pair.ne.0)) then
!
! ----- Print
!
        if (niv .ge. 2) then
            write (ifm,*) '<CONTACT> CALCUL DES SECDS MEMBRES ELEMENTAIRES'
        endif
!
! ----- Init fields
!
        call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! ----- Prepare input fields
!
        call nmelco_prep(phase    , 'VECT'   ,&
                         mesh     , model    , ds_material, ds_contact,&
                         disp_prev, vite_prev, acce_prev, vite_curr , disp_cumu_inst,&
                         disp_newt_curr,nbin     , lpain    , lchin    ,&
                         option   , time_prev, time_curr , ds_constitutive)
!
! ----- <LIGREL> for contact elements
!
        ligrel = ds_contact%ligrel_elem_cont
!
! ----- Preparation of elementary vector
!
        call detrsd('VECT_ELEM', vect_elem)
        call memare('V', vect_elem, model, ' ', ' ', 'CHAR_MECA')
!
! ----- Prepare output fields
!
        lpaout(1) = 'PVECTUR'
        lchout(1) = vect_elem
!
! ----- Computation
!
        call calcul('S', option, ligrel, nbin, lchin,&
                    lpain, nbout, lchout, lpaout, base,&
                    'OUI')
!
! ----- Copy output fields
!
        call reajre(vect_elem, lchout(1), base)
    endif
!
    call jedema()
!
end subroutine
