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
subroutine nmassd(model      , nume_dof   , list_load, list_func_acti, &
                  ds_measure , disp_esti  ,&
                  hval_veelem, hval_veasse, matr_asse,&
                  cnpilo     , cndonn)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/nonlinLoadDirichletCompute.h"
#include "asterfort/nonlinDSVectCombInit.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddHat.h"
!
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: list_load
character(len=24), intent(in) :: model, nume_dof
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=19), intent(in) :: disp_esti
character(len=19), intent(in) :: hval_veelem(*), hval_veasse(*)
character(len=19), intent(in) :: cnpilo, cndonn, matr_asse
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! Evaluate second memeber for Dirichlet loads (AFFE_CHAR_MECA)
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  NUMEDD : NOM DE LA NUMEROTATION
! IN  LISCHA : SD L_CHARGES
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  DEPEST : DEPLACEMENT ESTIME (PAR DEPL_CALC OU EXTROPLATION)
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! IN  MATASS : SD MATRICE ASSEMBLEE
! OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_didi, l_pilo
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ...... CALCUL SECOND MEMBRE'
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Active functionnalities
!
    l_didi = isfonc(list_func_acti,'DIDI')
    l_pilo = isfonc(list_func_acti,'PILOTAGE')
!
! - Compute values of Dirichlet conditions
!
    call nonlinLoadDirichletCompute(list_load  , model      , nume_dof ,&
                                    ds_measure , matr_asse  , disp_esti,&
                                    hval_veelem, hval_veasse)
!
! - Dirichlet (given displacements) - AFFE_CHAR_MECA
!
    call nonlinDSVectCombAddHat(hval_veasse, 'CNDIDO', +1.d0, ds_vectcomb)
    call nonlinDSVectCombAddHat(hval_veasse, 'CNBUDI', -1.d0, ds_vectcomb)
    if (l_didi) then
        call nonlinDSVectCombAddHat(hval_veasse, 'CNDIDI', 1.d0, ds_vectcomb)
    endif
!
! - Second member (standard)
!
    call nonlinDSVectCombCompute(ds_vectcomb, cndonn)
!
    call nonlinDSVectCombInit(ds_vectcomb)
    if (l_pilo) then
! ----- Get Dirichlet loads (for PILOTAGE)
        call nonlinDSVectCombAddHat(hval_veasse, 'CNDIPI', +1.d0, ds_vectcomb)   
    endif
!
! - Second member (PILOTAGE)
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnpilo)
!
end subroutine
