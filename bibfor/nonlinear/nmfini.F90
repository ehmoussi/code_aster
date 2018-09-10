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
subroutine nmfini(sddyna, valinc         , measse    , modele, ds_material,&
                  carele, ds_constitutive, ds_measure, sddisc, numins     ,&
                  solalg, numedd         , fonact    , veelem, veasse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/diinst.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
#include "asterfort/mtdscr.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nonlinNForceCompute.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=19) :: sddyna, valinc(*), measse(*)
integer, intent(in) :: fonact(*)
character(len=24) :: modele, carele
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_Measure), intent(inout) :: ds_measure
character(len=24) :: numedd
character(len=19) :: sddisc, solalg(*), veelem(*), veasse(*)
integer :: numins
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
!
! CALCUL DES ENERGIES
! INITIALISATION DES VECTEURS DE FORCE POUR LE CALCUL DES ENERGIES
!
! --------------------------------------------------------------------------------------------------
!
! IN  SDDYNA : SD DYNAMIQUE
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
! IN  MODELE : MODELE
! In  fonact           : list of active functionnalities
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  NUMINS : NUMERO D'INSTANT
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  NUMEDD : NUME_DDL
! IN  VEELEM : VECTEURS ELEMENTAIRES
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: masse, amort, vitmoi, accmoi
    character(len=19) :: fexmoi, fammoi, flimoi
    integer :: imasse, iamort
    integer :: nb_equa, i_equa
    aster_logical :: lamor, ldyna
    character(len=19) :: cnfnod, fnomoi
    real(kind=8) :: time_prev, time_curr
    real(kind=8), pointer :: cv(:) => null()
    real(kind=8), pointer :: ma(:) => null()
    real(kind=8), pointer :: ccmo(:) => null()
    real(kind=8), pointer :: cnfno(:) => null()
    real(kind=8), pointer :: fammo(:) => null()
    real(kind=8), pointer :: fexmo(:) => null()
    real(kind=8), pointer :: flimo(:) => null()
    real(kind=8), pointer :: fnomo(:) => null()
    real(kind=8), pointer :: vitmo(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    lamor = ndynlo(sddyna,'MAT_AMORT')
    ldyna = ndynlo(sddyna,'DYNAMIQUE')
    call nmchex(valinc, 'VALINC', 'FEXMOI', fexmoi)
    call jeveuo(fexmoi//'.VALE', 'E', vr=fexmo)
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=nb_equa)
!
! - Get time
!
    ASSERT(numins .eq. 1)
    time_prev = diinst(sddisc,numins-1)
    time_curr = diinst(sddisc,numins)
!
! --- AJOUT DE LA FORCE DE LIAISON ET DE LA FORCE D AMORTISSEMENT MODAL
!
    call nmchex(valinc, 'VALINC', 'FAMMOI', fammoi)
    call jeveuo(fammoi//'.VALE', 'L', vr=fammo)
    call nmchex(valinc, 'VALINC', 'FLIMOI', flimoi)
    call jeveuo(flimoi//'.VALE', 'L', vr=flimo)
    do i_equa = 1, nb_equa
        fexmo(i_equa)=fammo(i_equa)+flimo(i_equa)
    end do
!
! --- AJOUT DU TERME C.V
!
    if (lamor) then
        call nmchex(measse, 'MEASSE', 'MEAMOR', amort)
        call mtdscr(amort)
        call jeveuo(amort//'.&INT', 'L', iamort)
        call nmchex(valinc, 'VALINC', 'VITMOI', vitmoi)
        call jeveuo(vitmoi//'.VALE', 'L', vr=vitmo)
        AS_ALLOCATE(vr=cv, size=nb_equa)
        call mrmult('ZERO', iamort, vitmo, cv, 1,&
                    .true._1)
        do i_equa = 1, nb_equa
            fexmo(i_equa) = fexmo(i_equa) + cv(i_equa)
        end do
        AS_DEALLOCATE(vr=cv)
    endif
!
! --- AJOUT DU TERME M.A
!
    if (ldyna) then
        call nmchex(measse, 'MEASSE', 'MEMASS', masse)
        call mtdscr(masse)
        call jeveuo(masse//'.&INT', 'L', imasse)
        call nmchex(valinc, 'VALINC', 'ACCMOI', accmoi)
        call jeveuo(accmoi//'.VALE', 'L', vr=ccmo)
        AS_ALLOCATE(vr=ma, size=nb_equa)
        call mrmult('ZERO', imasse, ccmo, ma, 1,&
                    .true._1)
        do i_equa = 1, nb_equa
            fexmo(i_equa) = fexmo(i_equa) + ma(i_equa)
        end do
        AS_DEALLOCATE(vr=ma)
    endif
!
! --- AJOUT DU TERME CNFNOD
!
    call nonlinNForceCompute(modele     , carele         , numedd  , fonact,&
                             ds_material, ds_constitutive, ds_measure,&
                             time_prev  , time_curr      ,&
                             valinc     , solalg         ,&
                             veelem     , veasse)
    call nmchex(veasse, 'VEASSE', 'CNFNOD', cnfnod)
    call jeveuo(cnfnod//'.VALE', 'L', vr=cnfno)
    do i_equa = 1, nb_equa
        fexmo(i_equa) = fexmo(i_equa) + cnfno(i_equa)
    end do
!
! --- INITIALISATION DES FORCES INTERNES
!
    call nmchex(valinc, 'VALINC', 'FNOMOI', fnomoi)
    call jeveuo(fnomoi//'.VALE', 'E', vr=fnomo)
    do i_equa = 1, nb_equa
        fnomo(i_equa) = cnfno(i_equa)
    end do
!
end subroutine
