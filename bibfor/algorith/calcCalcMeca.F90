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
subroutine calcCalcMeca(nb_option      , list_option,&
                        l_elem_nonl    , nume_harm  ,&
                        list_load      , model      , cara_elem,&
                        ds_constitutive, ds_material, ds_system,&
                        hval_incr      , hval_algo  ,&
                        vediri         , vefnod     ,&
                        vevarc_prev    , vevarc_curr,&
                        nb_obje_maxi   , obje_name  , obje_sdname, nb_obje)
!
use NonLin_Datastructure_type
use HHO_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/exixfe.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/knindi.h"
#include "asterfort/nmchex.h"
#include "asterfort/merimo.h"
#include "asterfort/medime.h"
#include "asterfort/vebtla.h"
#include "asterfort/vefnme.h"
#include "asterfort/nmvcpr_elem.h"
#include "asterfort/utmess.h"
#include "asterfort/nmvcd2.h"
#include "asterfort/vtzero.h"
!
integer, intent(in) :: nb_option
character(len=16), intent(in) :: list_option(:)
aster_logical, intent(in) :: l_elem_nonl
integer, intent(in) :: nume_harm
character(len=19), intent(in) :: list_load
character(len=24), intent(in) :: model, cara_elem
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_System), intent(in) :: ds_system
character(len=19), intent(in) :: hval_incr(:), hval_algo(:)
character(len=19), intent(in) :: vediri, vefnod
character(len=19), intent(in) :: vevarc_prev, vevarc_curr
integer, intent(in) :: nb_obje_maxi
character(len=16), intent(inout) :: obje_name(nb_obje_maxi)
character(len=24), intent(inout) :: obje_sdname(nb_obje_maxi)
integer, intent(out) ::  nb_obje
!
! --------------------------------------------------------------------------------------------------
!
! Command CALCUL
!
! Compute for mechanics
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_option        : number of options to compute
! In  list_option      : list of options to compute
! In  list_load        : name of datastructure for list of loads
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  l_elem_nonl      : .true. if all elements can compute non-linear options
! In  ds_constitutive  : datastructure for constitutive laws management
! In  ds_material      : datastructure for material parameters
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_algo        : hat-variable for algorithms fields
! In  vediri           : name of elementary for reaction (Lagrange) vector
! In  vefnod           : name of elementary for forces vector (FORC_NODA)
! In  vevarc_prev      : name of elementary for external state variables at beginning of step
! In  vevarc_curr      : name of elementary for external state variables at end of step
! In  nb_obje_maxi     : maximum number of new objects to add
! IO  obje_name        : name of new objects to add
! IO  obje_sdname      : datastructure name of new objects to add
! Out nb_obje          : number of new objects to add
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_matr, l_nonl, l_varc_prev, l_varc_curr, l_forc_noda
    aster_logical :: l_lagr, l_hho
    character(len=16) :: option
    character(len=19) :: varc_curr, disp_curr, sigm_curr, vari_curr
    character(len=19) :: vari_prev, disp_prev, sigm_prev, disp_cumu_inst
    integer :: iter_newt, ixfem, nb_subs_stat
    aster_logical :: l_meta_zirc, l_meta_acier, l_xfem, l_macr_elem
    integer :: ldccvg
    real(kind=8) :: partps(3)
    character(len=19) :: ligrmo, caco3d
    character(len=32) :: answer
    type(HHO_Field) :: hhoField
    character(len=1) :: base
    character(len=24) :: depnul
!
! --------------------------------------------------------------------------------------------------
!
    partps(:) = 0.d0
    nb_obje   = 0
    base      = 'G'
    caco3d    = '&&MERIMO.CARA_ROTAF'
!
! - Get LIGREL
!
    call dismoi('NOM_LIGREL', model, 'MODELE', repk=ligrmo)
!
! - Specific functionnalities
!
    call exixfe(model, ixfem)
    l_xfem      = ixfem .ne. 0
    call dismoi('NB_SS_ACTI', model, 'MODELE', repi=nb_subs_stat)
    l_macr_elem = nb_subs_stat .gt. 0
    call dismoi('EXI_HHO', model, 'MODELE', repk=answer)
    l_hho = (answer == 'OUI')
!
! - Name of variables
!
    call nmchex(hval_incr, 'VALINC', 'COMPLU', varc_curr)
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', disp_curr)
    call nmchex(hval_incr, 'VALINC', 'SIGPLU', sigm_curr)
    call nmchex(hval_incr, 'VALINC', 'VARPLU', vari_curr)
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', disp_prev)
    call nmchex(hval_incr, 'VALINC', 'SIGMOI', sigm_prev)
    call nmchex(hval_incr, 'VALINC', 'VARMOI', vari_prev)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', disp_cumu_inst )
!
! - What we are computing
!
    l_matr      = (knindi(16, 'MATR_TANG_ELEM', list_option, nb_option) .gt. 0)
    l_nonl      = (knindi(16, 'MATR_TANG_ELEM', list_option, nb_option) .gt. 0).or.&
                  (knindi(16, 'COMPORTEMENT'  , list_option, nb_option) .gt. 0).or.&
                  (knindi(16, 'FORC_INTE_ELEM', list_option, nb_option) .gt. 0)
    l_forc_noda = (knindi(16, 'FORC_NODA_ELEM'  , list_option, nb_option) .gt. 0)
    l_varc_prev = (knindi(16, 'FORC_VARC_ELEM_M', list_option, nb_option) .gt. 0)
    l_varc_curr = (knindi(16, 'FORC_VARC_ELEM_P', list_option, nb_option) .gt. 0)
    l_lagr      = l_matr
!
! - Some checks
!
    if (l_nonl) then
        if (.not.l_elem_nonl) then
            call utmess('F', 'CALCUL1_8')
        endif
        if (l_xfem) then
            call utmess('F', 'CALCUL1_10')
        endif
        if (l_macr_elem) then
            call utmess('F', 'CALCUL1_11')
        endif
        if (disp_prev .eq. ' ' .or. sigm_prev .eq. ' ' .or. vari_prev .eq. ' ') then
            call utmess('F', 'CALCUL1_12')
        endif
    endif
!
    if (l_forc_noda) then
        if (disp_prev .eq. ' ' .or. sigm_prev .eq. ' ') then
            call utmess('F', 'CALCUL1_13')
        endif
    endif
!
    if (l_varc_prev .or. l_varc_curr) then
        call nmvcd2('M_ZIRC' , ds_material%mater, l_meta_zirc)
        call nmvcd2('M_ACIER', ds_material%mater, l_meta_acier)
        if ((l_meta_zirc .or. l_meta_acier) .and. (.not.l_elem_nonl)) then
            call utmess('F', 'CALCUL1_9')
        endif
    endif
!
! - How we are computing
!
    option = ' '
    if (l_matr) then
        option = 'FULL_MECA'
    else
        option = 'RAPH_MECA'
    endif
!
! - Physical dof computation
!
    if (l_nonl) then
        iter_newt = 1
        call merimo(base           ,&
                    l_xfem         , l_macr_elem, l_hho    ,&
                    model          , cara_elem  , iter_newt,&
                    ds_constitutive, ds_material, ds_system,&
                    hval_incr      , hval_algo  , hhoField ,&
                    option         , ldccvg)
        call detrsd('CHAMP', caco3d)
    endif
!
! - Lagrange dof computation
!
    if (l_lagr) then
        call medime(base, 'CUMU', model, list_load, ds_system%merigi)
        call vebtla(base, model, ds_material%mater, cara_elem, disp_curr,&
                    list_load, vediri)
    endif
!
! - Nodal forces
!
    if (l_forc_noda) then
        option    = 'FORC_NODA'
        if (.not. l_nonl) then
            ! calcul avec sigma init (sans integration de comportement)
            call copisd('CHAMP_GD', 'V', sigm_prev, sigm_curr)
            call vefnme(option            , model    , ds_material%mateco, cara_elem,&
                    ds_constitutive%compor, partps   , 0                 , ligrmo   ,&
                    varc_curr             , sigm_curr, ' '               , disp_prev,&
                    disp_cumu_inst        , base     , vefnod)
        else
            ! t(i) => t(i+1) : depplu => depmoi, depdel = 0
            depnul='&&calcul.depl_nul'
            call copisd('CHAMP_GD', 'V', disp_cumu_inst, depnul)
            call vtzero(depnul)
            call vefnme(option            , model    , ds_material%mateco, cara_elem,&
                    ds_constitutive%compor, partps   , 0                 , ligrmo   ,&
                    varc_curr             , sigm_curr, ' '               , disp_curr,&
                    depnul                , base     , vefnod)
        endif
    endif
!
! - State variables
!
    if (l_varc_prev) then
        call nmvcpr_elem(model                , ds_material%mater     ,ds_material%mateco, &
                         cara_elem,&
                         nume_harm            , '-'                   , hval_incr,&
                         ds_material%varc_refe, ds_constitutive%compor,&
                         base                 , vevarc_prev)
    endif
    if (l_varc_curr) then
        call nmvcpr_elem(model                , ds_material%mater     ,ds_material%mateco, &
                         cara_elem,&
                         nume_harm            , '+'                   , hval_incr,&
                         ds_material%varc_refe, ds_constitutive%compor,&
                         base                 , vevarc_curr)
    endif
!
! - New objects in table
!
    nb_obje = 0
    if (l_lagr) then
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje) = 'FORC_DIRI_ELEM'
        obje_sdname(nb_obje) = vediri
    endif
    if (l_nonl) then
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje)   = 'FORC_INTE_ELEM'
        obje_sdname(nb_obje) = ds_system%vefint
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje)   = 'SIEF_ELGA'
        obje_sdname(nb_obje) = sigm_curr
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje)   = 'VARI_ELGA'
        obje_sdname(nb_obje) = vari_curr
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje)   = 'CODE_RETOUR_INTE'
        obje_sdname(nb_obje) = ds_constitutive%comp_error
        if (l_matr) then
            nb_obje = nb_obje + 1
            ASSERT(nb_obje.le.nb_obje_maxi)
            obje_name(nb_obje)   = 'MATR_TANG_ELEM'
            obje_sdname(nb_obje) = ds_system%merigi
        endif
    endif
    if (l_forc_noda) then
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje)   = 'FORC_NODA_ELEM'
        obje_sdname(nb_obje) = vefnod
    endif
    if (l_varc_prev) then
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje)   = 'FORC_VARC_ELEM_M'
        obje_sdname(nb_obje) = vevarc_prev
    endif
    if (l_varc_curr) then
        nb_obje = nb_obje + 1
        ASSERT(nb_obje.le.nb_obje_maxi)
        obje_name(nb_obje)   = 'FORC_VARC_ELEM_P'
        obje_sdname(nb_obje) = vevarc_curr
    endif
!
end subroutine
