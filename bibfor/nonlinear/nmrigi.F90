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
subroutine nmrigi(modelz         , carele     , sddyna,&
                  fonact         , iterat     ,&
                  ds_constitutive, ds_material,&
                  ds_measure     , valinc     , solalg,&
                  meelem         , ds_system  , optioz,&
                  ldccvg)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/isfonc.h"
#include "asterfort/merimo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdep0.h"
#include "asterfort/nmrinc.h"
#include "asterfort/nmtime.h"
!
character(len=*) :: optioz
character(len=*) :: modelz
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=24) :: carele
integer :: iterat, ldccvg
character(len=19) :: sddyna
type(NL_DS_System), intent(in) :: ds_system
character(len=19) :: meelem(*), solalg(*), valinc(*)
integer :: fonact(*)
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! CALCUL DES MATR_ELEM DE RIGIDITE
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  OPTRIG : OPTION DE CALCUL POUR MERIMO
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_material      : datastructure for material parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  SDDYNA : SD POUR LA DYNAMIQUE
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_system        : datastructure for non-linear system management
! IN  ITERAT : NUMERO D'ITERATION
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! OUT LDCCVG : CODE RETOUR DE L'INTEGRATION DU COMPORTEMENT
!                -1 : PAS D'INTEGRATION DU COMPORTEMENT
!                 0 : CAS DU FONCTIONNEMENT NORMAL
!                 1 : ECHEC DE L'INTEGRATION DE LA LDC
!                 2 : ERREUR SUR LA NON VERIF. DE CRITERES PHYSIQUES
!                 3 : SIZZ PAS NUL POUR C_PLAN DEBORS
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: merigi
    character(len=1) :: base
    character(len=24) :: modele
    character(len=16) :: optrig
    aster_logical :: tabret(0:10), lendo
!
! --------------------------------------------------------------------------------------------------
!
    base = 'V'
    modele = modelz
    ldccvg = 0
    optrig = optioz
!
! --- VECT_ELEM ET MATR_ELEM
!
    call nmchex(meelem, 'MEELEM', 'MERIGI', merigi)
!
! --- INCREMENT DE DEPLACEMENT NUL EN PREDICTION
!
    lendo = isfonc(fonact,'ENDO_NO')
    if (.not.lendo) then
        if (optrig(1:9) .eq. 'RIGI_MECA') then
            call nmdep0('ON ', solalg)
        endif
    endif
!
! - Init timer
!
    call nmtime(ds_measure, 'Init'  , 'Integrate')
    call nmtime(ds_measure, 'Launch', 'Integrate')
!
! - Computation
!
    call merimo(base                  , modele               , carele,&
                ds_material%field_mate, ds_material%varc_refe,&
                ds_constitutive       , iterat+1             , fonact, sddyna,&
                valinc                , solalg               , merigi,&
                ds_system%vefint      , optrig,&
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
! --- REMISE INCREMENT DE DEPLACEMENT
!
    if (optrig(1:9) .eq. 'RIGI_MECA') then
        call nmdep0('OFF', solalg)
    endif
!
end subroutine
