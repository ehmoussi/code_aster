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
subroutine nsassp(modele    , numedd     , lischa, fonact    , sddyna,&
                  ds_measure, valinc     , veelem, veasse    , cnpilo,&
                  cndonn    , ds_material, carele, ds_contact, matass,&
                  ds_algorom)
!
use NonLin_Datastructure_type
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmadir.h"
#include "asterfort/nmasdi.h"
#include "asterfort/nmasfi.h"
#include "asterfort/nmasva.h"
#include "asterfort/nmbudi.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdiri.h"
#include "asterfort/nmtime.h"
#include "asterfort/vtaxpy.h"
#include "asterfort/vtzero.h"
!
integer :: fonact(*)
character(len=19) :: lischa, sddyna, matass
character(len=24) :: modele, numedd, carele
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Measure), intent(inout) :: ds_measure
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: veasse(*), veelem(*), valinc(*)
character(len=19) :: cnpilo, cndonn
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - PREDICTION)
!
! CALCUL DU SECOND MEMBRE POUR LA PREDICTION - STATIQUE
!
! ----------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  NUMEDD : NOM DE LA NUMEROTATION
! IN  LISCHA : SD L_CHARGES
! IN  FONACT : FONCTIONNALITES ACTIVEES
! IN  SDDYNA : SD DYNAMIQUE
! In  ds_material      : datastructure for material parameters
! In  ds_contact       : datastructure for contact management
! IO  ds_measure       : datastructure for measure and statistics management
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
! IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
! OUT CNPILO : VECTEUR ASSEMBLE DES FORCES PILOTEES
! OUT CNDONN : VECTEUR ASSEMBLE DES FORCES DONNEES
! IN  MATASS : SD MATRICE ASSEMBLEE
!
!
    character(len=24) :: mate
    integer :: i, nbvec, nbcoef
    character(len=19) :: cnffdo, cndfdo, cnfvdo
    character(len=19) :: cnffpi, cndfpi, cndiri
    character(len=19) :: vebudi, vediri
    parameter    (nbcoef=9)
    real(kind=8) :: coef(nbcoef)
    character(len=19) :: vect(nbcoef)
    character(len=19) :: cnfnod, cnbudi, cnvcpr, cnsstr, cneltc, cneltf, cnfint
    character(len=19) :: depmoi, k19bla
    aster_logical :: lmacr, leltc, leltf, lallv
!
! ----------------------------------------------------------------------
!
    call vtzero(cndonn)
    call vtzero(cnpilo)
    cnffdo = '&&CNCHAR.FFDO'
    cnffpi = '&&CNCHAR.FFPI'
    cndfdo = '&&CNCHAR.DFDO'
    cndfpi = '&&CNCHAR.DFPI'
    cnfvdo = '&&CNCHAR.FVDO'
    k19bla = ' '
    mate   = ds_material%field_mate
!
! --- FONCTIONNALITES ACTIVEES
!
    lmacr = isfonc(fonact,'MACR_ELEM_STAT')
    leltc = isfonc(fonact,'ELT_CONTACT')
    leltf = isfonc(fonact,'ELT_FROTTEMENT')
    lallv = isfonc(fonact,'CONT_ALL_VERIF' )
!
! - Launch timer
!
    call nmtime(ds_measure, 'Init'  , '2nd_Member')
    call nmtime(ds_measure, 'Launch', '2nd_Member')
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    call nmchex(valinc, 'VALINC', 'DEPMOI', depmoi)
!
! --- CALCUL DU VECTEUR DES CHARGEMENTS FIXES        (NEUMANN)
!
    call nmasfi(fonact, sddyna, veasse, cnffdo, cnffpi)
!
! --- CALCUL DU VECTEUR DES CHARGEMENTS FIXES        (DIRICHLET)
!
    call nmasdi(fonact, veasse, cndfdo, cndfpi)
!
! --- CALCUL DU VECTEUR DES CHARGEMENTS VARIABLES    (NEUMANN)
!
    call nmasva(sddyna, veasse, cnfvdo)
!
! --- SECOND MEMBRE DES VARIABLES DE COMMANDE
!
    call nmchex(veasse, 'VEASSE', 'CNVCPR', cnvcpr)
!
! --- FORCES NODALES
!
    call nmchex(veasse, 'VEASSE', 'CNFNOD', cnfnod)
    call nmchex(veasse, 'VEASSE', 'CNFINT', cnfint)
!
! --- CALCUL DES REACTIONS D'APPUI BT.LAMBDA
!
    call nmchex(veelem, 'VEELEM', 'CNDIRI', vediri)
    call nmchex(veasse, 'VEASSE', 'CNDIRI', cndiri)
    call nmdiri(modele, mate, carele, lischa, k19bla,&
                depmoi, k19bla, k19bla, vediri)
    call nmadir(numedd, fonact, ds_contact, veasse, vediri,&
                cndiri)
!
! --- CONDITIONS DE DIRICHLET B.U
!
    call nmchex(veasse, 'VEASSE', 'CNBUDI', cnbudi)
    call nmchex(veelem, 'VEELEM', 'CNBUDI', vebudi)
    call nmbudi(modele, numedd, lischa, depmoi, vebudi,&
                cnbudi, matass)
!
! --- CHARGEMENTS DONNES
!
    nbvec = 7
    coef(1) = 1.d0
    coef(2) = 1.d0
    coef(3) = -1.d0
    coef(4) = -1.d0
    coef(5) = -1.d0
    coef(6) = 1.d0
    coef(7) = 1.d0
    vect(1) = cnffdo
    vect(2) = cnfvdo
    vect(3) = cndiri
    vect(4) = cnbudi
    vect(5) = cnfnod
    vect(6) = cnvcpr
    vect(7) = cndfdo
!
! - Internal forces
! 
    if (ds_algorom%phase.eq.'CORR_EF') then
        vect(5) = cnfint
    endif
!
! --- FORCES ISSUES DES MACRO-ELEMENTS STATIQUES
!
    if (lmacr) then
        call nmchex(veasse, 'VEASSE', 'CNSSTR', cnsstr)
        nbvec = nbvec + 1
        coef(nbvec) = 1.d0
        vect(nbvec) = cnsstr
    endif
!
! --- FORCES DES ELEMENTS DE CONTACT (XFEM+CONTINUE)
!
    if (leltc .and. (.not.lallv)) then
        call nmchex(veasse, 'VEASSE', 'CNELTC', cneltc)
        nbvec = nbvec + 1
        coef(nbvec) = -1.d0
        vect(nbvec) = cneltc
    endif
    if (leltf .and. (.not.lallv)) then
        call nmchex(veasse, 'VEASSE', 'CNELTF', cneltf)
        nbvec = nbvec + 1
        coef(nbvec) = -1.d0
        vect(nbvec) = cneltf
    endif
!
! --- CHARGEMENT DONNE
!
    if (nbvec .gt. nbcoef) then
        ASSERT(.false.)
    endif
    do i = 1, nbvec
        call vtaxpy(coef(i), vect(i), cndonn)
    end do
!
! --- CHARGEMENT PILOTE
!
    nbvec = 2
    coef(1) = 1.d0
    coef(2) = 1.d0
    vect(1) = cnffpi
    vect(2) = cndfpi
    if (nbvec .gt. nbcoef) then
        ASSERT(.false.)
    endif
    do i = 1, nbvec
        call vtaxpy(coef(i), vect(i), cnpilo)
    end do
!
! - End timer
!
    call nmtime(ds_measure, 'Stop', '2nd_Member')
!
end subroutine
