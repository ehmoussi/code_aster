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

function cfdisl(sdcont_defi_, question_)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mminfl.h"
#include "asterfort/cfdisi.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    aster_logical :: cfdisl
    character(len=*), intent(in) :: sdcont_defi_
    character(len=*), intent(in) :: question_
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Utility
!
! Get parameter (boolean)
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  question         : question to select parameter
! Out cfdisl           : value for selected parameter
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_defi, question
    integer :: cont_form
    integer :: algo_cont, algo_frot
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi = sdcont_defi_
    question    = question_
    cfdisl      = .false.
!
! - Get parameter
!
    if (question .eq. 'MODI_MATR_GLOB') then
        cont_form = cfdisi(sdcont_defi,'FORMULATION')
        if (cont_form .eq. 1) then
            algo_cont  = cfdisi(sdcont_defi,'ALGO_CONT')
            if (algo_cont .eq. 4) then
                cfdisl = .true.
            endif
        endif
    else if (question .eq.'MATR_CONT') then
        algo_cont = cfdisi(sdcont_defi,'ALGO_CONT')
        cfdisl = (algo_cont .eq. 1)
    else if (question .eq.'LISSAGE') then
        cfdisl = cfdisi(sdcont_defi,'LISSAGE').eq.1
    else if (question .eq.'COEF_ADAPT') then
        cfdisl = cfdisi(sdcont_defi,'COEF_ADAPT').eq.1
    else if (question .eq.'CONT_DISC_GLIS') then
        cfdisl = mminfl(sdcont_defi,'GLISSIERE_ZONE')
    else if (question .eq.'CONT_XFEM_GG') then
        cfdisl = cfdisi(sdcont_defi,'CONT_XFEM_GG').eq.1
    else if (question .eq.'EXIS_XFEM_CZM') then
        cfdisl = cfdisi(sdcont_defi,'EXIS_XFEM_CZM').eq.1
    else if (question .eq.'EXIS_PENA') then
        cfdisl = cfdisi(sdcont_defi,'EXIS_PENA').eq.1
    else if (question .eq.'ALL_VERIF') then
        cfdisl = cfdisi(sdcont_defi,'ALL_VERIF').eq.1
    else if (question .eq.'EXIS_VERIF') then
        cfdisl = cfdisi(sdcont_defi,'EXIS_VERIF').eq.1
    else if (question .eq.'EXIS_GLISSIERE') then
        cfdisl = cfdisi(sdcont_defi,'EXIS_GLISSIERE').eq.1
    else if (question .eq.'ALL_INTEG_NOEUD') then
        cfdisl = cfdisi(sdcont_defi,'ALL_INTEG_NOEUD').eq.1
    else if (question .eq.'ALL_INTERPENETRE') then
        cfdisl = cfdisi(sdcont_defi,'ALL_INTERPENETRE').eq.1
    else if (question .eq.'STOP_INTERP') then
        cfdisl = cfdisi(sdcont_defi,'STOP_INTERP').eq.1
    else if (question .eq.'ELIM_ARETE') then
        cfdisl = cfdisi(sdcont_defi,'ELIM_ARETE_TYPE').eq.1
    else if (question .eq.'FORMUL_MAILLEE') then
        cont_form = cfdisi(sdcont_defi,'FORMULATION')
        cfdisl = (cont_form.eq.1).or.(cont_form.eq.2)
    else if (question .eq.'FORMUL_DISCRETE') then
        cont_form = cfdisi(sdcont_defi,'FORMULATION')
        cfdisl = (cont_form.eq.1)
    else if (question .eq.'FORMUL_CONTINUE') then
        cont_form = cfdisi(sdcont_defi,'FORMULATION')
        cfdisl = (cont_form.eq.2)
    else if (question .eq.'FORMUL_XFEM') then
        cont_form = cfdisi(sdcont_defi,'FORMULATION')
        cfdisl = (cont_form.eq.3)
    else if (question .eq.'FORMUL_LAC') then
        cont_form = cfdisi(sdcont_defi,'FORMULATION')
        cfdisl = (cont_form.eq.5)
    else if (question.eq.'AXISYMETRIQUE') then
        cfdisl = cfdisi(sdcont_defi,'AXISYMETRIQUE').eq.1
    else if (question.eq.'FROTTEMENT') then
        algo_frot = cfdisi(sdcont_defi,'ALGO_FROT')
        cfdisl = algo_frot.ne.0
    else if (question.eq.'FROT_DISCRET') then
        algo_frot = cfdisi(sdcont_defi,'ALGO_FROT')
        cfdisl = algo_frot.eq.1
    else if (question.eq.'FROT_PENA') then
        algo_frot = cfdisi(sdcont_defi,'ALGO_FROT')
        cfdisl = algo_frot.eq.1
    else if (question.eq.'CONT_PENA') then
        algo_cont = cfdisi(sdcont_defi,'ALGO_CONT')
        cfdisl = algo_cont.eq.4
    else if (question.eq.'CONT_ACTI') then
        algo_cont = cfdisi(sdcont_defi,'ALGO_CONT')
        cfdisl = algo_cont.eq.1
    else if (question.eq.'CONT_GCP') then
        algo_cont = cfdisi(sdcont_defi,'ALGO_CONT')
        cfdisl = algo_cont.eq.2
    else if (question.eq.'PRE_COND_DIRICHLET') then
        cfdisl = cfdisi(sdcont_defi,'PRE_COND').eq.1
    else if (question.eq.'GEOM_NEWTON') then
        cfdisl = cfdisi(sdcont_defi,'ALGO_RESO_GEOM').eq.1
    else if (question.eq.'FROT_NEWTON') then
        cfdisl = cfdisi(sdcont_defi,'ALGO_RESO_FROT').eq.1
    else if (question.eq.'CONT_NEWTON') then
        cfdisl = cfdisi(sdcont_defi,'ALGO_RESO_CONT').eq.1
    else if (question.eq.'GEOM_BOUCLE') then
        cfdisl = cfdisi(sdcont_defi,'ALGO_RESO_GEOM') .eq. 0 .and.&
                 cfdisi(sdcont_defi,'NB_ITER_GEOM') .ne.0
    else if (question.eq.'CONT_BOUCLE') then
        cfdisl = cfdisi(sdcont_defi,'ALGO_RESO_CONT').eq.0
    else if (question.eq.'FROT_BOUCLE') then
        cfdisl = cfdisi(sdcont_defi,'ALGO_RESO_FROT').eq.0
    else if (question.eq.'REAC_GEOM_SANS') then
        cfdisl = cfdisi(sdcont_defi,'NB_ITER_GEOM').eq.0
    else if (question.eq.'REAC_GEOM_MANU') then
        cfdisl = cfdisi(sdcont_defi,'NB_ITER_GEOM').gt.0
    else if (question.eq.'REAC_GEOM_AUTO') then
        cfdisl = cfdisi(sdcont_defi,'NB_ITER_GEOM').lt.0
    else
        write(6,*) 'QUESTION: ',question
        ASSERT(.false.)
    endif
!
end function
