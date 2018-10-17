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
subroutine nmelcm(mesh       , model          ,&
                  ds_material, ds_contact, ds_constitutive, ds_measure,&
                  hval_incr  , hval_algo ,&
                  matr_elem)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/cfdisl.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/infdbg.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/memare.h"
#include "asterfort/nmelco_prep.h"
#include "asterfort/reajre.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmvcex.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: mesh
character(len=24), intent(in) :: model
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Contact), intent(in) :: ds_contact
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: hval_incr(*), hval_algo(*)
character(len=19), intent(out) :: matr_elem
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue/XFEM/LAC methods - Compute elementary matrix for contact
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  ds_material      : datastructure for material parameters
! In  ds_contact       : datastructure for contact management
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! Out matr_elem        : elementary matrix
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
    character(len=19) :: xcohes, ccohes
    character(len=16) :: option
    aster_logical :: l_cont_lac, l_all_verif, l_xfem_czm, l_xthm
    character(len=19) :: disp_prev, vite_prev, acce_prev, vite_curr, varc_prev, varc_curr
    character(len=19) :: disp_cumu_inst, disp_newt_curr
    character(len=19) :: time_prev, time_curr
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
! - Begin measure
!
    call nmtime(ds_measure, 'Init', 'Cont_Elem')
    call nmtime(ds_measure, 'Launch', 'Cont_Elem')
!
! - Get hat variables
!
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst)
    call nmchex(hval_algo, 'SOLALG', 'DDEPLA', disp_newt_curr)
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'VITMOI', vite_prev)
    call nmchex(hval_incr, 'VALINC', 'ACCMOI', acce_prev)
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vite_curr)
    call nmchex(hval_incr, 'VALINC', 'COMMOI', varc_prev)
    call nmchex(hval_incr, 'VALINC', 'COMPLU', varc_curr)
    call nmvcex('INST', varc_prev, time_prev)
    call nmvcex('INST', varc_curr, time_curr)
!
! - Get contact parameters
!
    l_cont_lac  = cfdisl(ds_contact%sdcont_defi, 'FORMUL_LAC')
    l_xfem_czm  = cfdisl(ds_contact%sdcont_defi, 'EXIS_XFEM_CZM')
    l_all_verif = cfdisl(ds_contact%sdcont_defi, 'ALL_VERIF')
    l_xthm      = ds_contact%l_cont_thm

    if (.not.l_all_verif .and. ((.not.l_cont_lac) .or. ds_contact%nb_cont_pair.ne.0)) then
! ----- Display
        if (niv .ge. 2) then
            call utmess('I','CONTACT5_27')
        endif
! ----- Init fields
        call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
! ----- Prepare input fields
        call nmelco_prep('MATR'   ,&
                         mesh     , model    , ds_material, ds_contact,&
                         disp_prev, vite_prev, acce_prev, vite_curr , disp_cumu_inst,&
                         disp_newt_curr,nbin     , lpain    , lchin    ,&
                         option   , time_prev, time_curr , ds_constitutive,&
                         ccohes   , xcohes)
! ----- <LIGREL> for contact elements
        ligrel = ds_contact%ligrel_elem_cont
! ----- Preparation of elementary matrix
        call detrsd('MATR_ELEM', matr_elem)
        call memare('V', matr_elem, model, ' ', ' ', 'RIGI_MECA')
! ----- Prepare output fields
        lpaout(1) = 'PMATUNS'
        lchout(1) = matr_elem(1:15)//'.M01'
        lpaout(2) = 'PMATUUR'
        lchout(2) = matr_elem(1:15)//'.M02'
        if (l_xthm .or. l_xfem_czm) then
           lpaout(3) = 'PCOHESO'
           lchout(3) = ccohes
        endif
! ----- Computation
        call calcul('S', option, ligrel, nbin, lchin,&
                    lpain, nbout, lchout, lpaout, base,&
                    'OUI')
! ----- Copy output fields
        call reajre(matr_elem, lchout(1), base)
        call reajre(matr_elem, lchout(2), base)
        if (l_xthm .or. l_xfem_czm) then
            call copisd('CHAMP_GD', 'V', lchout(3), xcohes)
        endif
    endif
!
! - End measure
!
    call nmtime(ds_measure, 'Stop', 'Cont_Elem')
    call nmrinc(ds_measure, 'Cont_Elem')
!
    call jedema()
!
end subroutine
