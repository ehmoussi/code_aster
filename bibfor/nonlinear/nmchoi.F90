! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine nmchoi(phase , sddyna, nume_inst, list_func_acti, reasma,&
                  metpre, metcor, lcamor   , optrig        , lcrigi,&
                  larigi, lcfint)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
!
character(len=10), intent(in) :: phase
character(len=19), intent(in) :: sddyna
integer, intent(in) :: nume_inst, list_func_acti(*)
aster_logical, intent(in) :: reasma, lcamor
character(len=16), intent(in) :: metcor, metpre
character(len=16), intent(out) :: optrig
aster_logical, intent(out) :: lcrigi, lcfint, larigi
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Select option for compute matrixes
!
! --------------------------------------------------------------------------------------------------
!
! In  phase            : computation
!                         'PREDICTION'
!                         'CORRECTION'
! In  sddyna           : dynamic parameters datastructure
! In  nume_inst        : index of current step time
! In  list_func_acti   : list of active functionnalities
! In  reasma           : flag for assembling global matrix
! In metpre           : type of matrix for prediction
! In metcor           : type of matrix for correction
! Out optrig           : option for rigidity matrix
! IN  LCAMOR : .TRUE. SI MATR_ELEM D'AMORTISSEMENT A CALCULER
! OUT OPTRIG : OPTION DE CALCUL DE MERIMO
! OUT LCRIGI : .TRUE. SI MATR_ELEM DE RIGIDITE A CALCULER
! OUT LARIGI : .TRUE. SI MATR_ELEM DE RIGIDITE A ASSEMBLER
! OUT LCFINT : .TRUE. SI VECT_ELEM DES FORCES INTERNES A CALCULER
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_implex, lshima, lprem, l_hho
!
! --------------------------------------------------------------------------------------------------
!
    optrig = ' '
    lcfint = ASTER_FALSE
    lcrigi = ASTER_FALSE
    larigi = ASTER_FALSE
!
! - Active functionnalities
!
    l_hho    = isfonc(list_func_acti,'HHO')
    l_implex = isfonc(list_func_acti,'IMPLEX')
    lshima   = ndynlo(sddyna,'COEF_MASS_SHIFT')
!
! - PREMIER PAS DE TEMPS ?
!
    lprem = nume_inst.le.1
!
! - OPTION DE CALCUL DE MERIMO
!
    if (phase .eq. 'CORRECTION') then
        if (reasma) then
            if (metcor .eq. 'TANGENTE') then
                optrig = 'FULL_MECA'
            else
                optrig = 'FULL_MECA_ELAS'
            endif
        else
            optrig = 'RAPH_MECA'
        endif
    else if (phase.eq.'PREDICTION') then
        if (metpre .eq. 'TANGENTE') then
            optrig = 'RIGI_MECA_TANG'
        else if (metpre.eq.'SECANTE') then
            optrig = 'RIGI_MECA_ELAS'
        else if (metpre.eq.'ELASTIQUE') then
            optrig = 'RIGI_MECA'
        else
            optrig = 'RIGI_MECA_TANG'
        endif
        if (l_implex) then
            optrig = 'RIGI_MECA_IMPLEX'
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! --- MATR_ELEM DE RIGIDITE A CALCULER ?
!
    if (phase .eq. 'PREDICTION') then
        lcrigi = reasma
    endif
!
! --- SI ON DOIT RECALCULER L'AMORTISSEMENT DE RAYLEIGH
!
    if (lcamor) then
        lcrigi = ASTER_TRUE
    endif
!
! --- VECT_ELEM DES FORCES INTERNES A CALCULER ?
!
    if (phase .eq. 'PREDICTION') then
        if (optrig(1:9) .eq. 'FULL_MECA') then
            lcfint = ASTER_TRUE
        else if (optrig(1:10) .eq. 'RIGI_MECA ') then
            lcfint = ASTER_FALSE
        else if (optrig(1:10) .eq. 'RIGI_MECA_') then
            lcfint = ASTER_FALSE
        else if (optrig(1:9) .eq. 'RAPH_MECA') then
            lcfint = ASTER_TRUE
        else
            ASSERT(ASTER_FALSE)
        endif
    else if (phase .eq. 'CORRECTION') then
        lcfint = lcrigi
    else
        ASSERT(ASTER_FALSE)
    endif
!
! --- DECALAGE COEF_MASS_SHIFT AU PREMIER PAS DE TEMPS -> ON A BESOIN
! --- DE LA MATRICE DE RIGIDITE
!
    if (lshima .and. lprem) then
        lcrigi = ASTER_TRUE
        larigi = ASTER_TRUE
    endif
!
! --- ASSEMBLAGE DE LA RIGIDITE ?
!
    if (reasma) then
        larigi = ASTER_TRUE
    endif
!
    if (l_hho) then
        larigi = ASTER_FALSE
    endif
!
end subroutine
