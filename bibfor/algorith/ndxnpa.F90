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
subroutine ndxnpa(model         , cara_elem,&
                  list_func_acti, ds_print,&
                  ds_material   , ds_constitutive,&
                  sddisc, sddyna, sdnume, nume_dof, nume_inst  ,&
                  hval_incr     , hval_algo)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/isnnem.h"
#include "asterfort/copisd.h"
#include "asterfort/diinst.h"
#include "asterfort/dismoi.h"
#include "asterfort/initia.h"
#include "asterfort/isfonc.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndnpas.h"
#include "asterfort/nmchex.h"
#include "asterfort/nonlinDSMaterialTimeStep.h"
!
character(len=24), intent(in) :: model, cara_elem
integer, intent(in) :: list_func_acti(*)
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=19), intent(in) :: sddyna, sdnume, sddisc
type(NL_DS_Print), intent(inout) :: ds_print
integer, intent(in) :: nume_inst
character(len=24), intent(in) :: nume_dof
character(len=19), intent(in) :: hval_algo(*), hval_incr(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! INITIALISATION DES CHAMPS D'INCONNUES POUR UN NOUVEAU PAS DE TEMPS
!
! ----------------------------------------------------------------------
!
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  NUMEDD : NUME_DDL
! IN  NUMINS : NUMERO INSTANT COURANT
! IO  ds_print         : datastructure for printing parameters
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  SDNUME : NOM DE LA SD NUMEROTATION
! IN  SDDYNA : SD DYNAMIQUE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
!
! ----------------------------------------------------------------------
!
    aster_logical :: lgrot
    integer :: neq
    character(len=19) :: depmoi, varmoi
    character(len=19) :: depplu, varplu, vitplu, accplu
    character(len=19) :: depdel
    integer :: jdepde
    integer :: indro
    real(kind=8), pointer :: depp(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=neq)
!
! --- FONCTIONNALITES ACTIVEES
!
    lgrot = isfonc(list_func_acti,'GD_ROTA')
!
! --- ELEMENTS DE STRUCTURES EN GRANDES ROTATIONS
!
    if (lgrot) then
        call jeveuo(sdnume(1:19)//'.NDRO', 'L', indro)
    else
        indro = isnnem()
    endif
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(hval_incr, 'VALINC', 'DEPMOI', depmoi)
    call nmchex(hval_incr, 'VALINC', 'VARMOI', varmoi)
    call nmchex(hval_incr, 'VALINC', 'DEPPLU', depplu)
    call nmchex(hval_incr, 'VALINC', 'VITPLU', vitplu)
    call nmchex(hval_incr, 'VALINC', 'ACCPLU', accplu)
    call nmchex(hval_incr, 'VALINC', 'VARPLU', varplu)
    call nmchex(hval_algo, 'SOLALG', 'DEPDEL', depdel)
!
! --- ESTIMATIONS INITIALES DES VARIABLES INTERNES
!
    call copisd('CHAMP_GD', 'V', varmoi, varplu)
!
! --- INITIALISATION DES DEPLACEMENTS
!
    call copisd('CHAMP_GD', 'V', depmoi, depplu)
!
! --- INITIALISATION DE L'INCREMENT DE DEPLACEMENT DEPDEL
!
    call jeveuo(depdel//'.VALE', 'E', jdepde)
    call jeveuo(depplu//'.VALE', 'L', vr=depp)
    call initia(neq, lgrot, zi(indro), depp, zr(jdepde))
!
! --- INITIALISATIONS EN DYNAMIQUE
!
    call ndnpas(list_func_acti, nume_dof, nume_inst, sddisc, sddyna,&
                hval_incr, hval_algo)
!
! - Print or not ?
!
    ds_print%l_print = mod(nume_inst+1,ds_print%reac_print) .eq. 0
!
! - Update material parameters for new time step
!
    call nonlinDSMaterialTimeStep(model          , ds_material, cara_elem,&
                                  ds_constitutive, hval_incr  ,&
                                  nume_dof       , sddisc     , nume_inst)
!
    call jedema()
!
end subroutine
