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

subroutine nminvc(modelz, mate  , carele  , ds_constitutive, ds_measure,&
                  sddisc, sddyna, valinc  , solalg         , lischa    ,&
                  comref, numedd, ds_inout, veelem         , veasse    ,&
                  measse)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmcvec.h"
#include "asterfort/nmxvec.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*) :: modelz
    character(len=24) :: mate, carele
    type(NL_DS_Constitutive), intent(in) :: ds_constitutive
    character(len=19) :: sddisc, sddyna, lischa
    character(len=24) :: comref, numedd
    type(NL_DS_Measure), intent(inout) :: ds_measure
    type(NL_DS_InOut), intent(in) :: ds_inout
    character(len=19) :: veelem(*), veasse(*), measse(*)
    character(len=19) :: solalg(*), valinc(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! CALCUL ET ASSEMBLAGE DES VECT_ELEM CONSTANTS AU COURS DU CALCUL
!
! ----------------------------------------------------------------------
!
! IN  SDDYNA : SD DYNAMIQUE
! In  ds_constitutive  : datastructure for constitutive laws management
! IN  MODELE : NOM DU MODELE
! IN  SOLVEU : SOLVEUR
! IN  NUMEDD : NUME_DDL
! IN  LISCHA : LISTE DES CHARGEMENTS
! In  ds_inout         : datastructure for input/output management
! IN  MATE   : NOM DU CHAMP DE MATERIAU
! IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
! IN  SDDISC : SD DISCRETISATION
! IO  ds_measure       : datastructure for measure and statistics management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! OUT MEELEM : MATRICES ELEMENTAIRES
! OUT MEASSE : MATRICES ASSEMBLEES
!
! ----------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: numins
    integer :: nbvect
    character(len=6) :: ltypve(20)
    character(len=16) :: loptve(20)
    aster_logical :: lcalve(20), lassve(20)
!
! ----------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> PRECALCUL DES VECT_ELEM CONSTANTES'
    endif
!
! --- INITIALISATIONS
!
    numins = 1
    call nmcvec('INIT', ' ', ' ', .false._1, .false._1,&
                nbvect, ltypve, loptve, lcalve, lassve)
!
! --- CREATION DU VECT_ELEM POUR FORCE DE REFERENCE LIEE
! --- AUX VAR. COMMANDES EN T-
!
    call nmcvec('AJOU', 'CNVCF1', ' ', .true._1, .true._1,&
                nbvect, ltypve, loptve, lcalve, lassve)
!
! --- CALCUL DES VECT_ELEM DE LA LISTE
!
    if (nbvect .gt. 0) then
        call nmxvec(modelz, mate  , carele, ds_constitutive, ds_measure,&
                    sddisc, sddyna, numins, valinc         , solalg    ,&
                    lischa, comref, numedd, ds_inout       , veelem    ,&
                    veasse, measse, nbvect, ltypve         , lcalve    ,&
                    loptve, lassve)
    endif
!
end subroutine
