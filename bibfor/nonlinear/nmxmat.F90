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
! aslint: disable=W1504
!
subroutine nmxmat(modelz         , ds_material, carele    ,&
                  ds_constitutive, sddisc     , numins    ,&
                  valinc         , solalg     , lischa    ,&
                  numedd         , numfix     , ds_measure,&
                  nbmatr         , ltypma     , loptme    ,&
                  loptma         , lcalme     , lassme    ,&
                  meelem         , measse     , ds_system)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/diinst.h"
#include "asterfort/nmassm.h"
#include "asterfort/nmcalm.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmtime.h"
!
character(len=*) :: modelz
type(NL_DS_Material), intent(in) :: ds_material
character(len=24) :: carele
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
character(len=19) :: sddisc
integer :: numins
character(len=19) :: solalg(*), valinc(*), lischa
character(len=24) :: numedd, numfix
type(NL_DS_Measure), intent(inout) :: ds_measure
integer :: nbmatr
character(len=6) :: ltypma(20)
character(len=16) :: loptme(20), loptma(20)
aster_logical :: lcalme(20), lassme(20)
character(len=19) :: meelem(*), measse(*)
type(NL_DS_System), intent(in) :: ds_system
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! CALCUL ET ASSEMBLAGE DES MATR_ELEM DE LA LISTE
!
! --------------------------------------------------------------------------------------------------
!
! IN  MODELE : MODELE
! IN  NUMEDD : NUME_DDL (VARIABLE AU COURS DU CALCUL)
! IN  NUMFIX : NUME_DDL (FIXE AU COURS DU CALCUL)
! In  ds_material      : datastructure for material parameters
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  LISCHA : LISTE DES CHARGES
! IO  ds_measure       : datastructure for measure and statistics management
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  NUMINS : NUMERO D'INSTANT
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  NBMATR : NOMBRE DE MATR_ELEM DANS LA LISTE
! IN  LTYPMA : LISTE DES NOMS DES MATR_ELEM
! IN  LOPTME : LISTE DES OPTIONS DES MATR_ELEM
! IN  LOPTMA : LISTE DES OPTIONS DES MATR_ASSE
! IN  LASSME : SI MATR_ELEM A ASSEMBLER
! IN  LCALME : SI MATR_ELEM A CALCULER
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: typmat
    integer :: imatr
    character(len=16) :: optcal, optass
    character(len=19) :: matele, matass
    character(len=1) :: base
    real(kind=8) :: instam, instap
    aster_logical :: lcalc, lasse
!
! --------------------------------------------------------------------------------------------------
!
    base   = 'V'
    instam = diinst(sddisc,numins-1)
    instap = diinst(sddisc,numins)
!
! --- CALCUL ET ASSEMBLAGE DES MATR_ELEM
!
    do imatr = 1, nbmatr
        typmat = ltypma(imatr)
        optcal = loptme(imatr)
        optass = loptma(imatr)
        lcalc  = lcalme(imatr)
        lasse  = lassme(imatr)
! ----- Compute
        if (lcalc) then
            call nmchex(meelem, 'MEELEM', typmat, matele)
            call nmcalm(typmat         , modelz, lischa   , ds_material, carele,&
                        ds_constitutive, instam, instap   , valinc     , solalg,&
                        optcal         , base  , ds_system, meelem     , matele)
        endif
! ----- Assembly
        if (lasse) then
            call nmtime(ds_measure, 'Init', 'Matr_Asse')
            call nmtime(ds_measure, 'Launch', 'Matr_Asse')
            call nmchex(measse, 'MEASSE', typmat, matass)
            call nmassm(lischa, numedd, numfix, typmat, optass,&
                        meelem, matass)
            call nmtime(ds_measure, 'Stop', 'Matr_Asse')
        endif
    end do
!
end subroutine
